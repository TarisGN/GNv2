local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("gamz-food:removeMoney")
AddEventHandler("gamz-food:removeMoney", function(money)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.removeMoney(money)
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgershot', function(account)
      societyAccount = account
    end)
    if societyAccount ~= nil then
      societyAccount.addMoney(money)
end
end)