-- coinfeedui: lower-center popup feed for coin/exp gains on hit + kill,
-- survival ticks are silent server-side and never reach here

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ShopEvents = ReplicatedStorage:WaitForChild("ShopEvents")
local CoinFeed = ShopEvents:WaitForChild("CoinFeed")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinFeedGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 1)
container.Position = UDim2.new(0.5, 0, 0.82, 0)
container.Size = UDim2.new(0, 280, 0, 1)
container.BackgroundTransparency = 1
container.Parent = screenGui

local REASON_STYLE = {
	hit = {
		color = Color3.fromRGB(255, 214, 92),
		pitch = 1.15,
		scale = 1.0,
		label = "HIT",
	},
	kill = {
		color = Color3.fromRGB(255, 90, 90),
		pitch = 0.85,
		scale = 1.3,
		label = "KILL",
	},
}

local function playDing(pitch)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	sound.PlaybackSpeed = pitch
	sound.Volume = 0.85
	sound.Parent = container
	sound:Play()
	Debris:AddItem(sound, 2)
end

local function spawnPopup(coins, exp, reason)
	local style = REASON_STYLE[reason] or REASON_STYLE.hit

	local text = style.label .. "  +" .. tostring(coins) .. " coin"
	if coins ~= 1 then
		text = text .. "s"
	end
	if exp and exp > 0 then
		text = text .. "   +" .. tostring(exp) .. " xp"
	end

	local label = Instance.new("TextLabel")
	label.Name = "Popup"
	label.BackgroundTransparency = 1
	label.AnchorPoint = Vector2.new(0.5, 1)
	label.Position = UDim2.new(0.5, math.random(-22, 22), 1, 0)
	label.Size = UDim2.new(0, 240 * style.scale, 0, 34 * style.scale)
	label.Font = Enum.Font.GothamBlack
	label.TextScaled = true
	label.TextColor3 = style.color
	label.TextStrokeTransparency = 0.25
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.Text = text
	label.TextTransparency = 1
	label.Rotation = math.random(-4, 4)
	label.Parent = container

	playDing(style.pitch)

	local poppedPosition = label.Position - UDim2.new(0, 0, 0, 16)

	local tweenIn = TweenService:Create(
		label,
		TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ TextTransparency = 0, Position = poppedPosition }
	)
	tweenIn:Play()

	task.delay(0.6, function()
		local tweenOut = TweenService:Create(
			label,
			TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ TextTransparency = 1, Position = poppedPosition - UDim2.new(0, 0, 0, 26) }
		)
		tweenOut:Play()
		tweenOut.Completed:Connect(function()
			label:Destroy()
		end)
	end)
end

CoinFeed.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end
	spawnPopup(payload.coins or 0, payload.exp or 0, payload.reason)
end)
