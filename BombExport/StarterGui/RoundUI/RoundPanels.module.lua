local T = require(script.Parent.UITheme)
local RoundPanels = {}

function RoundPanels.init(gui, stateEvent, aliveEvent, winnerEvent)
	-- lobby banner
	local lobbyBanner = T.frame("LobbyBanner", gui,
		UDim2.new(0,360,0,64), UDim2.new(0.5,-180,0,16), T.C_YELLOW, 0.15, 5)
	T.addStudOverlay(lobbyBanner, 0.6)
	T.corner(lobbyBanner, 16)
	T.stroke(lobbyBanner, 2.5, T.C_CYAN)
	T.label("LobbyText", lobbyBanner, "Waiting for players...",
		UDim2.new(1,-16,1,0), UDim2.new(0,8,0,0), T.C_CYAN)

	-- intermission card
	local iCard = T.frame("IntermissionCard", gui,
		UDim2.new(0,420,0,140), UDim2.new(0.5,-210,0,80), T.C_DARK, 0.08, 5)
	T.addStudOverlay(iCard, 0.6)
	T.corner(iCard, 20)
	T.stroke(iCard, 3, T.C_YELLOW)
	iCard.Visible = false
	T.label("IHeader", iCard, "INTERMISSION",
		UDim2.new(1,-20,0.45,0), UDim2.new(0,10,0.04,0), T.C_YELLOW)
	local iCountRow = T.frame("CountRow", iCard,
		UDim2.new(1,-20,0.48,0), UDim2.new(0,10,0.5,0), T.C_DARK, 1, 6)
	T.addStudOverlay(iCountRow, 0.75)
	local iCountNum = T.label("CountNum", iCountRow, "15",
		UDim2.new(0.35,0,1,0), UDim2.new(0.08,0,0,0), T.C_WHITE)
	T.label("CountSub", iCountRow, "Get ready!",
		UDim2.new(0.6,0,0.75,0), UDim2.new(0.38,0,0.12,0), T.C_ORANGE)

	-- hud
	local hudRoot = T.frame("HUD", gui,
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), T.C_DARK, 1, 3)
	hudRoot.Visible = false
	local alivePill = T.frame("AlivePill", hudRoot,
		UDim2.new(0,220,0,54), UDim2.new(0.5,-110,0,16), T.C_DARK, 0.12, 6)
	T.addStudOverlay(alivePill, 0.65)
	T.corner(alivePill, 27)
	T.stroke(alivePill, 2.5, T.C_GREEN)
	T.label("SwordIcon", alivePill, "",
		UDim2.new(0.22,0,1,0), UDim2.new(0.04,0,0,0), T.C_GREEN)
	local aliveCountLabel = T.label("AliveCount", alivePill, "0 ALIVE",
		UDim2.new(0.72,0,1,0), UDim2.new(0.26,0,0,0), T.C_WHITE)

	-- win card
	local winCard = T.frame("WinCard", gui,
		UDim2.new(0,480,0,180), UDim2.new(0.5,-240,0.5,-90), T.C_DARK, 0.05, 10)
	T.addStudOverlay(winCard, 0.6)
	T.corner(winCard, 24)
	T.stroke(winCard, 3.5, T.C_PINK)
	winCard.Visible = false
	local winLabel = T.label("WinLabel", winCard, "WINNER!",
		UDim2.new(1,-20,0.5,0), UDim2.new(0,10,0.05,0), T.C_YELLOW)
	local winNameLabel = T.label("WinName", winCard, "PlayerName",
		UDim2.new(1,-20,0.32,0), UDim2.new(0,10,0.52,0), T.C_WHITE)
	T.label("WinSub", winCard, "Returning to lobby...",
		UDim2.new(1,-20,0.2,0), UDim2.new(0,10,0.8,0), T.C_ORANGE)

	local function hideAll()
		lobbyBanner.Visible = false
		iCard.Visible = false
		hudRoot.Visible = false
		winCard.Visible = false
	end

	stateEvent.OnClientEvent:Connect(function(state, data)
		if state == "Lobby" then
			hideAll()
			lobbyBanner.Visible = true
		elseif state == "Intermission" then
			hideAll()
			iCard.Visible = true
			iCountNum.Text = tostring(data.time or 15)
			iCountNum.TextColor3 = (data.time or 15) <= 5 and T.C_PINK or T.C_WHITE
		elseif state == "InGame" then
			hideAll()
			hudRoot.Visible = true
		end
	end)

	aliveEvent.OnClientEvent:Connect(function(n)
		aliveCountLabel.Text = n .. " ALIVE"
	end)

	winnerEvent.OnClientEvent:Connect(function(winner)
		winCard.Visible = true
		if winner == "Nobody" then
			winLabel.Text = "DRAW!"
			winLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			winNameLabel.Text = "Everyone died"
		else
			winLabel.Text = "WINNER!"
			winLabel.TextColor3 = T.C_YELLOW
			winNameLabel.Text = winner
		end
		T.popIn(winCard)
	end)
end

return RoundPanels
