-- helper shorthands
local CS  = ColorSequence.new
local CSK = ColorSequenceKeypoint.new
local NS  = NumberSequence.new
local NSK = NumberSequenceKeypoint.new
local NR  = NumberRange.new
local C3  = Color3.fromRGB

return {
	{
		name    = "Void",
		decalId = "rbxassetid://71425889880001",
		price   = 200,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.5, C3(10,0,20)), CSK(1, C3(20,0,40)) }),
				LightEmission = 0.05, LightInfluence = 0.95,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.2, C3(15,0,25)), CSK(0.5, C3(30,0,50)), CSK(0.75, C3(80,0,130)), CSK(1, C3(100,0,150)) }),
				LightEmission = 0.3, Size = NS({ NSK(0,0), NSK(0.4,10), NSK(1,0) }),
				Speed        = NR(3,24), SpreadAngle = {180,180},
				Lifetime     = NR(1.5,4.6), EmitCount = 65,
			},
			light = { Color = C3(80,0,120), Brightness = 3, Range = 18 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Eclipse",
		decalId = "rbxassetid://78012537806279",
		price   = 240,
		rarity = {
			name = "Rare",
			chance = 6,
		},
		rarityName = "Rare",
		dropChance = 6,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(20,0,60)), CSK(0.4, C3(50,20,80)), CSK(0.7, C3(80,40,0)), CSK(1, C3(80,40,0)) }),
				LightEmission = 0.3, LightInfluence = 0.65,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(10,0,30)), CSK(0.2, C3(30,10,60)), CSK(0.5, C3(60,20,100)), CSK(0.75, C3(140,60,0)), CSK(1, C3(200,120,0)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.3,9), NSK(1,0) }),
				Speed        = NR(7,35), SpreadAngle = {170,170},
				Lifetime     = NR(1,2.85), EmitCount = 70,
			},
			light = { Color = C3(60,30,0), Brightness = 4, Range = 22 },
			sound = "rbxassetid://110143052710363",
		},
	},
	{
		name    = "Phantom",
		decalId = "rbxassetid://1169346953",
		price   = 180,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(140,140,160)), CSK(0.4, C3(170,170,190)), CSK(0.7, C3(200,200,220)), CSK(1, C3(200,200,220)) }),
				LightEmission = 0.4, LightInfluence = 0.55,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,2.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(160,160,180)), CSK(0.2, C3(190,190,210)), CSK(0.5, C3(220,220,240)), CSK(0.75, C3(140,140,180)), CSK(1, C3(50,50,70)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.35,9), NSK(1,0) }),
				Speed        = NR(4,22), SpreadAngle = {150,150},
				Lifetime     = NR(1.5,4), EmitCount = 65,
			},
			light = { Color = C3(180,180,220), Brightness = 4, Range = 22 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Wraith",
		decalId = "rbxassetid://10492222668",
		price   = 220,
		rarity = {
			name = "Uncommon",
			chance = 15,
		},
		rarityName = "Uncommon",
		dropChance = 15,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,20,80)), CSK(0.5, C3(0,40,110)), CSK(1, C3(0,60,140)) }),
				LightEmission = 0.4, LightInfluence = 0.55,
				Lifetime     = 0.45,
				WidthScale   = NS({ NSK(0,3.6), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(0,10,40)), CSK(0.2, C3(0,25,70)), CSK(0.5, C3(0,50,120)), CSK(0.75, C3(40,90,200)), CSK(1, C3(100,150,255)) }),
				LightEmission = 0.6, Size = NS({ NSK(0,0), NSK(0.4,10), NSK(1,0) }),
				Speed        = NR(3,20), SpreadAngle = {140,140},
				Lifetime     = NR(2,5.2), EmitCount = 60,
			},
			light = { Color = C3(0,40,120), Brightness = 4, Range = 20 },
			sound = "rbxassetid://180199793",
		},
	},
	{
		name    = "Abyssal",
		decalId = "rbxassetid://86285886487806",
		price   = 300,
		rarity = {
			name = "Legendary",
			chance = 1,
		},
		rarityName = "Legendary",
		dropChance = 1,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,30,40)), CSK(0.4, C3(0,50,60)), CSK(0.7, C3(0,70,80)), CSK(1, C3(0,80,80)) }),
				LightEmission = 0.2, LightInfluence = 0.75,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,4.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(0,20,30)), CSK(0.2, C3(0,40,50)), CSK(0.5, C3(0,80,90)), CSK(0.75, C3(0,120,140)), CSK(1, C3(0,160,160)) }),
				LightEmission = 0.5, Size = NS({ NSK(0,0), NSK(0.4,10), NSK(1,0) }),
				Speed        = NR(3,20), SpreadAngle = {160,160},
				Lifetime     = NR(2,5.7), EmitCount = 50,
			},
			light = { Color = C3(0,120,120), Brightness = 4, Range = 20 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Umbra",
		decalId = "rbxassetid://105394191676144",
		price   = 280,
		rarity = {
			name = "Epic",
			chance = 3,
		},
		rarityName = "Epic",
		dropChance = 3,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.5, C3(40,0,0)), CSK(1, C3(100,0,0)) }),
				LightEmission = 0.15, LightInfluence = 0.85,
				Lifetime     = 0.5,
				WidthScale   = NS({ NSK(0,5.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(0,0,0)), CSK(0.2, C3(30,0,0)), CSK(0.5, C3(80,0,0)), CSK(0.75, C3(140,0,0)), CSK(1, C3(200,0,0)) }),
				LightEmission = 0.4, Size = NS({ NSK(0,0), NSK(0.35,9.5), NSK(1,0) }),
				Speed        = NR(6,28), SpreadAngle = {170,170},
				Lifetime     = NR(1.5,3.4), EmitCount = 60,
			},
			light = { Color = C3(100,0,0), Brightness = 4, Range = 20 },
			sound = "rbxassetid://82623651042971",
		},
	},
	{
		name    = "Nightfall",
		decalId = "rbxassetid://72314123",
		price   = 160,
		rarity = {
			name = "Common",
			chance = 30,
		},
		rarityName = "Common",
		dropChance = 30,
		explosionFX = {
			trail = {
				Color        = CS({ CSK(0, C3(10,0,40)), CSK(0.5, C3(30,20,80)), CSK(1, C3(60,40,120)) }),
				LightEmission = 0.4, LightInfluence = 0.55,
				Lifetime     = 0.4,
				WidthScale   = NS({ NSK(0,3.0), NSK(1,0) }),
				Texture      = "rbxassetid://72314123",
			},
			burst = {
				Texture      = "rbxassetid://72314123",
				Color        = CS({ CSK(0, C3(10,5,40)), CSK(0.2, C3(25,15,70)), CSK(0.5, C3(50,40,120)), CSK(0.75, C3(80,60,180)), CSK(1, C3(100,80,200)) }),
				LightEmission = 0.6, Size = NS({ NSK(0,0), NSK(0.3,8), NSK(1,0) }),
				Speed        = NR(6,28), SpreadAngle = {160,160},
				Lifetime     = NR(1,2.85), EmitCount = 75,
			},
			light = { Color = C3(60,40,120), Brightness = 5, Range = 24 },
			sound = "rbxassetid://180199793",
		},
	},
}
