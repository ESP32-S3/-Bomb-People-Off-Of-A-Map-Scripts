-- expbarui: horizontal exp bar at the bottom of the screen,
-- fills left→right, blue theme, shows "current / needed", no level number

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local UITheme = require(script.Parent.UITheme)
local LevelFormula = require(ReplicatedStorage:WaitForChild("LevelFormula"))

-- ── colours ────────────────────────────────────────────────────────
local BAR_BG     = Color3.fromRGB(18, 18, 24)       -- matches uitheme.c_dark
local BAR_FILL   = Color3.fromRGB(40, 120, 255)     -- primary blue
local BAR_GLOW   = Color3.fromRGB(80, 160, 255)     -- lighter blue for stroke
local TEXT_COL   = UITheme.C_WHITE

-- ── build UI ────────────────────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "ExpBarGui"
gui.ResetOnSpawn = false
-- render below other roundui elements so it doesn't block clicks
gui.DisplayOrder = -1
gui.Parent = script.Parent -- startergui.roundui (copies to playergui)

-- outer container, sits near the bottom-centre of the screen
local container = UITheme.frame("Container", gui,
	UDim2.new(0.38, 0, 0, 36),          -- width ~38 % of screen, 36 px tall
	UDim2.new(0.5, 0, 0.88, 0),          -- anchored bottom-centre
	BAR_BG, 0.15, 2)
UITheme.corner(container, 18)
UITheme.stroke(container, 2, BAR_GLOW)

-- fill bar (clipped by container)
local fill = UITheme.frame("Fill", container,
	UDim2.new(0, 0, 1, 0),               -- starts at 0 width, full height
	UDim2.new(0, 0, 0, 0),
	BAR_FILL, 0, 3)
UITheme.corner(fill, 16)

-- subtle inner glow on the fill
local innerStroke = Instance.new("UIStroke")
innerStroke.Name = "InnerGlow"
innerStroke.Thickness = 1.5
innerStroke.Color = BAR_GLOW
innerStroke.Transparency = 0.5
innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
innerStroke.Parent = fill

-- text label  "currentexp / expneeded"
local label = UITheme.label("ExpLabel", container, "",
	UDim2.new(1, -12, 1, 0),             -- nearly full width, full height
	UDim2.new(0, 6, 0, 0),
	TEXT_COL)
label.ZIndex = 5
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center

-- ── update logic ───────────────────────────────────────────────────
local function updateBar()
	local level = player:GetAttribute("Level")
	local exp   = player:GetAttribute("Exp")
	if not level or not exp then return end

	local needed = LevelFormula.GetExpToNextLevel(level)
	local ratio  = math.clamp(exp / needed, 0, 1)

	-- tween the fill width for a smooth feel
	local targetWidth = UDim2.new(ratio, 0, 1, 0)
	TweenService:Create(fill,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = targetWidth }
	):Play()

	label.Text = string.format("%d / %d", exp, needed)
end

-- listen for attribute changes
player:GetAttributeChangedSignal("Exp"):Connect(updateBar)
player:GetAttributeChangedSignal("Level"):Connect(updateBar)

-- initial draw (small delay so attributes are loaded)
task.defer(updateBar)
