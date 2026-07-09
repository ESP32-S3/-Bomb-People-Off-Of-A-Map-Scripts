-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Hellfire",
		decalId = "rbxassetid://14775566533",
		price   = 150,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,220)), CSK(0.12, C3(255,220,80)), CSK(0.3, C3(255,50,0)), CSK(0.6, C3(255,130,0)), CSK(1, C3(255,220,40)) }),
				LightEmission = 1, LightInfluence = 0.03,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,4.2), NSK(0.2,6.0), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(255,255,220)), CSK(0.1, C3(255,180,80)), CSK(0.25, C3(255,30,0)), CSK(0.5, C3(255,120,0)), CSK(0.75, C3(200,40,0)), CSK(1, C3(40,0,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.12,10), NSK(0.4,7), NSK(1,0) }),
				Speed        = NR(20,70), SpreadAngle = {180,180},
				Lifetime     = NR(0.6,1.5), EmitCount = 210,
			},
			light = { Color = C3(255,120,0), Brightness = 18, Range = 50 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Magma Core",
		decalId = "rbxassetid://161923848",
		price   = 200,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(220,30,0)), CSK(0.25, C3(255,60,0)), CSK(0.5, C3(255,100,0)), CSK(0.75, C3(255,160,20)), CSK(1, C3(255,200,60)) }),
				LightEmission = 1, LightInfluence = 0.08,
				Lifetime     = 0.38,
				WidthScale   = NS({ NSK(0,4.7), NSK(0.3,5.7), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(255,220,180)), CSK(0.15, C3(255,120,40)), CSK(0.3, C3(220,20,0)), CSK(0.55, C3(255,70,0)), CSK(0.8, C3(180,30,0)), CSK(1, C3(30,0,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,12), NSK(0.5,8), NSK(1,0) }),
				Speed        = NR(12,44), SpreadAngle = {160,160},
				Lifetime     = NR(0.9,1.8), EmitCount = 190,
			},
			light = { Color = C3(220,60,0), Brightness = 16, Range = 44 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Ember",
		decalId = "rbxassetid://293014110",
		price   = 100,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,180)), CSK(0.2, C3(255,240,80)), CSK(0.45, C3(255,180,0)), CSK(0.75, C3(255,100,0)), CSK(1, C3(255,60,0)) }),
				LightEmission = 0.9, LightInfluence = 0.15,
				Lifetime     = 0.26,
				WidthScale   = NS({ NSK(0,2.7), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(255,240,140)), CSK(0.15, C3(255,220,60)), CSK(0.35, C3(255,180,0)), CSK(0.55, C3(255,80,0)), CSK(0.8, C3(180,40,0)), CSK(1, C3(60,10,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.08,5.5), NSK(0.3,3.5), NSK(1,0) }),
				Speed        = NR(26,100), SpreadAngle = {180,180},
				Lifetime     = NR(0.35,1.05), EmitCount = 160,
			},
			light = { Color = C3(255,160,0), Brightness = 14, Range = 36 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Volcanic",
		decalId = "rbxassetid://6191976998",
		price   = 250,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(20,5,0)), CSK(0.2, C3(120,20,0)), CSK(0.4, C3(220,50,0)), CSK(0.65, C3(255,140,0)), CSK(0.85, C3(255,200,60)), CSK(1, C3(255,230,120)) }),
				LightEmission = 0.8, LightInfluence = 0.18,
				Lifetime     = 0.48,
				WidthScale   = NS({ NSK(0,5.2), NSK(0.3,6.4), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(10,5,5)), CSK(0.15, C3(80,15,0)), CSK(0.35, C3(200,40,0)), CSK(0.55, C3(255,120,0)), CSK(0.8, C3(255,200,80)), CSK(1, C3(255,240,140)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.18,12), NSK(0.5,9), NSK(1,0) }),
				Speed        = NR(9,42), SpreadAngle = {150,150},
				Lifetime     = NR(1.15,2.4), EmitCount = 155,
			},
			light = { Color = C3(180,50,0), Brightness = 20, Range = 56 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Purgatory",
		decalId = "rbxassetid://75444423576238",
		price   = 300,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(200,0,255)), CSK(0.2, C3(255,20,80)), CSK(0.45, C3(255,60,20)), CSK(0.7, C3(255,130,0)), CSK(1, C3(255,180,40)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.38,
				WidthScale   = NS({ NSK(0,4.0), NSK(0.25,5.5), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(255,180,255)), CSK(0.12, C3(220,0,255)), CSK(0.3, C3(160,0,220)), CSK(0.5, C3(255,40,0)), CSK(0.75, C3(200,0,60)), CSK(1, C3(60,0,60)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.12,10), NSK(0.4,7), NSK(1,0) }),
				Speed        = NR(22,80), SpreadAngle = {180,180},
				Lifetime     = NR(0.7,1.7), EmitCount = 210,
			},
			light = { Color = C3(200,0,255), Brightness = 20, Range = 48 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Solar Flare",
		decalId = "rbxassetid://102173189480441",
		price   = 350,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.15, C3(255,255,200)), CSK(0.35, C3(255,240,120)), CSK(0.65, C3(255,210,0)), CSK(1, C3(255,180,0)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.22,
				WidthScale   = NS({ NSK(0,3.5), NSK(0.2,4.7), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(255,255,255)), CSK(0.1, C3(255,250,180)), CSK(0.25, C3(255,230,80)), CSK(0.45, C3(255,170,0)), CSK(0.7, C3(255,100,0)), CSK(1, C3(255,60,0)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,12), NSK(0.35,9), NSK(1,0) }),
				Speed        = NR(32,120), SpreadAngle = {180,180},
				Lifetime     = NR(0.25,0.95), EmitCount = 220,
			},
			light = { Color = C3(255,240,150), Brightness = 30, Range = 68 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Charcoal",
		decalId = "rbxassetid://963708591",
		price   = 120,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(30,30,30)), CSK(0.3, C3(80,40,0)), CSK(0.6, C3(140,70,0)), CSK(1, C3(100,100,100)) }),
				LightEmission = 0.5, LightInfluence = 0.5,
				Lifetime     = 0.58,
				WidthScale   = NS({ NSK(0,6.4), NSK(1,0) }),
				Texture      = "rbxassetid://11509651894",
			},
			burst = {
				Texture      = "rbxassetid://11509651894",
				Color        = CS({ CSK(0, C3(15,15,15)), CSK(0.2, C3(40,30,20)), CSK(0.4, C3(80,60,40)), CSK(0.65, C3(255,140,0)), CSK(0.85, C3(255,200,60)), CSK(1, C3(255,230,120)) }),
				LightEmission = 0.75, Size = NS({ NSK(0,0), NSK(0.22,12), NSK(0.6,9), NSK(1,0) }),
				Speed        = NR(6,30), SpreadAngle = {130,130},
				Lifetime     = NR(1.7,3.6), EmitCount = 160,
			},
			light = { Color = C3(255,80,0), Brightness = 12, Range = 36 },
			sound = "rbxassetid://180199793",
		},
	},
}
