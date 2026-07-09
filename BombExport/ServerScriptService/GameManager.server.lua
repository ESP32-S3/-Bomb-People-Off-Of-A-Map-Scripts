local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local GamepassSFX = require(ServerScriptService:WaitForChild("GamepassSFX"))
local CurrencyAPI = require(ServerScriptService:WaitForChild("CurrencyAPI"))
local LevelSystem = require(ServerScriptService:WaitForChild("LevelSystem"))
local PerkMultipliers = require(RS:WaitForChild("PerkMultipliers"))

local KILL_COINS = 25
local KILL_EXP = 15

local INTERMISSION_TIME = 20
local VOTE_DURATION = 12
local MIN_PLAYERS = 2

local events     = RS:WaitForChild("RoundEvents")
local stateEvent = events:WaitForChild("StateChanged")
local aliveEvent = events:WaitForChild("AliveChanged")
local winEvent   = events:WaitForChild("RoundWinner")

local mapChangedBE = RS:WaitForChild("MapChanged")

local voteStartEvent  = events:WaitForChild("VoteStart")
local mapVoteEvent    = events:WaitForChild("MapVote")
local voteUpdateEvent = events:WaitForChild("VoteUpdate")

local lobby           = workspace:WaitForChild("Floating Lobby")
local lobbySpawn      = lobby:WaitForChild("SpawnLocation")
local currentMapFolder = workspace:WaitForChild("CurrentMap")

local currentState = "Lobby"
local alivePlayers = {}
local activeMap    = nil
local roundEnding  = false

local mapVotes       = {}
local voteTally      = {}
local voteCandidates = {}
local votingOpen     = false

local function getMaps()
	local t = {}
	for _, v in ipairs(ServerStorage:GetChildren()) do
		if v:IsA("Folder") and v.Name ~= "CurrentMap" then
			table.insert(t, v)
		end
	end
	return t
end

local function loadMap(chosenName)
	local maps = getMaps()
	assert(#maps > 0, "No map folders found in ServerStorage!")
	local chosen
	if chosenName then
		for _, m in ipairs(maps) do
			if m.Name == chosenName then chosen = m; break end
		end
	end
	chosen = chosen or maps[math.random(1, #maps)]
	chosen.Parent = currentMapFolder
	activeMap = chosen
	mapChangedBE:Fire(chosen)
end

local function unloadMap()
	if activeMap then
		activeMap.Parent = ServerStorage
		activeMap = nil
		mapChangedBE:Fire(nil)
	end
end

local function resetVotes()
	mapVotes = {}
	voteTally = {}
	voteCandidates = {}
	votingOpen = false
end

local function fireAll(event, ...)
	for _, p in ipairs(Players:GetPlayers()) do
		event:FireClient(p, ...)
	end
end

local function startVote()
	local pool = getMaps()
	for i = #pool, 2, -1 do
		local j = math.random(i)
		pool[i], pool[j] = pool[j], pool[i]
	end
	voteCandidates = {}
	for i = 1, math.min(3, #pool) do
		table.insert(voteCandidates, pool[i].Name)
		voteTally[pool[i].Name] = 0
	end
	if #voteCandidates == 0 then return end
	votingOpen = true
	fireAll(voteStartEvent, voteCandidates, VOTE_DURATION)
	task.delay(VOTE_DURATION, function()
		votingOpen = false
	end)
end

local function tallyWinner()
	if #voteCandidates == 0 then
		return nil
	end

	local maxCount = 0
	for _, name in ipairs(voteCandidates) do
		local c = voteTally[name] or 0
		if c > maxCount then maxCount = c end
	end

	-- no votes: pick a random candidate from the ballot
	if maxCount == 0 then
		return voteCandidates[math.random(1, #voteCandidates)]
	end

	-- tied top vote: random among the tied maps
	local tied = {}
	for _, name in ipairs(voteCandidates) do
		if (voteTally[name] or 0) == maxCount then
			table.insert(tied, name)
		end
	end
	return tied[math.random(1, #tied)]
end

local function getSpawn()
	if activeMap then
		return activeMap:FindFirstChildWhichIsA("SpawnLocation") or activeMap:FindFirstChild("FFASpawn", true)
	end
end

local function waitMapReady(timeout)
	local start = os.clock()
	while os.clock() - start < timeout do
		if getSpawn() then return true end
		task.wait()
	end
	return getSpawn() ~= nil
end

local function countAlive()
	local n, last = 0, nil
	for p, alive in pairs(alivePlayers) do
		if alive and p and p.Parent then
			n += 1; last = p
		end
	end
	return n, last
end

local function broadcastAlive()
	fireAll(aliveEvent, countAlive())
end

local function teleportToLobby(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(
			lobbySpawn.Position + Vector3.new(math.random(-4,4), 3, math.random(-4,4))
		)
	end
end

local function teleportToMap(player)
	local spawn = getSpawn()
	if not spawn then return end
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(
			spawn.Position + Vector3.new(math.random(-8,8), 3, math.random(-8,8))
		)
	end
end

local function endRound(winner)
	if roundEnding then return end
	roundEnding = true
	currentState = "Lobby"
	fireAll(winEvent, winner and winner.Name or "Nobody")
	task.wait(4)
	for _, p in ipairs(Players:GetPlayers()) do
		alivePlayers[p] = nil
		teleportToLobby(p)
	end
	unloadMap()
	fireAll(stateEvent, "Lobby", {})
	roundEnding = false
end

local function onPlayerDied(player, humanoid)
	if currentState ~= "InGame" then return end
	alivePlayers[player] = false
	broadcastAlive()

	local killer = humanoid and GamepassSFX.ConsumeKiller(humanoid)
	if killer and killer ~= player then
		GamepassSFX.NotifyKill(killer)
		local coins = math.floor(KILL_COINS * PerkMultipliers.GetCoinMultiplier(killer) + 0.5)
		local exp = math.floor(KILL_EXP * PerkMultipliers.GetXPMultiplier(killer) + 0.5)
		CurrencyAPI.AddCoins(killer, coins, "kill", exp)
		LevelSystem.AddExp(killer, exp)
	end

	task.delay(0.3, function()
		if currentState ~= "InGame" or roundEnding then return end
		local n, last = countAlive()
		if n <= 1 then endRound(last) end
	end)
end

local function setupChar(player, char)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.Died:Connect(function()
		onPlayerDied(player, humanoid)
	end)
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(char) setupChar(player, char) end)
	if player.Character then setupChar(player, player.Character) end
end

Players.PlayerAdded:Connect(function(p)
	setupPlayer(p)
	if currentState ~= "InGame" then
		task.delay(1, function()
			if p and p.Parent then teleportToLobby(p) end
		end)
	end
end)

Players.PlayerRemoving:Connect(function(p)
	if mapVotes[p] then
		local v = mapVotes[p]
		voteTally[v] = math.max(0, (voteTally[v] or 1) - 1)
		mapVotes[p] = nil
		fireAll(voteUpdateEvent, voteTally)
	end
	if currentState == "InGame" then
		alivePlayers[p] = nil
		task.delay(0.3, function()
			if currentState ~= "InGame" or roundEnding then return end
			local n, last = countAlive()
			if n <= 1 then endRound(last) end
		end)
	end
end)

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

mapVoteEvent.OnServerEvent:Connect(function(player, mapName)
	if not votingOpen then return end
	local valid = false
	for _, n in ipairs(voteCandidates) do
		if n == mapName then valid = true; break end
	end
	if not valid then return end
	local prev = mapVotes[player]
	if prev == mapName then return end
	if prev then voteTally[prev] = math.max(0, (voteTally[prev] or 1) - 1) end
	mapVotes[player] = mapName
	voteTally[mapName] = (voteTally[mapName] or 0) + 1
	fireAll(voteUpdateEvent, voteTally)
end)

-- main loop
while true do
	currentState = "Lobby"
	roundEnding = false
	fireAll(stateEvent, "Lobby", {})
	repeat task.wait(1) until #Players:GetPlayers() >= MIN_PLAYERS

	currentState = "Intermission"
	resetVotes()
	for t = INTERMISSION_TIME, 1, -1 do
		fireAll(stateEvent, "Intermission", { time = t })
		if t == INTERMISSION_TIME then
			startVote()
		end
		task.wait(1)
	end
	if #Players:GetPlayers() < MIN_PLAYERS then continue end

	loadMap(tallyWinner())
	waitMapReady(5)
	task.wait(0.5)

	currentState = "InGame"
	roundEnding = false
	alivePlayers = {}
	local allPlayers = Players:GetPlayers()
	for _, p in ipairs(allPlayers) do alivePlayers[p] = true end
	fireAll(stateEvent, "InGame", {})
	broadcastAlive()
	for _, p in ipairs(allPlayers) do teleportToMap(p) end

	repeat task.wait(0.5) until currentState == "Lobby"
	task.wait(3)
end
