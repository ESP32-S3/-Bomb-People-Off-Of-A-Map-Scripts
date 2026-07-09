-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Frostbite",
		decalId = "rbxassetid://13986675333",
		price   = 150,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,240,255)), CSK(0.2, C3(140,220,255)), CSK(0.45, C3(100,200,255)), CSK(0.7, C3(180,240,255)), CSK(1, C3(240,255,255)) }),
				LightEmission = 0.9, LightInfluence = 0.18,
				Lifetime     = 0.38,
				WidthScale   = NS({ NSK(0,4.0), NSK(0.25,5.5), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(220,245,255)), CSK(0.35, C3(160,220,255)), CSK(0.55, C3(80,180,255)), CSK(0.8, C3(180,230,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.15,11), NSK(0.4,7), NSK(1,0) }),
				Speed        = NR(22,75), SpreadAngle = {180,180},
				Lifetime     = NR(0.7,1.7), EmitCount = 210,
			},
			light = { Color = C3(150,220,255), Brightness = 14, Range = 44 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Blizzard",
		decalId = "rbxassetid://1230486119",
		price   = 180,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(220,240,255)), CSK(0.4, C3(180,220,255)), CSK(0.7, C3(240,250,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, LightInfluence = 0.08,
				Lifetime     = 0.26,
				WidthScale   = NS({ NSK(0,2.2), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.2, C3(230,245,255)), CSK(0.45, C3(200,235,255)), CSK(0.7, C3(180,225,255)), CSK(1, C3(220,240,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.08,5), NSK(0.3,3.5), NSK(1,0) }),
				Speed        = NR(32,110), SpreadAngle = {180,180},
				Lifetime     = NR(0.35,1.15), EmitCount = 190,
			},
			light = { Color = C3(200,230,255), Brightness = 16, Range = 40 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Glacial",
		decalId = "rbxassetid://13986683660",
		price   = 220,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(20,60,140)), CSK(0.25, C3(50,120,200)), CSK(0.5, C3(80,160,220)), CSK(0.75, C3(160,220,255)), CSK(1, C3(220,245,255)) }),
				LightEmission = 0.9, LightInfluence = 0.15,
				Lifetime     = 0.44,
				WidthScale   = NS({ NSK(0,4.7), NSK(0.3,6.0), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(30,80,160)), CSK(0.2, C3(60,140,210)), CSK(0.4, C3(100,190,255)), CSK(0.65, C3(180,230,255)), CSK(0.85, C3(240,250,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,12), NSK(0.5,8), NSK(1,0) }),
				Speed        = NR(16,58), SpreadAngle = {170,170},
				Lifetime     = NR(0.9,2.3), EmitCount = 160,
			},
			light = { Color = C3(80,180,255), Brightness = 16, Range = 50 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Permafrost",
		decalId = "rbxassetid://10378221250",
		price   = 260,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(10,30,80)), CSK(0.25, C3(30,80,160)), CSK(0.5, C3(50,120,200)), CSK(0.75, C3(120,190,255)), CSK(1, C3(180,230,255)) }),
				LightEmission = 0.8, LightInfluence = 0.25,
				Lifetime     = 0.52,
				WidthScale   = NS({ NSK(0,5.2), NSK(0.3,6.4), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(10,30,80)), CSK(0.15, C3(30,70,150)), CSK(0.35, C3(60,130,200)), CSK(0.55, C3(120,190,255)), CSK(0.8, C3(200,235,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.22,12), NSK(0.55,9), NSK(1,0) }),
				Speed        = NR(11,47), SpreadAngle = {150,150},
				Lifetime     = NR(1.15,2.75), EmitCount = 135,
			},
			light = { Color = C3(40,100,200), Brightness = 14, Range = 44 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Snowstorm",
		decalId = "rbxassetid://5513404310",
		price   = 130,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.4, C3(240,250,255)), CSK(0.7, C3(230,245,255)), CSK(1, C3(220,240,255)) }),
				LightEmission = 1, LightInfluence = 0.03,
				Lifetime     = 0.26,
				WidthScale   = NS({ NSK(0,1.7), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.2, C3(240,250,255)), CSK(0.45, C3(220,240,255)), CSK(0.7, C3(200,230,255)), CSK(1, C3(230,245,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.08,6.5), NSK(0.3,4), NSK(1,0) }),
				Speed        = NR(26,100), SpreadAngle = {180,180},
				Lifetime     = NR(0.45,1.25), EmitCount = 160,
			},
			light = { Color = C3(230,245,255), Brightness = 18, Range = 40 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Cryo",
		decalId = "rbxassetid://16967638719",
		price   = 300,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,240,255)), CSK(0.25, C3(60,250,255)), CSK(0.5, C3(120,255,255)), CSK(0.75, C3(180,255,255)), CSK(1, C3(230,255,255)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.28,
				WidthScale   = NS({ NSK(0,3.2), NSK(0.2,4.5), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(100,245,255)), CSK(0.25, C3(0,220,255)), CSK(0.5, C3(60,255,255)), CSK(0.75, C3(180,255,255)), CSK(1, C3(255,255,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.08,12), NSK(0.3,7), NSK(1,0) }),
				Speed        = NR(32,110), SpreadAngle = {180,180},
				Lifetime     = NR(0.45,1.4), EmitCount = 210,
			},
			light = { Color = C3(0,220,255), Brightness = 28, Range = 62 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Tundra",
		decalId = "rbxassetid://532404131",
		price   = 110,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(160,175,190)), CSK(0.3, C3(190,200,215)), CSK(0.6, C3(220,230,240)), CSK(1, C3(240,245,250)) }),
				LightEmission = 0.6, LightInfluence = 0.38,
				Lifetime     = 0.58,
				WidthScale   = NS({ NSK(0,6.4), NSK(1,0) }),
				Texture      = "rbxassetid://117619335653779",
			},
			burst = {
				Texture      = "rbxassetid://117619335653779",
				Color        = CS({ CSK(0, C3(140,160,180)), CSK(0.2, C3(180,200,220)), CSK(0.4, C3(220,235,245)), CSK(0.65, C3(255,255,255)), CSK(0.85, C3(200,230,250)), CSK(1, C3(140,200,230)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.25,12), NSK(0.6,9), NSK(1,0) }),
				Speed        = NR(6,36), SpreadAngle = {130,130},
				Lifetime     = NR(1.4,3.2), EmitCount = 140,
			},
			light = { Color = C3(200,215,230), Brightness = 10, Range = 36 },
			sound = "rbxassetid://180199793",
		},
	},
}
