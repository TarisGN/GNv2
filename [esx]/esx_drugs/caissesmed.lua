--SERVEUR

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
			local xCanettes, xFerraille = xPlayer.getInventoryItem('canettes'), xPlayer.getInventoryItem('canette')

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

-- CLIENT



--Canettes

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CanettesField.coords, true) < 50 then
			SpawnCanettesPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CanettesProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('canettes_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessCanettes()
						else
							OpenBuyLicenseMenu('canettes_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'canettes_processing')
				else
					ProcessCanettes()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCanettes()
	isProcessing = true

	ESX.ShowNotification(_U('canettes_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonCanettes')
	local timeLeft = Config.Delays.CanettesProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CanettesProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('canettes_processingtoofar'))
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

		for i=1, #canettesPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(canettesPlants[i]), false) < 1 then
				nearbyObject, nearbyID = canettesPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('canettes_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_janitor', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(canettesPlants, nearbyID)
						spawnedCanettess = spawnedCanettess - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonCanettes')
					else
						ESX.ShowNotification(_U('canettes_inventoryfull'))
					end

					isPickingUp = false

				end, 'canettes')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(canettesPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCanettesPlants()
	while spawnedCanettess < 25 do
		Citizen.Wait(0)
		local canettesCoords = GenerateCanettesCoords()

		ESX.Game.SpawnLocalObject('prop_ecola_can', canettesCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(canettesPlants, obj)
			spawnedCanettess = spawnedCanettess + 1
		end)
	end
end

function ValidateCanettesCoord(plantCoord10)
	if spawnedCanettess > 0 then
		local validate = true

		for k, v in pairs(canettesPlants) do
			if GetDistanceBetweenCoords(plantCoord10, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord10, Config.CircleZones.CanettesField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCanettesCoords()
	while true do
		Citizen.Wait(1)

		local canettesCoordX, canettesCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		canettesCoordX = Config.CircleZones.CanettesField.coords.x + modX
		canettesCoordY = Config.CircleZones.CanettesField.coords.y + modY

		local coordZ = GetCoordZ(canettesCoordX, canettesCoordY)
		local coord = vector3(canettesCoordX, canettesCoordY, coordZ)

		if ValidateCanettesCoord(coord) then
			return coord
		end
	end
end

-- TRAD

['canettes_pickupprompt'] = 'appuyez sur ~INPUT_CONTEXT~ pour ramasser une ~g~Canette Usagée~s~.',
  ['canettes_inventoryfull'] = 'vous n\'avez plus assez de place dans votre inventaire pour récolter des ~g~Canettes~s~.',
  ['canettes_processprompt'] = 'appuyez ~INPUT_CONTEXT~ pour démarrer le ~g~filtrage des canettes~s~.',
  ['canettes_processingstarted'] = 'compression des ~g~Canettes~s~...',
  ['canettes_processingfull'] = 'transformation ~r~annulée~s~. Votre inventaire est plein!',
  ['canettes_processingenough'] = 'vous devez avoir ~b~1x~s~ ~g~Canette usagée~s~ pour lancer le filtrage.',
  ['canettes_processed'] = 'vous avez compressé ~b~1x~s~ ~g~Canette~s~',
  ['canettes_processingtoofar'] = 'la transformation a été ~r~annulée~s~. Vous êtes sorti de la zone.',


  -- CONFIG

  CanettesField = {coords = vector3(-520, -2829.76, 6.0), name = _U('blip_canettesfield'), 0},
  CanettesProcessing = {coords = vector3(-520, -2829.76, 6.0), name = _U('blip_canettesprocessing'), 0},