--SERVEUR

function CancelProcessing(playerID)

	if playersProcessingPatate[playerID] then
		ESX.ClearTimeout(playersProcessingPatate[playerID])
		playersProcessingPatate[playerID] = nil
	end

end

--Tabac Blond
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

RegisterServerEvent('esx_drugs:processPatate')
AddEventHandler('esx_drugs:processPatate', function()
	if not playersProcessingPatate[source] then
		local _source = source

		playersProcessingPatate[_source] = ESX.SetTimeout(Config.Delays.PatateProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPatate, xPatateDose = xPlayer.getInventoryItem('patate'), xPlayer.getInventoryItem('patatedose')

			if xPatateDose.limit ~= -1 and (xPatateDose.count + 1) >= xPatateDose.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('patate_processingfull'))
			elseif xPatate.count < 4 then
				TriggerClientEvent('esx:showNotification', _source, _U('patate_processingenough'))
			else
				xPlayer.removeInventoryItem('patate', 4)
				xPlayer.addInventoryItem('dosepatate', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('patate_processed'))
			end

			playersProcessingPatate[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit patate processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

-- CLIENT





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.PatateField.coords, true) < 50 then
			SpawnPatatePlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.PatateProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('patate_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessPatate()
						else
							OpenBuyLicenseMenu('patate_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'patate_processing')
				else
					ProcessPatate()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessPatate()
	isProcessing = true

	ESX.ShowNotification(_U('patate_processingstarted'))
	TriggerServerEvent('esx_drugs:processPatate')
	local timeLeft = Config.Delays.PatateProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.PatateProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('patate_processingtoofar'))
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

		for i=1, #patatePlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(patatePlants[i]), false) < 1 then
				nearbyObject, nearbyID = patatePlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('patate_pickupprompt'))
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
		
						table.remove(patatePlants, nearbyID)
						spawnedPatates = spawnedPatates - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPatate')
					else
						ESX.ShowNotification(_U('patate_inventoryfull'))
					end

					isPickingUp = false

				end, 'patate')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(patatePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnPatatePlants()
	while spawnedPatates < 25 do
		Citizen.Wait(0)
		local patateCoords = GeneratePatateCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_02b', patateCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(patatePlants, obj)
			spawnedPatates = spawnedPatates + 1
		end)
	end
end

function ValidatePatateCoord(plantCoord5)
	if spawnedPatates > 0 then
		local validate = true

		for k, v in pairs(patatePlants) do
			if GetDistanceBetweenCoords(plantCoord5, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord5, Config.CircleZones.PatateField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratePatateCoords()
	while true do
		Citizen.Wait(1)

		local patateCoordX, patateCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		patateCoordX = Config.CircleZones.PatateField.coords.x + modX
		patateCoordY = Config.CircleZones.PatateField.coords.y + modY

		local coordZ = GetCoordZ(patateCoordX, patateCoordY)
		local coord = vector3(patateCoordX, patateCoordY, coordZ)

		if ValidatePatateCoord(coord) then
			return coord
		end
	end
end



['patate_pickupprompt'] = 'appuyez sur ~INPUT_CONTEXT~ pour ramasser des ~g~Patates~s~.',
  ['patate_inventoryfull'] = 'vous n\'avez plus assez de place dans votre inventaire pour récolter des ~g~Patates~s~.',
  ['patate_processprompt'] = 'appuyez ~INPUT_CONTEXT~ pour démarrer le ~g~tri de la patate~s~.',
  ['patate_processingstarted'] = 'transformation des ~g~Sachets~s~ en ~g~Dose de patate~s~...',
  ['patate_processingfull'] = 'transformation ~r~annulée~s~. Votre inventaire est plein!',
  ['patate_processingenough'] = 'vous devez avoir ~b~3x~s~ ~g~Sachets~s~ pour lancer une transformation.',
  ['patate_processed'] = 'vous avez transformé ~b~3x~s~ ~g~Sachets~s~ en ~b~1x~s~ ~g~Dose de patate~s~',
  ['patate_processingtoofar'] = 'la transformation a été ~r~annulée~s~. Vous êtes sorti de la zone.',

PatateField = {coords = vector3(2886.9729003906, 4609.4565429688, 46.987), name = _U('blip_patatefield'), 0},