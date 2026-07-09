local gui = script.Parent
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- modules
local T            = require(script.Parent.UITheme)
local RoundPanels  = require(script.Parent.RoundPanels)
local VotePanel    = require(script.Parent.VotePanel)
local ShopUI       = require(script.Parent.ShopUI)
local InventoryUI  = require(script.Parent.InventoryUI)
local CrateAnim    = require(script.Parent.CrateAnimation)
local CoinShopUI   = require(script.Parent.CoinShopUI)

local RS = game:GetService("ReplicatedStorage")
local CrateData = require(RS:WaitForChild("CrateData"))

-- events
local events          = RS:WaitForChild("RoundEvents")
local ShopEvents      = RS:WaitForChild("ShopEvents")
local buyCrateEvent   = ShopEvents:WaitForChild("BuyCrate")
local openCrateEvent  = ShopEvents:WaitForChild("OpenCrate")
local sellItemEvent   = ShopEvents:WaitForChild("SellItem")
local equipItemEvent  = ShopEvents:WaitForChild("EquipItem")
local getDataFunc     = ShopEvents:WaitForChild("GetData")
local crateResultEvent = ShopEvents:WaitForChild("CrateResult")
local dataUpdateEvent = ShopEvents:WaitForChild("DataUpdate")
local openShopEvent   = ShopEvents:WaitForChild("OpenShop")

-- shared state
local myData = { coins=0, inventory={}, ownedCrates={}, cratePrices={}, equippedCrate=nil, equippedName=nil }

-- persistent coin pill (top-right hud)
local coinPill = T.frame("CoinPill", gui,
	UDim2.new(0,180,0,48), UDim2.new(1,-196,0,16), T.C_DARK, 0.12, 8)
T.addStudOverlay(coinPill, 0.65)
T.corner(coinPill, 24)
T.stroke(coinPill, 2.5, T.C_YELLOW)
T.label("CoinIcon", coinPill, "",
	UDim2.new(0.2,0,1,0), UDim2.new(0.02,0,0,0), T.C_YELLOW)
local coinLabel = T.label("CoinLabel", coinPill, "0",
	UDim2.new(0.75,0,1,0), UDim2.new(0.22,0,0,0), T.C_YELLOW)

-- plus button next to coin pill, opens coin purchase menu
local coinPlusBtn = T.btn("CoinPlusBtn", gui, "+",
	UDim2.new(0,36,0,36), UDim2.new(1,-238,0,22), T.C_DARK, T.C_GREEN)
T.corner(coinPlusBtn, 18)
T.stroke(coinPlusBtn, 2, T.C_GREEN)
coinPlusBtn.ZIndex = 8
coinPlusBtn.MouseButton1Click:Connect(function()
	CoinShopUI.show()
end)

-- inventory toggle button
local invBtn = T.btn("InvButton", gui, "INVENTORY",
	UDim2.new(0,220,0,50), UDim2.new(1,-236,1,-66), T.C_DARK, T.C_CYAN)
T.corner(invBtn, 25)
T.stroke(invBtn, 2.5, T.C_CYAN)
invBtn.ZIndex = 8

local function updateCoinDisplays()
	coinLabel.Text = tostring(myData.coins)
	ShopUI.updateCoinLabel()
	InventoryUI.updateCoinLabel()
end

-- init all sub-modules
RoundPanels.init(gui,
	events:WaitForChild("StateChanged"),
	events:WaitForChild("AliveChanged"),
	events:WaitForChild("RoundWinner"))

VotePanel.init(gui,
	events:WaitForChild("VoteStart"),
	events:WaitForChild("MapVote"),
	events:WaitForChild("VoteUpdate"))

events:WaitForChild("StateChanged").OnClientEvent:Connect(function(state)
	if state == "Lobby" or state == "InGame" then
		VotePanel.hide()
	end
end)

ShopUI.init(gui, CrateData, myData, buyCrateEvent, function(crateName)
	if not CrateAnim.isActive() then
		openCrateEvent:FireServer(crateName)
	end
end)

InventoryUI.init(gui, myData, sellItemEvent, equipItemEvent)

CoinShopUI.init(gui)
CrateAnim.init(gui)
CrateAnim.onDone(function()
	if ShopUI.isVisible()      then ShopUI.refresh()      end
	if InventoryUI.isVisible() then InventoryUI.refresh() end
end)

-- inventory button toggle
invBtn.MouseButton1Click:Connect(function()
	if InventoryUI.isVisible() then InventoryUI.hide() else InventoryUI.show() end
end)

-- mobile controls: sprint + throw buttons, touch devices only, hidden in studio
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not RunService:IsStudio()

if isMobile then
	local sprintBtn = T.btn("SprintButton", gui, "SPRINT",
		UDim2.new(0,90,0,90), UDim2.new(0,30,1,-140), T.C_DARK, T.C_CYAN)
	T.corner(sprintBtn, 45)
	T.stroke(sprintBtn, 3, T.C_CYAN)
	sprintBtn.ZIndex = 10
	sprintBtn.Visible = false

	local throwBtn = T.btn("ThrowButton", gui, "THROW",
		UDim2.new(0,90,0,90), UDim2.new(1,-120,1,-140), T.C_DARK, T.C_YELLOW)
	T.corner(throwBtn, 45)
	T.stroke(throwBtn, 3, T.C_YELLOW)
	throwBtn.ZIndex = 10
	throwBtn.Visible = false

	sprintBtn.MouseButton1Down:Connect(function()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
	end)
	sprintBtn.MouseButton1Up:Connect(function()
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
	end)

	throwBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if tool then tool:Activate() end
	end)

	events:WaitForChild("StateChanged").OnClientEvent:Connect(function(state)
		local show = state == "InGame"
		sprintBtn.Visible = show
		throwBtn.Visible = show
	end)
end

-- remote event wiring
dataUpdateEvent.OnClientEvent:Connect(function(data)
	myData.coins        = data.coins
	myData.inventory    = data.inventory
	myData.ownedCrates  = data.ownedCrates
	myData.equippedCrate = data.equippedCrate
	myData.equippedName  = data.equippedName
	updateCoinDisplays()
	if ShopUI.isVisible()      then ShopUI.refresh()      end
	if InventoryUI.isVisible() then InventoryUI.refresh() end
end)

crateResultEvent.OnClientEvent:Connect(function(result)
	task.spawn(CrateAnim.play, result.crateName, result, CrateData)
end)

openShopEvent.OnClientEvent:Connect(function()
	ShopUI.show()
end)

-- initial data fetch
task.spawn(function()
	local ok, data = pcall(function() return getDataFunc:InvokeServer() end)
	if ok and data then
		myData.coins       = data.coins
		myData.inventory   = data.inventory
		myData.ownedCrates = data.ownedCrates
		myData.cratePrices = data.cratePrices
		myData.equippedCrate = data.equippedCrate
		myData.equippedName  = data.equippedName
		updateCoinDisplays()
	end
end)