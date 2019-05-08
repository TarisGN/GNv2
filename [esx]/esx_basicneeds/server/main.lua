ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('pain', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pain', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_pain'))

end)

ESX.RegisterUsableItem('eau', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('eau', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_eau'))

end)

ESX.RegisterUsableItem('hamburger', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_burger'))

end)

ESX.RegisterUsableItem('hamburger2', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger2', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_burger'))

end)

ESX.RegisterUsableItem('icetea', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('icetea', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_icetea'))

end)

ESX.RegisterUsableItem('kebab', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kebab', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_kebab'))

end)

ESX.RegisterUsableItem('sushi', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sushi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_sushi'))

end)

ESX.RegisterUsableItem('pizza', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger',400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_pizza'))

end)

ESX.RegisterUsableItem('sandwich', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 180000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_sand'))

end)


ESX.RegisterUsableItem('cappuccino', function(source)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cappuccino', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_cap'))

end)

ESX.RegisterUsableItem('soda', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('soda', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_soda'))

end)

ESX.RegisterUsableItem('jusfruit', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('jusfruit', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_jusfruit'))

end)

ESX.RegisterUsableItem('energy', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('energy', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_energy'))

end)

ESX.RegisterUsableItem('drpepper', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('drpepper', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_drpepper'))

end)

ESX.RegisterUsableItem('limonade', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('limonade', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_limonade'))

end)

ESX.RegisterUsableItem('mixapero', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('mixapero', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_status:remove', source, 'thirst', 50000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_mixapero'))

end)

ESX.RegisterUsableItem('bolcacahuetes', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('bolcacahuetes', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_bolcacahuetes'))

end)

ESX.RegisterUsableItem('bolnoixcajou', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('bolnoixcajou', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_bolnoixcajou'))

end)

ESX.RegisterUsableItem('bolpistache', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('bolpistache', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_bolpistache'))

end)

ESX.RegisterUsableItem('bolchips', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('bolchips', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_bolchips'))

end)

ESX.RegisterUsableItem('saucisson', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('saucisson', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_saucisson'))

end)

ESX.RegisterUsableItem('ice', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('ice', 1)

        TriggerClientEvent('esx_status:add', source, 'thirst', 100)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_ice'))

end)

ESX.RegisterUsableItem('menthe', function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem('menthe', 1)

        TriggerClientEvent('esx_status:add', source, 'hunger', 100)
        TriggerClientEvent('esx_basicneeds:onEat', source)
        TriggerClientEvent('esx:showNotification', source, _U('used_menthe'))

end)

ESX.RegisterUsableItem('jus_raisin', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jus_raisin', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_jus'))

end)

ESX.RegisterUsableItem('menu', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('menu', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_menu'))

end)