-- Ceci est un exemple basique utilisant ESX.
-- C'est seulement une demo, à vous de modifier à votre convenance.
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getPlayerByName(playername)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer ~= nil and xPlayer.getName() == playername then
            return xPlayer
        end
    end
    return nil
end

AddEventHandler('onPlayerVote', function (playername, ip, date)
    local player = getPlayerByName(playername)
    if Player then
        Player.addInventoryItem('ticket', 8)
        
       	TriggerClientEvent("pNotify:SendNotification", -1, {
					text = ""..playername.. " a voté.</br>Il a gagné <b style='color:green'>8 tickets à gratter</b>",
					type = "info",
					timeout = 15000,
					layout = "centerRight"
	    })
    else
        print("Joueur introuvable !")

        -- Pour notifier (requiert pNotify) :
		TriggerClientEvent("pNotify:SendNotification", -1, {
					text = "Un inconnu a voté pour le serveur !",
					type = "info",
					timeout = 15000,
					layout = "centerRight"
	    })
    end
end)

