ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'cozinheiro', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'cozinheiro', _U('cozinheiro_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'cozinheiro', 'Cozinheiro', 'society_cozinheiro', 'society_cozinheiro', 'society_cozinheiro', {type = 'private'})



RegisterServerEvent('esx_cozinheirojob:getStockItem')
AddEventHandler('esx_cozinheirojob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_cozinheirojob:Billing')--Not Working...
AddEventHandler('esx_cozinheirojob:Billing', function(money, player)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(player)
  local valor = money

    if xTarget.getMoney() >= valor then
      xTarget.removeMoney(valor)
      xPlayer.addMoney(valor)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "O seu cliente nao tem esse dinheiro, valor: " ..valor)
	  TriggerClientEvent('esx:showNotification', xTarget.source, "Voce nao tem esse dinheiro, valor: " ..valor)
    end
end)--Not Working

ESX.RegisterServerCallback('esx_cozinheirojob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_cozinheirojob:putStockItems')
AddEventHandler('esx_cozinheirojob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_cozinheirojob:getFridgeStockItem')
AddEventHandler('esx_cozinheirojob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_cozinheirojob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_cozinheirojob:putFridgeStockItems')
AddEventHandler('esx_cozinheirojob:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cozinheiro_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_cozinheirojob:buyItem')
AddEventHandler('esx_cozinheirojob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cozinheiro', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
        end
    else
        TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
    end

end)


RegisterServerEvent('esx_cozinheirojob:craftingCoktails')
AddEventHandler('esx_cozinheirojob:craftingCoktails', function(Value)

    local _source = source
    local escolha = Value       
		if escolha == "ovoes" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('manteiga').count
            local bethQuantity      = xPlayer.getInventoryItem('ovo').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Manteiga~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Ovo~w~")
            else
                    TriggerClientEvent('esx:showNotification', _source, "O ovo estrelado esta ~g~pronto~w~")
                    xPlayer.removeInventoryItem('ovo', 1)
                    xPlayer.removeInventoryItem('manteiga', 1)
                    xPlayer.addInventoryItem('ovoes', 1)
            end
		elseif escolha == "vitela" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('manteiga').count
            local bethQuantity      = xPlayer.getInventoryItem('vitela').count
			local bethQuantity2      = xPlayer.getInventoryItem('oregaos').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Manteiga~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Vitela Crua~w~")
            elseif bethQuantity2 < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Oregaos~w~")
            else
                    TriggerClientEvent('esx:showNotification', _source, "A vitela assada esta ~g~pronta~w~")
                    xPlayer.removeInventoryItem('oregaos', 1)
					xPlayer.removeInventoryItem('vitela', 1)
                    xPlayer.removeInventoryItem('manteiga', 1)
                    xPlayer.addInventoryItem('vitelaass', 1)
            end
		elseif escolha == "polvo" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('manteiga').count
            local bethQuantity      = xPlayer.getInventoryItem('polvo').count
			local bethQuantity2      = xPlayer.getInventoryItem('alho').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Manteiga~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Polvo~w~")
            elseif bethQuantity2 < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Alho~w~")
            else
                    TriggerClientEvent('esx:showNotification', _source, "O polvo grelhado esta ~g~pronto~w~")
                    xPlayer.removeInventoryItem('alho', 1)
					xPlayer.removeInventoryItem('polvo', 1)
                    xPlayer.removeInventoryItem('manteiga', 1)
                    xPlayer.addInventoryItem('polvogre', 1)
            end
		elseif escolha == "ham" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('bread').count
            local bethQuantity      = xPlayer.getInventoryItem('carnep').count
			local bethQuantity2      = xPlayer.getInventoryItem('alface').count
			local bethQuantity3      = xPlayer.getInventoryItem('tomate').count
			local bethQuantity4      = xPlayer.getInventoryItem('queijo').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Pao~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Carne Picada~w~")
            elseif bethQuantity2 < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Alface~w~")
            elseif bethQuantity3 < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Tomate~w~")
            elseif bethQuantity4 < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Falta ~r~Queijo~w~")
            else
                    TriggerClientEvent('esx:showNotification', _source, "O Hamburguer esta ~g~pronto~w~")
                    xPlayer.removeInventoryItem('bread', 1)
					xPlayer.removeInventoryItem('carnep', 1)
                    xPlayer.removeInventoryItem('alface', 1)
					xPlayer.removeInventoryItem('tomate', 1)
					xPlayer.removeInventoryItem('queijo', 1)
                    xPlayer.addInventoryItem('hamb', 1)
            end
		else
			TriggerClientEvent('esx:showNotification', _source, "Rip ~r~ERRO 404~w~")
		end
end)

RegisterServerEvent('esx_cozinheirojob:shop')
AddEventHandler('esx_cozinheirojob:shop', function(item, valor)

    local _source = source
    local xPlayer           = ESX.GetPlayerFromId(_source)
	local comida = item
	local preco = valor
	if xPlayer.getMoney() >= preco then
        xPlayer.removeMoney(preco)
        xPlayer.addInventoryItem(comida, 1)
	end
end)

ESX.RegisterServerCallback('esx_cozinheirojob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_cozinheiro', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_cozinheirojob:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_cozinheiro', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_cozinheirojob:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_cozinheiro', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_cozinheirojob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
