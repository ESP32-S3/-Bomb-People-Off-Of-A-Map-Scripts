-- gamepasssfxui: buttons to buy / configure the kill sfx and explosion sfx
-- gamepasses, update pass_id below once real gamepass ids exist (must match
-- the server's gamepasssfx module)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("GamepassRemotes")
local ownsGamepassFn = remotes:WaitForChild("OwnsGamepass")
local setSoundEvt = remotes:WaitForChild("SetCustomSoundId")
local playKillSoundEvt = remotes:WaitForChild("PlayKillSound")

local PASS_ID = {
	Kill = 1893184301,
	Explosion = 1891054366,
}

local LABELS = {
	Kill = "Kill SFX",
	Explosion = "Explosion SFX",
}

-- server tells us we got a kill: play our (custom or default) kill sound
-- locally, only the killer hears this
playKillSoundEvt.OnClientEvent:Connect(function(soundId)
	if not soundId or soundId == "" then return end
	local s = Instance.new("Sound")
	s.SoundId = soundId
	s.Volume = 1
	s.Parent = playerGui
	s:Play()
	Debris:AddItem(s, 6)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamepassSFXUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "ButtonContainer"
container.AnchorPoint = Vector2.new(1, 0)
container.Position = UDim2.new(1, -16, 0, 80)
container.Size = UDim2.new(0, 160, 0, 92)
container.BackgroundTransparency = 1
container.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = container

-- sound-id entry popup (shared by both buttons)
local popup = Instance.new("Frame")
popup.Name = "SoundIdPopup"
popup.AnchorPoint = Vector2.new(0.5, 0.5)
popup.Position = UDim2.new(0.5, 0, 0.5, 0)
popup.Size = UDim2.new(0, 280, 0, 150)
popup.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
popup.Visible = false
popup.ZIndex = 10
popup.Parent = screenGui

local popupCorner = Instance.new("UICorner")
popupCorner.CornerRadius = UDim.new(0, 10)
popupCorner.Parent = popup

local popupTitle = Instance.new("TextLabel")
popupTitle.Name = "Title"
popupTitle.Size = UDim2.new(1, -20, 0, 30)
popupTitle.Position = UDim2.new(0, 10, 0, 10)
popupTitle.BackgroundTransparency = 1
popupTitle.Font = Enum.Font.GothamBold
popupTitle.TextColor3 = Color3.new(1, 1, 1)
popupTitle.TextSize = 18
popupTitle.Text = "Enter Sound ID"
popupTitle.ZIndex = 11
popupTitle.Parent = popup

local input = Instance.new("TextBox")
input.Name = "SoundIdInput"
input.Size = UDim2.new(1, -20, 0, 36)
input.Position = UDim2.new(0, 10, 0, 50)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderText = "e.g. 9120386436"
input.Text = ""
input.ClearTextOnFocus = false
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.ZIndex = 11
input.Parent = popup

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = input

local submitBtn = Instance.new("TextButton")
submitBtn.Name = "SubmitButton"
submitBtn.Size = UDim2.new(0.48, -5, 0, 34)
submitBtn.Position = UDim2.new(0, 10, 1, -44)
submitBtn.BackgroundColor3 = Color3.fromRGB(70, 160, 90)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 16
submitBtn.Text = "Save"
submitBtn.ZIndex = 11
submitBtn.Parent = popup

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitBtn

local cancelBtn = Instance.new("TextButton")
cancelBtn.Name = "CancelButton"
cancelBtn.Size = UDim2.new(0.48, -5, 0, 34)
cancelBtn.Position = UDim2.new(0.52, 0, 1, -44)
cancelBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 96)
cancelBtn.TextColor3 = Color3.new(1, 1, 1)
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.TextSize = 16
cancelBtn.Text = "Cancel"
cancelBtn.ZIndex = 11
cancelBtn.Parent = popup

local cancelCorner = Instance.new("UICorner")
cancelCorner.CornerRadius = UDim.new(0, 6)
cancelCorner.Parent = cancelBtn

local activePassType = nil

local function closePopup()
	popup.Visible = false
	activePassType = nil
end

local function openPopup(passType)
	activePassType = passType
	popupTitle.Text = "Enter " .. LABELS[passType] .. " Sound ID"
	input.Text = ""
	popup.Visible = true
end

cancelBtn.MouseButton1Click:Connect(closePopup)

submitBtn.MouseButton1Click:Connect(function()
	if activePassType then
		setSoundEvt:FireServer(activePassType, input.Text)
	end
	closePopup()
end)

-- buttons─────────────────────
local function makeButton(passType)
	local btn = Instance.new("TextButton")
	btn.Name = passType .. "Button"
	btn.Size = UDim2.new(1, 0, 0, 42)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.Text = LABELS[passType]
	btn.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local function refresh()
		local ok, owns = pcall(function()
			return ownsGamepassFn:InvokeServer(passType)
		end)
		owns = ok and owns
		if owns then
			btn.Text = "Set " .. LABELS[passType]
			btn.BackgroundColor3 = Color3.fromRGB(60, 130, 80)
		else
			btn.Text = "Get " .. LABELS[passType]
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		end
		return owns
	end

	btn.MouseButton1Click:Connect(function()
		local owns = refresh()
		if owns then
			openPopup(passType)
		else
			MarketplaceService:PromptGamePassPurchase(player, PASS_ID[passType])
		end
	end)

	refresh()
end

makeButton("Kill")
makeButton("Explosion")

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, passId, purchased)
	if plr ~= player or not purchased then return end
	for passType, id in pairs(PASS_ID) do
		if id == passId then
			local btn = container:FindFirstChild(passType .. "Button")
			if btn then
				btn.Text = "Set " .. LABELS[passType]
				btn.BackgroundColor3 = Color3.fromRGB(60, 130, 80)
			end
		end
	end
end)
