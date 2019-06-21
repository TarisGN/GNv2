--SERVEUR

function CancelProcessing(playerID)

	if playersProcessingPochonCaisse[playerID] then
		ESX.ClearTimeout(playersProcessingPochonCaisse[playerID])
		playersProcessingPochonCaisse[playerID] = nil
	end

end

--CAISSE
RegisterServerEvent('esx_drugs:pickedUpPochonCaisse')
AddEventHandler('esx_drugs:pickedUpPochonCaisse', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('pochoncaisse')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('caisse_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_drugs:processPochonCaisse')
AddEventHandler('esx_drugs:processPochonCaisse', function()
	if not playersProcessingPochonCaisse[source] then
		local _source = source

		playersProcessingPochonCaisse[_source] = ESX.SetTimeout(Config.Delays.CaisseProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPochonCaisse, xCaisseDose = xPlayer.getInventoryItem('pochoncaisse'), xPlayer.getInventoryItem('caissedose')

			if xCaisseDose.limit ~= -1 and (xCaisseDose.count + 1) >= xCaisseDose.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processingfull'))
			elseif xPochonCaisse.count < 4 then
				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processingenough'))
			else
				xPlayer.removeInventoryItem('pochoncaisse', 4)
				xPlayer.addInventoryItem('dosecaisse', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('caisse_processed'))
			end

			playersProcessingPochonCaisse[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit caisse processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

-- CLIENT





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CaisseField.coords, true) < 50 then
			SpawnCaissePlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CaisseProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('caisse_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessCaisse()
						else
							OpenBuyLicenseMenu('caisse_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'caisse_processing')
				else
					ProcessCaisse()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCaisse()
	isProcessing = true

	ESX.ShowNotification(_U('caisse_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonCaisse')
	local timeLeft = Config.Delays.CaisseProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CaisseProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('caisse_processingtoofar'))
			TriggerServerEvent('esx_drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #caissePlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(caissePlants[i]), false) < 1 then
				nearbyObject, nearbyID = caissePlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('caisse_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(caissePlants, nearbyID)
						spawnedCaisses = spawnedCaisses - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonCaisse')
					else
						ESX.ShowNotification(_U('caisse_inventoryfull'))
					end

					isPickingUp = false

				end, 'pochoncaisse')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(caissePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCaissePlants()
	while spawnedCaisses < 25 do
		Citizen.Wait(0)
		local caisseCoords = GenerateCaisseCoords()

		ESX.Game.SpawnLocalObject('prop_cratepile_07a_l1', caisseCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(caissePlants, obj)
			spawnedCaisses = spawnedCaisses + 1
		end)
	end
end

function ValidateCaisseCoord(plantCoord2)
	if spawnedCaisses > 0 then
		local validate = true

		for k, v in pairs(caissePlants) do
			if GetDistanceBetweenCoords(plantCoord2, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord2, Config.CircleZones.CaisseField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCaisseCoords()
	while true do
		Citizen.Wait(1)

		local caisseCoordX, caisseCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		caisseCoordX = Config.CircleZones.CaisseField.coords.x + modX
		caisseCoordY = Config.CircleZones.CaisseField.coords.y + modY

		local coordZ = GetCoordZ(caisseCoordX, caisseCoordY)
		local coord = vector3(caisseCoordX, caisseCoordY, coordZ)

		if ValidateCaisseCoord(coord) then
			return coord
		end
	end
end



['caisse_pickupprompt'] = 'appuyez sur ~INPUT_CONTEXT~ pour ramasser un pochon de ~g~Coke~s~.',
  ['caisse_inventoryfull'] = 'vous n\'avez plus assez de place dans votre inventaire pour récolter des ~g~pochons de Coke~s~.',
  ['caisse_processprompt'] = 'appuyez ~INPUT_CONTEXT~ pour démarrer le ~g~tri de la caisse~s~.',
  ['caisse_processingstarted'] = 'transformation des ~g~Sachets~s~ en ~g~Dose de caisse~s~...',
  ['caisse_processingfull'] = 'transformation ~r~annulée~s~. Votre inventaire est plein!',
  ['caisse_processingenough'] = 'vous devez avoir ~b~3x~s~ ~g~Sachets~s~ pour lancer une transformation.',
  ['caisse_processed'] = 'vous avez transformé ~b~3x~s~ ~g~Sachets~s~ en ~b~1x~s~ ~g~Dose de caisse~s~',
  ['caisse_processingtoofar'] = 'la transformation a été ~r~annulée~s~. Vous êtes sorti de la zone.',