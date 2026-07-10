

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local INTERMISSION_TIME = 30
local MIN_PLAYERS = 2

local events = RS:WaitForChild("RoundEvents")
local stateEvent = events:WaitForChild("StateChanged")
local aliveEvent = events:WaitForChild("AliveChanged")
local winnerEvent = events:WaitForChild("RoundWinner")

local map1 = workspace:WaitForChild("Map1")
local lobby = workspace:WaitForChild("Floating Lobby")
local lobbySpawn = lobby:WaitForChild("SpawnLocation")
local ffaSpawn = map1:WaitForChild("FFASpawn")

local gameState = RS:FindFirstChild("GameState")

if not gameState then
	gameState = Instance.new("StringValue")
	gameState.Name = "GameState"
	gameState.Parent = RS
end

local currentState = "Lobby"
gameState.Value = currentState

local alivePlayers = {}
local roundEnding = false

local function setState(state)
	currentState = state
	gameState.Value = state
end

local function fireAll(event, ...)
	for _, player in ipairs(Players:GetPlayers()) do
		event:FireClient(player, ...)
	end
end

local function countAlive()
	local count = 0
	local lastAlive = nil

	for player, alive in pairs(alivePlayers) do
		if alive and player and player.Parent then
			count += 1
			lastAlive = player
		end
	end

	return count, lastAlive
end

local function broadcastAlive()
	local count = countAlive()
	fireAll(aliveEvent, count)
end

local function teleportToLobby(player)
	local character = player.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	root.CFrame = CFrame.new(
		lobbySpawn.Position + Vector3.new(
			math.random(-4, 4),
			3,
			math.random(-4, 4)
		)
	)
end

local function teleportToMap(player)
	local character = player.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	root.CFrame = CFrame.new(
		ffaSpawn.Position + Vector3.new(
			math.random(-8, 8),
			3,
			math.random(-8, 8)
		)
	)
end

local function endRound(winner)
	if roundEnding then
		return
	end

	roundEnding = true
	setState("Lobby")

	fireAll(
		winnerEvent,
		winner and winner.Name or "Nobody"
	)

	task.wait(4)

	for _, player in ipairs(Players:GetPlayers()) do
		alivePlayers[player] = nil

		local character = player.Character
		if character then
			local root = character:FindFirstChild("HumanoidRootPart")

			if root then
				root.CFrame = CFrame.new(
					lobbySpawn.Position + Vector3.new(
						math.random(-4, 4),
						3,
						math.random(-4, 4)
					)
				)
			end
		end
	end

	fireAll(stateEvent, "Lobby", {})
	roundEnding = false
end

local function onPlayerDied(player)
	if currentState ~= "InGame" then
		return
	end

	alivePlayers[player] = false
	broadcastAlive()

	task.delay(0.3, function()
		if currentState ~= "InGame" or roundEnding then
			return
		end

		local count, lastAlive = countAlive()

		if count <= 1 then
			endRound(lastAlive)
		end
	end)
end

local function setupCharacter(player, character)
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.Died:Connect(function()
		onPlayerDied(player)
	end)
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)

	if player.Character then
		setupCharacter(player, player.Character)
	end
end

Players.PlayerAdded:Connect(function(player)
	setupPlayer(player)

	if currentState ~= "InGame" then
		task.delay(1, function()
			if player and player.Parent then
				teleportToLobby(player)
			end
		end)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if currentState ~= "InGame" then
		return
	end

	alivePlayers[player] = nil

	task.delay(0.3, function()
		if currentState ~= "InGame" or roundEnding then
			return
		end

		local count, lastAlive = countAlive()

		if count <= 1 then
			endRound(lastAlive)
		end
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

while true do
	setState("Lobby")
	roundEnding = false

	fireAll(stateEvent, "Lobby", {})

	repeat
		task.wait(1)
	until #Players:GetPlayers() >= MIN_PLAYERS

	setState("Intermission")

	for t = INTERMISSION_TIME, 1, -1 do
		fireAll(stateEvent, "Intermission", {
			time = t
		})

		task.wait(1)
	end

	if #Players:GetPlayers() < MIN_PLAYERS then
		continue
	end

	setState("InGame")
	roundEnding = false

	alivePlayers = {}

	local allPlayers = Players:GetPlayers()

	for _, player in ipairs(allPlayers) do
		alivePlayers[player] = true
	end

	fireAll(stateEvent, "InGame", {})
	broadcastAlive()

	for _, player in ipairs(allPlayers) do
		teleportToMap(player)
	end

	repeat
		task.wait(0.5)
	until currentState == "Lobby"

	task.wait(3)
end
