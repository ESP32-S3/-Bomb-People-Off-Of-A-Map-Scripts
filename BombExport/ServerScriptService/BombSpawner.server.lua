local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local BOMB_GROUP = "Bombs"
local SPAWN_GROUP = "BombSpawns"

pcall(function() PhysicsService:RegisterCollisionGroup(BOMB_GROUP) end)
pcall(function() PhysicsService:RegisterCollisionGroup(SPAWN_GROUP) end)
pcall(function() PhysicsService:CollisionGroupSetCollidable(BOMB_GROUP, SPAWN_GROUP, false) end)

local PlayerEquip = require(script.Parent.PlayerEquip)
local BombSkin = require(RS:WaitForChild("BombSkin"))

local currentMapFolder = workspace:WaitForChild("CurrentMap")
local mapChangedBE = RS:WaitForChild("MapChanged")

-- tag bombspawns parts with the bombspawns collision group so
-- thrown bombs pass through them without bouncing or detonating
local function tagSpawnPartsIn(folder)
	for _, mapFolder in ipairs(folder:GetChildren()) do
		for _, child in ipairs(mapFolder:GetChildren()) do
			if child.Name == "BombSpawns" then
				for _, desc in ipairs(child:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.CollisionGroup = SPAWN_GROUP
					end
				end
			end
		end
	end
end

tagSpawnPartsIn(currentMapFolder)

currentMapFolder.DescendantAdded:Connect(function(desc)
	if desc:IsA("BasePart") and desc:FindFirstAncestor("BombSpawns") then
		desc.CollisionGroup = SPAWN_GROUP
	end
end)
local bombModelTemplate = RS:WaitForChild("BombModel")
local bombToolTemplate = RS:WaitForChild("Bomb")

local SPAWN_DELAY = 10
local SPAWN_INTERVAL = 1

local activeBombs = {}
local debounce = {}
local runId = 0

local function getSpawnParts()
	local parts = {}
	for _, mapFolder in ipairs(currentMapFolder:GetChildren()) do
		for _, child in ipairs(mapFolder:GetChildren()) do
			if child.Name == "BombSpawns" then
				for _, desc in ipairs(child:GetDescendants()) do
					if desc:IsA("BasePart") then
						table.insert(parts, desc)
					end
				end
			end
		end
	end
	return parts
end

local function giveBombTool(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local char = player.Character
	if not backpack then return end
	if backpack:FindFirstChild("Bomb") then return end
	if char and char:FindFirstChild("Bomb") then return end

	local toolClone = bombToolTemplate:Clone()

	toolClone.Parent = backpack

	local equippedItem = PlayerEquip.getEquippedItem(player)
	if equippedItem then
		print("[BombSpawner] applying skin for", player.Name, "item:", equippedItem.name)
		BombSkin.apply(toolClone, equippedItem)
	else
		print("[BombSpawner] no equipped skin for", player.Name)
	end
end

local function swayLoop(bomb, baseCF)
	local t = 0
	while bomb.Parent do
		t += task.wait(0.05)
		bomb:PivotTo(baseCF + Vector3.new(0, math.sin(t * 3.2) * 0.35, 0))
	end
end

local function clearBombs()
	for _, e in ipairs(activeBombs) do
		if e.bomb and e.bomb.Parent then
			e.bomb:Destroy()
		end
		if e.part and e.part.Parent then
			e.part:SetAttribute("Occupied", false)
		end
	end
	activeBombs = {}
	debounce = {}
end

local function spawnBombAtPart(part)
	if not part or not part.Parent then return end
	if part:GetAttribute("Occupied") then return end

	local bomb = bombModelTemplate:Clone()
	local baseCF = CFrame.new(part.Position + Vector3.new(0, part.Size.Y / 2 + 2, 0))
	bomb:PivotTo(baseCF)
	bomb.Parent = currentMapFolder

	for _, p in ipairs(bomb:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Anchored = true
		end
	end

	part:SetAttribute("Occupied", true)
	table.insert(activeBombs, { bomb = bomb, part = part })

	task.spawn(swayLoop, bomb, baseCF)

	local root = bomb.PrimaryPart or bomb:FindFirstChildWhichIsA("BasePart")
	if root then
		root.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if not player or debounce[player] then return end

			debounce[player] = true
			giveBombTool(player)

			if part.Parent then
				part:SetAttribute("Occupied", false)
			end

			if bomb.Parent then
				bomb:Destroy()
			end

			task.delay(1, function()
				debounce[player] = nil
			end)
		end)
	end
end

local function spawnLoop(myRunId)
	while runId == myRunId do
		local parts = getSpawnParts()
		local available = {}

		for _, part in ipairs(parts) do
			if part.Parent and not part:GetAttribute("Occupied") then
				table.insert(available, part)
			end
		end

		if #available > 0 then
			local chosen = available[math.random(1, #available)]
			spawnBombAtPart(chosen)
		end

		task.wait(SPAWN_INTERVAL)
	end
end

mapChangedBE.Event:Connect(function(map)
	runId += 1
	local myRunId = runId

	clearBombs()

	if not map then return end

	task.wait(SPAWN_DELAY)

	if runId ~= myRunId then return end
	if currentMapFolder:FindFirstChild(map.Name) then
		task.spawn(spawnLoop, myRunId)
	end
end)