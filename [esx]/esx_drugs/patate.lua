--SERVEUR

function CancelProcessing(playerID)

	if playersProcessingRaisin[playerID] then
		ESX.ClearTimeout(playersProcessingRaisin[playerID])
		playersProcessingRaisin[playerID] = nil
	end

end

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

RegisterServerEvent('esx_drugs:processRaisin')
AddEventHandler('esx_drugs:processRaisin', function()
	if not playersProcessingRaisin[source] then
		local _source = source

		playersProcessingRaisin[_source] = ESX.SetTimeout(Config.Delays.RaisinProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xRaisin, xRaisinDose = xPlayer.getInventoryItem('raisin'), xPlayer.getInventoryItem('raisindose')

			if xRaisinDose.limit ~= -1 and (xRaisinDose.count + 1) >= xRaisinDose.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processingfull'))
			elseif xRaisin.count < 4 then
				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processingenough'))
			else
				xPlayer.removeInventoryItem('raisin', 4)
				xPlayer.addInventoryItem('doseraisin', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('raisin_processed'))
			end

			playersProcessingRaisin[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit raisin processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

-- CLIENT





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.RaisinField.coords, true) < 50 then
			SpawnRaisinPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.RaisinProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('raisin_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessRaisin()
						else
							OpenBuyLicenseMenu('raisin_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'raisin_processing')
				else
					ProcessRaisin()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessRaisin()
	isProcessing = true

	ESX.ShowNotification(_U('raisin_processingstarted'))
	TriggerServerEvent('esx_drugs:processRaisin')
	local timeLeft = Config.Delays.RaisinProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.RaisinProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('raisin_processingtoofar'))
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

		for i=1, #raisinPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(raisinPlants[i]), false) < 1 then
				nearbyObject, nearbyID = raisinPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('raisin_pickupprompt'))
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
		
						table.remove(raisinPlants, nearbyID)
						spawnedRaisins = spawnedRaisins - 1
		
						TriggerServerEvent('esx_drugs:pickedUpRaisin')
					else
						ESX.ShowNotification(_U('raisin_inventoryfull'))
					end

					isPickingUp = false

				end, 'raisin')
			end

		else
			Citizen.Wait(500)
		end

	end

end)



function SpawnRaisinPlants()
	while spawnedRaisins < 25 do
		Citizen.Wait(0)
		local raisinCoords = GenerateRaisinCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_02b', raisinCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(raisinPlants, obj)
			spawnedRaisins = spawnedRaisins + 1
		end)
	end
end

function ValidateRaisinCoord(plantCoord6)
	if spawnedRaisins > 0 then
		local validate = true

		for k, v in pairs(raisinPlants) do
			if GetDistanceBetweenCoords(plantCoord6, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord6, Config.CircleZones.RaisinField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateRaisinCoords()
	while true do
		Citizen.Wait(1)

		local raisinCoordX, raisinCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		raisinCoordX = Config.CircleZones.RaisinField.coords.x + modX
		raisinCoordY = Config.CircleZones.RaisinField.coords.y + modY

		local coordZ = GetCoordZ(raisinCoordX, raisinCoordY)
		local coord = vector3(raisinCoordX, raisinCoordY, coordZ)

		if ValidateRaisinCoord(coord) then
			return coord
		end
	end
end



['raisin_pickupprompt'] = 'appuyez sur ~INPUT_CONTEXT~ pour ramasser des ~g~Raisins~s~.',
  ['raisin_inventoryfull'] = 'vous n\'avez plus assez de place dans votre inventaire pour récolter des ~g~Raisins~s~.',
  ['raisin_processprompt'] = 'appuyez ~INPUT_CONTEXT~ pour démarrer le ~g~tri de la raisin~s~.',
  ['raisin_processingstarted'] = 'transformation des ~g~Sachets~s~ en ~g~Dose de raisin~s~...',
  ['raisin_processingfull'] = 'transformation ~r~annulée~s~. Votre inventaire est plein!',
  ['raisin_processingenough'] = 'vous devez avoir ~b~3x~s~ ~g~Sachets~s~ pour lancer une transformation.',
  ['raisin_processed'] = 'vous avez transformé ~b~3x~s~ ~g~Sachets~s~ en ~b~1x~s~ ~g~Dose de raisin~s~',
  ['raisin_processingtoofar'] = 'la transformation a été ~r~annulée~s~. Vous êtes sorti de la zone.',

RaisinField = {coords = vector3(2886.9729003906, 4609.4565429688, 46.987), name = _U('blip_raisinfield'), 0},