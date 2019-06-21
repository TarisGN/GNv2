-- CLIENT VENTE
-- ENTER MARKER

  if zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance'  then
    CurrentAction     = 'farm_resell'
    CurrentActionMsg  = _U('press_sell')
    CurrentActionData = {zone = zone}
  end

  --EXIT MARKER

   if (zone == 'SellFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
    TriggerServerEvent('esx_ambulancejob:stopSell')
  end

  --key controls

  if CurrentAction == 'farm_resell' then
                TriggerServerEvent('esx_ambulancejob:startSell', CurrentActionData.zone)
            end


 -- SERVER

 ----------------ACHAT PNJ---------------
RegisterServerEvent('esx_ambulancejob:pedBuyCig')
AddEventHandler('esx_ambulancejob:pedBuyCig', function()
  
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

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
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

RegisterServerEvent('esx_ambulancejob:pedCallPolice')
AddEventHandler('esx_ambulancejob:pedCallPolice', function()
	
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
      if xPlayer.getInventoryItem('medicament').count <= 0 then
        medicament = 0
      else
        medicament = 1
      end
      
      if xPlayer.getInventoryItem('pilules').count <= 0 then
        pilules = 0
      else
        pilules = 1
      end
    
      if medicament == 0 and pilules == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
        return
      elseif xPlayer.getInventoryItem('medicament').count <= 0 and pilules == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_medicament_sale'))
        medicament = 0
        return
      elseif xPlayer.getInventoryItem('pilules').count <= 0 and medicament == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_pilules_sale'))
        pilules = 0
        return
      else
        if (pilules == 1) then
          SetTimeout(1100, function()
            local money = math.random(65,70)
            xPlayer.removeInventoryItem('pilules', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
              societyAccount = account
            end)
            if societyAccount ~= nil then
              societyAccount.addMoney(money)
              TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
            end
            Sell(source,zone)
          end)
        elseif (medicament == 1) then
          SetTimeout(1100, function()
            local money = math.random(60,65)
            xPlayer.removeInventoryItem('medicament', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
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

RegisterServerEvent('esx_ambulancejob:startSell')
AddEventHandler('esx_ambulancejob:startSell', function(zone)

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

RegisterServerEvent('esx_ambulancejob:stopSell')
AddEventHandler('esx_ambulancejob:stopSell', function()

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
  'medicament',
  'pilules'
}

Config.CigResellChances = {
  medicament = 25,
  pilules = 35,
}

Config.CigResellQuantity= {
  medicament = {min = 5, max = 10},
  pilules = {min = 5, max = 10},
}

Config.CigPrices = {
  medicament = {min = 15, max = 10},
  pilules = {min = 15,   max = 15},
}

Config.CigPricesHigh = {
  medicament = {min = 45, max = 10},
  pilules = {min = 35,   max = 15},
}

Config.Time = {
	medicament = 5 * 60,
	pilules = 5 * 60,
}


-- lieux

  SellFarm = {
    Pos   = {x = 359.86, y = -585.45, z = 28.82},
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
	Color = {r = 136, g = 243, b = 216},
    Name  = "Vente des produits",
    Type  = 1
  },