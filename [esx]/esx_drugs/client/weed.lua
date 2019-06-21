local spawnedWeeds = 0
local weedPlants = {}
local spawnedCokes = 0
local cokePlants = {}
local spawnedCaisses = 0
local caissePlants = {}
local spawnedTabacblonds = 0
local tabacblondPlants = {}
local spawnedTabacbruns = 0
local tabacbrunPlants = {}
local spawnedPatates = 0
local patatePlants = {}
local spawnedRaisins = 0
local raisinPlants = {}
local spawnedCaissemeds = 0
local caissemedPlants = {}
local spawnedBatteries = 0
local batteriePlants = {}
local spawnedHuiles = 0
local huilesPlants = {}
local spawnedCanettes = 0
local canettesPlants = {}
local isPickingUp, isProcessing = false, false



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 50 then
			SpawnWeedPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('weed_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessWeed()
						else
							OpenBuyLicenseMenu('weed_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'weed_processing')
				else
					ProcessWeed()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessWeed()
	isProcessing = true

	ESX.ShowNotification(_U('weed_processingstarted'))
	TriggerServerEvent('esx_drugs:processCannabis')
	local timeLeft = Config.Delays.WeedProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('weed_processingtoofar'))
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

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('weed_pickupprompt'))
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
		
						table.remove(weedPlants, nearbyID)
						spawnedWeeds = spawnedWeeds - 1
		
						TriggerServerEvent('esx_drugs:pickedUpCannabis')
					else
						ESX.ShowNotification(_U('weed_inventoryfull'))
					end

					isPickingUp = false

				end, 'cannabis')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

AddEventHandler('onResourceStop2', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cokePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)


function SpawnWeedPlants()
	while spawnedWeeds < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

--Huiles

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.HuilesField.coords, true) < 50 then
			SpawnHuilesPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.HuilesProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('huiles_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessHuiles()
						else
							OpenBuyLicenseMenu('huiles_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'huiles_processing')
				else
					ProcessHuiles()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessHuiles()
	isProcessing = true

	ESX.ShowNotification(_U('huiles_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonHuiles')
	local timeLeft = Config.Delays.HuilesProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.HuilesProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('huiles_processingtoofar'))
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

		for i=1, #huilesPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(huilesPlants[i]), false) < 1 then
				nearbyObject, nearbyID = huilesPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('huiles_pickupprompt'))
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
		
						table.remove(huilesPlants, nearbyID)
						spawnedHuiles = spawnedHuiles - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonHuiles')
					else
						ESX.ShowNotification(_U('huiles_inventoryfull'))
					end

					isPickingUp = false

				end, 'huiles')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(huilesPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnHuilesPlants()
	while spawnedHuiles < 25 do
		Citizen.Wait(0)
		local huilesCoords = GenerateHuilesCoords()

		ESX.Game.SpawnLocalObject('prop_oilcan_01a', huilesCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(huilesPlants, obj)
			spawnedHuiles = spawnedHuiles + 1
		end)
	end
end

function ValidateHuilesCoord(plantCoord9)
	if spawnedHuiles > 0 then
		local validate = true

		for k, v in pairs(huilesPlants) do
			if GetDistanceBetweenCoords(plantCoord9, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord9, Config.CircleZones.HuilesField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateHuilesCoords()
	while true do
		Citizen.Wait(1)

		local huilesCoordX, huilesCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		huilesCoordX = Config.CircleZones.HuilesField.coords.x + modX
		huilesCoordY = Config.CircleZones.HuilesField.coords.y + modY

		local coordZ = GetCoordZ(huilesCoordX, huilesCoordY)
		local coord = vector3(huilesCoordX, huilesCoordY, coordZ)

		if ValidateHuilesCoord(coord) then
			return coord
		end
	end
end


--COKE




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 50 then
			SpawnCokePlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('coke_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessCoke()
						else
							OpenBuyLicenseMenu('coke_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'coke_processing')
				else
					ProcessCoke()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCoke()
	isProcessing = true

	ESX.ShowNotification(_U('coke_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonCoke')
	local timeLeft = Config.Delays.CokeProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CokeProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('coke_processingtoofar'))
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

		for i=1, #cokePlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(cokePlants[i]), false) < 1 then
				nearbyObject, nearbyID = cokePlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('coke_pickupprompt'))
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
		
						table.remove(cokePlants, nearbyID)
						spawnedCokes = spawnedCokes - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonCoke')
					else
						ESX.ShowNotification(_U('coke_inventoryfull'))
					end

					isPickingUp = false

				end, 'pochoncoke')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop3', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cokePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCokePlants()
	while spawnedCokes < 25 do
		Citizen.Wait(0)
		local cokeCoords = GenerateCokeCoords()

		ESX.Game.SpawnLocalObject('prop_coke_block_01', cokeCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(cokePlants, obj)
			spawnedCokes = spawnedCokes + 1
		end)
	end
end

function ValidateCokeCoord(plantCoord2)
	if spawnedCokes > 0 then
		local validate = true

		for k, v in pairs(cokePlants) do
			if GetDistanceBetweenCoords(plantCoord2, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord2, Config.CircleZones.CokeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCokeCoords()
	while true do
		Citizen.Wait(1)

		local cokeCoordX, cokeCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		cokeCoordX = Config.CircleZones.CokeField.coords.x + modX
		cokeCoordY = Config.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZ(cokeCoordX, cokeCoordY)
		local coord = vector3(cokeCoordX, cokeCoordY, coordZ)

		if ValidateCokeCoord(coord) then
			return coord
		end
	end
end

--CAISSES 

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

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)

-- 		if GetDistanceBetweenCoords(coords, Config.CircleZones.CaisseProcessing.coords, true) < 1 then
-- 			if not isProcessing then
-- 				ESX.ShowHelpNotification(_U('caisse_processprompt'))
-- 			end

-- 			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

-- 				if Config.LicenseEnable then
-- 					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
-- 						if hasProcessingLicense then
-- 							ProcessCaisse()
-- 						else
-- 							OpenBuyLicenseMenu('caisse_processing')
-- 						end
-- 					end, GetPlayerServerId(PlayerId()), 'caisse_processing')
-- 				else
-- 					ProcessCaisse()
-- 				end

-- 			end
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function ProcessCaisse()
-- 	isProcessing = true

-- 	ESX.ShowNotification(_U('caisse_processingstarted'))
-- 	TriggerServerEvent('esx_drugs:processPochonCaisse')
-- 	local timeLeft = Config.Delays.CaisseProcessing / 1000
-- 	local playerPed = PlayerPedId()

-- 	while timeLeft > 0 do
-- 		Citizen.Wait(1000)
-- 		timeLeft = timeLeft - 1

-- 		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CaisseProcessing.coords, false) > 4 then
-- 			ESX.ShowNotification(_U('caisse_processingtoofar'))
-- 			TriggerServerEvent('esx_drugs:cancelProcessing')
-- 			break
-- 		end
-- 	end

-- 	isProcessing = false
-- end

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

				end, 'biere')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop4', function(resource)
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

		ESX.Game.SpawnLocalObject('prop_crate_11e', caisseCoords, function(obj)
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

-- TABAC BLOND

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

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)

-- 		if GetDistanceBetweenCoords(coords, Config.CircleZones.TabacblondProcessing.coords, true) < 1 then
-- 			if not isProcessing then
-- 				ESX.ShowHelpNotification(_U('tabacblond_processprompt'))
-- 			end

-- 			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

-- 				if Config.LicenseEnable then
-- 					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
-- 						if hasProcessingLicense then
-- 							ProcessTabacblond()
-- 						else
-- 							OpenBuyLicenseMenu('tabacblond_processing')
-- 						end
-- 					end, GetPlayerServerId(PlayerId()), 'tabacblond_processing')
-- 				else
-- 					ProcessTabacblond()
-- 				end

-- 			end
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function ProcessTabacblond()
-- 	isProcessing = true

-- 	ESX.ShowNotification(_U('tabacblond_processingstarted'))
-- 	TriggerServerEvent('esx_drugs:processTabacblond')
-- 	local timeLeft = Config.Delays.TabacblondProcessing / 1000
-- 	local playerPed = PlayerPedId()

-- 	while timeLeft > 0 do
-- 		Citizen.Wait(1000)
-- 		timeLeft = timeLeft - 1

-- 		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.TabacblondProcessing.coords, false) > 4 then
-- 			ESX.ShowNotification(_U('tabacblond_processingtoofar'))
-- 			TriggerServerEvent('esx_drugs:cancelProcessing')
-- 			break
-- 		end
-- 	end

-- 	isProcessing = false
-- end

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

AddEventHandler('onResourceStop5', function(resource)
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

function ValidateTabacblondCoord(plantCoord4)
	if spawnedTabacblonds > 0 then
		local validate = true

		for k, v in pairs(tabacblondPlants) do
			if GetDistanceBetweenCoords(plantCoord4, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord4, Config.CircleZones.TabacblondField.coords, false) > 50 then
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TabacbrunField.coords, true) < 50 then
			SpawnTabacbrunPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)

-- 		if GetDistanceBetweenCoords(coords, Config.CircleZones.TabacbrunProcessing.coords, true) < 1 then
-- 			if not isProcessing then
-- 				ESX.ShowHelpNotification(_U('tabacbrun_processprompt'))
-- 			end

-- 			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

-- 				if Config.LicenseEnable then
-- 					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
-- 						if hasProcessingLicense then
-- 							ProcessTabacbrun()
-- 						else
-- 							OpenBuyLicenseMenu('tabacbrun_processing')
-- 						end
-- 					end, GetPlayerServerId(PlayerId()), 'tabacbrun_processing')
-- 				else
-- 					ProcessTabacbrun()
-- 				end

-- 			end
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function ProcessTabacbrun()
-- 	isProcessing = true

-- 	ESX.ShowNotification(_U('tabacbrun_processingstarted'))
-- 	TriggerServerEvent('esx_drugs:processTabacbrun')
-- 	local timeLeft = Config.Delays.TabacbrunProcessing / 1000
-- 	local playerPed = PlayerPedId()

-- 	while timeLeft > 0 do
-- 		Citizen.Wait(1000)
-- 		timeLeft = timeLeft - 1

-- 		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.TabacbrunProcessing.coords, false) > 4 then
-- 			ESX.ShowNotification(_U('tabacbrun_processingtoofar'))
-- 			TriggerServerEvent('esx_drugs:cancelProcessing')
-- 			break
-- 		end
-- 	end

-- 	isProcessing = false
-- end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #tabacbrunPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(tabacbrunPlants[i]), false) < 1 then
				nearbyObject, nearbyID = tabacbrunPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('tabacbrun_pickupprompt'))
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
		
						table.remove(tabacbrunPlants, nearbyID)
						spawnedTabacbruns = spawnedTabacbruns - 1
		
						TriggerServerEvent('esx_drugs:pickedUpTabacbrun')
					else
						ESX.ShowNotification(_U('tabacbrun_inventoryfull'))
					end

					isPickingUp = false

				end, 'tabacbrun')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop6', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(tabacbrunPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnTabacbrunPlants()
	while spawnedTabacbruns < 25 do
		Citizen.Wait(0)
		local tabacbrunCoords = GenerateTabacbrunCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_02b', tabacbrunCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(tabacbrunPlants, obj)
			spawnedTabacbruns = spawnedTabacbruns + 1
		end)
	end
end

function ValidateTabacbrunCoord(plantCoord5)
	if spawnedTabacbruns > 0 then
		local validate = true

		for k, v in pairs(tabacbrunPlants) do
			if GetDistanceBetweenCoords(plantCoord5, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord5, Config.CircleZones.TabacbrunField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateTabacbrunCoords()
	while true do
		Citizen.Wait(1)

		local tabacbrunCoordX, tabacbrunCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		tabacbrunCoordX = Config.CircleZones.TabacbrunField.coords.x + modX
		tabacbrunCoordY = Config.CircleZones.TabacbrunField.coords.y + modY

		local coordZ = GetCoordZ(tabacbrunCoordX, tabacbrunCoordY)
		local coord = vector3(tabacbrunCoordX, tabacbrunCoordY, coordZ)

		if ValidateTabacbrunCoord(coord) then
			return coord
		end
	end
end

--BATTERIES

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.BatterieField.coords, true) < 50 then
			SpawnBatteriePlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.BatterieProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('batterie_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessBatterie()
						else
							OpenBuyLicenseMenu('batterie_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'batterie_processing')
				else
					ProcessBatterie()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessBatterie()
	isProcessing = true

	ESX.ShowNotification(_U('batterie_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonBatterie')
	local timeLeft = Config.Delays.BatterieProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.BatterieProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('batterie_processingtoofar'))
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

		for i=1, #batteriePlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(batteriePlants[i]), false) < 1 then
				nearbyObject, nearbyID = batteriePlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('batterie_pickupprompt'))
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
		
						table.remove(batteriePlants, nearbyID)
						spawnedBatteries = spawnedBatteries - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonBatterie')
					else
						ESX.ShowNotification(_U('batterie_inventoryfull'))
					end

					isPickingUp = false

				end, 'batterie')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(batteriePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnBatteriePlants()
	while spawnedBatteries < 25 do
		Citizen.Wait(0)
		local batterieCoords = GenerateBatterieCoords()

		ESX.Game.SpawnLocalObject('prop_battery_01', batterieCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(batteriePlants, obj)
			spawnedBatteries = spawnedBatteries + 1
		end)
	end
end

function ValidateBatterieCoord(plantCoord8)
	if spawnedBatteries > 0 then
		local validate = true

		for k, v in pairs(batteriePlants) do
			if GetDistanceBetweenCoords(plantCoord8, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord8, Config.CircleZones.BatterieField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateBatterieCoords()
	while true do
		Citizen.Wait(1)

		local batterieCoordX, batterieCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		batterieCoordX = Config.CircleZones.BatterieField.coords.x + modX
		batterieCoordY = Config.CircleZones.BatterieField.coords.y + modY

		local coordZ = GetCoordZ(batterieCoordX, batterieCoordY)
		local coord = vector3(batterieCoordX, batterieCoordY, coordZ)

		if ValidateBatterieCoord(coord) then
			return coord
		end
	end
end


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

						Citizen.Wait(1500)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(canettesPlants, nearbyID)
						spawnedCanettes = spawnedCanettes - 1
		
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

AddEventHandler('onResourceStop10', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(canettesPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCanettesPlants()
	while spawnedCanettes < 25 do
		Citizen.Wait(0)
		local canettesCoords = GenerateCanettesCoords()

		ESX.Game.SpawnLocalObject('prop_food_juice02', canettesCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(canettesPlants, obj)
			spawnedCanettes = spawnedCanettes + 1
		end)
	end
end

function ValidateCanettesCoord(plantCoord10)
	if spawnedCanettes > 0 then
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



-- Patates


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

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)

-- 		if GetDistanceBetweenCoords(coords, Config.CircleZones.PatateProcessing.coords, true) < 1 then
-- 			if not isProcessing then
-- 				ESX.ShowHelpNotification(_U('patate_processprompt'))
-- 			end

-- 			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

-- 				if Config.LicenseEnable then
-- 					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
-- 						if hasProcessingLicense then
-- 							ProcessPatate()
-- 						else
-- 							OpenBuyLicenseMenu('patate_processing')
-- 						end
-- 					end, GetPlayerServerId(PlayerId()), 'patate_processing')
-- 				else
-- 					ProcessPatate()
-- 				end

-- 			end
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function ProcessPatate()
-- 	isProcessing = true

-- 	ESX.ShowNotification(_U('patate_processingstarted'))
-- 	TriggerServerEvent('esx_drugs:processPatate')
-- 	local timeLeft = Config.Delays.PatateProcessing / 1000
-- 	local playerPed = PlayerPedId()

-- 	while timeLeft > 0 do
-- 		Citizen.Wait(1000)
-- 		timeLeft = timeLeft - 1

-- 		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.PatateProcessing.coords, false) > 4 then
-- 			ESX.ShowNotification(_U('patate_processingtoofar'))
-- 			TriggerServerEvent('esx_drugs:cancelProcessing')
-- 			break
-- 		end
-- 	end

-- 	isProcessing = false
-- end

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

AddEventHandler('onResourceStop7', function(resource)
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

		ESX.Game.SpawnLocalObject('prop_aloevera_01', patateCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(patatePlants, obj)
			spawnedPatates = spawnedPatates + 1
		end)
	end
end

function ValidatePatateCoord(plantCoord6)
	if spawnedPatates > 0 then
		local validate = true

		for k, v in pairs(patatePlants) do
			if GetDistanceBetweenCoords(plantCoord6, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord6, Config.CircleZones.PatateField.coords, false) > 50 then
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

--CAISSESMED

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CaissemedField.coords, true) < 50 then
			SpawnCaissemedPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CaissemedProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('caissemed_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessCaissemed()
						else
							OpenBuyLicenseMenu('caissemed_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'caissemed_processing')
				else
					ProcessCaissemed()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCaissemed()
	isProcessing = true

	ESX.ShowNotification(_U('caissemed_processingstarted'))
	TriggerServerEvent('esx_drugs:processPochonCaissemed')
	local timeLeft = Config.Delays.CaissemedProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CaissemedProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('caissemed_processingtoofar'))
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

		for i=1, #caissemedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(caissemedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = caissemedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('caissemed_pickupprompt'))
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
		
						table.remove(caissemedPlants, nearbyID)
						spawnedCaissemeds = spawnedCaissemeds - 1
		
						TriggerServerEvent('esx_drugs:pickedUpPochonCaissemed')
					else
						ESX.ShowNotification(_U('caissemed_inventoryfull'))
					end

					isPickingUp = false

				end, 'caissemed')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop8', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(caissemedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCaissemedPlants()
	while spawnedCaissemeds < 25 do
		Citizen.Wait(0)
		local caissemedCoords = GenerateCaissemedCoords()

		ESX.Game.SpawnLocalObject('prop_mil_crate_02', caissemedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(caissemedPlants, obj)
			spawnedCaissemeds = spawnedCaissemeds + 1
		end)
	end
end

function ValidateCaissemedCoord(plantCoord6)
	if spawnedCaissemeds > 0 then
		local validate = true

		for k, v in pairs(caissemedPlants) do
			if GetDistanceBetweenCoords(plantCoord6, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord6, Config.CircleZones.CaissemedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCaissemedCoords()
	while true do
		Citizen.Wait(1)

		local caissemedCoordX, caissemedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		caissemedCoordX = Config.CircleZones.CaissemedField.coords.x + modX
		caissemedCoordY = Config.CircleZones.CaissemedField.coords.y + modY

		local coordZ = GetCoordZ(caissemedCoordX, caissemedCoordY)
		local coord = vector3(caissemedCoordX, caissemedCoordY, coordZ)

		if ValidateCaissemedCoord(coord) then
			return coord
		end
	end
end

--RAISIN

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

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		local coords = GetEntityCoords(playerPed)

-- 		if GetDistanceBetweenCoords(coords, Config.CircleZones.RaisinProcessing.coords, true) < 1 then
-- 			if not isProcessing then
-- 				ESX.ShowHelpNotification(_U('raisin_processprompt'))
-- 			end

-- 			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

-- 				if Config.LicenseEnable then
-- 					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
-- 						if hasProcessingLicense then
-- 							ProcessRaisin()
-- 						else
-- 							OpenBuyLicenseMenu('raisin_processing')
-- 						end
-- 					end, GetPlayerServerId(PlayerId()), 'raisin_processing')
-- 				else
-- 					ProcessRaisin()
-- 				end

-- 			end
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function ProcessRaisin()
-- 	isProcessing = true

-- 	ESX.ShowNotification(_U('raisin_processingstarted'))
-- 	TriggerServerEvent('esx_drugs:processRaisin')
-- 	local timeLeft = Config.Delays.RaisinProcessing / 1000
-- 	local playerPed = PlayerPedId()

-- 	while timeLeft > 0 do
-- 		Citizen.Wait(1000)
-- 		timeLeft = timeLeft - 1

-- 		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.RaisinProcessing.coords, false) > 4 then
-- 			ESX.ShowNotification(_U('raisin_processingtoofar'))
-- 			TriggerServerEvent('esx_drugs:cancelProcessing')
-- 			break
-- 		end
-- 	end

-- 	isProcessing = false
-- end

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

						Citizen.Wait(1000)
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

		ESX.Game.SpawnLocalObject('prop_fruit_basket', raisinCoords, function(obj)
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