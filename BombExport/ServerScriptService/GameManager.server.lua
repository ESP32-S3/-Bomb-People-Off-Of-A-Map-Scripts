--Connected Discord Github
--Discord: goofygoober211  Roblox: zohohohobro

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")

local GamepassSFX = require(ServerScriptService:WaitForChild("GamepassSFX"))
local CurrencyAPI = require(ServerScriptService:WaitForChild("CurrencyAPI"))
local LevelSystem = require(ServerScriptService:WaitForChild("LevelSystem"))
local PerkMultipliers = require(RS:WaitForChild("PerkMultipliers"))

local SessionStore = DataStoreService:GetDataStore("FFA_SessionStats_v1")

local KILL_COINS = 25
local KILL_EXP = 15
local INTERMISSION_TIME = 20
local VOTE_DURATION = 12
local MIN_PLAYERS = 2
local SPAWN_RADIUS = 8
local SPAWN_RAY_HEIGHT = 20
local AUTOSAVE_INTERVAL = 60

local events = RS:WaitForChild("RoundEvents")
local stateEvent = events:WaitForChild("StateChanged")
local aliveEvent = events:WaitForChild("AliveChanged")
local winEvent = events:WaitForChild("RoundWinner")
local mapChangedBE = RS:WaitForChild("MapChanged")
local voteStartEvent = events:WaitForChild("VoteStart")
local mapVoteEvent = events:WaitForChild("MapVote")
local voteUpdateEvent = events:WaitForChild("VoteUpdate")

local lobby = workspace:WaitForChild("Floating Lobby")
local lobbySpawn = lobby:WaitForChild("SpawnLocation")
local currentMapFolder = workspace:WaitForChild("CurrentMap")

-- keeping round stats (kills/deaths) separate from the currency module
-- so I'm not calling CurrencyAPI every tick just to show a scoreboard
local PlayerSession = {}
PlayerSession.__index = PlayerSession

function PlayerSession.new(player)
	local self = setmetatable({}, PlayerSession)
	self.player = player
	self.kills = 0
	self.deaths = 0
	self.alive = true
	return self
end

function PlayerSession:RegisterKill()
	self.kills += 1
end

function PlayerSession:RegisterDeath()
	self.deaths += 1
	self.alive = false
end

function PlayerSession:Reset()
	self.kills = 0
	self.deaths = 0
	self.alive = true
end

local sessions = {}

local function getSession(player)
	local s = sessions[player]
	if not s then
		s = PlayerSession.new(player)
		sessions[player] = s
	end
	return s
end

local currentState = "Lobby"
local activeMap = nil
local roundEnding = false

local mapVotes = {}
local voteTally = {}
local voteCandidates = {}
local votingOpen = false

local function getMaps()
	local pool = {}
	for _, folder in ipairs(ServerStorage:GetChildren()) do
		if folder:IsA("Folder") and folder.Name ~= "CurrentMap" then
			table.insert(pool, folder)
		end
	end
	return pool
end

local function loadMap(chosenName)
	local maps = getMaps()
	assert(#maps > 0, "No map folders found in ServerStorage!")

	local chosen
	if chosenName then
		for _, m in ipairs(maps) do
			if m.Name == chosenName then
				chosen = m
				break
			end
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

-- fisher-yates, so candidate picks aren't biased toward folder order
local function shuffle(list)
	for i = #list, 2, -1 do
		local j = math.random(i)
		list[i], list[j] = list[j], list[i]
	end
	return list
end

local function startVote()
	local pool = shuffle(getMaps())
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
	if #voteCandidates == 0 then return nil end

	local maxCount = 0
	for _, name in ipairs(voteCandidates) do
		maxCount = math.max(maxCount, voteTally[name] or 0)
	end

	if maxCount == 0 then
		-- nobody voted, just grab a random map off the ballot
		return voteCandidates[math.random(1, #voteCandidates)]
	end

	local tied = {}
	for _, name in ipairs(voteCandidates) do
		if (voteTally[name] or 0) == maxCount then
			table.insert(tied, name)
		end
	end
	return tied[math.random(1, #tied)]
end

-- players get placed on a ring around the spawn point using CFrame math,
-- then a downward raycast finds actual ground height so nobody spawns
-- clipped into terrain or floating above it on uneven maps
local spawnRayParams = RaycastParams.new()
spawnRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getSpawnPart()
	if not activeMap then return nil end
	return activeMap:FindFirstChildWhichIsA("SpawnLocation")
		or activeMap:FindFirstChild("FFASpawn", true)
end

local function waitMapReady(timeout)
	local start = os.clock()
	while os.clock() - start < timeout do
		if getSpawnPart() then return true end
		task.wait()
	end
	return getSpawnPart() ~= nil
end

local function computeGroundedSpawnCFrame(basePos, angle, radius)
	local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
	local rayOrigin = basePos + offset + Vector3.new(0, SPAWN_RAY_HEIGHT, 0)

	spawnRayParams.FilterDescendantsInstances = { currentMapFolder }
	local result = workspace:Raycast(rayOrigin, Vector3.new(0, -SPAWN_RAY_HEIGHT * 2, 0), spawnRayParams)

	local groundY = result and result.Position.Y or basePos.Y
	local finalPos = Vector3.new(rayOrigin.X, groundY + 3, rayOrigin.Z)
	return CFrame.new(finalPos)
end

local function teleportToLobby(player, index, total)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local angle = (index / math.max(total, 1)) * math.pi * 2
	root.CFrame = computeGroundedSpawnCFrame(lobbySpawn.Position, angle, 6)
end

local function teleportToMap(player, index, total)
	local spawnPart = getSpawnPart()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not spawnPart or not root then return end

	local angle = (index / math.max(total, 1)) * math.pi * 2
	root.CFrame = computeGroundedSpawnCFrame(spawnPart.Position, angle, SPAWN_RADIUS)
end

local function countAlive()
	local n, last = 0, nil
	for player, session in pairs(sessions) do
		if session.alive and player and player.Parent then
			n += 1
			last = player
		end
	end
	return n, last
end

local function broadcastAlive()
	fireAll(aliveEvent, countAlive())
end

-- pcall wrapped since UpdateAsync throttles/fails sometimes and that
-- should never be allowed to blow up the round loop
local function saveSession(player)
	local session = sessions[player]
	if not session then return end

	local ok, err = pcall(function()
		SessionStore:UpdateAsync("Player_" .. player.UserId, function(old)
			old = old or { TotalKills = 0, TotalDeaths = 0 }
			old.TotalKills += session.kills
			old.TotalDeaths += session.deaths
			return old
		end)
	end)

	if not ok then
		warn(("FFA autosave failed for %s: %s"):format(player.Name, tostring(err)))
	end
end

task.spawn(function()
	while true do
		task.wait(AUTOSAVE_INTERVAL)
		for _, player in ipairs(Players:GetPlayers()) do
			saveSession(player)
		end
	end
end)

local function endRound(winner)
	if roundEnding then return end
	roundEnding = true
	currentState = "Lobby"

	fireAll(winEvent, winner and winner.Name or "Nobody")
	task.wait(4)

	local players = Players:GetPlayers()
	for i, p in ipairs(players) do
		local session = sessions[p]
		if session then session:Reset() end
		teleportToLobby(p, i, #players)
	end

	unloadMap()
	fireAll(stateEvent, "Lobby", {})
	roundEnding = false
end

local function checkRoundOver()
	if currentState ~= "InGame" or roundEnding then return end
	local n, last = countAlive()
	if n <= 1 then
		endRound(last)
	end
end

local function onPlayerDied(player, humanoid)
	if currentState ~= "InGame" then return end

	local session = getSession(player)
	session:RegisterDeath()
	broadcastAlive()

	-- GamepassSFX tags the humanoid with whoever landed the last hit
	local killer = humanoid and GamepassSFX.ConsumeKiller(humanoid)
	if killer and killer ~= player then
		local killerSession = getSession(killer)
		killerSession:RegisterKill()

		GamepassSFX.NotifyKill(killer)
		local coins = math.floor(KILL_COINS * PerkMultipliers.GetCoinMultiplier(killer) + 0.5)
		local exp = math.floor(KILL_EXP * PerkMultipliers.GetXPMultiplier(killer) + 0.5)
		CurrencyAPI.AddCoins(killer, coins, "kill", exp)
		LevelSystem.AddExp(killer, exp)
	end

	task.delay(0.3, checkRoundOver)
end

local function setupChar(player, char)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.Died:Connect(function()
		onPlayerDied(player, humanoid)
	end)
end

local function setupPlayer(player)
	getSession(player)
	player.CharacterAdded:Connect(function(char)
		setupChar(player, char)
	end)
	if player.Character then
		setupChar(player, player.Character)
	end
end

Players.PlayerAdded:Connect(function(player)
	setupPlayer(player)
	if currentState ~= "InGame" then
		task.delay(1, function()
			if player and player.Parent then
				teleportToLobby(player, 1, 1)
			end
		end)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if mapVotes[player] then
		local votedFor = mapVotes[player]
		voteTally[votedFor] = math.max(0, (voteTally[votedFor] or 1) - 1)
		mapVotes[player] = nil
		fireAll(voteUpdateEvent, voteTally)
	end

	saveSession(player)

	if currentState == "InGame" and sessions[player] then
		sessions[player].alive = false
		task.delay(0.3, checkRoundOver)
	end

	sessions[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

mapVoteEvent.OnServerEvent:Connect(function(player, mapName)
	if not votingOpen then return end

	local isValid = false
	for _, name in ipairs(voteCandidates) do
		if name == mapName then
			isValid = true
			break
		end
	end
	if not isValid then return end

	local previous = mapVotes[player]
	if previous == mapName then return end

	if previous then
		voteTally[previous] = math.max(0, (voteTally[previous] or 1) - 1)
	end
	mapVotes[player] = mapName
	voteTally[mapName] = (voteTally[mapName] or 0) + 1
	fireAll(voteUpdateEvent, voteTally)
end)

while true do
	currentState = "Lobby"
	roundEnding = false
	fireAll(stateEvent, "Lobby", {})

	repeat
		task.wait(1)
	until #Players:GetPlayers() >= MIN_PLAYERS

	currentState = "Intermission"
	resetVotes()

	for t = INTERMISSION_TIME, 1, -1 do
		fireAll(stateEvent, "Intermission", { time = t })
		if t == INTERMISSION_TIME then
			startVote()
		end
		task.wait(1)
	end

	if #Players:GetPlayers() < MIN_PLAYERS then
		continue
	end

	loadMap(tallyWinner())
	waitMapReady(5)
	task.wait(0.5)

	currentState = "InGame"
	roundEnding = false

	local roundPlayers = Players:GetPlayers()
	for _, p in ipairs(roundPlayers) do
		getSession(p):Reset()
	end

	fireAll(stateEvent, "InGame", {})
	broadcastAlive()

	for i, p in ipairs(roundPlayers) do
		teleportToMap(p, i, #roundPlayers)
	end

	repeat
		task.wait(0.5)
	until currentState == "Lobby"

	task.wait(3)
end
