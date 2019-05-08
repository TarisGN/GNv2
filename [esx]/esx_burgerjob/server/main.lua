ESX                = nil
local ShopItems = {}
local hasSqlRun = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'burgershot', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'burgershot', _U('burgershot_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'burgershot', 'BurgerShot', 'society_burgershot', 'society_burgershot', 'society_burgershot', {type = 'private'})



RegisterServerEvent('esx_burgerjob:getStockItem')
AddEventHandler('esx_burgerjob:getStockItem', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_burgershot', function(inventory)

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

ESX.RegisterServerCallback('esx_burgerjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_burgershot', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_burgerjob:putStockItems')
AddEventHandler('esx_burgerjob:putStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_burgershot', function(inventory)

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

ESX.RegisterServerCallback('esx_burgerjob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_burgershot', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_burgerjob:addVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_burgershot', function(store)

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




RegisterServerEvent('esx_burgerjob:craftingCoktails')
AddEventHandler('esx_burgerjob:craftingCoktails', function(itemValue)

    local _source = source
    local _itemValue = itemValue
    TriggerClientEvent('esx:showNotification', _source, _U('assembling_cocktail'))

    if _itemValue == 'hamburger' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('viande').count
            local bethQuantity      = xPlayer.getInventoryItem('pain').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('viande') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('pain') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('viande', 2)
                    xPlayer.removeInventoryItem('pain', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('hamburger') .. ' ~w~!')
                    xPlayer.removeInventoryItem('viande', 2)
                    xPlayer.removeInventoryItem('pain', 2)
                    xPlayer.addInventoryItem('hamburger', 1)
                end
            end

        end)
    end


    if _itemValue == 'menu' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('patate').count
            local bethQuantity      = xPlayer.getInventoryItem('viande').count
            local gimelQuantity     = xPlayer.getInventoryItem('pain').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('patate') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('viande') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('pain') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('patate', 2)
                    xPlayer.removeInventoryItem('viande', 2)
                    xPlayer.removeInventoryItem('pain', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('menu') .. ' ~w~!')
                    xPlayer.removeInventoryItem('patate', 2)
                    xPlayer.removeInventoryItem('viande', 2)
                    xPlayer.removeInventoryItem('pain', 2)
                    xPlayer.addInventoryItem('menu', 1)
                end
            end

        end)
    end

end)





ESX.RegisterServerCallback('esx_burgerjob:removeVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_burgershot', function(store)

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

ESX.RegisterServerCallback('esx_burgerjob:getPlayerInventory', function(source, cb)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)