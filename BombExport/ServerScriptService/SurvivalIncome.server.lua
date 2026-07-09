-- survivalincome: 1c (silent) + 1xp every 5s for every player alive during an active round,
-- no ui feed for this one on purpose, it's a quiet background trickle

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CurrencyAPI = require(ServerScriptService:WaitForChild("CurrencyAPI"))
local LevelSystem = require(ServerScriptService:WaitForChild("LevelSystem"))
local PerkMultipliers = require(ReplicatedStorage:WaitForChild("PerkMultipliers"))

local GameState = ReplicatedStorage:WaitForChild("GameState")

local TICK_SECONDS = 5
local COINS_PER_TICK = 1
local EXP_PER_TICK = 1

local function isAliveInRound(player)
	if GameState.Value ~= "InGame" then
		return false
	end

	local character = player.Character
	if not character then
		return false
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

task.spawn(function()
	while true do
		task.wait(TICK_SECONDS)

		for _, player in ipairs(Players:GetPlayers()) do
			if isAliveInRound(player) then
				local coins = math.floor(COINS_PER_TICK * PerkMultipliers.GetCoinMultiplier(player) + 0.5)
				local exp = math.floor(EXP_PER_TICK * PerkMultipliers.GetXPMultiplier(player) + 0.5)
				CurrencyAPI.AddCoins(player, coins, "survive", exp, true)
				LevelSystem.AddExp(player, exp)
			end
		end
	end
end)
