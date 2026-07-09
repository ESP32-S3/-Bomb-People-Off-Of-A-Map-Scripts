local Players = game:GetService("Players")
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

-- tag every basepart in a character (including accessories / 3d
-- clothing) with the playercharacters group, this runs persistently,
-- unlike the bomb tool script which is destroyed after each throw
local function tagCharacterParts(char)
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("BasePart") then
			d.CollisionGroup = PLAYER_GROUP
		end
	end

	-- catch accessories and clothing that load after the character
	char.DescendantAdded:Connect(function(d)
		if d:IsA("BasePart") then
			d.CollisionGroup = PLAYER_GROUP
		end
	end)
end

local function onPlayerAdded(player)
	if player.Character then
		tagCharacterParts(player.Character)
	end
	player.CharacterAdded:Connect(tagCharacterParts)
end

-- tag players already in the game
for _, plr in ipairs(Players:GetPlayers()) do
	onPlayerAdded(plr)
end

-- tag players who join later
Players.PlayerAdded:Connect(onPlayerAdded)