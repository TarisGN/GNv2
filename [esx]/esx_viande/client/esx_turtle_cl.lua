local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PID           			= 0
local GUI           			= {}
local viandeQTE       				= 0
ESX 			    			= nil
GUI.Time            			= 0
local viande_meatQTE 				= 0
local myJob 					= nil
local PlayerData 				= {}
local GUI 						= {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('esx_viande:hasEnteredMarker', function(zone)

        ESX.UI.Menu.CloseAll()

        if zone == 'exitMarker' then
            CurrentAction     = zone
            CurrentActionMsg  = _U('exit_marker')
            CurrentActionData = {}
        end

        --viande process
        if zone == 'viandeFarm' then
            if myJob ~= "police" then
                CurrentAction     = 'viande_harvest'
                CurrentActionMsg  = _U('press_collect_viande')
                CurrentActionData = {}
            end
        end

        if zone == 'viandeTreatment' then
            if myJob ~= "police" then
                if viandeQTE >= 10 then
                    CurrentAction     = 'viande_treatment'
                    CurrentActionMsg  = _U('press_process_viande')
                    CurrentActionData = {}
                end
            end
        end

        if zone == 'viandeResell' then
            if myJob ~= "police" then
                if viande_meatQTE >= 1 then
                    CurrentAction     = 'viande_resell'
                    CurrentActionMsg  = _U('press_sell_viande')
                    CurrentActionData = {}
                end
            end
        end
    end)

AddEventHandler('esx_viande:hasExitedMarker', function(zone)

        CurrentAction = nil
        ESX.UI.Menu.CloseAll()

        TriggerServerEvent('esx_viande:stopHarvestviande')
        TriggerServerEvent('esx_viande:stopTransformviande')
        TriggerServerEvent('esx_viande:stopSellviande')
end)

-- Render markers
Citizen.CreateThread(function()
    while true do

        Wait(0)

        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k,v in pairs(Config.Zones) do
            if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
                DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
        end

    end
end)


-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('esx_viande:ReturnInventory')
AddEventHandler('esx_viande:ReturnInventory', function(viandeNbr, viandepNbr, jobName, currentZone)
	viandeQTE       = viandeNbr
	viande_meatQTE = viandepNbr
	myJob         = jobName
	TriggerEvent('esx_viande:hasEnteredMarker', currentZone)
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(10)

        local coords      = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker  = false
        local currentZone = nil

        for k,v in pairs(Config.Zones) do
            if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
                isInMarker  = true
                currentZone = k
            end
        end

        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            LastZone				= currentZone
            TriggerServerEvent('esx_viande:GetUserInventory', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_viande:hasExitedMarker', LastZone)
        end

        if isInMarker and isInZone then
            TriggerEvent('esx_viande:hasEnteredMarker', 'exitMarker')
        end

    end
end)


-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustReleased(0, Keys['E']) then
                isInZone = true -- unless we set this boolean to false, we will always freeze the user
                if CurrentAction == 'exitMarker' then
                    isInZone = false -- do not freeze user
                    TriggerEvent('esx_viande:freezePlayer', false)
                    TriggerEvent('esx_viande:hasExitedMarker', lastZone)
                    Citizen.Wait(15000)
                    elseif CurrentAction == 'viande_harvest' then
                        TriggerServerEvent('esx_viande:startHarvestviande')
                    elseif CurrentAction == 'viande_treatment' then
                        TriggerServerEvent('esx_viande:startTransformviande')
                    elseif CurrentAction == 'viande_resell' then
                        TriggerServerEvent('esx_viande:startSellviande')
                else
                    isInZone = false
                end

                if isInZone then
                    TriggerEvent('esx_viande:freezePlayer', true)
                end

                CurrentAction = nil
            end
        end
    end
end)

RegisterNetEvent('esx_viande:freezePlayer')
AddEventHandler('esx_viande:freezePlayer', function(freeze)
    FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)
