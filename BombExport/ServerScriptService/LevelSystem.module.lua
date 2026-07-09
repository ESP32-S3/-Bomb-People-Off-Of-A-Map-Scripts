-- levelsystem: holds level/exp state per player, billboard display, datastore save/load,
-- exp-granting hooks call levelsystem.addexp(player, amount) later, none wired yet

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LevelFormula = require(ReplicatedStorage:WaitForChild("LevelFormula"))
local levelStore = DataStoreService:GetDataStore("PlayerLevelData_v1")

local LevelSystem = {}
local playerData = {} -- [player] = {Level = n, Exp = n}

local function createBillboard(character)
	local head = character:WaitForChild("Head")

	local existing = head:FindFirstChild("LevelBillboard")
	if existing then
		existing:Destroy()
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "LevelBillboard"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 80, 0, 24)
	billboard.StudsOffset = Vector3.new(0, 2.6, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Name = "LevelLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.4
	label.Text = "Lvl 1"
	label.Parent = billboard

end

local function updateBillboardText(player)
	local character = player.Character
	if not character then
		return
	end

	local head = character:FindFirstChild("Head")
	if not head then
		return
	end

	local billboard = head:FindFirstChild("LevelBillboard")
	if not billboard then
		return
	end

	local label = billboard:FindFirstChild("LevelLabel")
	if not label then
		return
	end

	local data = playerData[player]
	label.Text = "Lvl " .. tostring(data and data.Level or 1)
end

local function onCharacterAdded(player, character)
	createBillboard(character)
	updateBillboardText(player)
end

local function loadData(player)
	local data

	local ok, err = pcall(function()
		data = levelStore:GetAsync("Player_" .. player.UserId)
	end)

	if not ok then
		warn("[LevelSystem] load fail for " .. player.Name .. ": " .. tostring(err))
	end

	data = data or {Level = 1, Exp = 0}
	playerData[player] = data

	player:SetAttribute("Level", data.Level)
	player:SetAttribute("Exp", data.Exp)
end

local function saveData(player)
	local data = playerData[player]
	if not data then
		return
	end

	local ok, err = pcall(function()
		levelStore:SetAsync("Player_" .. player.UserId, data)
	end)

	if not ok then
		warn("[LevelSystem] save fail for " .. player.Name .. ": " .. tostring(err))
	end
end

-- public api, ready for future exp sources to call into
function LevelSystem.AddExp(player, amount)
	local data = playerData[player]
	if not data or not amount or amount <= 0 then
		return
	end

	data.Exp += amount

	local leveledUp = false
	local threshold = LevelFormula.GetExpToNextLevel(data.Level)

	while data.Exp >= threshold do
		data.Exp -= threshold
		data.Level += 1
		leveledUp = true
		threshold = LevelFormula.GetExpToNextLevel(data.Level)
	end

	player:SetAttribute("Level", data.Level)
	player:SetAttribute("Exp", data.Exp)

	if leveledUp then
		updateBillboardText(player)
	end
end

function LevelSystem.GetData(player)
	return playerData[player]
end

function LevelSystem.Init()
	Players.PlayerAdded:Connect(function(player)
		loadData(player)

		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)

		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		saveData(player)
		playerData[player] = nil
	end)

	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do
			saveData(player)
		end
	end)

	-- catch players already in-game (e.g. script reloaded in studio test)
	for _, player in ipairs(Players:GetPlayers()) do
		loadData(player)
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end
end

return LevelSystem
