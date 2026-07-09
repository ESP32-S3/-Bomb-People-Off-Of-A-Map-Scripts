local BombSkin = {}

local DEBUG = true

local function log(...)
	if DEBUG then
		print("[BombSkin]", ...)
	end
end

print("[BombSkin] MODULE REQUIRED — script loaded")

local function isPlaceholder(id)
	return not id or id == "" or id == "rbxassetid://0"
end

local function clearOld(handle)
	log("clearOld called on:", handle:GetFullName())

	for _, c in ipairs(handle:GetChildren()) do
		if c.Name == "FXTrail"
			or c.Name == "FXBurst"
			or c.Name == "FXLight"
			or c.Name == "FXSound"
			or c.Name == "FXAttach0"
			or c.Name == "FXAttach1" then

			log("destroying:", c.Name, c.ClassName)
			c:Destroy()
		end
	end
end

local function getHandle(tool)
	log("getHandle:", tool:GetFullName())

	local handle = tool:FindFirstChild("Handle")
	if handle and handle:IsA("MeshPart") then
		log("MeshPart handle found:", handle:GetFullName())
		return handle
	end

	log("NO MeshPart handle found")
	return nil
end

local SKIN_MATERIALS = {
	["Hellfire"] = {material = Enum.Material.CrackedLava, variant = "Hellfire"},
	["Magma Core"] = {material = Enum.Material.CrackedLava, variant = "Magma Core"},
	["Ember"] = {material = Enum.Material.Rock, variant = "Ember"},
	["Volcanic"] = {material = Enum.Material.Basalt, variant = "Volcanic"},
	["Purgatory"] = {material = Enum.Material.CrackedLava, variant = "Purgatory"},
	["Solar Flare"] = {material = Enum.Material.Foil, variant = "Solar Flare"},
	["Charcoal"] = {material = Enum.Material.Rock, variant = "Charcoal"},

	["Frostbite"] = {material = Enum.Material.Ice, variant = "Frostbite"},
	["Blizzard"] = {material = Enum.Material.Snow, variant = "Blizzard"},
	["Glacial"] = {material = Enum.Material.Glacier, variant = "Glacial"},
	["Permafrost"] = {material = Enum.Material.Ice, variant = "Permafrost"},
	["Snowstorm"] = {material = Enum.Material.Snow, variant = "Snowstorm"},
	["Cryo"] = {material = Enum.Material.Ice, variant = "Cryo"},
	["Tundra"] = {material = Enum.Material.Snow, variant = "Tundra"},

	["Glitch"] = {material = Enum.Material.Foil, variant = "Glitch"},
	["Circuit"] = {material = Enum.Material.DiamondPlate, variant = "Circuit"},
	["Synthwave"] = {material = Enum.Material.Foil, variant = "Synthwave"},
	["Overdrive"] = {material = Enum.Material.Metal, variant = "Overdrive"},
	["Voltage"] = {material = Enum.Material.Foil, variant = "Voltage"},
	["Matrix"] = {material = Enum.Material.DiamondPlate, variant = "Matrix"},
	["Ultraviolet"] = {material = Enum.Material.Foil, variant = "Ultraviolet"},

	["Verdant"] = {material = Enum.Material.LeafyGrass, variant = "Verdant"},
	["Petal Storm"] = {material = Enum.Material.Fabric, variant = "Petal Storm"},
	["Spore"] = {material = Enum.Material.Mud, variant = "Spore"},
	["Thornburst"] = {material = Enum.Material.Rock, variant = "Thornburst"},
	["Mossy"] = {material = Enum.Material.Ground, variant = "Mossy"},
	["Seismic"] = {material = Enum.Material.Ground, variant = "Seismic"},
	["Wildfire"] = {material = Enum.Material.CrackedLava, variant = "Wildfire"},

	["Nebula"] = {material = Enum.Material.Foil, variant = "Nebula"},
	["Supernova"] = {material = Enum.Material.Foil, variant = "Supernova"},
	["Black Hole"] = {material = Enum.Material.Basalt, variant = "Black Hole"},
	["Stardust"] = {material = Enum.Material.Foil, variant = "Stardust"},
	["Pulsar"] = {material = Enum.Material.Metal, variant = "Pulsar"},
	["Dark Matter"] = {material = Enum.Material.Basalt, variant = "Dark Matter"},
	["Comet"] = {material = Enum.Material.Ice, variant = "Comet"},

	["Void"] = {material = Enum.Material.Basalt, variant = "Void"},
	["Eclipse"] = {material = Enum.Material.Slate, variant = "Eclipse"},
	["Phantom"] = {material = Enum.Material.Fabric, variant = "Phantom"},
	["Wraith"] = {material = Enum.Material.Rock, variant = "Wraith"},
	["Abyssal"] = {material = Enum.Material.Basalt, variant = "Abyssal"},
	["Umbra"] = {material = Enum.Material.Slate, variant = "Umbra"},
	["Nightfall"] = {material = Enum.Material.Slate, variant = "Nightfall"},

	["Bubblegum"] = {material = Enum.Material.Rubber, variant = "Bubblegum"},
	["Lollipop"] = {material = Enum.Material.Rubber, variant = "Lollipop"},
	["Cotton Candy"] = {material = Enum.Material.Fabric, variant = "Cotton Candy"},
	["Jawbreaker"] = {material = Enum.Material.Marble, variant = "Jawbreaker"},
	["Gummy"] = {material = Enum.Material.Rubber, variant = "Gummy"},
	["Caramel"] = {material = Enum.Material.Leather, variant = "Caramel"},
	["Pop Rocks"] = {material = Enum.Material.Marble, variant = "PopRocksSkin"},

	["Biohazard"] = {material = Enum.Material.Rubber, variant = "Biohazard"},
	["Acid Rain"] = {material = Enum.Material.Rubber, variant = "Acid Rain"},
	["Mutagen"] = {material = Enum.Material.Rubber, variant = "Mutagen"},
	["Venom"] = {material = Enum.Material.Rubber, variant = "Venom"},
	["Irradiated"] = {material = Enum.Material.CorrodedMetal, variant = "Irradiated"},
	["Plague"] = {material = Enum.Material.Mud, variant = "Plague"},
	["Sludge"] = {material = Enum.Material.Mud, variant = "Sludge"},

	["Lightning Strike"] = {material = Enum.Material.Foil, variant = "Lightning Strike"},
	["Thunderhead"] = {material = Enum.Material.Slate, variant = "Thunderhead"},
	["Stormfront"] = {material = Enum.Material.Slate, variant = "Stormfront"},
	["Thunderclap"] = {material = Enum.Material.Foil, variant = "Thunderclap"},
	["Rainstorm"] = {material = Enum.Material.Slate, variant = "Rainstorm"},
	["Static"] = {material = Enum.Material.Foil, variant = "Static"},
	["Zeus"] = {material = Enum.Material.Foil, variant = "Zeus"},

	["Runic"] = {material = Enum.Material.Rock, variant = "Runic"},
	["Pharaoh"] = {material = Enum.Material.Sandstone, variant = "Pharaoh"},
	["Arcane"] = {material = Enum.Material.Marble, variant = "Arcane"},
	["Dragon Stone"] = {material = Enum.Material.Rock, variant = "Dragon Stone"},
	["Elder Seal"] = {material = Enum.Material.Marble, variant = "Elder Seal"},
	["Cursed"] = {material = Enum.Material.Rock, variant = "Cursed"},
	["Obsidian"] = {material = Enum.Material.Basalt, variant = "Obsidian"},
}

function BombSkin.apply(tool, item)
	log("=== APPLY START ===")
	log("tool:", tool:GetFullName())
	log("item:", item and (item.Name or item.name) or "nil")

	tool.AncestryChanged:Connect(function(_, parent)
		log("TOOL MOVED TO:", parent and parent:GetFullName() or "nil")
	end)

	local handle = getHandle(tool)
	if not handle then
		log("NO HANDLE FOUND")
		return
	end

	log("USING HANDLE:", handle:GetFullName())

	handle.ChildAdded:Connect(function(child)
		log("HANDLE CHILD ADDED:", child.Name, child.ClassName)
	end)

	handle.ChildRemoved:Connect(function(child)
		log("HANDLE CHILD REMOVED:", child.Name, child.ClassName)
	end)

	clearOld(handle)

	handle:SetAttribute("HasSkinExplosion", false)

	-- =========================
	-- texture (mesh only)
	-- =========================
	local decalId = item.decalId
	log("decalId:", decalId)

	local skinName = item.name or item.Name
	local matInfo = skinName and SKIN_MATERIALS[skinName]

	if item.solidColor then
		log("applying flat solidColor skin:", skinName)
		handle.Color = item.solidColor
		handle.Material = item.material or Enum.Material.Plastic
		handle.MaterialVariant = ""
		handle.TextureID = ""
	elseif matInfo then
		log("applying MaterialVariant to MeshPart:", matInfo.variant)
		handle.Color = Color3.new(1, 1, 1)
		handle.TextureID = ""
		handle.Material = matInfo.material
		handle.MaterialVariant = matInfo.variant
	elseif not isPlaceholder(decalId) then
		log("no MaterialVariant mapped, falling back to TextureID")
		handle.Color = Color3.new(1, 1, 1)
		handle.Material = Enum.Material.Plastic
		handle.MaterialVariant = ""
		handle.TextureID = decalId
	else
		log("skipping placeholder decalId, no MaterialVariant either")
		handle.Material = Enum.Material.Plastic
		handle.MaterialVariant = ""
		handle.TextureID = ""
	end

	-- =========================
	-- fx system
	-- =========================
	local fx = item.explosionFX
	if not fx then
		log("NO explosionFX")
		return
	end

	handle:SetAttribute("HasSkinExplosion", true)

	local a0 = Instance.new("Attachment")
	a0.Name = "FXAttach0"
	a0.Position = Vector3.new(0, handle.Size.Y / 2, 0)
	a0.Parent = handle

	local a1 = Instance.new("Attachment")
	a1.Name = "FXAttach1"
	a1.Position = Vector3.new(0, -handle.Size.Y / 2, 0)
	a1.Parent = handle

	log("attachments created")

	-- TRAIL
	if fx.trail then
		local trail = Instance.new("Trail")
		trail.Name = "FXTrail"
		trail.Attachment0 = a0
		trail.Attachment1 = a1

		if fx.trail.Color then trail.Color = fx.trail.Color end
		trail.LightEmission = fx.trail.LightEmission or 0
		trail.LightInfluence = fx.trail.LightInfluence or 1
		trail.Lifetime = fx.trail.Lifetime or 0.3

		if fx.trail.WidthScale then
			trail.WidthScale = fx.trail.WidthScale
		end

		if not isPlaceholder(fx.trail.Texture) then
			trail.Texture = fx.trail.Texture
		end

		trail.Parent = handle
		log("trail parented")
	end

	-- BURST
	if fx.burst then
		local emitter = Instance.new("ParticleEmitter")
		emitter.Name = "FXBurst"
		emitter.Enabled = false
		emitter.Rate = 0

		if not isPlaceholder(fx.burst.Texture) then
			emitter.Texture = fx.burst.Texture
		end

		if fx.burst.Color then emitter.Color = fx.burst.Color end
		emitter.LightEmission = fx.burst.LightEmission or 0

		if fx.burst.Size then emitter.Size = fx.burst.Size end
		if fx.burst.Speed then emitter.Speed = fx.burst.Speed end

		if fx.burst.SpreadAngle then
			emitter.SpreadAngle = Vector2.new(
				fx.burst.SpreadAngle[1],
				fx.burst.SpreadAngle[2]
			)
		end

		if fx.burst.Lifetime then
			emitter.Lifetime = fx.burst.Lifetime
		end

		emitter:SetAttribute("EmitCount", fx.burst.EmitCount or 50)
		emitter.Parent = handle

		log("burst parented")
	end

	-- LIGHT
	if fx.light then
		local light = Instance.new("PointLight")
		light.Name = "FXLight"
		light.Enabled = false

		if fx.light.Color then light.Color = fx.light.Color end
		light.Brightness = fx.light.Brightness or 5
		light.Range = fx.light.Range or 20

		light.Parent = handle
	end

	-- SOUND
	if fx.sound and not isPlaceholder(fx.sound) then
		local sound = Instance.new("Sound")
		sound.Name = "FXSound"
		sound.SoundId = fx.sound
		sound.Parent = handle
	end

	log("=== APPLY END ===")
end

function BombSkin.bind(tool, item)
	if not tool or not item then
		log("bind aborted: nil")
		return
	end

	log("binding tool:", tool:GetFullName())

	tool.Equipped:Connect(function()
		log("TOOL EQUIPPED:", tool:GetFullName())
		task.wait(0.05)
		BombSkin.apply(tool, item)
	end)
end

return BombSkin