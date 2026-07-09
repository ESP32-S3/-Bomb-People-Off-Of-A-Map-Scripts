-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Runic",
		decalId = "rbxassetid://13367067189",
		price   = 220,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,140,0)), CSK(0.4, C3(255,170,30)), CSK(0.7, C3(255,200,60)), CSK(1, C3(255,200,80)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(220,100,0)), CSK(0.2, C3(255,140,20)), CSK(0.5, C3(255,180,50)), CSK(0.75, C3(200,140,20)), CSK(1, C3(80,40,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,5.5), NSK(1,0) }),
				Speed        = NR(11,50), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.7), EmitCount = 130,
			},
			light = { Color = C3(255,160,0), Brightness = 12, Range = 34 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Pharaoh",
		decalId = "rbxassetid://18839545838",
		price   = 260,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,160,20)), CSK(0.4, C3(220,180,40)), CSK(0.7, C3(240,200,60)), CSK(1, C3(255,220,80)) }),
				LightEmission = 0.8, LightInfluence = 0.15,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(160,120,10)), CSK(0.2, C3(200,160,30)), CSK(0.5, C3(240,200,60)), CSK(0.75, C3(220,180,40)), CSK(1, C3(200,160,20)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.25,7.5), NSK(1,0) }),
				Speed        = NR(9,40), SpreadAngle = {160,160},
				Lifetime     = NR(0.8,2.3), EmitCount = 90,
			},
			light = { Color = C3(240,200,60), Brightness = 10, Range = 30 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Arcane",
		decalId = "rbxassetid://13505892614",
		price   = 300,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(100,0,200)), CSK(0.25, C3(50,0,255)), CSK(0.5, C3(0,180,255)), CSK(0.75, C3(50,0,255)), CSK(1, C3(100,0,200)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,1.6), NSK(0.5,2.8), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(80,0,200)), CSK(0.2, C3(40,0,255)), CSK(0.4, C3(0,200,255)), CSK(0.6, C3(100,0,255)), CSK(0.8, C3(180,0,255)), CSK(1, C3(20,0,60)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,6.5), NSK(1,0) }),
				Speed        = NR(13,56), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.7), EmitCount = 110,
			},
			light = { Color = C3(100,0,255), Brightness = 14, Range = 36 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Dragon Stone",
		decalId = "rbxassetid://9315132857",
		price   = 380,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(120,0,0)), CSK(0.3, C3(180,20,0)), CSK(0.6, C3(220,60,0)), CSK(1, C3(255,120,0)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(80,0,0)), CSK(0.2, C3(140,20,0)), CSK(0.4, C3(200,40,0)), CSK(0.6, C3(255,80,0)), CSK(0.8, C3(255,100,0)), CSK(1, C3(30,10,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,9), NSK(1,0) }),
				Speed        = NR(15,56), SpreadAngle = {165,165},
				Lifetime     = NR(0.8,2.3), EmitCount = 95,
			},
			light = { Color = C3(220,60,0), Brightness = 16, Range = 40 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Elder Seal",
		decalId = "rbxassetid://120002789",
		price   = 450,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,220)), CSK(0.25, C3(255,240,160)), CSK(0.5, C3(255,220,100)), CSK(0.75, C3(255,240,160)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.25,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(255,250,200)), CSK(0.3, C3(255,240,160)), CSK(0.5, C3(255,220,80)), CSK(0.75, C3(200,160,40)), CSK(1, C3(120,80,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.15,7.5), NSK(1,0) }),
				Speed        = NR(18,77), SpreadAngle = {180,180},
				Lifetime     = NR(0.5,1.6), EmitCount = 125,
			},
			light = { Color = C3(255,240,160), Brightness = 20, Range = 48 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Cursed",
		decalId = "rbxassetid://81291675304721",
		price   = 320,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,60,0)), CSK(0.4, C3(20,120,20)), CSK(0.7, C3(40,160,40)), CSK(1, C3(60,200,60)) }),
				LightEmission = 0.6, LightInfluence = 0.35,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.2, C3(0,40,0)), CSK(0.4, C3(0,120,0)), CSK(0.6, C3(40,200,40)), CSK(0.8, C3(80,255,80)), CSK(1, C3(0,30,0)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.25,7.5), NSK(1,0) }),
				Speed        = NR(7,35), SpreadAngle = {170,170},
				Lifetime     = NR(0.8,2.3), EmitCount = 90,
			},
			light = { Color = C3(0,200,0), Brightness = 8, Range = 28 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Obsidian",
		decalId = "rbxassetid://6506254403",
		price   = 200,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(10,10,10)), CSK(0.4, C3(30,30,35)), CSK(0.7, C3(50,50,55)), CSK(1, C3(60,60,70)) }),
				LightEmission = 0.05, LightInfluence = 0.95,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://4511013903",
			},
			burst = {
				Texture      = "rbxassetid://4511013903",
				Color        = CS({ CSK(0, C3(5,5,5)), CSK(0.2, C3(20,20,25)), CSK(0.5, C3(40,40,50)), CSK(0.75, C3(70,70,90)), CSK(1, C3(100,100,120)) }),
				LightEmission = 0.15, Size = NS({ NSK(0,0), NSK(0.3,10), NSK(1,0) }),
				Speed        = NR(11,50), SpreadAngle = {170,170},
				Lifetime     = NR(0.5,1.7), EmitCount = 100,
			},
			light = { Color = C3(60,60,80), Brightness = 3, Range = 18 },
			sound = "rbxassetid://180199793",
		},
	},
}
