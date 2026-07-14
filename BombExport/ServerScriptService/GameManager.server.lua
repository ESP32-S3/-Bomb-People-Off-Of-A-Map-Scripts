```lua
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

-- Round stats (kills/deaths) are tracked here instead of inside CurrencyAPI.
-- CurrencyAPI represents persistent currency state, which is a much heavier
-- read/write path (datastore-backed). Scoreboard numbers change constantly
-- during a round, so routing every kill/death through that module would mean
-- hitting currency logic every tick just to display a number. Keeping a
-- lightweight per-round object avoids that coupling entirely.
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

-- Lazily creates a session on first access instead of requiring every
-- caller to check "does this player have a session yet?" This matters
-- because players can be referenced from multiple independent events
-- (PlayerAdded, death handling, vote removal) and the ordering between
-- those isn't guaranteed — this guarantees a session exists no matter
-- which one fires first.
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

-- Maps live in ServerStorage until picked, rather than sitting permanently
-- in workspace. This keeps unloaded maps out of physics/streaming and makes
-- "which maps exist" a simple folder scan instead of needing a separate
-- registry to maintain in parallel with the actual map folders.
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

	-- chosenName comes from the vote result, but that vote could have had
	-- zero candidates (edge case) or referenced a name that no longer
	-- matches a folder (e.g. renamed mid-development). Falling back to a
	-- random pick guarantees a map always loads rather than the round
	-- loop stalling on a nil.
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

	-- Reparenting is how the map actually "loads" — moving it into the
	-- live map folder puts its parts under workspace so they simulate,
	-- stream to clients, and are visible to spawn raycasts.
	chosen.Parent = currentMapFolder
	activeMap = chosen
	mapChangedBE:Fire(chosen)
end

local function unloadMap()
	if activeMap then
		-- Reparenting back to ServerStorage (rather than destroying) means
		-- the same map instance gets reused next time it's picked, instead
		-- of re-cloning/rebuilding it from scratch every round.
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

-- Fisher-Yates shuffle. A naive "just insert in whatever order and pick the
-- first 3" would silently favor whichever maps happen to sit earlier in
-- ServerStorage's child order (Roblox doesn't guarantee that order is
-- randomized on its own). This produces a uniformly random ordering so
-- ballot candidates aren't skewed by folder placement.
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
	-- Closing the vote on a delayed timer (rather than only closing it when
	-- the intermission countdown reaches zero) means votingOpen reflects
	-- the vote's own duration even if VOTE_DURATION and INTERMISSION_TIME
	-- ever drift apart, so late votes can't sneak in after the window closes.
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
		-- Nobody voted at all, so every candidate is tied at zero. Picking
		-- randomly here (instead of e.g. always picking candidate #1)
		-- avoids the same map effectively becoming "default" every time
		-- voting participation is low.
		return voteCandidates[math.random(1, #voteCandidates)]
	end

	-- Multiple maps can legitimately tie for the highest vote count.
	-- Collecting all of them and picking randomly among the tied set keeps
	-- the result fair, instead of always favoring whichever tied option
	-- appears first in voteCandidates.
	local tied = {}
	for _, name in ipairs(voteCandidates) do
		if (voteTally[name] or 0) == maxCount then
			table.insert(tied, name)
		end
	end
	return tied[math.random(1, #tied)]
end

-- Spawn points are placed on a ring around a base position using angle-based
-- CFrame math (rather than all players spawning at one exact point) so
-- characters don't stack on top of each other and shove each other around
-- immediately after teleporting.
local spawnRayParams = RaycastParams.new()
spawnRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getSpawnPart()
	if not activeMap then return nil end
	-- Two fallback strategies: a standard SpawnLocation part, or a part
	-- specifically named "FFASpawn" nested anywhere in the map. This lets
	-- map builders use either the built-in Roblox spawn object or a custom
	-- marker without the round logic needing to know which style a given
	-- map uses.
	return activeMap:FindFirstChildWhichIsA("SpawnLocation")
		or activeMap:FindFirstChild("FFASpawn", true)
end

local function waitMapReady(timeout)
	-- Polls for the spawn part rather than assuming it exists the instant
	-- the map is reparented, because large maps can still be streaming in
	-- their contents when loadMap returns. Bounding this with a timeout
	-- prevents an infinite hang if a map is missing a spawn part entirely.
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

	-- The ray starts well above the target spot and fires straight down.
	-- This is necessary because maps can have uneven terrain — using the
	-- spawn part's raw Y position directly would clip characters into
	-- hills or leave them floating above dips. Casting down finds the
	-- actual walkable surface under each ring position.
	spawnRayParams.FilterDescendantsInstances = { currentMapFolder }
	local result = workspace:Raycast(rayOrigin, Vector3.new(0, -SPAWN_RAY_HEIGHT * 2, 0), spawnRayParams)

	-- If the raycast misses (e.g. a gap in the map geometry), falling back
	-- to basePos.Y keeps spawning functional instead of erroring out.
	local groundY = result and result.Position.Y or basePos.Y
	local finalPos = Vector3.new(rayOrigin.X, groundY + 3, rayOrigin.Z)
	return CFrame.new(finalPos)
end

local function teleportToLobby(player, index, total)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Spreading players evenly around the circle (rather than clustering
	-- angles arbitrarily) means index/total directly determines each
	-- player's slot, so the ring stays evenly spaced regardless of how
	-- many players are being placed at once.
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
		-- Checking player.Parent guards against a player who disconnected
		-- mid-round but whose session entry hasn't been cleaned up yet by
		-- PlayerRemoving — without this check a departed player could
		-- still count as "alive" and block the round from ending.
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

-- Wrapped in pcall because UpdateAsync can throttle or fail for reasons
-- outside this script's control (datastore request budget, backend
-- hiccups). Without the pcall, a single failed save would throw and kill
-- whichever coroutine called it — which, since this runs from both the
-- autosave loop and PlayerRemoving, could interrupt the entire round loop
-- or leave a leaving player's data half-processed.
local function saveSession(player)
	local session = sessions[player]
	if not session then return end

	local ok, err = pcall(function()
		-- UpdateAsync (rather than SetAsync) is used so this adds to
		-- whatever total already exists in the store instead of overwriting
		-- it — necessary because this same function runs repeatedly across
		-- multiple autosave cycles and rounds for the same player.
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

-- Runs independently of the round loop so stats get persisted periodically
-- even during a long round, rather than only on player removal — this
-- limits data loss if the server crashes mid-round to at most one
-- autosave interval's worth of progress.
task.spawn(function()
	while true do
		task.wait(AUTOSAVE_INTERVAL)
		for _, player in ipairs(Players:GetPlayers()) do
			saveSession(player)
		end
	end
end)

local function endRound(winner)
	-- roundEnding is a guard against re-entrancy: countAlive dropping to
	-- <=1 can be observed from more than one death event in quick
	-- succession (e.g. two players dying almost simultaneously), and
	-- without this flag endRound could fire twice for the same round.
	if roundEnding then return end
	roundEnding = true
	currentState = "Lobby"

	fireAll(winEvent, winner and winner.Name or "Nobody")
	-- Pausing here gives clients time to show the winner announcement
	-- before players get yanked back to the lobby, instead of the
	-- teleport happening instantly and cutting off that moment.
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
	-- Only evaluates during an actual in-progress round — calling this
	-- during Lobby/Intermission would be meaningless since sessions are
	-- reset between rounds, and skipping while roundEnding is already true
	-- prevents redundant work while the round-end sequence is mid-flight.
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

	-- GamepassSFX tracks which humanoid dealt the killing blow separately
	-- from this script, since damage-source tracking needs to hook into
	-- the same tool/weapon code that GamepassSFX already owns. Consuming
	-- it here (rather than reading and leaving it) clears that record so
	-- a stale killer tag can't be misattributed to a future, unrelated death.
	local killer = humanoid and GamepassSFX.ConsumeKiller(humanoid)
	if killer and killer ~= player then
		local killerSession = getSession(killer)
		killerSession:RegisterKill()

		GamepassSFX.NotifyKill(killer)
		-- Rounding with +0.5 before flooring converts truncation into
		-- standard rounding — without it, a multiplier like 1.5x would
		-- consistently shortchange the player by always rounding down
		-- rather than to the nearest whole reward.
		local coins = math.floor(KILL_COINS * PerkMultipliers.GetCoinMultiplier(killer) + 0.5)
		local exp = math.floor(KILL_EXP * PerkMultipliers.GetXPMultiplier(killer) + 0.5)
		CurrencyAPI.AddCoins(killer, coins, "kill", exp)
		LevelSystem.AddExp(killer, exp)
	end

	-- Deferred slightly rather than checked immediately, so that if two
	-- players die in the same instant, both deaths get registered into
	-- session state before the alive-count is evaluated — checking
	-- synchronously here could catch the count mid-update and misjudge
	-- the round as over (or not) based on incomplete information.
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
	-- Connecting to CharacterAdded up front handles every respawn for this
	-- player's lifetime, while the explicit check below handles the case
	-- where a character already exists at connect-time (e.g. server
	-- restarts, or this being called from the initial server-players loop)
	-- — without that check, an already-spawned character's death would
	-- never be wired up.
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
		-- Delayed slightly so the player's character has time to actually
		-- spawn in before the teleport runs — teleportToLobby needs
		-- HumanoidRootPart to exist, which isn't guaranteed the instant
		-- PlayerAdded fires.
		task.delay(1, function()
			if player and player.Parent then
				teleportToLobby(player, 1, 1)
			end
		end)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	-- If the leaving player had voted, their vote needs to be un-counted
	-- so the tally clients see doesn't include a vote from someone no
	-- longer in the game, which would misrepresent how close the vote is.
	if mapVotes[player] then
		local votedFor = mapVotes[player]
		voteTally[votedFor] = math.max(0, (voteTally[votedFor] or 1) - 1)
		mapVotes[player] = nil
		fireAll(voteUpdateEvent, voteTally)
	end

	saveSession(player)

	-- If they leave mid-round, their session needs to be marked dead so
	-- the alive-count used to decide "is the round over" doesn't keep
	-- counting a player who's no longer connected.
	if currentState == "InGame" and sessions[player] then
		sessions[player].alive = false
		task.delay(0.3, checkRoundOver)
	end

	sessions[player] = nil
end)

-- Handles players already in the server when this script starts running
-- (e.g. a script reload), since PlayerAdded only fires for players joining
-- after the connection is made.
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

mapVoteEvent.OnServerEvent:Connect(function(player, mapName)
	-- Rejects votes outside the voting window and validates mapName
	-- against the actual candidate list — both checks exist because this
	-- handler receives raw client input, which could be stale (sent after
	-- the window closed) or spoofed (a name never offered as a candidate).
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
	-- Voting for the same map again is a no-op rather than double-counting
	-- — without this check, re-sending the same vote would increment the
	-- tally each time instead of representing one player, one vote.
	if previous == mapName then return end

	-- Changing a vote requires removing the old tally entry before adding
	-- the new one, so a player switching their choice doesn't get counted
	-- toward two different maps simultaneously.
	if previous then
		voteTally[previous] = math.max(0, (voteTally[previous] or 1) - 1)
	end
	mapVotes[player] = mapName
	voteTally[mapName] = (voteTally[mapName] or 0) + 1
	fireAll(voteUpdateEvent, voteTally)
end)

-- Main round loop. Structured as an infinite state machine (Lobby ->
-- Intermission -> InGame -> back to Lobby) running in a single coroutine,
-- rather than event-driven state transitions, so the round's timing and
-- ordering stays linear and easy to follow top-to-bottom instead of being
-- scattered across multiple independent callbacks.
while true do
	currentState = "Lobby"
	roundEnding = false
	fireAll(stateEvent, "Lobby", {})

	-- Blocks here until enough players are present, since starting a round
	-- with fewer than MIN_PLAYERS wouldn't make sense for a free-for-all
	-- format (nobody to fight).
	repeat
		task.wait(1)
	until #Players:GetPlayers() >= MIN_PLAYERS

	currentState = "Intermission"
	resetVotes()

	for t = INTERMISSION_TIME, 1, -1 do
		fireAll(stateEvent, "Intermission", { time = t })
		-- Starting the vote exactly on the first countdown tick (rather
		-- than before the loop) means the vote's own duration is measured
		-- from a point clients have already been told intermission began,
		-- keeping the vote window inside the visible countdown.
		if t == INTERMISSION_TIME then
			startVote()
		end
		task.wait(1)
	end

	-- Player count can drop below the minimum during intermission (players
	-- leaving). Re-checking here and looping back to Lobby avoids starting
	-- a round that would immediately have too few participants.
	if #Players:GetPlayers() < MIN_PLAYERS then
		continue
	end

	loadMap(tallyWinner())
	waitMapReady(5)
	-- Small buffer after the map reports ready, giving physics/streaming
	-- one more moment to settle before players are teleported in.
	task.wait(0.5)

	currentState = "InGame"
	roundEnding = false

	-- Snapshotting Players:GetPlayers() into roundPlayers up front means
	-- the round's initial spawn count is fixed at round-start, rather than
	-- being recalculated (and potentially changing) as players are
	-- iterated over below.
	local roundPlayers = Players:GetPlayers()
	for _, p in ipairs(roundPlayers) do
		getSession(p):Reset()
	end

	fireAll(stateEvent, "InGame", {})
	broadcastAlive()

	for i, p in ipairs(roundPlayers) do
		teleportToMap(p, i, #roundPlayers)
	end

	-- Blocks here for the entire duration of the round — currentState only
	-- flips back to "Lobby" from inside endRound, so this is effectively
	-- waiting for the round-over condition to be detected and processed
	-- elsewhere before the loop continues.
	repeat
		task.wait(0.5)
	until currentState == "Lobby"

	task.wait(3)
end
```
