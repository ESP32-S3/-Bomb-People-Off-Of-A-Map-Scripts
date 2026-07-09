-- permultipliers: reads the player attributes gamepassmanager sets (vip / doublexp / doublecoins)
-- and returns the multiplier to apply at any coin/exp reward call site,
-- vip (1.25x) stacks multiplicatively with the matching permanent double-pass

local PerkMultipliers = {}

local VIP_MULT = 1.25
local DOUBLE_MULT = 2

function PerkMultipliers.GetCoinMultiplier(player)
	if not player then return 1 end
	local mult = 1
	if player:GetAttribute("VIP") then
		mult *= VIP_MULT
	end
	if player:GetAttribute("DoubleCoins") then
		mult *= DOUBLE_MULT
	end
	return mult
end

function PerkMultipliers.GetXPMultiplier(player)
	if not player then return 1 end
	local mult = 1
	if player:GetAttribute("VIP") then
		mult *= VIP_MULT
	end
	if player:GetAttribute("DoubleXP") then
		mult *= DOUBLE_MULT
	end
	return mult
end

return PerkMultipliers
