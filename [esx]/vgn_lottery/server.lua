ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

identifier = nil


-- Lottery command, either specified numbers for a ticket or randomly generated ones. When multiple tickets are bought the numbers are always psuedorandom.
TriggerEvent('es:addCommand',  'lotte​ry', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local num1 = args[2]
    local nu​m2 = args[3]
    local num3 = args[4]
    local amtTickets = 1
    if num1 ~= "random" then
        num1 = ton​umber(num1)
        num2 = tonumber(num2)
        num3 = tonumber(num3)
        amtTickets = tonumber(amtTickets)
    else
        amtTickets = args[3]
        amtTickets = tonumber(amtTickets)
    end
    if amtTickets <= 100 then
        for i=1, amtTickets, 1 do
            num1 = math.random(1,100)
            num2 = math.ra​ndom(1,100)
            num3 = math.random(1,100)
            if num1 < 100 or num2 < 100 or num3 < 100 then
                if xPl​ayer.getMoney() >= 10 then
                    MySQL.Async.execute(
                    'INSERT INTO v​gn_lottery (identifier, numbers) VALUES (@identifier, @numbers)',
                        {
                            ['@identifier'] = xPlayer.identifier,
                            ['@numbers'] = num1..num2..num3,
                        },
                        function(rowsChanged)
                            xPlayer.removeMoney(10)
                        end)
                    TriggerClientE​vent("chatMessage", source, "Lottery", {0, 150, 150}, "You've enter the lottery with numbers: "..num1.." "..num2.." "..num3)
                else
                    TriggerClientE​vent("chatMessage", source, "Lottery", {0, 150, 150}, "You don't have enough money on you to buy a ticket.")
                end
            else
                TriggerClien​tEvent("chatMessage", source, "Lottery", {0, 150, 150}, "The numbers must be less than 100.")
            end
        end
    else
        TriggerClient​Event("chatMessage", source, "Lottery", { 0, 150, 150 }, "You may not buy more than 100 tickets at once.")
    end
end)

--Draw lottery command. Needed permission level of 3 or higher. Superadmin override.
TriggerEvent('es:addAdminCommand', 'drawlottery', 3, function(source, args, user)
    drawLottery()
end, function(source, args, user)
    TriggerC​lientEvent("ch​atMessage", source, "Lottery", { 0, 150, 150 }, "You do not have permission to draw the lottery.")
end)


TriggerEvent('es:addCommand','lotterypot', function(source, args, user)
    local potAmt = 0
    MySQL.Async.​fetchAll('SELECT * FROM vgn_lottery', {},
        function(result)
            for i=1,​ #result, 1 do
                potAmt = potAmt + 1
            end
            MySQL.Async.fetchAll('SELECT * FROM datastore_data WHERE name = @name',
                {
                    ['@name'] = "system"
                },
                function(result)
                    potAmt = potAmt + result[1].data
                    TriggerCli​entEvent("chatMessage", source, "Lottery", { 0, 150, 150 }, "The jackpot is currently at: $"..potAmt*10)
                end)
        end)
end)

-- Automatic drawing of lottery
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if os.date("%X") == "16:55:00" then
            Citizen.Wait(1000)
            TriggerCl​ientEvent("chatMessage", source, "Lottery", { 0, 150, 150 }, "A drawing will happen in 5 minutes!")
        end
        if os.date("%X") == "17:55:00" then
            drawLottery()
            Citi​zen.Wait(1000)
        end
    end
end)


-- Lottery picker function
function drawLottery()
    MySQL.Async.fetchAll(
        'SELECT * FROM vgn_lottery WHERE numbers = @numbers',
        {
            ['@numbers'] = math.random(1,100)..math.random(1,100)..math.random(1,100),
        },
        function(result)
            if result[1] ~= nil then
                identifier = result[1].identifier
                loca​l xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                local moneyGained = 0
                MySQL.Async.fetchAll('SELECT * FROM vgn_lottery', {}, function(result)
                    for i=1, #result, 1 do
                        money​Gained = moneyGained + 1
                    end
                    MySQL.Async.fetchAll('SELECT * FROM datastore_data WHERE name = @name',
                        {
                            ['@name'] = "sy​stem",
                        },
                        function(result)
                            money​Gained = moneyGained + result[1].data
                            if xPlayer == nil then
                                MySQL.Async.fetchAll(
                                'SELECT * FROM us​ers WHERE identifier = @identifier',
                                    {
                                        ['@iden​tifier'] = identifier,
                                    },
                                    function(result)
                                        TriggerClientEvent("chatMessage", -1, "Lottery", {0, 150, 150}, result[1].name.." has just won the Mega Millions. Congrats! They won: $"..moneyG​ained*10)
                                        MySQL.Sync.execute('UPDATE users SET money=@money WHERE identifier=@identifier', {['@money'] = result[1].money + moneyGained*10, ['@identifier'] = iden​tifier})
                                    end
                                )
                            else
                                TriggerClient​Event("chatMessage", -1, "Lottery", {0,150,150}, xPlayer.name.." has just won the lottery. Congrats! They won: $"..moneyGained*10)
                                xPlayer.addMoney(moneyGained*10)
                            end
                            MySQL.Sync.exe​cute("UPDATE datastore_data SET data=@data WHERE name=@name", {['@data'] = 0, ['@name'] = 'system'})
                            MySQL.Sync.exe​cute("TRUNCATE TABLE vgn_lottery")
                        end)

                end
                )
            else
                TriggerClientEvent("chatMessage", -1, "Lottery", {0, 150, 150}, "No one has won the lottery. Better luck next time!")
                local tickets = 0
                MySQL.Async.fetchAll('SELECT * FROM vgn_lottery', {}, function(result)
                    for i=1, #result, 1 do
                        tickets = tickets + 1
                    end
                    MySQL.Async.ex​ecute('TRUNCATE TABLE vgn_lottery', {}, function()
                        MySQL.Async.fetchAll('SELECT​ * FROM datastore_data WHERE name = @name',
                            {
                                ['@name'] = "system",
                            },
                            function(result)
                                if result[1].data == 0 then
                                    --Citizen.Trace("No previous tickets found. New round started")
                                    MySQL.Async​.execute('UPDATE datastore_data SET data=@data WHERE name=@name',
                                        {
                                            ['@name'] = "system",
                                            ['@​data'] = tickets,
                                        },
                                    function() end)
                                else
                                    --Citizen.Trace("Tickets detected. "..result[1].data)
                                    MySQL.Async.e​xecute('UPDATE datastore_data SET data=@data WHERE name=@name',
                                        {
                                            ['@name'] = "system",
                                            ['@data'] = tickets + result[1].data,
                                        },
                                        functi​on() end)
                                end
                        end)
                    end)
                en​d)
            end

        end
    )
end

