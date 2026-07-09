local T = require(script.Parent.UITheme)
local CoinShopUI = require(script.Parent.CoinShopUI)
local ShopUI = {}

local shopOverlay, shopCard, shopScroll
local _CrateData, _myData, _buyCrateEvent, _onOpen
local _coinLabel

function ShopUI.init(gui, CrateData, myData, buyCrateEvent, onOpen)
	_CrateData = CrateData
	_myData = myData
	_buyCrateEvent = buyCrateEvent
	_onOpen = onOpen

	shopOverlay = T.frame("ShopOverlay", gui,
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), T.C_DARK, 0.35, 20)
	shopOverlay.Visible = false

	shopCard = T.frame("ShopCard", shopOverlay,
		UDim2.new(0,700,0.85,0), UDim2.new(0.5,-350,0.075,0), T.C_DARK, 0.05, 21)
	T.addStudOverlay(shopCard, 0.65)
	T.corner(shopCard, 24)
	T.stroke(shopCard, 3, T.C_CYAN)

	local shopHeader = T.frame("ShopHeader", shopCard,
		UDim2.new(1,0,0,60), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 22)
	T.addStudOverlay(shopHeader, 0.7)
	T.corner(shopHeader, 24)
	T.label("ShopTitle", shopHeader, "CRATE SHOP",
		UDim2.new(0.55,0,1,0), UDim2.new(0.02,0,0,0), T.C_CYAN)

	local shopCloseBtn = T.btn("ShopClose", shopHeader, "X",
		UDim2.new(0,48,0,48), UDim2.new(1,-56,0.5,-24), T.C_DARK, T.C_PINK)
	T.corner(shopCloseBtn, 24)
	T.stroke(shopCloseBtn, 2, T.C_PINK)

	local shopCoinPill = T.frame("ShopCoinPill", shopHeader,
		UDim2.new(0,160,0,40), UDim2.new(0.55,0,0.5,-20), T.C_DARK, 0.15, 23)
	T.addStudOverlay(shopCoinPill, 0.65)
	T.corner(shopCoinPill, 20)
	T.stroke(shopCoinPill, 2, T.C_YELLOW)
	_coinLabel = T.label("ShopCoinLabel", shopCoinPill, "0",
		UDim2.new(1,-8,1,0), UDim2.new(0,4,0,0), T.C_YELLOW)

	shopScroll = Instance.new("ScrollingFrame")
	shopScroll.Name = "ShopScroll"
	shopScroll.Parent = shopCard
	shopScroll.Size = UDim2.new(1,-20,1,-200)
	shopScroll.Position = UDim2.new(0,10,0,70)
	shopScroll.BackgroundTransparency = 1
	shopScroll.BorderSizePixel = 0
	shopScroll.ScrollBarThickness = 6
	shopScroll.ScrollBarImageColor3 = T.C_CYAN
	shopScroll.ZIndex = 22
	shopScroll.CanvasSize = UDim2.new(0,0,0,0)
	shopScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local shopGrid = Instance.new("UIGridLayout")
	shopGrid.Parent = shopScroll
	shopGrid.CellSize = UDim2.new(0.5,-10,0,180)
	shopGrid.CellPadding = UDim2.new(0,10,0,10)
	shopGrid.SortOrder = Enum.SortOrder.LayoutOrder

	shopCloseBtn.MouseButton1Click:Connect(ShopUI.hide)
	shopOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			ShopUI.hide()
		end
	end)
end

function ShopUI.updateCoinLabel()
	if _coinLabel then
		_coinLabel.Text = tostring(_myData.coins)
	end
end

function ShopUI.refresh()
	for _, child in ipairs(shopScroll:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
	end

	local crateNames = {}
	for name in pairs(_CrateData.Crates) do table.insert(crateNames, name) end
	table.sort(crateNames, function(a, b)
		local priceA = _myData.cratePrices[a] or 200
		local priceB = _myData.cratePrices[b] or 200
		return priceA < priceB
	end)

	for i, crateName in ipairs(crateNames) do
		local items = _CrateData.Crates[crateName]
		local price = _myData.cratePrices[crateName] or 200
		local crateColor = _CrateData.CrateColors and _CrateData.CrateColors[crateName] or T.C_CYAN
		local owned = _myData.ownedCrates[crateName] or 0

		local card = T.frame("Crate_"..crateName, shopScroll,
			UDim2.new(0.5,-10,0,180), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 23)
		card.LayoutOrder = i
		T.addStudOverlay(card, 0.7)
		T.corner(card, 16)
		T.stroke(card, 2.5, crateColor)

		T.label("CrateName", card, crateName:upper(),
			UDim2.new(1,-16,0,36), UDim2.new(0,8,0,6), crateColor)
		T.label("CrateInfo", card, #items.." skins",
			UDim2.new(1,-16,0,22), UDim2.new(0,8,0,44), Color3.fromRGB(160,160,180))

		if owned > 0 then
			T.label("OwnedLabel", card, "Owned: "..owned,
				UDim2.new(1,-16,0,22), UDim2.new(0,8,0,68), T.C_GREEN)
		end

		local buyBtn = T.btn("BuyBtn", card, "BUY "..price,
			UDim2.new(0.48,0,0,36), UDim2.new(0.02,0,0,96), T.C_DARK, T.C_YELLOW)
		T.corner(buyBtn, 18)
		T.stroke(buyBtn, 2, T.C_YELLOW)
		buyBtn.MouseButton1Click:Connect(function()
			if _myData.coins < price then
				CoinShopUI.show()
			else
				_buyCrateEvent:FireServer(crateName)
			end
		end)

		local openBtn = T.btn("OpenBtn", card, "OPEN",
			UDim2.new(0.48,0,0,36), UDim2.new(0.5,0,0,96), T.C_DARK, crateColor)
		T.corner(openBtn, 18)
		T.stroke(openBtn, 2, crateColor)
		openBtn.Visible = owned > 0
		openBtn.MouseButton1Click:Connect(function()
			if _onOpen then _onOpen(crateName) end
		end)

		local seen = {}
		for _, item in ipairs(items) do
			if not seen[item.rarityName] then seen[item.rarityName] = item.dropChance end
		end
		local rarityOrder = {"Common","Uncommon","Rare","Epic","Legendary"}
		local parts = {}
		for _, rName in ipairs(rarityOrder) do
			if seen[rName] then
				table.insert(parts, rName:sub(1,1)..":"..seen[rName].."%")
			end
		end

		local chanceLbl = T.label("Chances", card, table.concat(parts,"  "),
			UDim2.new(1,-16,0,24), UDim2.new(0,8,0,140), Color3.fromRGB(100,100,120))
		chanceLbl.TextScaled = false
		chanceLbl.TextSize = 11

		T.label("SellHint", card, "Sell items at 60% value",
			UDim2.new(1,-16,0,18), UDim2.new(0,8,0,158), Color3.fromRGB(80,80,100))
	end
end

function ShopUI.show()
	shopOverlay.Visible = true
	T.popIn(shopCard)
	ShopUI.refresh()
end

function ShopUI.hide()
	shopOverlay.Visible = false
end

function ShopUI.isVisible()
	return shopOverlay.Visible
end

return ShopUI
