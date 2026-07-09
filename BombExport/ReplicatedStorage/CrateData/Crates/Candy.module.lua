-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Bubblegum",
		decalId = "rbxassetid://3293730154",
		price   = 100,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,150,200)), CSK(0.4, C3(255,180,220)), CSK(0.7, C3(255,210,235)), CSK(1, C3(255,220,240)) }),
				LightEmission = 0.7, LightInfluence = 0.3,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(255,100,180)), CSK(0.2, C3(255,150,210)), CSK(0.5, C3(255,200,230)), CSK(0.75, C3(255,160,200)), CSK(1, C3(200,80,160)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.2,5.5), NSK(1,0) }),
				Speed        = NR(11,42), SpreadAngle = {180,180},
				Lifetime     = NR(0.5,1.4), EmitCount = 120,
			},
			light = { Color = C3(255,120,200), Brightness = 8, Range = 28 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Lollipop",
		decalId = "rbxassetid://99841771251038",
		price   = 140,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,0,0)), CSK(0.25, C3(255,180,0)), CSK(0.5, C3(0,200,0)), CSK(0.75, C3(0,100,255)), CSK(1, C3(200,0,255)) }),
				LightEmission = 0.9, LightInfluence = 0.08,
				Lifetime     = 0.25,
				WidthScale   = NS({ NSK(0,1.6), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(255,0,80)), CSK(0.15, C3(255,100,0)), CSK(0.33, C3(0,200,255)), CSK(0.5, C3(0,255,200)), CSK(0.66, C3(255,220,0)), CSK(1, C3(180,0,255)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.2,4.5), NSK(1,0) }),
				Speed        = NR(14,56), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.15), EmitCount = 120,
			},
			light = { Color = C3(255,100,0), Brightness = 9, Range = 30 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Cotton Candy",
		decalId = "rbxassetid://13833617283",
		price   = 120,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,180,240)), CSK(0.3, C3(220,190,255)), CSK(0.5, C3(180,200,255)), CSK(0.7, C3(220,190,255)), CSK(1, C3(255,180,240)) }),
				LightEmission = 0.7, LightInfluence = 0.3,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(255,180,240)), CSK(0.2, C3(230,190,255)), CSK(0.5, C3(200,210,255)), CSK(0.8, C3(240,200,255)), CSK(1, C3(255,200,255)) }),
				LightEmission = 0.8, Size = NS({ NSK(0,0), NSK(0.3,7), NSK(1,0) }),
				Speed        = NR(6,26), SpreadAngle = {160,160},
				Lifetime     = NR(1,2.85), EmitCount = 80,
			},
			light = { Color = C3(255,180,240), Brightness = 6, Range = 24 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Jawbreaker",
		decalId = "rbxassetid://114781021872649",
		price   = 190,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,80,0)), CSK(0.25, C3(255,0,100)), CSK(0.5, C3(0,180,255)), CSK(0.75, C3(100,0,255)), CSK(1, C3(200,0,255)) }),
				LightEmission = 1, LightInfluence = 0.05,
				Lifetime     = 0.2,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(255,0,0)), CSK(0.15, C3(255,120,0)), CSK(0.25, C3(255,220,0)), CSK(0.4, C3(0,220,0)), CSK(0.55, C3(0,100,255)), CSK(0.75, C3(120,0,255)), CSK(1, C3(220,0,255)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.2,6.5), NSK(1,0) }),
				Speed        = NR(18,70), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.15), EmitCount = 135,
			},
			light = { Color = C3(255,100,200), Brightness = 12, Range = 34 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Gummy",
		decalId = "rbxassetid://85207018582561",
		price   = 110,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(100,255,80)), CSK(0.4, C3(180,255,40)), CSK(0.7, C3(255,230,0)), CSK(1, C3(255,200,0)) }),
				LightEmission = 0.8, LightInfluence = 0.2,
				Lifetime     = 0.3,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(0,220,80)), CSK(0.2, C3(80,255,40)), CSK(0.5, C3(255,200,0)), CSK(0.75, C3(255,120,0)), CSK(1, C3(255,80,0)) }),
				LightEmission = 0.9, Size = NS({ NSK(0,0), NSK(0.2,4.5), NSK(1,0) }),
				Speed        = NR(13,50), SpreadAngle = {180,180},
				Lifetime     = NR(0.4,1.15), EmitCount = 130,
			},
			light = { Color = C3(80,255,80), Brightness = 8, Range = 28 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Caramel",
		decalId = "rbxassetid://7231116289",
		price   = 130,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(180,110,30)), CSK(0.4, C3(210,140,50)), CSK(0.7, C3(240,170,70)), CSK(1, C3(240,180,80)) }),
				LightEmission = 0.6, LightInfluence = 0.4,
				Lifetime     = 0.35,
				WidthScale   = NS({ NSK(0,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(140,80,20)), CSK(0.2, C3(180,120,40)), CSK(0.5, C3(220,160,60)), CSK(0.75, C3(240,190,90)), CSK(1, C3(255,210,120)) }),
				LightEmission = 0.7, Size = NS({ NSK(0,0), NSK(0.25,6.5), NSK(1,0) }),
				Speed        = NR(7,32), SpreadAngle = {150,150},
				Lifetime     = NR(0.8,2.05), EmitCount = 75,
			},
			light = { Color = C3(220,160,50), Brightness = 6, Range = 24 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Pop Rocks",
		decalId = "rbxassetid://136786935954717",
		price   = 160,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(255,0,120)), CSK(0.3, C3(0,220,255)), CSK(0.6, C3(255,220,0)), CSK(1, C3(255,0,120)) }),
				LightEmission = 1, LightInfluence = 0,
				Lifetime     = 0.12,
				WidthScale   = NS({ NSK(0,0.8), NSK(0.5,2.4), NSK(1,0) }),
				Texture      = "rbxassetid://136913510021553",
			},
			burst = {
				Texture      = "rbxassetid://136913510021553",
				Color        = CS({ CSK(0, C3(255,0,100)), CSK(0.15, C3(255,0,200)), CSK(0.33, C3(0,255,200)), CSK(0.5, C3(0,255,255)), CSK(0.66, C3(255,240,0)), CSK(1, C3(255,0,180)) }),
				LightEmission = 1, Size = NS({ NSK(0,0), NSK(0.1,3), NSK(1,0) }),
				Speed        = NR(25,98), SpreadAngle = {180,180},
				Lifetime     = NR(0.2,0.7), EmitCount = 150,
			},
			light = { Color = C3(255,100,200), Brightness = 14, Range = 36 },
			sound = "rbxassetid://82623651042971",
		},
	},
}
