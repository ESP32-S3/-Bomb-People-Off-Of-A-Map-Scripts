-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Verdant",
		decalId = "rbxassetid://140329257432603",
		price   = 120,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,200,0)), CSK(0.3, C3(40,240,20)), CSK(0.6, C3(80,255,40)), CSK(1, C3(120,255,60)) }),
				LightEmission = 0.6, LightInfluence = 0.4,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,2.5), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(0,220,0)), CSK(0.2, C3(40,255,20)), CSK(0.45, C3(100,255,50)), CSK(0.7, C3(60,200,20)), CSK(1, C3(20,80,0)) }),
				LightEmission = 0.7, Size = NS({ NSK(0,0), NSK(0.3,5.5), NSK(1,0) }),
				Speed        = NR(10,38), SpreadAngle = {160,160},
				Lifetime     = NR(0.9,2.05), EmitCount = 100,
			},
			light = { Color = C3(50,200,0), Brightness = 7, Range = 28 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Petal Storm",
		decalId = "rbxassetid://98757642945833",
		price   = 180,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,120,170)), CSK(0.3, C3(255,170,200)), CSK(0.6, C3(255,210,230)), CSK(1, C3(255,230,245)) }),
				LightEmission = 0.7, LightInfluence = 0.35,
				Lifetime     = 0.46,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(255,160,200)), CSK(0.2, C3(255,200,225)), CSK(0.45, C3(255,230,245)), CSK(0.7, C3(255,200,225)), CSK(1, C3(200,80,140)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.2,4.5), NSK(1,0) }),
				Speed        = NR(6,28), SpreadAngle = {160,160},
				Lifetime     = NR(1.4,2.85), EmitCount = 90,
			},
			light = { Color = C3(255,150,200), Brightness = 7, Range = 26 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Spore",
		decalId = "rbxassetid://867455377",
		price   = 140,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,240,0)), CSK(0.4, C3(220,255,60)), CSK(0.7, C3(240,255,120)), CSK(1, C3(255,255,180)) }),
				LightEmission = 0.8, LightInfluence = 0.28,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,1.7), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(220,255,0)), CSK(0.2, C3(240,255,80)), CSK(0.45, C3(255,255,150)), CSK(0.7, C3(200,240,60)), CSK(1, C3(100,140,0)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.2,4), NSK(1,0) }),
				Speed        = NR(8,30), SpreadAngle = {180,180},
				Lifetime     = NR(1.15,2.3), EmitCount = 110,
			},
			light = { Color = C3(180,255,0), Brightness = 8, Range = 30 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Thornburst",
		decalId = "rbxassetid://672751795",
		price   = 160,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(100,60,20)), CSK(0.4, C3(140,100,40)), CSK(0.7, C3(180,140,60)), CSK(1, C3(200,160,80)) }),
				LightEmission = 0.3, LightInfluence = 0.55,
				Lifetime     = 0.46,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(80,50,10)), CSK(0.2, C3(100,70,20)), CSK(0.4, C3(140,100,30)), CSK(0.65, C3(60,140,20)), CSK(0.85, C3(0,180,0)), CSK(1, C3(0,100,0)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.15,6.5), NSK(1,0) }),
				Speed        = NR(16,54), SpreadAngle = {170,170},
				Lifetime     = NR(0.46,1.15), EmitCount = 105,
			},
			light = { Color = C3(80,60,20), Brightness = 5, Range = 24 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Mossy",
		decalId = "rbxassetid://7034974835",
		price   = 100,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(30,80,20)), CSK(0.4, C3(50,120,40)), CSK(0.7, C3(80,160,60)), CSK(1, C3(100,180,70)) }),
				LightEmission = 0.3, LightInfluence = 0.6,
				Lifetime     = 0.58,
				WidthScale   = NS({ NSK(0,4.5), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(20,60,10)), CSK(0.25, C3(40,100,30)), CSK(0.5, C3(70,130,50)), CSK(0.75, C3(50,100,30)), CSK(1, C3(20,50,10)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.4,11), NSK(1,0) }),
				Speed        = NR(3,16), SpreadAngle = {120,120},
				Lifetime     = NR(2.3,4.6), EmitCount = 80,
			},
			light = { Color = C3(60,120,30), Brightness = 5, Range = 22 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Seismic",
		decalId = "rbxassetid://4970747516",
		price   = 200,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(120,70,30)), CSK(0.4, C3(160,110,50)), CSK(0.7, C3(200,150,70)), CSK(1, C3(240,180,90)) }),
				LightEmission = 0.5, LightInfluence = 0.5,
				Lifetime     = 0.46,
				WidthScale   = NS({ NSK(0,3.7), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(80,50,20)), CSK(0.2, C3(120,80,40)), CSK(0.45, C3(180,120,60)), CSK(0.7, C3(240,160,50)), CSK(0.9, C3(255,180,60)), CSK(1, C3(255,200,80)) }),
				LightEmission = 0.7, Size = NS({ NSK(0,0), NSK(0.3,9), NSK(1,0) }),
				Speed        = NR(6,28), SpreadAngle = {140,140},
				Lifetime     = NR(1.15,2.85), EmitCount = 70,
			},
			light = { Color = C3(200,130,50), Brightness = 8, Range = 30 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Wildfire",
		decalId = "rbxassetid://13545688032",
		price   = 230,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(220,130,0)), CSK(0.3, C3(255,180,20)), CSK(0.6, C3(255,220,60)), CSK(1, C3(255,240,100)) }),
				LightEmission = 0.9, LightInfluence = 0.15,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,2.5), NSK(1,0) }),
				Texture      = "rbxassetid://14596508213",
			},
			burst = {
				Texture      = "rbxassetid://14596508213",
				Color        = CS({ CSK(0, C3(200,90,0)), CSK(0.15, C3(255,140,0)), CSK(0.35, C3(255,180,20)), CSK(0.55, C3(255,160,0)), CSK(0.75, C3(120,60,0)), CSK(1, C3(40,20,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,7.5), NSK(1,0) }),
				Speed        = NR(12,48), SpreadAngle = {170,170},
				Lifetime     = NR(0.7,1.7), EmitCount = 85,
			},
			light = { Color = C3(230,140,0), Brightness = 10, Range = 34 },
			sound = "rbxassetid://82623651042971",
		},
	},
}
