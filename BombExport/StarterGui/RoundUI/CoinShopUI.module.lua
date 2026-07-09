local T = require(script.Parent.UITheme)
local CoinShopUI = {}

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- todo: fill real developer product ids from creator dashboard once made,
-- productid = 0 means "not set yet", button warns instead of prompting
local COIN_PACKS = {
	{coins = 500,   productId = 0, label = "500"},
	{coins = 1500,  productId = 0, label = "1,500"},
	{coins = 5000,  productId = 0, label = "5,000"},
	{coins = 15000, productId = 0, label = "15,000"},
}

local overlay, card

function CoinShopUI.init(gui)
	overlay = T.frame("CoinShopOverlay", gui,
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), T.C_DARK, 0.35, 30)
	overlay.Visible = false

	card = T.frame("CoinShopCard", overlay,
		UDim2.new(0,500,0,420), UDim2.new(0.5,-250,0.5,-210), T.C_DARK, 0.05, 31)
	T.addStudOverlay(card, 0.65)
	T.corner(card, 24)
	T.stroke(card, 3, T.C_YELLOW)

	local header = T.frame("CoinShopHeader", card,
		UDim2.new(1,0,0,60), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 32)
	T.addStudOverlay(header, 0.7)
	T.corner(header, 24)
	T.label("CoinShopTitle", header, "GET COINS",
		UDim2.new(0.7,0,1,0), UDim2.new(0.02,0,0,0), T.C_YELLOW)

	local closeBtn = T.btn("CoinShopClose", header, "✕",
		UDim2.new(0,48,0,48), UDim2.new(1,-56,0.5,-24), T.C_DARK, T.C_PINK)
	T.corner(closeBtn, 24)
	T.stroke(closeBtn, 2, T.C_PINK)
	closeBtn.MouseButton1Click:Connect(function() CoinShopUI.hide() end)

	local grid = Instance.new("Frame")
	grid.Name = "CoinShopGrid"
	grid.Parent = card
	grid.Size = UDim2.new(1,-20,1,-80)
	grid.Position = UDim2.new(0,10,0,70)
	grid.BackgroundTransparency = 1
	grid.ZIndex = 32

	local layout = Instance.new("UIGridLayout")
	layout.Parent = grid
	layout.CellSize = UDim2.new(0.5,-10,0,150)
	layout.CellPadding = UDim2.new(0,10,0,10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	for i, pack in ipairs(COIN_PACKS) do
		local packCard = T.frame("Pack_"..i, grid,
			UDim2.new(0.5,-10,0,150), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 33)
		packCard.LayoutOrder = i
		T.addStudOverlay(packCard, 0.7)
		T.corner(packCard, 16)
		T.stroke(packCard, 2.5, T.C_YELLOW)

		T.label("PackCoins", packCard, pack.label,
			UDim2.new(1,-16,0,40), UDim2.new(0,8,0,10), T.C_YELLOW)

		local buyBtn = T.btn("PackBuy", packCard, "BUY",
			UDim2.new(1,-16,0,44), UDim2.new(0,8,0,90), T.C_DARK, T.C_GREEN)
		T.corner(buyBtn, 18)
		T.stroke(buyBtn, 2, T.C_GREEN)
		buyBtn.MouseButton1Click:Connect(function()
			if pack.productId and pack.productId ~= 0 then
				MarketplaceService:PromptProductPurchase(Players.LocalPlayer, pack.productId)
			else
				warn("[CoinShopUI] no product id set for pack: "..pack.label)
			end
		end)
	end

	overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			CoinShopUI.hide()
		end
	end)
end

function CoinShopUI.show()
	overlay.Visible = true
	T.popIn(card)
end

function CoinShopUI.hide()
	overlay.Visible = false
end

function CoinShopUI.isVisible()
	return overlay.Visible
end

return CoinShopUI
