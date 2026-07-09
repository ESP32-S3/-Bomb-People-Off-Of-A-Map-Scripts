local Crates = {
	Inferno = require(script.Crates.Inferno),
	Arctic = require(script.Crates.Arctic),
	Neon = require(script.Crates.Neon),
	Nature = require(script.Crates.Nature),
	Galaxy = require(script.Crates.Galaxy),
	Shadow = require(script.Crates.Shadow),
	Candy = require(script.Crates.Candy),
	Toxic = require(script.Crates.Toxic),
	Thunder = require(script.Crates.Thunder),
	Ancient = require(script.Crates.Ancient),
}

local CratePrices = {
	Candy = 300,
	Nature = 450,
	Arctic = 600,
	Inferno = 800,
	Neon = 950,
	Shadow = 1150,
	Thunder = 1400,
	Ancient = 1700,
	Toxic = 2050,
	Galaxy = 2500,
}
local CrateColors = {
	Inferno = Color3.fromRGB(255, 80, 0),
	Arctic = Color3.fromRGB(100, 200, 255),
	Neon = Color3.fromRGB(255, 0, 200),
	Nature = Color3.fromRGB(50, 200, 50),
	Galaxy = Color3.fromRGB(100, 50, 200),
	Shadow = Color3.fromRGB(80, 50, 120),
	Candy = Color3.fromRGB(255, 100, 180),
	Toxic = Color3.fromRGB(150, 255, 0),
	Thunder = Color3.fromRGB(255, 230, 50),
	Ancient = Color3.fromRGB(200, 160, 60),
}

return {
	Crates = Crates,
	CratePrices = CratePrices,
	CrateColors = CrateColors,
}
