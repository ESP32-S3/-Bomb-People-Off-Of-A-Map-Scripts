local TweenService = game:GetService("TweenService")
local T = require(script.Parent.UITheme)

local CrateAnimation = {}

local crateOverlay, spinCard, spinBorder
local spinCrateLabel, spinDivider, spinNameLabel
local spinRarityLabel, spinValueLabel, spinContinueBtn
local tickSound
local isSpinning = false
local onDoneCallbacks = {}

function CrateAnimation.init(gui)
	crateOverlay = T.frame("CrateOverlay", gui,
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), T.C_DARK, 0.5, 40)
	crateOverlay.Visible = false

	spinCard = T.frame("SpinCard", crateOverlay,
		UDim2.new(0,400,0,300), UDim2.new(0.5,-200,0.5,-150), T.C_DARK, 0, 41)
	T.addStudOverlay(spinCard, 0.65)
	T.corner(spinCard, 24)

	spinBorder = Instance.new("UIStroke")
	spinBorder.Name = "SpinBorder"
	spinBorder.Parent = spinCard
	spinBorder.Thickness = 4
	spinBorder.Color = T.C_WHITE
	spinBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

	spinCrateLabel = T.label("SpinCrate", spinCard, "",
		UDim2.new(1,-20,0,40), UDim2.new(0,10,0,12), T.C_ORANGE)
	spinDivider = T.frame("SpinDivider", spinCard,
		UDim2.new(0.8,0,0,2), UDim2.new(0.1,0,0,58), T.C_CYAN, 0.5, 42)
	spinNameLabel = T.label("SpinName", spinCard, "???",
		UDim2.new(1,-20,0,60), UDim2.new(0,10,0,68), T.C_WHITE)
	spinRarityLabel = T.label("SpinRarity", spinCard, "",
		UDim2.new(1,-20,0,36), UDim2.new(0,10,0,138), T.C_WHITE)
	spinValueLabel = T.label("SpinValue", spinCard, "",
		UDim2.new(1,-20,0,30), UDim2.new(0,10,0,180), T.C_ORANGE)

	tickSound = Instance.new("Sound")
	tickSound.Name = "CrateTickSFX"
	tickSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	tickSound.PlaybackSpeed = 2.5
	tickSound.Volume = 0.6
	tickSound.Parent = spinCard

	spinContinueBtn = T.btn("SpinContinue", spinCard, "CONTINUE",
		UDim2.new(0.6,0,0,44), UDim2.new(0.2,0,0,240), T.C_DARK, T.C_CYAN)
	T.corner(spinContinueBtn, 22)
	T.stroke(spinContinueBtn, 2.5, T.C_CYAN)
	spinContinueBtn.Visible = false

	spinContinueBtn.MouseButton1Click:Connect(function()
		crateOverlay.Visible = false
		for _, cb in ipairs(onDoneCallbacks) do cb() end
	end)
end

function CrateAnimation.onDone(cb)
	table.insert(onDoneCallbacks, cb)
end

function CrateAnimation.isActive()
	return isSpinning
end

function CrateAnimation.play(crateName, result, CrateData)
	isSpinning = true
	crateOverlay.Visible = true
	spinContinueBtn.Visible = false

	local crateColor = CrateData.CrateColors and CrateData.CrateColors[crateName] or T.C_CYAN
	spinCrateLabel.Text = crateName:upper()
	spinCrateLabel.TextColor3 = crateColor
	spinBorder.Color = crateColor
	spinDivider.BackgroundColor3 = crateColor

	local items = CrateData.Crates[crateName] or {}
	local interval = 0.04
	local elapsed = 0
	local totalDuration = 2.8
	local currentIndex = math.random(1, math.max(1, #items))

	while elapsed < totalDuration do
		if #items > 0 then
			local item = items[currentIndex]
			spinNameLabel.Text = item.name
			spinRarityLabel.Text = item.rarityName:upper()
			spinRarityLabel.TextColor3 = T.RARITY_COLORS[item.rarityName] or T.C_WHITE
			spinValueLabel.Text = ""
			currentIndex = currentIndex % #items + 1
		end
		tickSound:Play()
		local progress = elapsed / totalDuration
		interval = 0.04 + progress ^ 3 * 0.55
		task.wait(interval)
		elapsed = elapsed + interval
	end

	spinNameLabel.Text = result.name
	spinRarityLabel.Text = result.rarityName:upper()
	spinRarityLabel.TextColor3 = T.RARITY_COLORS[result.rarityName] or T.C_WHITE
	spinValueLabel.Text = "Value: " .. result.price

	local rarityColor = T.RARITY_COLORS[result.rarityName] or T.C_WHITE
	for _ = 1, 5 do
		spinBorder.Color = rarityColor
		task.wait(0.12)
		spinBorder.Color = T.C_DARK
		task.wait(0.12)
	end
	spinBorder.Color = rarityColor

	spinCard.Size = UDim2.new(0, 400 * 0.85, 0, 300 * 0.85)
	TweenService:Create(spinCard,
		TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 400, 0, 300)}
	):Play()

	spinContinueBtn.Visible = true
	isSpinning = false
end

return CrateAnimation
