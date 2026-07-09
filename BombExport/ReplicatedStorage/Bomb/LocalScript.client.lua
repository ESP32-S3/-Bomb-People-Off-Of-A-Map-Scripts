local Tool = script.Parent
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local RemoteEvent = RS:WaitForChild("BombRemoteEvent")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local debounce = false

local function forceEquip()
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if Tool.Parent ~= char then
		hum:EquipTool(Tool)
	end
end

Tool.AncestryChanged:Connect(function()
	task.defer(forceEquip)
end)

Tool.Unequipped:Connect(function()
	task.defer(forceEquip)
end)

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	forceEquip()
end)

task.spawn(function()
	while Tool.Parent do
		task.wait(0.1)
		forceEquip()
	end
end)

Tool.Activated:Connect(function()
	if debounce then return end
	debounce = true

	RemoteEvent:FireServer(camera.CFrame.LookVector)

	task.wait(0.2)
	debounce = false
end)

forceEquip()