-- levelsystemloader: boots levelsystem, keep this script tiny, real logic lives in module

local LevelSystem = require(game:GetService("ServerScriptService"):WaitForChild("LevelSystem"))
LevelSystem.Init()
