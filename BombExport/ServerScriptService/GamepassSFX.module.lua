-- gamepasssfx: owns gamepass-gated custom-sound logic for kill and explosion sfx,
-- set the two gamepass ids below once they exist (0 = disabled)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KILL_GAMEPASS_ID = 1893184301
local EXPLOSION_GAMEPASS_ID = 1891054366

local DEFAULT_KILL_SOUND_ID = ""
local DEFAULT_EXPLOSION_SOUND_ID = ""

local store = nil
do
	local ok, ds = pcall(function()
		return DataStoreService:GetDataStore("GamepassSFXSettings_v1")
	end)
	if ok then store = ds end
end

local remotesFolder = ReplicatedStorage:FindFirstChild("GamepassRemotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "GamepassRemotes"
	remotesFolder.Parent = ReplicatedStorage
end

local function ensure(className, name)
	local inst = remotesFolder:FindFirstChild(name)
	if not inst then
		inst = Instance.new(className)
		inst.Name = name
		inst.Parent = remotesFolder
	end
	return inst
end

local ownsGamepassFn   = ensure("RemoteFunction", "OwnsGamepass")
local setSoundEvt      = ensure("RemoteEvent", "SetCustomSoundId")
local playKillSoundEvt = ensure("RemoteEvent", "PlayKillSound")

local PASS_ID = {
	Kill = KILL_GAMEPASS_ID,
	Explosion = EXPLOSION_GAMEPASS_ID,
}

local settings = {}        -- [UserId] = { kill = soundId, explosion = soundId }
local ownershipCache = {}  -- [UserId] = { Kill = bool, Explosion = bool }
local hitTags = {}         -- [Humanoid] = { killer = Player, expires = os.clock() }

local function checkOwnership(player, passType)
	local id = PASS_ID[passType]
	if not id or id <= 0 then return false end

	local cache = ownershipCache[player.UserId]
	if cache and cache[passType] ~= nil then
		return cache[passType]
	end

	local ok, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
	end)
	owns = ok and owns or false

	cache = cache or {}
	cache[passType] = owns
	ownershipCache[player.UserId] = cache
	return owns
end

local function loadSettings(player)
	local data = nil
	if store then
		local ok, result = pcall(function()
			return store:GetAsync("u_" .. player.UserId)
		end)
		if ok then data = result end
	end
	settings[player.UserId] = data or {}
end

local function saveSettings(player)
	if not store then return end
	local data = settings[player.UserId]
	if not data then return end
	pcall(function()
		store:SetAsync("u_" .. player.UserId, data)
	end)
end

local function sanitizeSoundId(raw)
	if typeof(raw) == "number" then
		raw = tostring(raw)
	end
	if typeof(raw) ~= "string" then return nil end

	raw = raw:gsub("rbxassetid://", "")
	raw = raw:gsub("%D", "")
	if raw == "" or #raw > 18 then return nil end

	local n = tonumber(raw)
	if not n or n <= 0 or n ~= math.floor(n) then return nil end

	return "rbxassetid://" .. raw
end

local Module = {}

function Module.GetExplosionSoundId(thrower, skinSoundId)
	local data = thrower and settings[thrower.UserId]
	if data and data.explosion and checkOwnership(thrower, "Explosion") then
		return data.explosion
	end
	if skinSoundId and skinSoundId ~= "" and skinSoundId ~= "rbxassetid://0" then
		return skinSoundId
	end
	return DEFAULT_EXPLOSION_SOUND_ID
end

function Module.GetKillSoundId(killer)
	local data = killer and settings[killer.UserId]
	if data and data.kill and checkOwnership(killer, "Kill") then
		return data.kill
	end
	return DEFAULT_KILL_SOUND_ID
end

-- tag a victim's humanoid with who threw the bomb that hit them, so the
-- round system can attribute the kill a moment later when died fires
function Module.TagHit(humanoid, killer)
	if not humanoid or not killer then return end
	hitTags[humanoid] = { killer = killer, expires = os.clock() + 8 }
end

-- call once, right when a humanoid dies, consumes (clears) the tag
function Module.ConsumeKiller(humanoid)
	local tag = hitTags[humanoid]
	if not tag then return nil end
	hitTags[humanoid] = nil
	if os.clock() > tag.expires then return nil end
	if not tag.killer or not tag.killer.Parent then return nil end
	return tag.killer
end

-- plays the killer's (custom or default) kill sound, audible to them only
function Module.NotifyKill(killer)
	if not killer then return end
	playKillSoundEvt:FireClient(killer, Module.GetKillSoundId(killer))
end

ownsGamepassFn.OnServerInvoke = function(player, passType)
	if passType ~= "Kill" and passType ~= "Explosion" then return false end
	return checkOwnership(player, passType)
end

setSoundEvt.OnServerEvent:Connect(function(player, passType, rawId)
	if passType ~= "Kill" and passType ~= "Explosion" then return end
	if not checkOwnership(player, passType) then return end

	local clean = sanitizeSoundId(rawId)
	if not clean then return end

	local data = settings[player.UserId] or {}
	if passType == "Kill" then
		data.kill = clean
	else
		data.explosion = clean
	end
	settings[player.UserId] = data
	saveSettings(player)
end)

Players.PlayerAdded:Connect(loadSettings)
Players.PlayerRemoving:Connect(function(player)
	saveSettings(player)
	settings[player.UserId] = nil
	ownershipCache[player.UserId] = nil
end)

for _, p in ipairs(Players:GetPlayers()) do
	loadSettings(p)
end

return Module
