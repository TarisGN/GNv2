--CLIENT

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer2.coords, true) < 0.5 then
			if not menu2Open then
				ESX.ShowHelpNotification(_U('dealer_prompt2'))

				if IsControlJustReleased(0, Keys['E']) then
					was2Open = true
					OpenDrugShop2()
				end
			else
				Citizen.Wait(500)
			end
		else
			if was2Open then
				was2Open = false
				ESX.UI.Menu.CloseAll()
			end

			Citizen.Wait(500)
		end
	end
end)

function OpenDrugShop2()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menu2Open = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrugDealerItems2[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,

				-- menu properties
				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop2', {
		title    = _U('dealer_title2'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_drugs:sellDrug2', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menu2Open = false
	end)
end

---SERV

RegisterServerEvent('esx_drugs:sellDrug2')
AddEventHandler('esx_drugs:sellDrug2', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold2', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)