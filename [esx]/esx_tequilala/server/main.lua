ESX                = nil

local PlayersSelling       = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'tequilala', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'tequilala', _U('tequilala_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'tequilala', 'Tequilala', 'society_tequilala', 'society_tequilala', 'society_tequilala', {type = 'private'})



RegisterServerEvent('esx_tequilalajob:getStockItem')
AddEventHandler('esx_tequilalajob:getStockItem', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala', function(inventory)

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

ESX.RegisterServerCallback('esx_tequilalajob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_tequilalajob:putStockItems')
AddEventHandler('esx_tequilalajob:putStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala', function(inventory)

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


RegisterServerEvent('esx_tequilalajob:getFridgeStockItem')
AddEventHandler('esx_tequilalajob:getFridgeStockItem', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala_fridge', function(inventory)

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

ESX.RegisterServerCallback('esx_tequilalajob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_tequilalajob:putFridgeStockItems')
AddEventHandler('esx_tequilalajob:putFridgeStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequilala_fridge', function(inventory)

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


RegisterServerEvent('esx_tequilalajob:buyItem')
AddEventHandler('esx_tequilalajob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tequilala', function(account)
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


RegisterServerEvent('esx_tequilalajob:craftingCoktails')
AddEventHandler('esx_tequilalajob:craftingCoktails', function(itemValue)

    local _source = source
    local _itemValue = itemValue
    TriggerClientEvent('esx:showNotification', _source, _U('assembling_cocktail'))

    if _itemValue == 'caissebiere' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count
            
            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packbiere') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('biere', 4)
                end
            end

        end)
    end

    if _itemValue == 'caissevodka' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packvodka') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('vodka', 3)
                end
            end

        end)
    end

    if _itemValue == 'caissewhisky' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packwhisky') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('whisky', 3)
                end
            end

        end)
    end

if _itemValue == 'caissesake' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packsake') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('sake', 3)
                end
            end

        end)
    end


if _itemValue == 'caisseenergy' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packenergy') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('energy', 6)
                end
            end

        end)
    end

if _itemValue == 'caissesoda' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('caisse').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('caisse') .. '~w~')
            
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('caisse', 1)
                
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('packsoda') .. ' ~w~!')
                    xPlayer.removeInventoryItem('caisse', 1)        
                    xPlayer.addInventoryItem('soda', 6)
                end
            end

        end)
    end

    -- if _itemValue == 'golem' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('limonade').count
    --         local bethQuantity      = xPlayer.getInventoryItem('vodka').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('ice').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
    --         elseif gimelQuantity < 1 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('golem') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --                 xPlayer.addInventoryItem('golem', 1)
    --             end
    --         end

    --     end)
    -- end
    
    if _itemValue == 'whiskycoca' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('soda').count
            local bethQuantity      = xPlayer.getInventoryItem('whisky').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('soda') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('whiskycoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.addInventoryItem('whiskycoca', 1)
                end
            end

        end)
    end

    -- if _itemValue == 'rhumcoca' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('soda').count
    --         local bethQuantity      = xPlayer.getInventoryItem('rhum').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('soda') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('soda', 2)
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumcoca') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('soda', 2)
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --                 xPlayer.addInventoryItem('rhumcoca', 1)
    --             end
    --         end

    --     end)
    -- end

    if _itemValue == 'vodkaenergy' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('energy').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
          
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkaenergy') .. ' ~w~!')
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.addInventoryItem('vodkaenergy', 1)
                end
            end

        end)
    end

    -- if _itemValue == 'vodkafruit' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
    --         local bethQuantity      = xPlayer.getInventoryItem('vodka').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('ice').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
    --         elseif gimelQuantity < 1 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('jusfruit', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkafruit') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('jusfruit', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --                 xPlayer.addInventoryItem('vodkafruit', 1) 
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'rhumfruit' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
    --         local bethQuantity      = xPlayer.getInventoryItem('rhum').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('ice').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
    --         elseif gimelQuantity < 1 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('jusfruit', 2)
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumfruit') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('jusfruit', 2)
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --                 xPlayer.addInventoryItem('rhumfruit', 1)
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'teqpaf' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('limonade').count
    --         local bethQuantity      = xPlayer.getInventoryItem('tequila').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('teqpaf') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --                 xPlayer.addInventoryItem('teqpaf', 1)
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'mojito' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('rhum').count
    --         local bethQuantity      = xPlayer.getInventoryItem('limonade').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('menthe').count
    --         local daletQuantity      = xPlayer.getInventoryItem('ice').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
    --         elseif gimelQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('menthe') .. '~w~')
    --         elseif daletQuantity < 1 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('menthe', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mojito') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('rhum', 2)
    --                 xPlayer.removeInventoryItem('limonade', 2)
    --                 xPlayer.removeInventoryItem('menthe', 2)
    --                 xPlayer.removeInventoryItem('ice', 1)
    --                 xPlayer.addInventoryItem('mojito', 1)
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'mixapero' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('bolcacahuetes').count
    --         local bethQuantity      = xPlayer.getInventoryItem('bolnoixcajou').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('bolpistache').count
    --         local daletQuantity     = xPlayer.getInventoryItem('bolchips').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolcacahuetes') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolnoixcajou') .. '~w~')
    --         elseif gimelQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolpistache') .. '~w~')
    --         elseif daletQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolchips') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('bolcacahuetes', 2)
    --                 xPlayer.removeInventoryItem('bolnoixcajou', 2)
    --                 xPlayer.removeInventoryItem('bolpistache', 2)
    --                 xPlayer.removeInventoryItem('bolchips', 1)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mixapero') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('bolcacahuetes', 2)
    --                 xPlayer.removeInventoryItem('bolnoixcajou', 2)
    --                 xPlayer.removeInventoryItem('bolpistache', 2)
    --                 xPlayer.removeInventoryItem('bolchips', 2)
    --                 xPlayer.addInventoryItem('mixapero', 1)
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'metreshooter' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('jager').count
    --         local bethQuantity      = xPlayer.getInventoryItem('vodka').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('whisky').count
    --         local daletQuantity     = xPlayer.getInventoryItem('tequila').count

    --         if alephQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
    --         elseif gimelQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
    --         elseif daletQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('jager', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('whisky', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('metreshooter') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('jager', 2)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('whisky', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --                 xPlayer.addInventoryItem('metreshooter', 1)
    --             end
    --         end

    --     end)
    -- end

    -- if _itemValue == 'jagercerbere' then
    --     SetTimeout(10000, function()        

    --         local xPlayer           = ESX.GetPlayerFromId(_source)

    --         local alephQuantity     = xPlayer.getInventoryItem('jagerbomb').count
    --         local bethQuantity      = xPlayer.getInventoryItem('vodka').count
    --         local gimelQuantity     = xPlayer.getInventoryItem('tequila').count

    --         if alephQuantity < 1 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jagerbomb') .. '~w~')
    --         elseif bethQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
    --         elseif gimelQuantity < 2 then
    --             TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
    --         else
    --             local chanceToMiss = math.random(100)
    --             if chanceToMiss <= Config.MissCraft then
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
    --                 xPlayer.removeInventoryItem('jagerbomb', 1)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --             else
    --                 TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('jagercerbere') .. ' ~w~!')
    --                 xPlayer.removeInventoryItem('jagerbomb', 1)
    --                 xPlayer.removeInventoryItem('vodka', 2)
    --                 xPlayer.removeInventoryItem('tequila', 2)
    --                 xPlayer.addInventoryItem('jagercerbere', 1)
    --             end
    --         end

    --     end)
    -- end

end)


ESX.RegisterServerCallback('esx_tequilalajob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tequilala', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_tequilalajob:addVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tequilala', function(store)

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

ESX.RegisterServerCallback('esx_tequilalajob:removeVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tequilala', function(store)

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

ESX.RegisterServerCallback('esx_tequilalajob:getPlayerInventory', function(source, cb)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

----------------ACHAT PNJ---------------
RegisterServerEvent('esx_tequilala:pedBuyCig')
AddEventHandler('esx_tequilala:pedBuyCig', function()
  
  local _source       = source
  local xPlayer       = ESX.GetPlayerFromId(_source)
  local resellChances = {}
  local cigTypeMagic  = math.random(0, 100)
  local chosenCig     = nil
  local prices        = nil

  if highPrice then
    prices = Config.CigPricesHigh
  else
    prices = Config.CigPrices
  end

  for k,v in pairs(Config.CigResellChances) do
    table.insert(resellChances, {cig = k, chance = v})
  end

  table.sort(resellChances, function(a, b)
    return a.chance < b.chance
  end)

  local count = 0

  for i=1, #resellChances, 1 do
    
    count = count + resellChances[i].chance

    if cigTypeMagic <= count then
      chosenCig = resellChances[i].cig
      break
    end

  end

  local pricePerUnit = randomFloat(prices[chosenCig].min, prices[chosenCig].max)
  local quantity     = math.random(Config.CigResellQuantity[chosenCig].min, Config.CigResellQuantity[chosenCig].max)
  local item         = xPlayer.getInventoryItem(chosenCig)
  local societyAccount  = nil

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tequilala', function(account)
    societyAccount = account
  end)

  if item.count > 0 then

    if item.count < quantity then

      local price = math.floor(item.count * pricePerUnit)

      xPlayer.removeInventoryItem(chosenCig, item.count)
      societyAccount.addMoney(price)
      
      TriggerClientEvent('esx:showNotification', _source, 'Vous avez gagné ~g~$' .. price .. '~s~ pour ~y~x' .. item.count .. ' ' .. item.label)
    else

      local price = math.floor(quantity * pricePerUnit)

      xPlayer.removeInventoryItem(chosenCig, quantity)
      societyAccount.addMoney(price)

      TriggerClientEvent('esx:showNotification', _source, 'Vous avez gagné ~g~$' .. price .. '~s~ pour ~y~x' .. quantity .. ' ' .. item.label)
    end

  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas les cigarettes demandées [' .. item.label .. ']')
  end

end)

RegisterServerEvent('esx_tequilala:pedCallPolice')
AddEventHandler('esx_tequilala:pedCallPolice', function()
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do

        local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
            
        if xPlayer2.job.name == 'crypted' then
            TriggerClientEvent('esx_cryptedphone:onMessage', xPlayer2.source, '', 'Une personne a essayé de me vendre des trucs', xPlayer.get('coords'), true, 'Alerte Moldu', false)
        end
    end
end)



local function Sell(source, zone)

  if PlayersSelling[source] == true then
    local xPlayer  = ESX.GetPlayerFromId(source)
    
    if zone == 'SellFarm' then
      if xPlayer.getInventoryItem('biere').count <= 0 then
        biere = 0
      else
        biere = 1
      end
      
      if xPlayer.getInventoryItem('soda').count <= 0 then
        soda = 0
      else
        soda = 1
      end
    
      if biere == 0 and soda == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
        return
      elseif xPlayer.getInventoryItem('biere').count <= 0 and soda == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_biere_sale'))
        biere = 0
        return
      elseif xPlayer.getInventoryItem('soda').count <= 0 and biere == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_soda_sale'))
        soda = 0
        return
      else
        if (soda == 1) then
          SetTimeout(1100, function()
            local money = math.random(80,115)
            xPlayer.removeInventoryItem('soda', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tequilala', function(account)
              societyAccount = account
            end)
            if societyAccount ~= nil then
              societyAccount.addMoney(money)
              TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
            end
            Sell(source,zone)
          end)
        elseif (biere == 1) then
          SetTimeout(1100, function()
            local money = math.random(120,175)
            xPlayer.removeInventoryItem('biere', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tequilala', function(account)
              societyAccount = account
            end)
            if societyAccount ~= nil then
              societyAccount.addMoney(money)
              TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
            end
            Sell(source,zone)
          end)
        end
        
      end
    end
  end
end





RegisterServerEvent('esx_tequilala:startSell')
AddEventHandler('esx_tequilala:startSell', function(zone)

  local _source = source
  
  if PlayersSelling[_source] == false then
    TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
    PlayersSelling[_source]=false
  else
    PlayersSelling[_source]=true
    TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
    Sell(_source, zone)
  end

end)

RegisterServerEvent('esx_tequilala:stopSell')
AddEventHandler('esx_tequilala:stopSell', function()

  local _source = source
  
  if PlayersSelling[_source] == true then
    PlayersSelling[_source]=false
    TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
    
  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
    PlayersSelling[_source]=true
  end

end)

