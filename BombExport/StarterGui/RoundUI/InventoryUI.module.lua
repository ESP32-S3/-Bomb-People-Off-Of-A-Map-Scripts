local T = require(script.Parent.UITheme)
local InventoryUI = {}

local invOverlay, invCard, invScroll, invEmpty
local _myData, _sellItemEvent, _equipItemEvent
local _coinLabel

function InventoryUI.init(gui, myData, sellItemEvent, equipItemEvent)
	_myData = myData
	_sellItemEvent = sellItemEvent
	_equipItemEvent = equipItemEvent

	invOverlay = T.frame("InvOverlay", gui,
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), T.C_DARK, 0.35, 30)
	invOverlay.Visible = false

	invCard = T.frame("InvCard", invOverlay,
		UDim2.new(0,700,0.85,0), UDim2.new(0.5,-350,0.075,0), T.C_DARK, 0.05, 31)
	T.addStudOverlay(invCard, 0.65)
	T.corner(invCard, 24)
	T.stroke(invCard, 3, T.C_GREEN)

	local invHeader = T.frame("InvHeader", invCard,
		UDim2.new(1,0,0,60), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 32)
	T.addStudOverlay(invHeader, 0.7)
	T.corner(invHeader, 24)
	T.label("InvTitle", invHeader, "INVENTORY",
		UDim2.new(0.55,0,1,0), UDim2.new(0.02,0,0,0), T.C_GREEN)

	local invCloseBtn = T.btn("InvClose", invHeader, "X",
		UDim2.new(0,48,0,48), UDim2.new(1,-56,0.5,-24), T.C_DARK, T.C_PINK)
	T.corner(invCloseBtn, 24)
	T.stroke(invCloseBtn, 2, T.C_PINK)

	local invCoinPill = T.frame("InvCoinPill", invHeader,
		UDim2.new(0,160,0,40), UDim2.new(0.55,0,0.5,-20), T.C_DARK, 0.15, 33)
	T.addStudOverlay(invCoinPill, 0.65)
	T.corner(invCoinPill, 20)
	T.stroke(invCoinPill, 2, T.C_YELLOW)
	_coinLabel = T.label("InvCoinLabel", invCoinPill, "0",
		UDim2.new(1,-8,1,0), UDim2.new(0,4,0,0), T.C_YELLOW)

	invScroll = Instance.new("ScrollingFrame")
	invScroll.Name = "InvScroll"
	invScroll.Parent = invCard
	invScroll.Size = UDim2.new(1,-20,1,-80)
	invScroll.Position = UDim2.new(0,10,0,70)
	invScroll.BackgroundTransparency = 1
	invScroll.BorderSizePixel = 0
	invScroll.ScrollBarThickness = 6
	invScroll.ScrollBarImageColor3 = T.C_GREEN
	invScroll.ZIndex = 32
	invScroll.CanvasSize = UDim2.new(0,0,0,0)
	invScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local invGrid = Instance.new("UIGridLayout")
	invGrid.Parent = invScroll
	invGrid.CellSize = UDim2.new(0.5,-10,0,196)
	invGrid.CellPadding = UDim2.new(0,10,0,10)
	invGrid.SortOrder = Enum.SortOrder.LayoutOrder

	invEmpty = T.label("InvEmpty", invScroll, "No items yet!\nBuy crates from the shop!",
		UDim2.new(1,0,0,120), UDim2.new(0,0,0,0), Color3.fromRGB(120,120,140))

	invCloseBtn.MouseButton1Click:Connect(InventoryUI.hide)
	invOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			InventoryUI.hide()
		end
	end)
end

function InventoryUI.updateCoinLabel()
	if _coinLabel then
		_coinLabel.Text = tostring(_myData.coins)
	end
end

function InventoryUI.refresh()
	for _, child in ipairs(invScroll:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
	end

	invEmpty.Visible = #_myData.inventory == 0

	for i, item in ipairs(_myData.inventory) do
		local rarityColor = T.RARITY_COLORS[item.rarityName] or T.C_WHITE
		local sellPrice = math.floor(item.price * 0.6)
		local isEquipped = _myData.equippedCrate == item.crateName and _myData.equippedName == item.name

		local card = T.frame("Item_"..i, invScroll,
			UDim2.new(0.5,-10,0,196), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 33)
		card.LayoutOrder = i
		T.addStudOverlay(card, 0.7)
		T.corner(card, 16)
		T.stroke(card, isEquipped and 3.5 or 2.5, isEquipped and T.C_YELLOW or rarityColor)

		T.label("ItemName", card, item.name,
			UDim2.new(1,-16,0,36), UDim2.new(0,8,0,6), rarityColor)
		T.label("ItemRarity", card, item.rarityName:upper(),
			UDim2.new(1,-16,0,22), UDim2.new(0,8,0,44), rarityColor)
		T.label("ItemCrate", card, "from "..item.crateName,
			UDim2.new(1,-16,0,22), UDim2.new(0,8,0,68), Color3.fromRGB(140,140,160))
		T.label("ItemValue", card, "Value: "..item.price,
			UDim2.new(1,-16,0,22), UDim2.new(0,8,0,92), T.C_ORANGE)

		if isEquipped then
			local badge = T.label("EquippedBadge", card, "EQUIPPED",
				UDim2.new(0.5,-10,0,20), UDim2.new(0.5,2,0,6), T.C_YELLOW)
			badge.TextXAlignment = Enum.TextXAlignment.Right
		end

		local equipBtn = T.btn("EquipBtn", card, isEquipped and "EQUIPPED" or "EQUIP",
			UDim2.new(0.44,0,0,34), UDim2.new(0.03,0,0,118),
			T.C_DARK, isEquipped and T.C_YELLOW or T.C_GREEN)
		T.corner(equipBtn, 17)
		T.stroke(equipBtn, 2, isEquipped and T.C_YELLOW or T.C_GREEN)
		if isEquipped then
			equipBtn.AutoButtonColor = false
		else
			equipBtn.MouseButton1Click:Connect(function()
				_equipItemEvent:FireServer(i)
			end)
		end

		local sellBtn = T.btn("SellBtn", card, "SELL "..sellPrice,
			UDim2.new(0.44,0,0,34), UDim2.new(0.53,0,0,118), T.C_DARK, T.C_YELLOW)
		T.corner(sellBtn, 17)
		T.stroke(sellBtn, 2, T.C_YELLOW)
		sellBtn.MouseButton1Click:Connect(function()
			_sellItemEvent:FireServer(i)
		end)
	end
end

function InventoryUI.show()
	invOverlay.Visible = true
	T.popIn(invCard)
	InventoryUI.refresh()
end

function InventoryUI.hide()
	invOverlay.Visible = false
end

function InventoryUI.isVisible()
	return invOverlay.Visible
end

return InventoryUI
