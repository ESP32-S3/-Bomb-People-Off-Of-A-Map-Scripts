local T = {}

T.STUD_ASSET = "rbxassetid://8890102508"
T.FONT = Enum.Font.FredokaOne

T.C_YELLOW  = Color3.fromRGB(255, 230, 40)
T.C_ORANGE  = Color3.fromRGB(255, 140, 30)
T.C_WHITE   = Color3.fromRGB(255, 255, 255)
T.C_DARK    = Color3.fromRGB(18, 18, 24)
T.C_CYAN    = Color3.fromRGB(60, 220, 255)
T.C_GREEN   = Color3.fromRGB(80, 255, 140)
T.C_PINK    = Color3.fromRGB(255, 80, 160)

T.RARITY_COLORS = {
	Common    = Color3.fromRGB(180, 180, 180),
	Uncommon  = Color3.fromRGB(80, 255, 140),
	Rare      = Color3.fromRGB(60, 220, 255),
	Epic      = Color3.fromRGB(255, 80, 160),
	Legendary = Color3.fromRGB(255, 230, 40),
}

function T.corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 12)
	c.Parent = p
	return c
end

function T.stroke(p, t, c)
	local s = Instance.new("UIStroke")
	s.Thickness = t or 2
	s.Color = c or Color3.new(0, 0, 0)
	s.Parent = p
	return s
end

function T.addStudOverlay(frameObj, transparency)
	local overlay = Instance.new("ImageLabel")
	overlay.Name = "StudOverlay"
	overlay.Parent = frameObj
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.Position = UDim2.fromScale(0, 0)
	overlay.Image = T.STUD_ASSET
	overlay.ScaleType = Enum.ScaleType.Tile
	overlay.TileSize = UDim2.new(0, 40, 0, 40)
	overlay.ImageTransparency = transparency or 0.6
	overlay.ZIndex = frameObj.ZIndex + 1
	overlay.Active = false
	return overlay
end

function T.label(name, parent, txt, sz, pos, col)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Parent = parent
	l.Size = sz
	l.Position = pos
	l.BackgroundTransparency = 1
	l.Text = txt
	l.TextColor3 = col or T.C_WHITE
	l.TextScaled = true
	l.Font = T.FONT
	l.RichText = true
	l.ZIndex = (parent:IsA("GuiObject") and parent.ZIndex or 0) + 5
	local s = Instance.new("UIStroke")
	s.Thickness = 2.5
	s.Color = T.C_DARK
	s.Transparency = 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	s.Parent = l
	return l
end

function T.frame(name, parent, sz, pos, col, trans, z)
	local f = Instance.new("Frame")
	f.Name = name
	f.Parent = parent
	f.Size = sz
	f.Position = pos
	f.BackgroundColor3 = col or T.C_DARK
	f.BackgroundTransparency = trans or 0
	f.BorderSizePixel = 0
	f.ZIndex = z or 2
	f.ClipsDescendants = true
	return f
end

function T.btn(name, parent, txt, sz, pos, bgCol, txtCol)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Parent = parent
	b.Size = sz
	b.Position = pos
	b.BackgroundColor3 = bgCol or T.C_DARK
	b.BackgroundTransparency = 0.15
	b.BorderSizePixel = 0
	b.Text = txt
	b.TextColor3 = txtCol or T.C_WHITE
	b.TextScaled = true
	b.Font = T.FONT
	b.ZIndex = (parent:IsA("GuiObject") and parent.ZIndex or 0) + 6
	b.AutoButtonColor = true
	T.corner(b, 10)
	T.stroke(b, 2, bgCol or T.C_DARK)
	return b
end

function T.popIn(obj)
	local TweenService = game:GetService("TweenService")
	obj.Size = UDim2.new(
		obj.Size.X.Scale,
		obj.Size.X.Offset * 0.7,
		obj.Size.Y.Scale,
		obj.Size.Y.Offset * 0.7
	)
	obj.Visible = true
	TweenService:Create(obj,
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(
				obj.Size.X.Scale / 0.7,
				obj.Size.X.Offset / 0.7,
				obj.Size.Y.Scale / 0.7,
				obj.Size.Y.Offset / 0.7
			)
		}
	):Play()
end

return T
