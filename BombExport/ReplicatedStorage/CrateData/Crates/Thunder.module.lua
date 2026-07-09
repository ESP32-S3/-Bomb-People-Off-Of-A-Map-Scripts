-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Lightning Strike",
		decalId = "rbxassetid://623235754",
		price   = 200,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.25, C3(255,250,160)), CSK(0.5, C3(255,240,100)), CSK(0.75, C3(255,250,160)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.08,
				WidthScale   = NS({ NSK(0,0.4), NSK(0.5,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(255,250,160)), CSK(0.3, C3(255,240,80)), CSK(0.55, C3(180,200,255)), CSK(1, C3(80,80,200)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.05,4), NSK(1,0) }),
				Speed        = NR(37,140), SpreadAngle = {180,180},
				Lifetime     = NR(0.1,0.46), EmitCount = 160,
			},
			light = { Color = C3(255,255,200), Brightness = 22, Range = 54 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Thunderhead",
		decalId = "rbxassetid://98132921497084",
		price   = 160,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(120,130,150)), CSK(0.4, C3(160,170,190)), CSK(0.7, C3(200,210,230)), CSK(1, C3(200,210,230)) }),
				LightEmission = 0.3, LightInfluence = 0.65,
				Lifetime     = 0.45,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(100,110,130)), CSK(0.2, C3(140,150,170)), CSK(0.5, C3(180,190,210)), CSK(0.75, C3(220,230,250)), CSK(1, C3(255,255,255)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.3,10), NSK(1,0) }),
				Speed        = NR(7,35), SpreadAngle = {150,150},
				Lifetime     = NR(1,2.85), EmitCount = 75,
			},
			light = { Color = C3(200,210,255), Brightness = 10, Range = 30 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Stormfront",
		decalId = "rbxassetid://17342734696",
		price   = 200,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(40,50,100)), CSK(0.4, C3(60,70,130)), CSK(0.7, C3(80,100,160)), CSK(1, C3(100,120,180)) }),
				LightEmission = 0.5, LightInfluence = 0.45,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(30,40,80)), CSK(0.2, C3(50,60,120)), CSK(0.5, C3(80,100,180)), CSK(0.75, C3(140,160,230)), CSK(1, C3(200,210,255)) }),
				LightEmission = 0.6, Size = NS({ NSK(0,0), NSK(0.3,9), NSK(1,0) }),
				Speed        = NR(9,40), SpreadAngle = {160,160},
				Lifetime     = NR(1,2.85), EmitCount = 80,
			},
			light = { Color = C3(80,100,200), Brightness = 8, Range = 28 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Thunderclap",
		decalId = "rbxassetid://90099258825142",
		price   = 280,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.3, C3(220,230,255)), CSK(0.6, C3(180,200,255)), CSK(1, C3(180,200,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.1,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(230,240,255)), CSK(0.2, C3(200,220,255)), CSK(0.5, C3(120,150,220)), CSK(1, C3(60,80,180)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.08,7.5), NSK(1,0) }),
				Speed        = NR(30,112), SpreadAngle = {180,180},
				Lifetime     = NR(0.2,0.7), EmitCount = 135,
			},
			light = { Color = C3(220,230,255), Brightness = 22, Range = 54 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Rainstorm",
		decalId = "rbxassetid://104988025021255",
		price   = 140,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(80,130,200)), CSK(0.4, C3(120,165,230)), CSK(0.7, C3(160,200,255)), CSK(1, C3(160,200,255)) }),
				LightEmission = 0.4, LightInfluence = 0.55,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,0.8), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(100,150,220)), CSK(0.2, C3(130,180,240)), CSK(0.5, C3(160,210,255)), CSK(0.75, C3(100,140,200)), CSK(1, C3(40,80,150)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.1,3), NSK(1,0) }),
				Speed        = NR(15,84), SpreadAngle = {60,180},
				Lifetime     = NR(0.4,1.4), EmitCount = 150,
			},
			light = { Color = C3(100,160,255), Brightness = 8, Range = 28 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Static",
		decalId = "rbxassetid://119604351310084",
		price   = 170,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,240,100)), CSK(0.25, C3(255,250,180)), CSK(0.5, C3(255,255,255)), CSK(0.75, C3(255,250,180)), CSK(1, C3(255,240,100)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.1,
				WidthScale   = NS({ NSK(0,0.6), NSK(0.5,1.6), NSK(1,0) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(255,255,200)), CSK(0.2, C3(255,250,140)), CSK(0.5, C3(255,240,80)), CSK(0.75, C3(180,180,220)), CSK(1, C3(100,100,200)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,3), NSK(1,0) }),
				Speed        = NR(22,98), SpreadAngle = {180,180},
				Lifetime     = NR(0.15,0.58), EmitCount = 155,
			},
			light = { Color = C3(255,240,100), Brightness = 16, Range = 36 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Zeus",
		decalId = "rbxassetid://5222445972",
		price   = 400,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,220,80)), CSK(0.25, C3(255,240,160)), CSK(0.5, C3(255,255,200)), CSK(0.75, C3(255,240,160)), CSK(1, C3(255,220,80)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.12,
				WidthScale   = NS({ NSK(0,2.4), NSK(0.5,0.8), NSK(1,2.4) }),
				Texture      = "rbxassetid://127877184756664",
			},
			burst = {
				Texture      = "rbxassetid://127877184756664",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(255,250,180)), CSK(0.2, C3(255,240,120)), CSK(0.5, C3(255,200,0)), CSK(0.75, C3(180,120,0)), CSK(1, C3(100,60,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,9), NSK(1,0) }),
				Speed        = NR(30,126), SpreadAngle = {180,180},
				Lifetime     = NR(0.2,0.92), EmitCount = 160,
			},
			light = { Color = C3(255,230,100), Brightness = 26, Range = 60 },
			sound = "rbxassetid://82623651042971",
		},
	},
}
