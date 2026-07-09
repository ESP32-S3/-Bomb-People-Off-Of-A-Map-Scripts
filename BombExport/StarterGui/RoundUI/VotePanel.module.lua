local T = require(script.Parent.UITheme)
local VotePanel = {}

function VotePanel.init(gui, voteStartEvent, mapVoteEvent, voteUpdateEvent)
	local card = T.frame("VoteCard", gui,
		UDim2.new(0,260,0,180), UDim2.new(0,20,0.5,-90), T.C_DARK, 0.08, 5)
	T.addStudOverlay(card, 0.6)
	T.corner(card, 16)
	T.stroke(card, 3, T.C_CYAN)
	card.Visible = false

	T.label("VHeader", card, "VOTE FOR MAP",
		UDim2.new(1,-16,0,26), UDim2.new(0,8,0,6), T.C_CYAN)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "OptionsScroll"
	scroll.Parent = card
	scroll.Size = UDim2.new(1,-16,1,-42)
	scroll.Position = UDim2.new(0,8,0,36)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 5
	scroll.ScrollBarImageColor3 = T.C_CYAN
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ZIndex = card.ZIndex + 1

	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = scroll
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0,6)

	local myVote = nil
	local buttons = {}

	local function clearButtons()
		for _, b in pairs(buttons) do b.frame:Destroy() end
		buttons = {}
		myVote = nil
	end

	local function refreshButtonLooks(tally)
		for name, b in pairs(buttons) do
			local count = (tally and tally[name]) or 0
			local selected = (myVote == name)
			b.nameLabel.Text = name
			b.countLabel.Text = tostring(count)
			b.frame.BackgroundColor3 = selected and T.C_GREEN or T.C_DARK
		end
	end

	local function buildOptions(options)
		clearButtons()
		buttons = {}
		for i, name in ipairs(options) do
			local row = T.frame("Opt_" .. name, scroll,
				UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), T.C_DARK, 0.1, 6)
			row.LayoutOrder = i
			T.corner(row, 8)
			T.stroke(row, 2, T.C_CYAN)
			local nameLabel = T.label("Name", row, name,
				UDim2.new(0.6,0,1,0), UDim2.new(0.04,0,0,0), T.C_WHITE)
			local countLabel = T.label("Count", row, "0",
				UDim2.new(0.32,0,1,0), UDim2.new(0.64,0,0,0), T.C_YELLOW)
			local click = Instance.new("TextButton")
			click.Name = "Click"
			click.Parent = row
			click.Size = UDim2.fromScale(1,1)
			click.BackgroundTransparency = 1
			click.Text = ""
			click.ZIndex = row.ZIndex + 10
			click.MouseButton1Click:Connect(function()
				if myVote == name then return end
				myVote = name
				mapVoteEvent:FireServer(name)
				refreshButtonLooks(nil)
			end)
			buttons[name] = { frame = row, nameLabel = nameLabel, countLabel = countLabel }
		end
	end

	voteStartEvent.OnClientEvent:Connect(function(options, duration)
		buildOptions(options)
		card.Visible = true
		T.popIn(card)
	end)

	voteUpdateEvent.OnClientEvent:Connect(function(tally)
		refreshButtonLooks(tally)
	end)

	function VotePanel.hide()
		card.Visible = false
	end
end

return VotePanel
