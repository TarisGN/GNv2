--SERVEUR

function CancelProcessing(playerID)

	if playersProcessingTabacblond[playerID] then
		ESX.ClearTimeout(playersProcessingTabacblond[playerID])
		playersProcessingTabacblond[playerID] = nil
	end

end

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

RegisterServerEvent('esx_drugs:processTabacblond')
AddEventHandler('esx_drugs:processTabacblond', function()
	if not playersProcessingTabacblond[source] then
		local _source = source

		playersProcessingTabacblond[_source] = ESX.SetTimeout(Config.Delays.TabacblondProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xTabacblond, xTabacblondDose = xPlayer.getInventoryItem('tabacblond'), xPlayer.getInventoryItem('tabacblonddose')

			if xTabacblondDose.limit ~= -1 and (xTabacblondDose.count + 1) >= xTabacblondDose.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processingfull'))
			elseif xTabacblond.count < 4 then
				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processingenough'))
			else
				xPlayer.removeInventoryItem('tabacblond', 4)
				xPlayer.addInventoryItem('dosetabacblond', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('tabacblond_processed'))
			end

			playersProcessingTabacblond[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit tabacblond processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

-- CLIENT





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TabacblondField.coords, true) < 50 then
			SpawnTabacblondPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TabacblondProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('tabacblond_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessTabacblond()
						else
							OpenBuyLicenseMenu('tabacblond_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'tabacblond_processing')
				else
					ProcessTabacblond()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessTabacblond()
	isProcessing = true

	ESX.ShowNotification(_U('tabacblond_processingstarted'))
	TriggerServerEvent('esx_drugs:processTabacblond')
	local timeLeft = Config.Delays.TabacblondProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.TabacblondProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('tabacblond_processingtoofar'))
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

		for i=1, #tabacblondPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(tabacblondPlants[i]), false) < 1 then
				nearbyObject, nearbyID = tabacblondPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('tabacblond_pickupprompt'))
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
		
						table.remove(tabacblondPlants, nearbyID)
						spawnedTabacblonds = spawnedTabacblonds - 1
		
						TriggerServerEvent('esx_drugs:pickedUpTabacblond')
					else
						ESX.ShowNotification(_U('tabacblond_inventoryfull'))
					end

					isPickingUp = false

				end, 'tabacblond')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(tabacblondPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnTabacblondPlants()
	while spawnedTabacblonds < 25 do
		Citizen.Wait(0)
		local tabacblondCoords = GenerateTabacblondCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_02a', tabacblondCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(tabacblondPlants, obj)
			spawnedTabacblonds = spawnedTabacblonds + 1
		end)
	end
end

function ValidateTabacblondCoord(plantCoord2)
	if spawnedTabacblonds > 0 then
		local validate = true

		for k, v in pairs(tabacblondPlants) do
			if GetDistanceBetweenCoords(plantCoord2, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord2, Config.CircleZones.TabacblondField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateTabacblondCoords()
	while true do
		Citizen.Wait(1)

		local tabacblondCoordX, tabacblondCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		tabacblondCoordX = Config.CircleZones.TabacblondField.coords.x + modX
		tabacblondCoordY = Config.CircleZones.TabacblondField.coords.y + modY

		local coordZ = GetCoordZ(tabacblondCoordX, tabacblondCoordY)
		local coord = vector3(tabacblondCoordX, tabacblondCoordY, coordZ)

		if ValidateTabacblondCoord(coord) then
			return coord
		end
	end
end



['tabacblond_pickupprompt'] = 'appuyez sur ~INPUT_CONTEXT~ pour ramasser ~g~Tabac Blond~s~.',
  ['tabacblond_inventoryfull'] = 'vous n\'avez plus assez de place dans votre inventaire pour récolter du ~g~Tabac~s~.',
  ['tabacblond_processprompt'] = 'appuyez ~INPUT_CONTEXT~ pour démarrer le ~g~tri de la tabacblond~s~.',
  ['tabacblond_processingstarted'] = 'transformation des ~g~Sachets~s~ en ~g~Dose de tabacblond~s~...',
  ['tabacblond_processingfull'] = 'transformation ~r~annulée~s~. Votre inventaire est plein!',
  ['tabacblond_processingenough'] = 'vous devez avoir ~b~3x~s~ ~g~Sachets~s~ pour lancer une transformation.',
  ['tabacblond_processed'] = 'vous avez transformé ~b~3x~s~ ~g~Sachets~s~ en ~b~1x~s~ ~g~Dose de tabacblond~s~',
  ['tabacblond_processingtoofar'] = 'la transformation a été ~r~annulée~s~. Vous êtes sorti de la zone.',

TabacblondField = {coords = vector3(2886.9729003906, 4609.4565429688, 46.987), name = _U('blip_tabacblondfield'), 0},