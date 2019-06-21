ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


-- RegisterServerEvent('esx_pawnshop:buypain')
-- AddEventHandler('esx_pawnshop:buypain', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 30) then
-- 		xPlayer.removeMoney(30)
		
-- 		xPlayer.addInventoryItem('pain', 1)
		
-- 		notification("Du köpte en ~g~Reparationslåda")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)


-- RegisterServerEvent('esx_pawnshop:buyBulletproof')
-- AddEventHandler('esx_pawnshop:buyBulletproof', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 35000) then
-- 		xPlayer.removeMoney(35000)
		
-- 		xPlayer.addInventoryItem('bulletproof', 1)
		
-- 		notification("Du köpte en ~g~Skottsäker väst")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)


-- RegisterServerEvent('esx_pawnshop:buyDrill')
-- AddEventHandler('esx_pawnshop:buyDrill', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 45000) then
-- 		xPlayer.removeMoney(45000)
		
-- 		xPlayer.addInventoryItem('drill', 1)
		
-- 		notification("Du köpte en ~g~borrmaskin")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)


-- RegisterServerEvent('esx_pawnshop:buybiere')
-- AddEventHandler('esx_pawnshop:buybiere', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 16214) then
-- 		xPlayer.removeMoney(16214)
		
-- 		xPlayer.addInventoryItem('biere', 1)
		
-- 		notification("Du köpte en ~g~ögonbindel")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)


-- RegisterServerEvent('esx_pawnshop:buysoda')
-- AddEventHandler('esx_pawnshop:buysoda', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 2591) then
-- 		xPlayer.removeMoney(2591)
		
-- 		xPlayer.addInventoryItem('fishing_rod', 1)
		
-- 		notification("Du köpte en ~g~fiskespö")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)

-- RegisterServerEvent('esx_pawnshop:buyAntibiotika')
-- AddEventHandler('esx_pawnshop:buyAntibiotika', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 1239) then
-- 		xPlayer.removeMoney(1239)
		
-- 		xPlayer.addInventoryItem('anti', 1)
		
-- 		notification("Du köpte en ~g~antibiotika")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)

-- RegisterServerEvent('esx_pawnshop:buyPhone')
-- AddEventHandler('esx_pawnshop:buyPhone', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 3400) then
-- 		xPlayer.removeMoney(3400)
		
-- 		xPlayer.addInventoryItem('phone', 1)
		
-- 		notification("Du köpte en ny ~g~telefon")
-- 	else
-- 		notification("Du har inte tillräckligt med ~r~pengar")
-- 	end		
-- end)


-----Vente


RegisterServerEvent('esx_pawnshop:sellgrand_cru')
AddEventHandler('esx_pawnshop:sellgrand_cru', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local grand_cru = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "grand_cru" then
			grand_cru = item.count
		end
	end
    
    if grand_cru > 0 then
        xPlayer.removeInventoryItem('grand_cru', 1)
        xPlayer.addMoney(65)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'plus de grand cru!')
    end
end)

RegisterServerEvent('esx_pawnshop:sellmenu')
AddEventHandler('esx_pawnshop:sellmenu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local menu = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "menu" then
			menu = item.count
		end
	end
    
    if menu > 0 then
        xPlayer.removeInventoryItem('menu', 1)
        xPlayer.addMoney(82)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Plus de Menus à vendre !')
    end
end)

RegisterServerEvent('esx_pawnshop:sellhamburger')
AddEventHandler('esx_pawnshop:sellhamburger', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local hamburger = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "hamburger" then
			hamburger = item.count
		end
	end
    
    if hamburger > 0 then
        xPlayer.removeInventoryItem('hamburger', 1)
        xPlayer.addMoney(75)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'plus de hamburger !')
    end
end)

RegisterServerEvent('esx_pawnshop:sellsoda')
AddEventHandler('esx_pawnshop:sellsoda', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local soda = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "soda" then
			soda = item.count
		end
	end
  
    if soda > 0 then
        xPlayer.removeInventoryItem('soda', 1)
        xPlayer.addMoney(12)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Plus de soda')
    end
end)


RegisterServerEvent('esx_pawnshop:sellbiere')
AddEventHandler('esx_pawnshop:sellbiere', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local biere = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "biere" then
			biere = item.count
		end
	end
    
    if biere > 0 then
        xPlayer.removeInventoryItem('biere', 1)
        xPlayer.addMoney(22)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Plus de bière à vendre')
    end
end)


function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end