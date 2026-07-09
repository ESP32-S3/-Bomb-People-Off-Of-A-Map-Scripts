-- levelformula: single source of truth for exp curve, change base / growth here only,
-- never hardcode per-level numbers anywhere else

local LevelFormula = {}

local BASE = 100
local GROWTH = 1.5

-- exp needed to go from `level` to `level + 1`
function LevelFormula.GetExpToNextLevel(level)
	return math.floor(BASE * (level ^ GROWTH))
end

return LevelFormula
