-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Glitch",
		decalId = "rbxassetid://84663754744938",
		price   = 180,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,0,255)), CSK(0.25, C3(80,255,240)), CSK(0.5, C3(0,255,200)), CSK(0.75, C3(255,0,180)), CSK(1, C3(180,0,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.18,
				WidthScale   = NS({ NSK(0,2.5), NSK(0.5,0.7), NSK(1,2.5) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(255,0,220)), CSK(0.2, C3(180,0,255)), CSK(0.4, C3(0,255,255)), CSK(0.6, C3(100,255,200)), CSK(0.8, C3(200,0,255)), CSK(1, C3(120,0,200)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,4), NSK(0.5,1), NSK(1,4) }),
				Speed        = NR(16,62), SpreadAngle = {180,180},
				Lifetime     = NR(0.35,1.05), EmitCount = 140,
			},
			light = { Color = C3(180,0,255), Brightness = 16, Range = 44 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Circuit",
		decalId = "rbxassetid://87827932945654",
		price   = 160,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,220,0)), CSK(0.4, C3(50,255,50)), CSK(0.7, C3(100,255,100)), CSK(1, C3(150,255,150)) }),
				LightEmission = 1, LightInfluence = 0.08,
				Lifetime     = 0.24,
				WidthScale   = NS({ NSK(0,1.2), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(0,255,0)), CSK(0.2, C3(50,255,50)), CSK(0.5, C3(100,255,100)), CSK(0.75, C3(0,180,0)), CSK(1, C3(0,80,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.15,4), NSK(1,0) }),
				Speed        = NR(20,70), SpreadAngle = {180,180},
				Lifetime     = NR(0.25,0.7), EmitCount = 160,
			},
			light = { Color = C3(0,255,50), Brightness = 14, Range = 38 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Synthwave",
		decalId = "rbxassetid://11403753875",
		price   = 220,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,0,150)), CSK(0.3, C3(200,0,255)), CSK(0.6, C3(80,0,255)), CSK(0.8, C3(0,150,255)), CSK(1, C3(0,220,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(255,0,150)), CSK(0.2, C3(220,0,200)), CSK(0.4, C3(180,0,255)), CSK(0.6, C3(80,0,255)), CSK(0.8, C3(0,180,255)), CSK(1, C3(0,200,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,6.5), NSK(1,0) }),
				Speed        = NR(14,56), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.4), EmitCount = 115,
			},
			light = { Color = C3(255,0,180), Brightness = 14, Range = 40 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Overdrive",
		decalId = "rbxassetid://97250773618062",
		price   = 280,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,0,100)), CSK(0.3, C3(255,40,140)), CSK(0.6, C3(255,80,180)), CSK(1, C3(255,120,200)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.22,
				WidthScale   = NS({ NSK(0,2.2), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(255,100,180)), CSK(0.25, C3(255,0,100)), CSK(0.5, C3(200,0,80)), CSK(0.75, C3(150,0,60)), CSK(1, C3(100,0,40)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,7.5), NSK(1,0) }),
				Speed        = NR(28,90), SpreadAngle = {180,180},
				Lifetime     = NR(0.35,0.95), EmitCount = 130,
			},
			light = { Color = C3(255,0,100), Brightness = 20, Range = 50 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Voltage",
		decalId = "rbxassetid://11765481844",
		price   = 200,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(80,160,255)), CSK(0.4, C3(150,210,255)), CSK(0.7, C3(220,240,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.15,
				WidthScale   = NS({ NSK(0,1.5), NSK(0.5,2.5), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(150,200,255)), CSK(0.35, C3(80,160,255)), CSK(0.6, C3(40,100,220)), CSK(1, C3(20,50,160)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,4.5), NSK(1,0) }),
				Speed        = NR(32,100), SpreadAngle = {180,180},
				Lifetime     = NR(0.25,0.7), EmitCount = 165,
			},
			light = { Color = C3(100,180,255), Brightness = 18, Range = 46 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Matrix",
		decalId = "rbxassetid://12567935423",
		price   = 170,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,200,0)), CSK(0.4, C3(0,140,0)), CSK(0.7, C3(0,100,0)), CSK(1, C3(0,60,0)) }),
				LightEmission = 1, LightInfluence = 0.15,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,0.7), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(0,255,0)), CSK(0.2, C3(0,220,0)), CSK(0.45, C3(0,150,0)), CSK(0.7, C3(0,100,0)), CSK(1, C3(0,30,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.05,2), NSK(1,0) }),
				Speed        = NR(12,84), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.7), EmitCount = 160,
			},
			light = { Color = C3(0,220,0), Brightness = 12, Range = 34 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Ultraviolet",
		decalId = "rbxassetid://13288987281",
		price   = 320,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(60,0,140)), CSK(0.3, C3(120,0,220)), CSK(0.6, C3(180,0,255)), CSK(1, C3(220,80,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.26,
				WidthScale   = NS({ NSK(0,2.5), NSK(1,0) }),
				Texture      = "rbxassetid://6423572458",
			},
			burst = {
				Texture      = "rbxassetid://6423572458",
				Color        = CS({ CSK(0, C3(100,0,220)), CSK(0.2, C3(160,0,255)), CSK(0.45, C3(220,0,255)), CSK(0.65, C3(180,0,220)), CSK(0.85, C3(100,0,140)), CSK(1, C3(40,0,60)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,5.5), NSK(1,0) }),
				Speed        = NR(16,62), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.4), EmitCount = 105,
			},
			light = { Color = C3(120,0,255), Brightness = 16, Range = 44 },
			sound = "rbxassetid://82623651042971",
		},
	},
}
