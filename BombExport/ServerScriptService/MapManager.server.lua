local RS = game:GetService("ReplicatedStorage")

local currentMapFolder = workspace:WaitForChild("CurrentMap")
local mapChangedBE     = RS:WaitForChild("MapChanged")

local function setPartsVisible(folder, visible)
	for _, desc in ipairs(folder:GetDescendants()) do
		if desc:IsA("BasePart") and not desc:FindFirstAncestor("BombSpawns") then
			desc.Transparency = visible and 0 or 1
			desc.CanCollide   = visible
			desc.CastShadow   = visible
		end
	end
end

-- gamemanager keeps inactive maps parented under serverstorage (it reparents
-- the chosen one into currentmap on load and back into serverstorage on unload),
-- serverstorage never replicates and never simulates, so there's nothing left
-- to hide, we only need to make the newly active map visible
mapChangedBE.Event:Connect(function(activeMap)
	if activeMap then
		setPartsVisible(activeMap, true)
	end
end)
