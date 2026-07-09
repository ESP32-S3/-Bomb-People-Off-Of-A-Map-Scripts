-- currencyapi: bridge for other systems to award coins through the existing shop coin
-- ledger, and to drive the lower-center coin/exp feed popup on the client,
-- call currencyapi.init(playerdata, sendupdatefn) once, from shopserver, at boot

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShopEvents = ReplicatedStorage:WaitForChild("ShopEvents")

local feedEvent = ShopEvents:FindFirstChild("CoinFeed")
if not feedEvent then
	feedEvent = Instance.new("RemoteEvent")
	feedEvent.Name = "CoinFeed"
	feedEvent.Parent = ShopEvents
end

local CurrencyAPI = {}

local playerDataRef = nil
local sendUpdateRef = nil

function CurrencyAPI.Init(playerData, sendUpdateFn)
	playerDataRef = playerData
	sendUpdateRef = sendUpdateFn
end

-- amount: coins to add
-- reason: "survive" | "hit" | "kill" (feed popup styling keys off this)
-- exp: exp amount to show in the popup, actual exp grant is a separate call
--      to levelsystem.addexp wherever this function gets called from, this
--      module only touches coins, it never grants exp itself
-- silent: true skips the feed popup entirely (used for the 5s survival tick)
function CurrencyAPI.AddCoins(player, amount, reason, exp, silent)
	if not playerDataRef then
		return
	end

	local data = playerDataRef[player.UserId]
	if not data or not amount or amount == 0 then
		return
	end

	data.coins += amount

	if sendUpdateRef then
		sendUpdateRef(player)
	end

	if amount > 0 and not silent then
		feedEvent:FireClient(player, {
			coins = amount,
			exp = exp or 0,
			reason = reason or "",
		})
	end
end

-- raw per-player data table (coins, inventory, ownedcrates, ...), same
-- table shopserver owns, lets other systems (e.g. gamepass grants) push
-- inventory items without shopserver needing to know about them
function CurrencyAPI.GetData(player)
	if not playerDataRef then
		return nil
	end
	return playerDataRef[player.UserId]
end

-- re-push this player's current data to their client (hud/shop ui)
function CurrencyAPI.RefreshClient(player)
	if sendUpdateRef then
		sendUpdateRef(player)
	end
end

function CurrencyAPI.GetCoins(player)
	if not playerDataRef then
		return nil
	end
	local data = playerDataRef[player.UserId]
	return data and data.coins
end

return CurrencyAPI
