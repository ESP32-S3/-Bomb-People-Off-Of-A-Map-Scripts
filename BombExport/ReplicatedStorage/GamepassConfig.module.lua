-- gamepassconfig: single source of truth for the 3 paid gamepasses, edit ids/prices here only

local GamepassConfig = {}

GamepassConfig.Passes = {
	VIP = {
		Id = 1890425527,
		Name = "VIP",
		Price = 1099,
		Color = Color3.fromRGB(255, 215, 0),
		Description = "1.25x Coins (Stacks) + 1.25x EXP (Stacks) + Gold Bomb Skin + Chat Tag",
	},
	DoubleXP = {
		Id = 1890143537,
		Name = "2x EXP",
		Price = 499,
		Color = Color3.fromRGB(0, 170, 255),
		Description = "Permanent 2x EXP",
	},
	DoubleCoins = {
		Id = 1890718381,
		Name = "2x Coins",
		Price = 799,
		Color = Color3.fromRGB(60, 220, 90),
		Description = "Permanent 2x Coins",
	},
}

return GamepassConfig
