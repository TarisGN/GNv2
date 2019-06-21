Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.EnablePlayerManagement     = true -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false -- use with EnablePlayerManagement disabled, or else it wont have any effects
Config.ResellPercentage           = 40

Config.Locale                     = 'fr'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true


Config.Cig = {
	'batterie_rech',
	'huile'
  }
  
  Config.CigResellChances = {
	batterie_rech = 25,
	huile = 35,
  }
  
  Config.CigResellQuantity= {
	batterie_rech = {min = 5, max = 10},
	huile = {min = 5, max = 10},
  }
  
  Config.CigPrices = {
	batterie_rech = {min = 15, max = 10},
	huile = {min = 15,   max = 15},
  }
  
  Config.CigPricesHigh = {
	batterie_rech = {min = 45, max = 10},
	huile = {min = 35,   max = 15},
  }
  
  Config.Time = {
	  batterie_rech = 5 * 60,
	  huile = 5 * 60,
  }


Config.Zones = {

	ShopEntering = {
		Pos   = { x = -38.36, y = -1668.09, z = 28.52 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	ShopInside = {
		Pos     = { x = -46.1, y = -1682.75, z = 28.422 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -54.53, y = -1668.91, z = 28.29 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -31.2, y = -1656.53, z = 28.49 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = { x = -58.04, y = -1675.07, z = 28.29 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	SellFarm = {
		Pos   = {x = 68.924179077148, y = 127.1748046875, z = 78.226},
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Type  = 1
	  },

	ResellVehicle = {
		Pos   = { x = -32.93, y = -1645.59, z = 28.24 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	}

}
