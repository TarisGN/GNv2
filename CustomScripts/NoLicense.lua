--[[
----------------------------------------------------------------------------
____________________________________________________________________________
						
						AUTHOR : Dennis (∂єѕαѕтєя)

			Afficher un texte "Vous conduiseez sans permis"
			Add text "You're driving without a license"

						
____________________________________________________________________________
						
---------------------------------------------------------------------------
]]--


Citizen.CreateThread(function()
    while true do

        local ownedLicenses = {}

        for i=1, #Licenses, 1 do
          ownedLicenses[Licenses[i].type] = true
        end

        Citizen.Wait(1)
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and (not ownedLicenses['dmv'] or not ownedLicenses['drive']) and CurrentTest ~= 'drive' then
          DrawMissionText("~r~Vous conduisez sans permis !", 2000)
        end

    end
end)