-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Biohazard",
		decalId = "rbxassetid://10830696031",
		price   = 150,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(80,200,0)), CSK(0.4, C3(120,240,20)), CSK(0.7, C3(160,255,30)), CSK(1, C3(180,255,50)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(60,180,0)), CSK(0.2, C3(100,220,0)), CSK(0.5, C3(180,255,0)), CSK(0.75, C3(120,200,0)), CSK(1, C3(20,80,0)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.25,6.5), NSK(1,0) }),
				Speed        = NR(11,42), SpreadAngle = {180,180},
				Lifetime     = NR(0.8,2.3), EmitCount = 130,
			},
			light = { Color = C3(100,255,0), Brightness = 10, Range = 30 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Acid Rain",
		decalId = "rbxassetid://2861383",
		price   = 170,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,255,0)), CSK(0.5, C3(160,240,0)), CSK(1, C3(120,200,0)) }),
				LightEmission = 1, LightInfluence = 0.05,
				Lifetime     = 0.2,
				WidthScale   = NS({ NSK(0,0.8), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(220,255,0)), CSK(0.2, C3(180,255,0)), CSK(0.5, C3(100,200,0)), CSK(0.75, C3(60,140,0)), CSK(1, C3(40,100,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,3), NSK(1,0) }),
				Speed        = NR(15,70), SpreadAngle = {140,180},
				Lifetime     = NR(0.5,1.7), EmitCount = 135,
			},
			light = { Color = C3(180,255,0), Brightness = 10, Range = 30 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Mutagen",
		decalId = "rbxassetid://7185243382",
		price   = 210,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(120,0,180)), CSK(0.3, C3(80,100,0)), CSK(0.5, C3(80,200,0)), CSK(0.7, C3(80,100,0)), CSK(1, C3(120,0,180)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,2.0), NSK(0.5,1.0), NSK(1,2.0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(100,0,180)), CSK(0.2, C3(80,0,140)), CSK(0.4, C3(80,200,0)), CSK(0.6, C3(120,255,0)), CSK(0.8, C3(180,0,120)), CSK(1, C3(20,60,0)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.2,5.5), NSK(1,0) }),
				Speed        = NR(9,40), SpreadAngle = {180,180},
				Lifetime     = NR(0.8,2.3), EmitCount = 95,
			},
			light = { Color = C3(120,200,0), Brightness = 8, Range = 28 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Venom",
		decalId = "rbxassetid://14060337027",
		price   = 250,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.4, C3(20,60,0)), CSK(0.7, C3(50,140,0)), CSK(1, C3(80,200,0)) }),
				LightEmission = 0.7, LightInfluence = 0.25,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.2, C3(20,40,0)), CSK(0.4, C3(60,180,0)), CSK(0.6, C3(120,255,0)), CSK(0.8, C3(80,200,0)), CSK(1, C3(0,40,0)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.2,7.5), NSK(1,0) }),
				Speed        = NR(11,50), SpreadAngle = {170,170},
				Lifetime     = NR(1,2.85), EmitCount = 85,
			},
			light = { Color = C3(80,220,0), Brightness = 10, Range = 30 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Irradiated",
		decalId = "rbxassetid://69529677",
		price   = 280,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,255,0)), CSK(0.4, C3(230,255,50)), CSK(0.7, C3(255,255,80)), CSK(1, C3(255,255,100)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.2,
				WidthScale   = NS({ NSK(0,1.6), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(220,255,0)), CSK(0.2, C3(255,255,50)), CSK(0.5, C3(255,255,150)), CSK(0.75, C3(160,200,0)), CSK(1, C3(80,120,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.15,5.5), NSK(1,0) }),
				Speed        = NR(18,77), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.4), EmitCount = 120,
			},
			light = { Color = C3(200,255,0), Brightness = 16, Range = 40 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Plague",
		decalId = "rbxassetid://86511655557910",
		price   = 190,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(80,100,0)), CSK(0.4, C3(100,120,10)), CSK(0.7, C3(120,140,15)), CSK(1, C3(140,160,20)) }),
				LightEmission = 0.4, LightInfluence = 0.55,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,3.6), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(60,80,0)), CSK(0.2, C3(80,100,5)), CSK(0.5, C3(120,150,20)), CSK(0.75, C3(160,180,40)), CSK(1, C3(200,200,50)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.4,10), NSK(1,0) }),
				Speed        = NR(3,20), SpreadAngle = {150,150},
				Lifetime     = NR(1.5,4.6), EmitCount = 65,
			},
			light = { Color = C3(120,160,0), Brightness = 6, Range = 24 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Sludge",
		decalId = "rbxassetid://7860964867",
		price   = 120,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(60,70,20)), CSK(0.4, C3(80,90,30)), CSK(0.7, C3(100,110,40)), CSK(1, C3(100,110,40)) }),
				LightEmission = 0.2, LightInfluence = 0.75,
				Lifetime     = 0.6,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://6710845632",
			},
			burst = {
				Texture      = "rbxassetid://6710845632",
				Color        = CS({ CSK(0, C3(40,55,10)), CSK(0.2, C3(60,75,20)), CSK(0.5, C3(80,100,30)), CSK(0.75, C3(120,140,45)), CSK(1, C3(160,180,60)) }),
				LightEmission = 0.3, Size = NS({ NSK(0,0), NSK(0.4,10), NSK(1,0) }),
				Speed        = NR(2,14), SpreadAngle = {120,120},
				Lifetime     = NR(2,5.7), EmitCount = 55,
			},
			light = { Color = C3(100,120,20), Brightness = 4, Range = 18 },
			sound = "rbxassetid://180199793",
		},
	},
}
