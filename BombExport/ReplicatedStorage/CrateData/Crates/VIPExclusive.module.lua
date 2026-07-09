-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name        = "Golden",
		solidColor  = C3(255, 215, 0),
		material    = Enum.Material.Metal,
		price       = 0,
		rarity      = { name = "VIP Exclusive", chance = 0 },
		rarityName  = "VIP Exclusive",
		dropChance  = 0,
		explosionFX = {
			trail = {
				Color         = CS({ CSK(0, C3(255,235,120)), CSK(0.4, C3(255,220,60)), CSK(0.7, C3(255,200,0)), CSK(1, C3(255,180,0)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime      = 0.3,
				WidthScale    = NS({ NSK(0,2.4), NSK(1,0) }),
				Texture       = "rbxassetid://11509651894",
			},
			burst = {
				Texture       = "rbxassetid://11509651894",
				Color         = CS({ CSK(0, C3(255,250,200)), CSK(0.15, C3(255,240,140)), CSK(0.4, C3(255,215,0)), CSK(0.65, C3(220,170,0)), CSK(1, C3(180,120,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,7.5), NSK(1,0) }),
				Speed         = NR(14,56), SpreadAngle = {180,180},
				Lifetime      = NR(0.6,1.5), EmitCount = 110,
			},
			light = { Color = C3(255,215,0), Brightness = 16, Range = 40 },
			sound = "rbxassetid://180199793",
		},
	},
}
