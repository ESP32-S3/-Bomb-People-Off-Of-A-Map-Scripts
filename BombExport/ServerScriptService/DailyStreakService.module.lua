-- dailystreakservice: tracks consecutive logins based on elapsed real time since last counted
-- join (no calendar day, no timezone) and shows a fire + number billboard
-- above the player's head, saves like level/shop systems

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local streakStore = DataStoreService:GetDataStore("PlayerStreakData_v1")

-- not tied to any calendar day or timezone, purely "how long since their
-- last counted join", measured in plain elapsed hours
local RESET_AFTER_HOURS = 36 -- gap this long (or longer) breaks the streak back to 1
local MIN_HOURS_BETWEEN_INCREMENTS = 12 -- guard so rapid rejoining can't farm extra counts

local DailyStreakService = {}
local playerData = {} -- [player] = {streak = n, lastJoin = unix timestamp}

local function createBillboard(character)
	local head = character:WaitForChild("Head")

	local existing = head:FindFirstChild("StreakBillboard")
	if existing then
		existing:Destroy()
	end

	-- sits above the levelsystem billboard (that one's at studsoffset 2.6)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "StreakBillboard"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 64, 0, 28)
	billboard.StudsOffset = Vector3.new(0, 3.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0, 1)
	layout.Parent = billboard

	-- cartoony flame, drawn from a couple of overlapping rounded frames
	-- (no external image asset needed, renders consistently everywhere)
	local fireFrame = Instance.new("Frame")
	fireFrame.Name = "FireIcon"
	fireFrame.BackgroundTransparency = 1
	fireFrame.Size = UDim2.new(0, 24, 0, 28)
	fireFrame.LayoutOrder = 1
	fireFrame.Parent = billboard

	local outerFlame = Instance.new("Frame")
	outerFlame.Name = "Outer"
	outerFlame.AnchorPoint = Vector2.new(0.5, 1)
	outerFlame.Position = UDim2.new(0.5, 0, 1, 0)
	outerFlame.Size = UDim2.new(0, 22, 0, 26)
	outerFlame.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
	outerFlame.BorderSizePixel = 0
	outerFlame.Rotation = 0
	outerFlame.Parent = fireFrame

	local outerCorner = Instance.new("UICorner")
	outerCorner.CornerRadius = UDim.new(0.5, 0)
	outerCorner.Parent = outerFlame

	local outerGradient = Instance.new("UIGradient")
	outerGradient.Rotation = 90
	outerGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 60)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 60, 10)),
	})
	outerGradient.Parent = outerFlame

	local tip = Instance.new("Frame")
	tip.Name = "Tip"
	tip.AnchorPoint = Vector2.new(0.5, 1)
	tip.Position = UDim2.new(0.5, 0, 0.42, 0)
	tip.Size = UDim2.new(0, 10, 0, 12)
	tip.Rotation = 45
	tip.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
	tip.BorderSizePixel = 0
	tip.Parent = outerFlame

	local tipCorner = Instance.new("UICorner")
	tipCorner.CornerRadius = UDim.new(0.6, 0)
	tipCorner.Parent = tip

	local innerFlame = Instance.new("Frame")
	innerFlame.Name = "Inner"
	innerFlame.AnchorPoint = Vector2.new(0.5, 1)
	innerFlame.Position = UDim2.new(0.5, 0, 1, 0)
	innerFlame.Size = UDim2.new(0, 11, 0, 14)
	innerFlame.BackgroundColor3 = Color3.fromRGB(255, 235, 130)
	innerFlame.BorderSizePixel = 0
	innerFlame.Parent = outerFlame

	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(0.5, 0)
	innerCorner.Parent = innerFlame

	local numberLabel = Instance.new("TextLabel")
	numberLabel.Name = "StreakLabel"
	numberLabel.BackgroundTransparency = 1
	numberLabel.Size = UDim2.new(0, 32, 0, 28)
	numberLabel.Font = Enum.Font.FredokaOne
	numberLabel.TextScaled = true
	numberLabel.TextColor3 = Color3.fromRGB(255, 150, 40)
	numberLabel.TextStrokeTransparency = 0.1
	numberLabel.TextStrokeColor3 = Color3.fromRGB(110, 30, 0)
	numberLabel.Text = "1"
	numberLabel.LayoutOrder = 2
	numberLabel.Parent = billboard

end

local function updateBillboardText(player)
	local character = player.Character
	if not character then return end

	local head = character:FindFirstChild("Head")
	if not head then return end

	local billboard = head:FindFirstChild("StreakBillboard")
	if not billboard then return end

	local label = billboard:FindFirstChild("StreakLabel")
	if not label then return end

	local data = playerData[player]
	label.Text = tostring(data and data.streak or 1)
end

local function onCharacterAdded(player, character)
	createBillboard(character)
	updateBillboardText(player)
end

local function loadData(player)
	local saved

	local ok, err = pcall(function()
		saved = streakStore:GetAsync("Player_" .. player.UserId)
	end)

	if not ok then
		warn("[DailyStreakService] load fail for " .. player.Name .. ": " .. tostring(err))
	end

	local now = os.time()
	local data = saved or { streak = 0, lastJoin = nil }

	if data.lastJoin == nil then
		-- first time ever joining
		data.streak = 1
	else
		local elapsedHours = (now - data.lastJoin) / 3600

		if elapsedHours >= RESET_AFTER_HOURS then
			-- streak broke since the last join, this join restarts it
			data.streak = 1
		elseif elapsedHours >= MIN_HOURS_BETWEEN_INCREMENTS then
			data.streak += 1
		end
		-- else: rejoined too soon after the last counted join, leave streak as-is
	end

	data.lastJoin = now
	playerData[player] = data

	player:SetAttribute("DailyStreak", data.streak)
end

local function saveData(player)
	local data = playerData[player]
	if not data then return end

	local ok, err = pcall(function()
		streakStore:SetAsync("Player_" .. player.UserId, data)
	end)

	if not ok then
		warn("[DailyStreakService] save fail for " .. player.Name .. ": " .. tostring(err))
	end
end

function DailyStreakService.GetStreak(player)
	local data = playerData[player]
	return data and data.streak
end

function DailyStreakService.Init()
	Players.PlayerAdded:Connect(function(player)
		loadData(player)

		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)

		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		saveData(player)
		playerData[player] = nil
	end)

	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do
			saveData(player)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		loadData(player)
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end
end

return DailyStreakService
