-- gamepassmanager: owns the 3 paid gamepasses: vip, 2x exp, 2x coins,
-- sets player attributes (vip / doublexp / doublecoins) that
-- perkmultipliers and the chat-tag code below read from, and grants
-- the vip gold bomb skin through the real inventory/equip system

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TextChatService = game:GetService("TextChatService")

local GamepassConfig = require(ReplicatedStorage:WaitForChild("GamepassConfig"))
local CurrencyAPI = require(ServerScriptService:WaitForChild("CurrencyAPI"))
local PlayerEquip = require(ServerScriptService:WaitForChild("PlayerEquip"))

local GOLD_CRATE_NAME = "VIPExclusive"
local GOLD_ITEM_NAME = "Golden"

local function grantVIPSkin(player)
	-- shopserver's datastore load may not have finished yet the moment
	-- vip ownership is confirmed, so retry briefly until data exists
	for _ = 1, 6 do
		local data = CurrencyAPI.GetData(player)
		if data then
			data.inventory = data.inventory or {}

			local already = false
			for _, it in ipairs(data.inventory) do
				if it.crateName == GOLD_CRATE_NAME and it.name == GOLD_ITEM_NAME then
					already = true
					break
				end
			end

			if not already then
				table.insert(data.inventory, {
					name = GOLD_ITEM_NAME,
					crateName = GOLD_CRATE_NAME,
					rarityName = "VIP Exclusive",
					price = 0,
				})
				-- first grant only: hand them the gold skin equipped,
				-- after this they're free to switch skins as normal,
				-- it just lives in their inventory from then on
				PlayerEquip.setEquipped(player, GOLD_CRATE_NAME, GOLD_ITEM_NAME)
				CurrencyAPI.RefreshClient(player)
			end

			return
		end
		task.wait(2)
	end
	warn("[GamepassManager] could not grant VIP skin to " .. player.Name .. " — ShopServer data never loaded")
end

local function checkOwnership(player, key, id)
	if player:GetAttribute(key) then return end

	local ok, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
	end)

	if ok and owns then
		player:SetAttribute(key, true)
		if key == "VIP" then
			grantVIPSkin(player)
		end
	end
end

local function checkAllPasses(player)
	for key, data in pairs(GamepassConfig.Passes) do
		checkOwnership(player, key, data.Id)
	end
end

Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		for _ = 1, 4 do
			checkAllPasses(player)
			task.wait(3)
		end
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(checkAllPasses, player)
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if not wasPurchased then return end
	for key, data in pairs(GamepassConfig.Passes) do
		if data.Id == gamePassId then
			player:SetAttribute(key, true)
			if key == "VIP" then
				grantVIPSkin(player)
			end
		end
	end
end)

-- vip chat tag: gold "[vip]" prefix on every message they send,
-- harmless no-op if this place is still on the legacy chat system
pcall(function()
	TextChatService.OnIncomingMessage = function(message)
		local props = Instance.new("TextChatMessageProperties")
		local source = message.TextSource
		if source then
			local player = Players:GetPlayerByUserId(source.UserId)
			if player and player:GetAttribute("VIP") then
				props.PrefixText = string.format('<font color="rgb(255,215,0)">[VIP]</font> %s', message.PrefixText)
			end
		end
		return props
	end
end)
