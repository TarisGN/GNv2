ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingviande     = {}
local PlayersTransformingviande   = {}
local PlayersSellingviande        = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(5000, CountCops)

end

CountCops()

--viande
local function Harvestviande(source)

	if CopsConnected < Config.RequiredCopsviande then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsviande)
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingviande[source] == true then

			local _source = source
			local xPlayer  = ESX.GetPlayerFromId(_source)

			local viande = xPlayer.getInventoryItem('viande')

			if viande.limit ~= -1 and viande.count >= viande.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_viande'))
			else
				xPlayer.addInventoryItem('viande', 1)
				Harvestviande(source)
			end

		end
	end)
end

RegisterServerEvent('esx_viande:startHarvestviande')
AddEventHandler('esx_viande:startHarvestviande', function()

	local _source = source

	PlayersHarvestingviande[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	Harvestviande(_source)

end)

RegisterServerEvent('esx_viande:stopHarvestviande')
AddEventHandler('esx_viande:stopHarvestviande', function()

	local _source = source

	PlayersHarvestingviande[_source] = false

end)

local function Transformviande(source)

	if CopsConnected < Config.RequiredCopsviande then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsviande)
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingviande[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local viandeQuantity = xPlayer.getInventoryItem('viande').count
			local meatQuantity = xPlayer.getInventoryItem('viande_meat').count

			if meatQuantity > 50 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_meat'))
			elseif viandeQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_viande'))
			else
				xPlayer.removeInventoryItem('viande', 5)
				xPlayer.addInventoryItem('viande_meat', 1)
			
				Transformviande(source)
			end

		end
	end)
end

RegisterServerEvent('esx_viande:startTransformviande')
AddEventHandler('esx_viande:startTransformviande', function()

	local _source = source

	PlayersTransformingviande[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	Transformviande(_source)

end)

RegisterServerEvent('esx_viande:stopTransformviande')
AddEventHandler('esx_viande:stopTransformviande', function()

	local _source = source

	PlayersTransformingviande[_source] = false

end)

local function Sellviande(source)

	if CopsConnected < Config.RequiredCopsviande then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsviande)
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingviande[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local meatQuantity = xPlayer.getInventoryItem('viande_meat').count

			if meatQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_meat_sale'))
			else
				xPlayer.removeInventoryItem('viande_meat', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 35)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 45)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 60)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 75)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 90)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 105)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_viande'))
                end
				
				Sellviande(source)
			end

		end
	end)
end

RegisterServerEvent('esx_viande:startSellviande')
AddEventHandler('esx_viande:startSellviande', function()

	local _source = source

	PlayersSellingviande[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	Sellviande(_source)

end)

RegisterServerEvent('esx_viande:stopSellviande')
AddEventHandler('esx_viande:stopSellviande', function()

	local _source = source

	PlayersSellingviande[_source] = false

end)


-- RETURN INVENTORY TO CLIENT
RegisterServerEvent('esx_viande:GetUserInventory')
AddEventHandler('esx_viande:GetUserInventory', function(currentZone)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_viande:ReturnInventory', 
    	_source,
		xPlayer.getInventoryItem('viande').count, 
		xPlayer.getInventoryItem('viande_meat').count,
		xPlayer.job.name, 
		currentZone
    )
end)
