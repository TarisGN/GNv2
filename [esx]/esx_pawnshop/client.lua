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
   
ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local blips = {
      {title="Export", colour=4, id=133, x = -826.44, y = -1261.76, z = 5.0}
}
 
      
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
  
local gym = {
    {x = -826.44, y = -1261.76, z = 5.0}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(gym) do
            DrawMarker(21, gym[k].x, gym[k].y, gym[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 153, 255, 255, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(gym) do
		
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour vendre~w~')
				
				if IsControlJustPressed(0, Keys['E']) then
					OpenPawnMenu()
				end			
            end
        end
    end
end)

function OpenPawnMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Pawnshop',
            elements = {
				{label = 'Achats', value = 'shop'},
				{label = 'Vendre', value = 'sell'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
				OpenPawnShopMenu()
            elseif data.current.value == 'sell' then
				OpenSellMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenPawnShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_shop_menu',
        {
            title    = 'Boutique',
            elements = {
				{label = 'Rien pour le moment', value = 'biere'},
            }
        },
        function(data, menu)
            if data.current.value == 'fixkit' then
				TriggerServerEvent('esx_pawnshop:buyFixkit')
            elseif data.current.value == 'bulletproof' then
				TriggerServerEvent('esx_pawnshop:buyBulletproof')
            elseif data.current.value == 'drill' then
				TriggerServerEvent('esx_pawnshop:buyDrill')
            elseif data.current.value == 'blindfold' then
				TriggerServerEvent('esx_pawnshop:buyBlindfold')
            elseif data.current.value == 'fishingrod' then
                TriggerServerEvent('esx_pawnshop:buyFishingrod')
            elseif data.current.value == 'antibiotika' then
                TriggerServerEvent('esx_pawnshop:buyAntibiotika')  
            elseif data.current.value == 'phone' then
				TriggerServerEvent('esx_pawnshop:buyPhone')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSellMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_sell_menu',
        {
            title    = 'Avez-vous l\'un des produits suivants que vous souhaitez vendre?',
            elements = {
                {label = 'Grand Cru', value = 'grand_cru'},
                {label = 'Soda', value = 'soda'},
                {label = 'Biere', value = 'biere'},
                {label = 'Menus Complets', value = 'menu'},
                {label = 'hamburger', value = 'hamburger'},

            }
        },
        function(data, menu)
            if data.current.value == 'grand_cru' then
				TriggerServerEvent('esx_pawnshop:sellgrand_cru')
            elseif data.current.value == 'soda' then
				TriggerServerEvent('esx_pawnshop:sellsoda')
            elseif data.current.value == 'biere' then
				TriggerServerEvent('esx_pawnshop:sellbiere')
            elseif data.current.value == 'hamburger' then
				TriggerServerEvent('esx_pawnshop:sellhamburger')
            elseif data.current.value == 'menu' then
				TriggerServerEvent('esx_pawnshop:sellmenu')
                     end
        end,
        function(data, menu)
            menu.close()
        end
    )
end





