-- CLIENT VENTE
-- ENTER MARKER

  if zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'burgershot'  then
    CurrentAction     = 'farm_resell'
    CurrentActionMsg  = _U('press_sell')
    CurrentActionData = {zone = zone}
  end

  --EXIT MARKER

   if (zone == 'SellFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'burgershot' then
    TriggerServerEvent('esx_burgerjob:stopSell')
  end

  --key controls

  if CurrentAction == 'farm_resell' then
                TriggerServerEvent('esx_burgerjob:startSell', CurrentActionData.zone)
            end


 -- SERVER

 ----------------ACHAT PNJ---------------
RegisterServerEvent('esx_burgerjob:pedBuyCig')
AddEventHandler('esx_burgerjob:pedBuyCig', function()
  
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

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgershot', function(account)
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

RegisterServerEvent('esx_burgerjob:pedCallPolice')
AddEventHandler('esx_burgerjob:pedCallPolice', function()
	
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
      if xPlayer.getInventoryItem('hamburger').count <= 0 then
        hamburger = 0
      else
        hamburger = 1
      end
      
      if xPlayer.getInventoryItem('menu').count <= 0 then
        menu = 0
      else
        menu = 1
      end
    
      if hamburger == 0 and menu == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
        return
      elseif xPlayer.getInventoryItem('hamburger').count <= 0 and menu == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_hamburger_sale'))
        hamburger = 0
        return
      elseif xPlayer.getInventoryItem('menu').count <= 0 and hamburger == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_menu_sale'))
        menu = 0
        return
      else
        if (menu == 1) then
          SetTimeout(1100, function()
            local money = math.random(65,70)
            xPlayer.removeInventoryItem('menu', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgershot', function(account)
              societyAccount = account
            end)
            if societyAccount ~= nil then
              societyAccount.addMoney(money)
              TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
            end
            Sell(source,zone)
          end)
        elseif (hamburger == 1) then
          SetTimeout(1100, function()
            local money = math.random(60,65)
            xPlayer.removeInventoryItem('hamburger', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgershot', function(account)
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

RegisterServerEvent('esx_burgerjob:startSell')
AddEventHandler('esx_burgerjob:startSell', function(zone)

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

RegisterServerEvent('esx_burgerjob:stopSell')
AddEventHandler('esx_burgerjob:stopSell', function()

  local _source = source
  
  if PlayersSelling[_source] == true then
    PlayersSelling[_source]=false
    TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
    
  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
    PlayersSelling[_source]=true
  end

end)

-- CONFIG

Config.Cig = {
  'hamburger',
  'menu'
}

Config.CigResellChances = {
  hamburger = 25,
  menu = 35,
}

Config.CigResellQuantity= {
  hamburger = {min = 5, max = 10},
  menu = {min = 5, max = 10},
}

Config.CigPrices = {
  hamburger = {min = 15, max = 10},
  menu = {min = 15,   max = 15},
}

Config.CigPricesHigh = {
  hamburger = {min = 45, max = 10},
  menu = {min = 35,   max = 15},
}

Config.Time = {
	hamburger = 5 * 60,
	menu = 5 * 60,
}


-- lieux

  SellFarm = {
    Pos   = {x = 68.924179077148, y = 127.1748046875, z = 78.226},
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
	Color = {r = 136, g = 243, b = 216},
    Name  = "Vente des produits",
    Type  = 1
  },