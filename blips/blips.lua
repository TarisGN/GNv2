local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},

	{title="TABAC", colour=1, id=162, x= 2860,  y= 4630, z= 46.987},
	{title="PATATES", colour=1, id=162, x= 567, y= 6473.0, z= 30},
	{title="IMPORT", colour=1, id=162,  x= -520, y= -2829.76, z= 6.0}
	 
  }
      
Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
	
--


