local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local CrateData = require(RS:WaitForChild("CrateData"))
local PlayerEquip = require(script.Parent.PlayerEquip)
local CurrencyAPI = require(script.Parent.CurrencyAPI)

local ShopEvents = RS:WaitForChild("ShopEvents")
local BuyCrate = ShopEvents:WaitForChild("BuyCrate")
local OpenCrate = ShopEvents:WaitForChild("OpenCrate")
local SellItem = ShopEvents:WaitForChild("SellItem")
local EquipItem = ShopEvents:WaitForChild("EquipItem")
local GetData = ShopEvents:WaitForChild("GetData")
local CrateResult = ShopEvents:WaitForChild("CrateResult")
local DataUpdate = ShopEvents:WaitForChild("DataUpdate")
local OpenShop = ShopEvents:WaitForChild("OpenShop")

local RunService = game:GetService("RunService")

local STARTING_COINS = 500
local STUDIO_COINS = 100000
local SELL_MULTIPLIER = 0.6

local shopStore = DataStoreService:GetDataStore("PlayerShopData_v1")

local playerData = {}

local function loadData(player)
	local saved

	local ok, err = pcall(function()
		saved = shopStore:GetAsync("Player_" .. player.UserId)
	end)

	if not ok then
		warn("[ShopServer] load fail for " .. player.Name .. ": " .. tostring(err))
	end

	playerData[player.UserId] = saved or {
		coins = STARTING_COINS,
		inventory = {},
		ownedCrates = {},
	}

	-- studio playtest override: give lots of coins
	if RunService:IsStudio() then
		playerData[player.UserId].coins = STUDIO_COINS
	end

	-- restore equipped skin from saved data
	local data = playerData[player.UserId]
	if data.equippedCrate and data.equippedName then
		PlayerEquip.setEquipped(player, data.equippedCrate, data.equippedName)
	end
end

local function saveData(player)
	local data = playerData[player.UserId]
	if not data then return end

	-- persist equipped skin so it survives rejoin
	local eq = PlayerEquip.getEquippedRaw(player)
	data.equippedCrate = eq and eq.crateName or nil
	data.equippedName = eq and eq.name or nil

	local ok, err = pcall(function()
		shopStore:SetAsync("Player_" .. player.UserId, data)
	end)

	if not ok then
		warn("[ShopServer] save fail for " .. player.Name .. ": " .. tostring(err))
	end
end

local function getRandomItem(crateName)
	local items = CrateData.Crates[crateName]
	if not items then return nil end

	local totalWeight = 0
	for _, item in ipairs(items) do
		totalWeight = totalWeight + item.dropChance
	end

	local roll = math.random() * totalWeight
	local current = 0
	for _, item in ipairs(items) do
		current = current + item.dropChance
		if roll <= current then
			return item
		end
	end

	return items[#items]
end

local function sendUpdate(player)
	local data = playerData[player.UserId]
	if not data then return end

	local eq = PlayerEquip.getEquippedRaw(player)

	DataUpdate:FireClient(player, {
		coins = data.coins,
		inventory = data.inventory,
		ownedCrates = data.ownedCrates,
		equippedCrate = eq and eq.crateName or nil,
		equippedName = eq and eq.name or nil,
	})
end

-- let any other server script award coins through currencyapi.addcoins,
-- they'll land in this same table and show up in the existing shop/hud ui
CurrencyAPI.Init(playerData, sendUpdate)

local function onPlayerAdded(player)
	loadData(player)
end

local function onPlayerRemoving(player)
	saveData(player)
	playerData[player.UserId] = nil
	PlayerEquip.clearEquipped(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)

GetData.OnServerInvoke = function(player)
	local data = playerData[player.UserId]
	if not data then
		loadData(player)
		data = playerData[player.UserId]
	end

	local eq = PlayerEquip.getEquippedRaw(player)

	return {
		coins = data.coins,
		inventory = data.inventory,
		ownedCrates = data.ownedCrates,
		cratePrices = CrateData.CratePrices,
		equippedCrate = eq and eq.crateName or nil,
		equippedName = eq and eq.name or nil,
	}
end

BuyCrate.OnServerEvent:Connect(function(player, crateName)
	local data = playerData[player.UserId]
	if not data then return end
	local price = CrateData.CratePrices[crateName]
	if not price then return end
	if data.coins < price then return end
	data.coins = data.coins - price
	data.ownedCrates[crateName] = (data.ownedCrates[crateName] or 0) + 1
	sendUpdate(player)
end)

OpenCrate.OnServerEvent:Connect(function(player, crateName)
	local data = playerData[player.UserId]
	if not data then return end
	if not data.ownedCrates[crateName] or data.ownedCrates[crateName] <= 0 then return end
	local item = getRandomItem(crateName)
	if not item then return end
	data.ownedCrates[crateName] = data.ownedCrates[crateName] - 1
	if data.ownedCrates[crateName] <= 0 then
		data.ownedCrates[crateName] = nil
	end
	table.insert(data.inventory, {
		name = item.name,
		crateName = crateName,
		rarityName = item.rarityName,
		price = item.price,
	})
	CrateResult:FireClient(player, {
		name = item.name,
		crateName = crateName,
		rarityName = item.rarityName,
		price = item.price,
	})
	sendUpdate(player)
end)

SellItem.OnServerEvent:Connect(function(player, itemIndex)
	local data = playerData[player.UserId]
	if not data then return end
	local item = data.inventory[itemIndex]
	if not item then return end

	-- if the sold item was equipped, unequip it
	local eq = PlayerEquip.getEquippedRaw(player)
	if eq and eq.crateName == item.crateName and eq.name == item.name then
		PlayerEquip.clearEquipped(player)
	end

	data.coins = data.coins + math.floor(item.price * SELL_MULTIPLIER)
	table.remove(data.inventory, itemIndex)
	sendUpdate(player)
end)

EquipItem.OnServerEvent:Connect(function(player, itemIndex)
	local data = playerData[player.UserId]
	if not data then return end
	local item = data.inventory[itemIndex]
	if not item then return end

	PlayerEquip.setEquipped(player, item.crateName, item.name)
	sendUpdate(player)
end)

-- proximityprompt triggers shop for the interacting player
local shopkeeper = workspace:FindFirstChild("Shopkeeper")
if shopkeeper then
	local prompt = shopkeeper:FindFirstChild("ProximityPrompt", true)
	if prompt and prompt:IsA("ProximityPrompt") then
		prompt.Triggered:Connect(function(player)
			OpenShop:FireClient(player)
		end)
	end
end