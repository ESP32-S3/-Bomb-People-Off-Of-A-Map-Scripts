-- gamepasspads: builds 3 standee pads (vip / 2x exp / 2x coins) in the lobby,
-- each shows a billboard with the pass icon + price, stepping on one
-- fires the real roblox purchase prompt for that pass

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local GamepassConfig = require(ReplicatedStorage:WaitForChild("GamepassConfig"))

local PAD_GAP = 10
local debounceByPlayer = {}

local function findLobbyAnchor()
	local lobby = Workspace:FindFirstChild("Floating Lobby")
	if lobby then
		local spawn = lobby:FindFirstChild("SpawnLocation")
		if spawn then
			return spawn.Position + Vector3.new(0, 2, 14)
		end
	end
	return Vector3.new(0, 5, 0)
end

local function buildPad(key, data, index, anchorPos)
	-- if a pad already exists in the workspace (placed by the developer
	-- in studio), use it as-is and just attach the billboard + touch
	-- logic, only create a fresh pad when none is present
	local pad = Workspace:FindFirstChild(key .. "Pad")
	if pad and pad:IsA("BasePart") then
		pad.Anchored = true
		pad.CanCollide = true
	else
		pad = Instance.new("Part")
		pad.Name = key .. "Pad"
		pad.Shape = Enum.PartType.Cylinder
		pad.Size = Vector3.new(1, 6, 6)
		pad.Orientation = Vector3.new(0, 0, 90)
		pad.Position = anchorPos + Vector3.new((index - 1) * PAD_GAP, 0, 0)
		pad.Anchored = true
		pad.CanCollide = true
		pad.Color = data.Color
		pad.Material = Enum.Material.Neon
		pad.Parent = Workspace
	end

	-- attach billboard if not already present
	local billboard = pad:FindFirstChild("GamepassBillboard")
	if not billboard then
		billboard = Instance.new("BillboardGui")
		billboard.Name = "GamepassBillboard"
		billboard.Size = UDim2.new(4, 0, 5, 0)
		billboard.StudsOffset = Vector3.new(0, 4, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = pad

		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.new(1, 0, 0.7, 0)
		icon.BackgroundTransparency = 1
		icon.Image = string.format("rbxthumb://type=GamePass&id=%d&w=150&h=150", data.Id)
		icon.Parent = billboard

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, 0, 0.3, 0)
		label.Position = UDim2.new(0, 0, 0.7, 0)
		label.BackgroundTransparency = 1
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0
		label.Text = string.format("%s - %d R$", data.Name, data.Price)
		label.Parent = billboard
	end

	-- attach touch handler (use an attribute so we don't double-connect
	-- if buildpad runs more than once for the same pad)
	if not pad:GetAttribute("GamepassTouchConnected") then
		pad:SetAttribute("GamepassTouchConnected", true)
		pad:SetAttribute("GamepassId", data.Id)

		pad.Touched:Connect(function(hit)
			local character = hit.Parent
			local player = character and Players:GetPlayerFromCharacter(character)
			if not player then return end
			if debounceByPlayer[player] then return end
			debounceByPlayer[player] = true
			local passId = pad:GetAttribute("GamepassId")
			if passId then
				MarketplaceService:PromptGamePassPurchase(player, passId)
			end
			task.delay(2, function()
				debounceByPlayer[player] = nil
			end)
		end)
	end
end

local anchor = findLobbyAnchor()
local index = 1
for key, data in pairs(GamepassConfig.Passes) do
	buildPad(key, data, index, anchor)
	index += 1
end
