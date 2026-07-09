-- dailystreakloader: boots dailystreakservice, keep tiny, logic lives in module

local DailyStreakService = require(game:GetService("ServerScriptService"):WaitForChild("DailyStreakService"))
DailyStreakService.Init()
