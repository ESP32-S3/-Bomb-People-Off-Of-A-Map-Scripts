local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CrateData = require(RS:WaitForChild("CrateData"))

local PlayerEquip = {}

-- [userId] = { crateName = string, name = string }
local equipped = {}

function PlayerEquip.setEquipped(player, crateName, name)
	equipped[player.UserId] = { crateName = crateName, name = name }
end

function PlayerEquip.clearEquipped(player)
	equipped[player.UserId] = nil
end

-- raw {cratename, name} or nil
function PlayerEquip.getEquippedRaw(player)
	return equipped[player.UserId]
end

-- full item definition (decalid, explosionfx, price, rarityname, etc.) or nil
function PlayerEquip.getEquippedItem(player)
	local e = equipped[player.UserId]
	if not e then return nil end

	local items = CrateData.Crates[e.crateName]
	if not items then return nil end

	for _, item in ipairs(items) do
		if item.name == e.name then
			return item
		end
	end

	return nil
end

Players.PlayerRemoving:Connect(function(player)
	equipped[player.UserId] = nil
end)

return PlayerEquip
