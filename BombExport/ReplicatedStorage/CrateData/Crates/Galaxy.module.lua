-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Nebula",
		decalId = "rbxassetid://11802397457",
		price   = 220,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(180,50,220)), CSK(0.25, C3(120,80,255)), CSK(0.5, C3(80,120,255)), CSK(0.75, C3(180,60,255)), CSK(1, C3(255,80,200)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(200,50,255)), CSK(0.2, C3(140,60,255)), CSK(0.4, C3(80,100,255)), CSK(0.6, C3(120,60,255)), CSK(0.8, C3(255,100,200)), CSK(1, C3(20,10,40)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.3,9), NSK(1,0) }),
				Speed        = NR(6,28), SpreadAngle = {180,180},
				Lifetime     = NR(1.5,3.4), EmitCount = 110,
			},
			light = { Color = C3(160,50,255), Brightness = 12, Range = 40 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Supernova",
		decalId = "rbxassetid://5297921619",
		price   = 400,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,220)), CSK(0.25, C3(255,240,160)), CSK(0.5, C3(255,180,100)), CSK(0.75, C3(255,120,40)), CSK(1, C3(255,80,0)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.2,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(255,250,200)), CSK(0.25, C3(255,220,100)), CSK(0.5, C3(255,120,0)), CSK(0.75, C3(180,40,0)), CSK(1, C3(40,0,80)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,10), NSK(1,0) }),
				Speed        = NR(30,110), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.4), EmitCount = 140,
			},
			light = { Color = C3(255,240,180), Brightness = 22, Range = 56 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Black Hole",
		decalId = "rbxassetid://80741296694492",
		price   = 500,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(5,0,15)), CSK(0.3, C3(30,0,60)), CSK(0.6, C3(60,0,120)), CSK(0.8, C3(30,0,60)), CSK(1, C3(0,0,0)) }),
				LightEmission = 0.1, LightInfluence = 0.9,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.2, C3(20,0,40)), CSK(0.4, C3(60,0,100)), CSK(0.6, C3(140,0,220)), CSK(0.8, C3(200,0,255)), CSK(1, C3(0,0,0)) }),
				LightEmission = 0.4, Size = NS({ NSK(0,0), NSK(0.2,7), NSK(0.8,10), NSK(1,0) }),
				Speed        = NR(3,20), SpreadAngle = {180,180},
				Lifetime     = NR(2,5.7), EmitCount = 55,
			},
			light = { Color = C3(100,0,200), Brightness = 4, Range = 20 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Stardust",
		decalId = "rbxassetid://3237990498",
		price   = 250,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,210,255)), CSK(0.4, C3(230,235,255)), CSK(0.7, C3(255,255,255)), CSK(1, C3(240,240,255)) }),
				LightEmission = 1, LightInfluence = 0.05,
				Lifetime     = 0.25,
				WidthScale   = NS({ NSK(0,1.0), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(220,220,255)), CSK(0.2, C3(240,240,255)), CSK(0.5, C3(255,255,255)), CSK(0.8, C3(200,200,255)), CSK(1, C3(150,160,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,3), NSK(1,0) }),
				Speed        = NR(15,70), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.4), EmitCount = 160,
			},
			light = { Color = C3(200,210,255), Brightness = 14, Range = 40 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Pulsar",
		decalId = "rbxassetid://130789220096213",
		price   = 300,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,200,255)), CSK(0.3, C3(120,240,255)), CSK(0.5, C3(255,255,255)), CSK(0.7, C3(120,240,255)), CSK(1, C3(0,200,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.2,
				WidthScale   = NS({ NSK(0,0.6), NSK(0.5,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(0,220,255)), CSK(0.2, C3(100,240,255)), CSK(0.5, C3(255,255,255)), CSK(0.8, C3(0,160,255)), CSK(1, C3(0,100,200)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.15,5.5), NSK(1,0) }),
				Speed        = NR(22,84), SpreadAngle = {180,180},
				Lifetime     = NR(0.3,1.05), EmitCount = 115,
			},
			light = { Color = C3(0,220,255), Brightness = 16, Range = 44 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Dark Matter",
		decalId = "rbxassetid://11321776490",
		price   = 380,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(20,0,60)), CSK(0.4, C3(50,0,100)), CSK(0.7, C3(80,0,140)), CSK(1, C3(80,0,140)) }),
				LightEmission = 0.3, LightInfluence = 0.65,
				Lifetime     = 0.45,
				WidthScale   = NS({ NSK(0,3.6), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(10,0,30)), CSK(0.2, C3(40,0,80)), CSK(0.45, C3(80,0,160)), CSK(0.7, C3(140,40,255)), CSK(1, C3(200,100,255)) }),
				LightEmission = 0.7, Size = NS({ NSK(0,0), NSK(0.3,9), NSK(1,0) }),
				Speed        = NR(7,35), SpreadAngle = {180,180},
				Lifetime     = NR(1,2.85), EmitCount = 75,
			},
			light = { Color = C3(80,0,160), Brightness = 8, Range = 32 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Comet",
		decalId = "rbxassetid://597104875",
		price   = 200,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(100,200,255)), CSK(0.3, C3(160,225,255)), CSK(0.6, C3(220,245,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://82804980836215",
			},
			burst = {
				Texture      = "rbxassetid://82804980836215",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(180,230,255)), CSK(0.35, C3(100,200,255)), CSK(0.6, C3(60,120,200)), CSK(1, C3(30,60,120)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,4.5), NSK(1,0) }),
				Speed        = NR(26,98), SpreadAngle = {160,160},
				Lifetime     = NR(0.3,0.95), EmitCount = 150,
			},
			light = { Color = C3(150,220,255), Brightness = 14, Range = 42 },
			sound = "rbxassetid://180199793",
		},
	},
}
