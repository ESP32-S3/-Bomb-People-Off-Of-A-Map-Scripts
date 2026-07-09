local Tool = script.Parent
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")
local PhysicsService = game:GetService("PhysicsService")

-- collision groups: bombs pass through bomb spawns and other bombs,
-- but collide with players and map geometry
local BOMB_GROUP = "Bombs"
local PLAYER_GROUP = "PlayerCharacters"
local SPAWN_GROUP = "BombSpawns"

pcall(function() PhysicsService:RegisterCollisionGroup(BOMB_GROUP) end)
pcall(function() PhysicsService:RegisterCollisionGroup(PLAYER_GROUP) end)
pcall(function() PhysicsService:RegisterCollisionGroup(SPAWN_GROUP) end)
pcall(function() PhysicsService:CollisionGroupSetCollidable(BOMB_GROUP, SPAWN_GROUP, false) end)
pcall(function() PhysicsService:CollisionGroupSetCollidable(BOMB_GROUP, BOMB_GROUP, false) end)

local function tagCharacterParts(char)
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("BasePart") then
			d.CollisionGroup = PLAYER_GROUP
		end
	end
	char.DescendantAdded:Connect(function(d)
		if d:IsA("BasePart") then
			d.CollisionGroup = PLAYER_GROUP
		end
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		tagCharacterParts(plr.Character)
	end
	plr.CharacterAdded:Connect(tagCharacterParts)
end
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(tagCharacterParts)
end)

local function isCharacterPart(part)
	if not part then return false end
	local model = part:FindFirstAncestorOfClass("Model")
	return model ~= nil and model:FindFirstChildOfClass("Humanoid") ~= nil
end

-- check whether a part belongs to the thrower's character (used
-- for a brief owner-immunity window after spawning so fast-moving
-- players don't blow themselves up on their own bomb)
local function isThrowerPart(part, thrower)
	if not part or not thrower then return false end
	local char = thrower.Character
	if not char then return false end
	return part:IsDescendantOf(char)
end

local function isBombSpawnPart(part)
	if not part then return false end
	return part:FindFirstAncestor("BombSpawns") ~= nil
end

local GamepassSFX = require(ServerScriptService:WaitForChild("GamepassSFX"))
local CurrencyAPI = require(ServerScriptService:WaitForChild("CurrencyAPI"))
local LevelSystem = require(ServerScriptService:WaitForChild("LevelSystem"))
local PerkMultipliers = require(RS:WaitForChild("PerkMultipliers"))

local HIT_COINS = 10
local HIT_EXP = 5

local RemoteEvent = RS:WaitForChild("BombRemoteEvent")

local FuseTime = 99
local ThrowSpeed = 300
local BlastRadius = 20
local BlastPressure = 300000
local SPAWN_DISTANCE = 5      -- studs ahead of the thrower to spawn
local OWNER_IMMUNITY = 0.1   -- seconds the bomb ignores its thrower
local BOMB_GRAVITY   = 25    -- studs/s² downward arc
local BOMB_LIFETIME  = 10    -- auto-detonate after this many seconds

local function getHandle(parts)
	for _, p in ipairs(parts) do
		if p.Name == "Handle" then
			return p
		end
	end
	return parts[1]
end

local function explode(pos, thrower, skinSoundId, hasSkinExplosion)
	local boom = Instance.new("Explosion")
	boom.Position = pos
	boom.BlastRadius = BlastRadius
	boom.BlastPressure = BlastPressure
	boom.DestroyJointRadiusPercent = 0
	-- skinned bombs play their own burst/light fx (bombskin sets this
	-- attribute), hide stock fireball so two explosions don't stack,
	-- hit/damage/pressure still fire normally, only the look is hidden
	boom.Visible = not hasSkinExplosion

	-- tag whoever gets caught in the blast so the round system can
	-- attribute the kill to `thrower` a moment later, when died fires
	-- also award the thrower coins/xp once per victim per blast, a
	-- multi-limb hit on the same player only ever pays out once here
	local rewardedThisBlast = {}

	boom.Hit:Connect(function(part)
		local hitChar = part and part.Parent
		local humanoid = hitChar and hitChar:FindFirstChildOfClass("Humanoid")
		if not humanoid or not thrower then return end

		GamepassSFX.TagHit(humanoid, thrower)

		if rewardedThisBlast[humanoid] then return end

		local hitPlayer = Players:GetPlayerFromCharacter(hitChar)
		if not hitPlayer or hitPlayer == thrower then return end

		rewardedThisBlast[humanoid] = true
		local coins = math.floor(HIT_COINS * PerkMultipliers.GetCoinMultiplier(thrower) + 0.5)
		local exp = math.floor(HIT_EXP * PerkMultipliers.GetXPMultiplier(thrower) + 0.5)
		CurrencyAPI.AddCoins(thrower, coins, "hit", exp)
		LevelSystem.AddExp(thrower, exp)
	end)

	boom.Parent = workspace

	-- positioned, gamepass-aware explosion sound (custom override if the
	-- thrower owns the explosion sfx gamepass and has set one)
	local soundId = GamepassSFX.GetExplosionSoundId(thrower, skinSoundId)
	if soundId ~= "" then
		local soundAnchor = Instance.new("Part")
		soundAnchor.Name = "ExplosionSoundAnchor"
		soundAnchor.Anchored = true
		soundAnchor.CanCollide = false
		soundAnchor.CanQuery = false
		soundAnchor.CanTouch = false
		soundAnchor.Transparency = 1
		soundAnchor.Size = Vector3.new(1, 1, 1)
		soundAnchor.CFrame = CFrame.new(pos)
		soundAnchor.Parent = workspace

		local sound = Instance.new("Sound")
		sound.SoundId = soundId
		sound.RollOffMaxDistance = 250
		sound.Volume = 1
		sound.Parent = soundAnchor
		sound:Play()

		Debris:AddItem(soundAnchor, 5)
	end
end

local function spawnBomb(toolClone, startPos, dir, thrower)
	local model = Instance.new("Model")
	model.Name = "Bomb"

	local parts = {}

	for _, v in ipairs(toolClone:GetDescendants()) do
		if v:IsA("BasePart") then
			local c = v:Clone()
			c.Anchored = true
			c.CanCollide = false
			c.CanTouch = false
			c.CanQuery = false
			c.CollisionGroup = BOMB_GROUP
			c.Parent = model
			table.insert(parts, c)
		end
	end

	local handle = getHandle(parts)
	if not handle then
		model:Destroy()
		return
	end

	model.PrimaryPart = handle
	model.Parent = workspace

	for _, p in ipairs(parts) do
		if p ~= handle then
			local w = Instance.new("WeldConstraint")
			w.Part0 = handle
			w.Part1 = p
			w.Parent = model
		end
	end

	-- position the bomb at the start
	model:PivotTo(CFrame.new(startPos))

	-- raycast params: the collision group makes the ray pass through
	-- players and bomb spawns automatically, also exclude this
	-- bomb model so it never hits itself
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { model }
	rayParams.CollisionGroup = BOMB_GROUP

	local pos = startPos
	local velocity = dir * ThrowSpeed + Vector3.new(0, 4, 0)
	local exploded = false
	local spawnTime = os.clock()
	local trail = handle:FindFirstChild("FXTrail")

	local function detonate(hitPos)
		if exploded then return end
		exploded = true

		local burst = handle:FindFirstChild("FXBurst")
		local light = handle:FindFirstChild("FXLight")

		if trail then
			trail.Enabled = false
		end

		if burst then
			burst:Emit(burst:GetAttribute("EmitCount") or 50)
		end

		if light then
			light.Enabled = true
		end

		local detonatePos = hitPos or handle.Position
		explode(detonatePos, thrower, handle:FindFirstChild("FXSound") and handle.FXSound.SoundId, handle:GetAttribute("HasSkinExplosion"))

		-- give the burst a moment to actually queue its particles
		-- (and the light a frame to flash) before the model is removed
		task.delay(0.15, function()
			if model and model.Parent then
				model:Destroy()
			end
		end)
	end

	-- move the bomb along a raycasted path with a small downward arc
	-- each frame: apply gravity, raycast ahead, detonate on contact
	local hb
	hb = RunService.Heartbeat:Connect(function(dt)
		if exploded then hb:Disconnect() return end

		-- auto-detonate after max lifetime
		if os.clock() - spawnTime > BOMB_LIFETIME then
			detonate(pos)
			return
		end

		-- apply gravity for the downward arc
		velocity -= Vector3.new(0, BOMB_GRAVITY * dt, 0)

		local newPos = pos + velocity * dt
		local segDir = newPos - pos

		-- raycast along the movement segment
		local ray = workspace:Raycast(pos, segDir, rayParams)
		if ray then
			-- skip bomb spawns (collision group filters most, this is backup)
			if isBombSpawnPart(ray.Instance) then
				-- pass through spawn pads
			-- skip the thrower during the immunity window
			elseif os.clock() - spawnTime < OWNER_IMMUNITY and isThrowerPart(ray.Instance, thrower) then
				-- pass through thrower
			else
				pos = ray.Position
				model:PivotTo(CFrame.new(pos))
				detonate(pos)
				return
			end
		end

		-- no collision: advance the bomb
		pos = newPos
		model:PivotTo(CFrame.new(pos))

		-- detonate if the bomb falls below the world
		if pos.Y < workspace.FallenPartsDestroyHeight + 10 then
			detonate(pos)
		end
	end)
end

RemoteEvent.OnServerEvent:Connect(function(player, dir)
	-- only respond if this tool belongs to the player who fired the event,
	-- without this check every player's bomb script reacts to any throw,
	-- causing other players' tools to be destroyed
	local backpack = player:FindFirstChildOfClass("Backpack")
	local char = player.Character
	if Tool.Parent ~= backpack and Tool.Parent ~= char then
		return
	end

	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if typeof(dir) ~= "Vector3" or dir.Magnitude < 0.1 then
		dir = root.CFrame.LookVector
	end

	dir = dir.Unit

	local toolClone = Tool:Clone()
	local spawnPos = root.Position + dir * SPAWN_DISTANCE

	-- do not destroy tool before cloning
	Tool:Destroy()

	spawnBomb(toolClone, spawnPos, dir, player)
end)