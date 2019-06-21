Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'fr'

Config.Zones = {

	RaisinFarm = {
		Pos   = {x = -2231.34, y = 2413.97, z = -990.681},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte de raisin",
		Type  = 1
	},


	TraitementVin = {
		Pos   = {x = -53.116, y = 1903.248, z = 194.361},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du Vin",
		Type  = 1
	},

	TraitementJus = {
		Pos   = {x = 811.337, y = 2179.402, z = 51.388},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du Jus de raisin",
		Type  = 1
	},
	
	SellFarm = {
		Pos   = {x = -158.737, y = -54.651, z = 53.396},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Type  = 1
	},

	SellFarm2 = {
		Pos   = {x = -158.737, y = -54.651, z = 53.396},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits de luxe",
		Type  = 1
	},

	VigneronActions = {
		Pos   = {x = -1912.372, y = 2072.8010, z = 139.387},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Type  = 0
	 },
	  
	VehicleSpawner = {
		Pos   = {x = -1889.653, y = 2050.071, z = 139.985},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 0
	},

	VehicleSpawnPoint = {
		Pos   = {x = -1903.984, y = 2058.367, z = 139.722},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = {x = -1913.550, y = 2030.590, z = 139.738},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Ranger son véhicule",
		Type  = 0
	}

}

Config.Cig = {
  'vine',
  'jus_raisin'
}

Config.CigResellChances = {
  vine = 45,
  jus_raisin = 25,
}

Config.CigResellQuantity= {
  vine = {min = 5, max = 10},
  jus_raisin = {min = 5, max = 10},
}

Config.CigPrices = {
  vine = {min = 15, max = 10},
  jus_raisin = {min = 15,   max = 15},
}

Config.CigPricesHigh = {
  vine = {min = 45, max = 10},
  jus_raisin = {min = 35,   max = 15},
}

Config.Time = {
  vine = 5 * 60,
  jus_raisin = 5 * 60,
}
