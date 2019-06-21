Config = {}

Config.Locale = 'fr'

Config.Delays = {
	WeedProcessing = 1000 * 10,
	CaissemedProcessing = 1000 * 10,
	HuilesProcessing = 500 * 10,
	BatterieProcessing = 500 * 10,
	CanettesProcessing = 500 * 10,
    CokeProcessing = 1000 * 10
}



Config.DrugDealerItems = {
	marijuana = 661,
	
}

Config.DrugDealerItems2 = {
   dosecoke = 891,
}

Config.DrugDealerItems3 = {
	medicament = 300,
 }

Config.DrugDealerItems4 = {
	ferraille = 165,
	
}

Config.RequiredCops = 1
Config.RequiredCops2 = 3

Config.LicenseEnable = true -- enable processing licenses? The player will be required to buy a license in order to process drugs. Requires esx_license

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 55000},
	caissemed_processing = {label = _U('license_caissemed'), price = 15000},
	huiles_processing = {label = _U('license_huile'), price = 5000},
	batterie_processing = {label = _U('license_batterie'), price = 5000},
	canettes_processing = {label = _U('license_canette'), price = 300},
	coke_processing = {label = _U('license_coke'), price = 80000}
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(3290.47, 5192.72, 18.42), name = _U('blip_weedfield'), 0},
	WeedProcessing = {coords = vector3(2329.02, 2571.29, 46.68), name = _U('blip_weedprocessing'), 0},
   
   CokeField = {coords = vector3(-1369.67, 5361.19, 2.73), name = _U('blip_cokefield'), 0},
   CokeProcessing = {coords = vector3(1094.27, -3194.68, -38.99), name = _U('blip_cokeprocessing'), 0},

   CaisseField = {coords = vector3(-520, -2829.76, 6.0), name = _U('blip_caissefield'), 0},
   --CaisseProcessing = {coords = vector3(-520, -2829.76, 6.0), name = _U('blip_caisseprocessing'), 0},
   TabacblondField = {coords = vector3(2860, 4630, 46.987), name = _U('blip_tabacblondfield'), 0},
   TabacbrunField = {coords = vector3(2886.9729003906, 4609.4565429688, 46.987), name = _U('blip_tabacbrunfield'), 0},
	
	   PatateField = {coords = vector3(567, 6473.0, 30), name = _U('blip_patatefield'), 0},

	   RaisinField = {coords = vector3(-2231.34, 2413.97, 12.17), name = _U('blip_raisinfield'), 0},
	   
 CaissemedField = {coords = vector3(1157.23, -2928.42, 5.9), name = _U('blip_caissefield'), 0},
CaissemedProcessing = {coords = vector3(3559.52, 3671.38, 28.12), name = _U('blip_caisseprocessing'), 0},

BatterieField = {coords = vector3(264.92, -2202.52, 8.92), name = _U('blip_batteriefield'), 0},
BatterieProcessing = {coords = vector3(2403.59, 3127.86, 48.15), name = _U('blip_batterieprocessing'), 0},

HuilesField = {coords = vector3(263.92, -2203.52, 8.92), name = _U('blip_huilesfield'), 0},
  HuilesProcessing = {coords = vector3(2432, 3152, 48), name = _U('blip_huilesprocessing'), 0},

  CanettesField = {coords = vector3(-1156, -1711, 6.98), name = _U('blip_canettesfield'), 0},
  CanettesProcessing = {coords = vector3(1392, -2205.33, 61.46), name = _U('blip_canettesprocessing'), 0},

	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), 0},
	DrugDealer2 = {coords = vector3(-1049.42, -522.19, 36.59), name = _U('blip_drugdealer2'), 0},
	DrugDealer3 = {coords = vector3(360.88, -584.75, 28.82), name = _U('blip_drugdealer3'), 0},
	DrugDealer4 = {coords = vector3(-1518.27, -920.82, 10.15), name = _U('blip_drugdealer4'), 0},
}