local WaitTime = 60000 -- How often do you want to update the status (In MS)

local DiscordAppId = tonumber(GetConvar("RichAppId", "572023461803982863"))
local DiscordAppAsset = GetConvar("RichAssetId", "boucv21")
        
Citizen.CreateThread(function()
        SetDiscordAppId(DiscordAppId)
        SetDiscordRichPresenceAsset(DiscordAppAsset)
        while true do
                local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
                local StreetHash = GetStreetNameAtCoord(x, y, z)
                Citizen.Wait(WaitTime)
                if StreetHash ~= nil then
                        StreetName = GetStreetNameFromHashKey(StreetHash)
                        if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
                                if IsPedSprinting(PlayerPedId()) then
                                        SetRichPresence("Cours à "..StreetName)
                                elseif IsPedRunning(PlayerPedId()) then
                                        SetRichPresence("Sprinte à "..StreetName)
                                elseif IsPedWalking(PlayerPedId()) then
                                        SetRichPresence("Se balade à "..StreetName)
                                elseif IsPedStill(PlayerPedId()) then
                                        SetRichPresence("Posé à "..StreetName)
                                end
                        elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
                                local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                                if MPH > 50 then
                                        SetRichPresence("Roule à fond sur "..StreetName.." en "..VehName)
                                elseif MPH <= 50 and MPH > 0 then
                                        SetRichPresence("Roule pénard sur "..StreetName.." en "..VehName)
                                elseif MPH == 0 then
                                        SetRichPresence("Garé à "..StreetName.." en "..VehName)
                                end
                        elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
                                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                                if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
                                        SetRichPresence("Vole au dessus de "..StreetName.." en "..VehName)
                                else
                                        SetRichPresence("Est posé à "..StreetName.." en "..VehName)
                                end
                        elseif IsEntityInWater(PlayerPedId()) then
                                SetRichPresence("Nage")
                        elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                                SetRichPresence("Navigue en "..VehName)
                        elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                                SetRichPresence("In a yellow submarine")
                        end
                end
        end
end)