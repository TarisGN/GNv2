ESX = nil
local playersProcessingCannabis = {}
local playersProcessingPochonCoke = {}
local playersProcessingPochonBatterie = {}
local playersProcessingPochonHuiles = {}
local playersProcessingPochonCaissemed = {}
local playersProcessingPochonCanettes = {}
local societyAccount  = nil

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

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

ESX.RegisterServerCallback('esx_drugs:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license == nil then
		print(('esx_drugs: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, licenseName, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem, xItem2 = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('seed_weed')
	

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end 
		
	if xItem2.limit ~= -1 and (xItem2.count + 1) > xItem2.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem2.name, 1)
	end
end)

ESX.RegisterServerCallback('esx_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
				
				if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xMarijuana, xClope = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana'), xPlayer.getInventoryItem('malbora')

			if xMarijuana.limit ~= -1 and (xMarijuana.count + 1) >= xMarijuana.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
			elseif xCannabis.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			elseif xClope.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			else
				xPlayer.removeInventoryItem('cannabis', 2)
				xPlayer.removeInventoryItem('malbora', 1)
				xPlayer.addInventoryItem('marijuana', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
			end

			playersProcessingCannabis[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end

	if playersProcessingPochonCoke[playerID] then
		ESX.ClearTimeout(playersProcessingPochonCoke[playerID])
		playersProcessingPochonCoke[playerID] = nil
	end

	if playersProcessingPochonCaissemed[playerID] then
		ESX.ClearTimeout(playersProcessingPochonCaissemed[playerID])
		playersProcessingPochonCaissemed[playerID] = nil
	end
	
end

-- function CancelProcessing(playerID)

-- 	if playersProcessingPochonCoke[playerID] then
-- 		ESX.ClearTimeout(playersProcessingPochonCoke[playerID])
-- 		playersProcessingPochonCoke[playerID] = nil
-- 	end

-- end

--vendeur2

RegisterServerEvent('esx_drugs:sellDrug2')
AddEventHandler('esx_drugs:sellDrug2', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems2[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if CopsConnected < Config.RequiredCops2 then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops2)
		return
	end

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold2', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)



--COKE
RegisterServerEvent('esx_drugs:pickedUpPochonCoke')
AddEventHandler('esx_drugs:pickedUpPochonCoke', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('pochoncoke')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('coke_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonCoke')
AddEventHandler('esx_drugs:processPochonCoke', function()
	
	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsCoke)
		return
	end

	if not playersProcessingPochonCoke[source] then
		local _source = source

		playersProcessingPochonCoke[_source] = ESX.SetTimeout(Config.Delays.CokeProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPochonCoke, xCokeDose, xMedoc = xPlayer.getInventoryItem('pochoncoke'), xPlayer.getInventoryItem('dosecoke'), xPlayer.getInventoryItem('medicament')

			if xCokeDose.limit ~= -1 and (xCokeDose.count + 1) >= xCokeDose.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingfull'))
			elseif xPochonCoke.count < 3 then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough'))
			elseif xMedoc.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough'))
			else
				xPlayer.removeInventoryItem('pochoncoke', 3)
				xPlayer.removeInventoryItem('medicament', 2)
				xPlayer.addInventoryItem('dosecoke', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('coke_processed'))
			end

			playersProcessingPochonCoke[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit coke processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)



-- function CancelProcessing(playerID)

-- 	if playersProcessingPochonCaisse[playerID] then
-- 		ESX.ClearTimeout(playersProcessingPochonCaisse[playerID])
-- 		playersProcessingPochonCaisse[playerID] = nil
-- 	end

-- end

--CAISSE
RegisterServerEvent('esx_drugs:pickedUpPochonCaisse')
AddEventHandler('esx_drugs:pickedUpPochonCaisse', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('caisse')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('caisse_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

-- RegisterServerEvent('esx_drugs:processPochonCaisse')
-- AddEventHandler('esx_drugs:processPochonCaisse', function()
-- 	if not playersProcessingPochonCaisse[source] then
-- 		local _source = source

-- 		playersProcessingPochonCaisse[_source] = ESX.SetTimeout(Config.Delays.CaisseProcessing, function()
-- 			local xPlayer = ESX.GetPlayerFromId(_source)
-- 			local xPochonCaisse, xCaisseDose = xPlayer.getInventoryItem('pochoncaisse'), xPlayer.getInventoryItem('caissedose')

-- 			if xCaisseDose.limit ~= -1 and (xCaisseDose.count + 1) >= xCaisseDose.limit then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processingfull'))
-- 			elseif xPochonCaisse.count < 4 then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processingenough'))
-- 			else
-- 				xPlayer.removeInventoryItem('pochoncaisse', 4)
-- 				xPlayer.addInventoryItem('dosecaisse', 1)

-- 				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processed'))
-- 			end

-- 			playersProcessingPochonCaisse[_source] = nil
-- 		end)
-- 	else
-- 		print(('esx_drugs: %s attempted to exploit caisse processing!'):format(GetPlayerIdentifiers(source)[1]))
-- 	end
-- end)



--Tabac Blond
RegisterServerEvent('esx_drugs:pickedUpTabacblond')
AddEventHandler('esx_drugs:pickedUpTabacblond', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('tabacblond')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 4)
	end
end)

-- RegisterServerEvent('esx_drugs:processTabacblond')
-- AddEventHandler('esx_drugs:processTabacblond', function()
-- 	if not playersProcessingTabacblond[source] then
-- 		local _source = source

-- 		playersProcessingTabacblond[_source] = ESX.SetTimeout(Config.Delays.TabacblondProcessing, function()
-- 			local xPlayer = ESX.GetPlayerFromId(_source)
-- 			local xTabacblond, xTabacblondDose = xPlayer.getInventoryItem('tabacblond'), xPlayer.getInventoryItem('tabacblonddose')

-- 			if xTabacblondDose.limit ~= -1 and (xTabacblondDose.count + 1) >= xTabacblondDose.limit then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processingfull'))
-- 			elseif xTabacblond.count < 4 then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processingenough'))
-- 			else
-- 				xPlayer.removeInventoryItem('tabacblond', 4)
-- 				xPlayer.addInventoryItem('dosetabacblond', 1)

-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processed'))
-- 			end

-- 			playersProcessingTabacblond[_source] = nil
-- 		end)
-- 	else
-- 		print(('esx_drugs: %s attempted to exploit tabacblond processing!'):format(GetPlayerIdentifiers(source)[1]))
-- 	end
-- end)

-- -- Tabac brun

-- function CancelProcessing(playerID)

-- 	if playersProcessingTabacbrun[playerID] then
-- 		ESX.ClearTimeout(playersProcessingTabacbrun[playerID])
-- 		playersProcessingTabacbrun[playerID] = nil
-- 	end

-- end

--Tabac Blond
RegisterServerEvent('esx_drugs:pickedUpTabacbrun')
AddEventHandler('esx_drugs:pickedUpTabacbrun', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('tabacbrun')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('tabacbrun_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 3)
	end
end)

-- RegisterServerEvent('esx_drugs:processTabacbrun')
-- AddEventHandler('esx_drugs:processTabacbrun', function()
-- 	if not playersProcessingTabacbrun[source] then
-- 		local _source = source

-- 		playersProcessingTabacbrun[_source] = ESX.SetTimeout(Config.Delays.TabacbrunProcessing, function()
-- 			local xPlayer = ESX.GetPlayerFromId(_source)
-- 			local xTabacbrun, xTabacbrunDose = xPlayer.getInventoryItem('tabacbrun'), xPlayer.getInventoryItem('tabacbrundose')

-- 			if xTabacbrunDose.limit ~= -1 and (xTabacbrunDose.count + 1) >= xTabacbrunDose.limit then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacbrun_processingfull'))
-- 			elseif xTabacbrun.count < 4 then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacbrun_processingenough'))
-- 			else
-- 				xPlayer.removeInventoryItem('tabacbrun', 4)
-- 				xPlayer.addInventoryItem('dosetabacbrun', 1)

-- 				TriggerClientEvent('esx:showNotification', _source, _U('tabacbrun_processed'))
-- 			end

-- 			playersProcessingTabacbrun[_source] = nil
-- 		end)
-- 	else
-- 		print(('esx_drugs: %s attempted to exploit tabacbrun processing!'):format(GetPlayerIdentifiers(source)[1]))
-- 	end
-- end)


-- function CancelProcessing(playerID)

-- 	if playersProcessingPatate[playerID] then
-- 		ESX.ClearTimeout(playersProcessingPatate[playerID])
-- 		playersProcessingPatate[playerID] = nil
-- 	end

-- end

--Patates

RegisterServerEvent('esx_drugs:pickedUpPatate')
AddEventHandler('esx_drugs:pickedUpPatate', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('patate')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('patate_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 4)
	end
end)

-- RegisterServerEvent('esx_drugs:processPatate')
-- AddEventHandler('esx_drugs:processPatate', function()
-- 	if not playersProcessingPatate[source] then
-- 		local _source = source

-- 		playersProcessingPatate[_source] = ESX.SetTimeout(Config.Delays.PatateProcessing, function()
-- 			local xPlayer = ESX.GetPlayerFromId(_source)
-- 			local xPatate, xPatateDose = xPlayer.getInventoryItem('patate'), xPlayer.getInventoryItem('patatedose')

-- 			if xPatateDose.limit ~= -1 and (xPatateDose.count + 1) >= xPatateDose.limit then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('patate_processingfull'))
-- 			elseif xPatate.count < 4 then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('patate_processingenough'))
-- 			else
-- 				xPlayer.removeInventoryItem('patate', 4)
-- 				xPlayer.addInventoryItem('dosepatate', 1)

-- 				TriggerClientEvent('esx:showNotification', _source, _U('patate_processed'))
-- 			end

-- 			playersProcessingPatate[_source] = nil
-- 		end)
-- 	else
-- 		print(('esx_drugs: %s attempted to exploit patate processing!'):format(GetPlayerIdentifiers(source)[1]))
-- 	end
-- end)


--CAISSE MED
RegisterServerEvent('esx_drugs:pickedUpPochonCaissemed')
AddEventHandler('esx_drugs:pickedUpPochonCaissemed', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('caissemed')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('caissemed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonCaissemed')
AddEventHandler('esx_drugs:processPochonCaissemed', function()
	if not playersProcessingPochonCaissemed[source] then
		local _source = source

		playersProcessingPochonCaissemed[_source] = ESX.SetTimeout(Config.Delays.CaissemedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPochonCaissemed, xCaisseDosemed = xPlayer.getInventoryItem('caissemed'), xPlayer.getInventoryItem('medicament')

			if xCaisseDosemed.limit ~= -1 and (xCaisseDosemed.count + 1) >= xCaisseDosemed.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('caissemed_processingfull'))
			elseif xPochonCaissemed.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('caissemed_processingenough'))
			else
				xPlayer.removeInventoryItem('caissemed', 1)
				xPlayer.addInventoryItem('medicament', 3)

				TriggerClientEvent('esx:showNotification', _source, _U('caissemed_processed'))
			end

			playersProcessingPochonCaissemed[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit caisse med processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)



--vendeur3



RegisterServerEvent('esx_drugs:sellDrug3')
AddEventHandler('esx_drugs:sellDrug3', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems3[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)
	
	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		
		local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
              societyAccount = account
            end)
            if societyAccount ~= nil then
              societyAccount.addMoney(price)
			end
		else
		
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold3', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)



--Raisins
RegisterServerEvent('esx_drugs:pickedUpRaisin')
AddEventHandler('esx_drugs:pickedUpRaisin', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('raisin')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('raisin_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 4)
	end
end)

-- RegisterServerEvent('esx_drugs:processRaisin')
-- AddEventHandler('esx_drugs:processRaisin', function()
-- 	if not playersProcessingRaisin[source] then
-- 		local _source = source

-- 		playersProcessingRaisin[_source] = ESX.SetTimeout(Config.Delays.RaisinProcessing, function()
-- 			local xPlayer = ESX.GetPlayerFromId(_source)
-- 			local xRaisin, xRaisinDose = xPlayer.getInventoryItem('raisin'), xPlayer.getInventoryItem('raisindose')

-- 			if xRaisinDose.limit ~= -1 and (xRaisinDose.count + 1) >= xRaisinDose.limit then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processingfull'))
-- 			elseif xRaisin.count < 4 then
-- 				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processingenough'))
-- 			else
-- 				xPlayer.removeInventoryItem('raisin', 4)
-- 				xPlayer.addInventoryItem('doseraisin', 1)

-- 				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processed'))
-- 			end

-- 			playersProcessingRaisin[_source] = nil
-- 		end)
-- 	else
-- 		print(('esx_drugs: %s attempted to exploit raisin processing!'):format(GetPlayerIdentifiers(source)[1]))
-- 	end
-- end)

-- BATTERIES
function CancelProcessing(playerID)

	if playersProcessingPochonBatterie[playerID] then
		ESX.ClearTimeout(playersProcessingPochonBatterie[playerID])
		playersProcessingPochonBatterie[playerID] = nil
	end

end

RegisterServerEvent('esx_drugs:pickedUpPochonBatterie')
AddEventHandler('esx_drugs:pickedUpPochonBatterie', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('batterie')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('batterie_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonBatterie')
AddEventHandler('esx_drugs:processPochonBatterie', function()
	if not playersProcessingPochonBatterie[source] then
		local _source = source

		playersProcessingPochonBatterie[_source] = ESX.SetTimeout(Config.Delays.BatterieProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xBatterie, xBatterieRech = xPlayer.getInventoryItem('batterie'), xPlayer.getInventoryItem('batterie_rech')

			if xBatterieRech.limit ~= -2 and (xBatterieRech.count + 2) >= xBatterieRech.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('batterie_processingfull'))
			elseif xBatterie.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('batterie_processingenough'))
			else
				xPlayer.removeInventoryItem('batterie', 2)
				xPlayer.addInventoryItem('batterie_rech', 2)

				TriggerClientEvent('esx:showNotification', _source, _U('batterie_processed'))
			end

			playersProcessingPochonBatterie[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit batterie med processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)


function CancelProcessing(playerID)

	if playersProcessingPochonHuiles[playerID] then
		ESX.ClearTimeout(playersProcessingPochonHuiles[playerID])
		playersProcessingPochonHuiles[playerID] = nil
	end

end

function CancelProcessing(playerID)

	if playersProcessingPochonCanettes[playerID] then
		ESX.ClearTimeout(playersProcessingPochonCanettes[playerID])
		playersProcessingPochonCanettes[playerID] = nil
	end

end

--Canettes
RegisterServerEvent('esx_drugs:pickedUpPochonCanettes')
AddEventHandler('esx_drugs:pickedUpPochonCanettes', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('canettes')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('canettes_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonCanettes')
AddEventHandler('esx_drugs:processPochonCanettes', function()
	if not playersProcessingPochonCanettes[source] then
		local _source = source

		playersProcessingPochonCanettes[_source] = ESX.SetTimeout(Config.Delays.CanettesProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCanettes, xFerraille = xPlayer.getInventoryItem('canettes'), xPlayer.getInventoryItem('ferraille')

			if xFerraille.limit ~= -1 and (xFerraille.count + 1) >= xFerraille.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('canettes_processingfull'))
			elseif xCanettes.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('canettes_processingenough'))
			else
				xPlayer.removeInventoryItem('canettes', 2)
				xPlayer.addInventoryItem('ferraille', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('canettes_processed'))
			end

			playersProcessingPochonCanettes[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit canettes processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)



--Huiles
RegisterServerEvent('esx_drugs:pickedUpPochonHuiles')
AddEventHandler('esx_drugs:pickedUpPochonHuiles', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('huiles')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('huiles_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonHuiles')
AddEventHandler('esx_drugs:processPochonHuiles', function()
	if not playersProcessingPochonHuiles[source] then
		local _source = source

		playersProcessingPochonHuiles[_source] = ESX.SetTimeout(Config.Delays.HuilesProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xHuiles, xHuilesRech = xPlayer.getInventoryItem('huiles'), xPlayer.getInventoryItem('huile')

			if xHuilesRech.limit ~= -2 and (xHuilesRech.count + 2) >= xHuilesRech.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('huiles_processingfull'))
			elseif xHuiles.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('huiles_processingenough'))
			else
				xPlayer.removeInventoryItem('huiles', 2)
				xPlayer.addInventoryItem('huile', 2)

				TriggerClientEvent('esx:showNotification', _source, _U('huiles_processed'))
			end

			playersProcessingPochonHuiles[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit huiles med processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)


--vendeur4

RegisterServerEvent('esx_drugs:sellDrug4')
AddEventHandler('esx_drugs:sellDrug4', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems4[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	xPlayer.addMoney(price)
	
	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold4', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

-- GENERAL

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
