Config                            = {}
Config.DrawDistance               = 100.0

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableVaultManagement      = true
Config.EnableHelicopters          = false
Config.EnableMoneyWash            = true
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.MissCraft                  = 10 -- %


Config.AuthorizedVehicles = {
    { name = 'taco',  label = 'Taco' },
    { name = 'foodtruck',  label = 'Foodtruck' },
}


Config.Cig = {
  'hamburger',
  'menu'
}

Config.CigResellChances = {
  hamburger = 75,
  menu = 95,
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
  hamburger = {min = 95, max = 10},
  menu = {min = 110,   max = 15},
}

Config.Time = {
    hamburger = 5 * 60,
    menu = 5 * 60,
}



Config.Blips = {
    
    Blip = {
      Pos     = { x = 233.3, y = -876.07, z = 29.49 },
      Sprite  = 106,
      Display = 4,
      Scale   = 1.2,
      Colour  = 59,
    },

}

Config.Zones = {

    Cloakrooms = {
        Pos   = { x = 241.28, y = -890.71, z = 29.49 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 1,
    },

    Vaults = {
        Pos   = { x = 220.0, y = -884.38, z = 29.49 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 1,
    },

    Vehicles = {
        Pos          = { x = 231.2, y = -896.0, z = 29.69 },
        SpawnPoint   = { x = 221.46, y = -898.87, z = 29.69 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 1,
        Heading      = 207.43,
    },

    VehicleDeleters = {
        Pos   = { x = 223.0, y = -890.0, z = 29.69 },
        Size  = { x = 3.0, y = 3.0, z = 0.2 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 1,
    },

    SellFarm = {
    Pos   = { x = -826.44, y = -1261.76, z = 4.0},
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = {r = 136, g = 243, b = 216},
    Name  = "Vente des produits",
    Type  = 1
  },

--[[
    Helicopters = {
        Pos          = { x = 137.177, y = -1278.757, z = 28.371 },
        SpawnPoint   = { x = 138.436, y = -1263.095, z = 28.626 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 23,
        Heading      = 207.43,
    },

    HelicopterDeleters = {
        Pos   = { x = 133.203, y = -1265.573, z = 28.396 },
        Size  = { x = 3.0, y = 3.0, z = 0.2 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 1,
    },
]]--

    BossActions = {
        Pos   = { x = 246.7, y = -888.56, z = 30.49 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 1,
    },


}



-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
  burgershot_outfit = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 281,   ['torso_2'] = 1,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 75,
        ['pants_1'] = 105,   ['pants_2'] = 3,
        ['shoes_1'] = 80,    ['shoes_2'] = 1,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['helmet_1'] = 130,    ['helmet_2'] = 2,
    },
    female = {
        ['tshirt_1'] = 16,  ['tshirt_2'] = 0,
        ['torso_1'] = 294,   ['torso_2'] = 1,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 112,   ['pants_2'] = 3,
        ['shoes_1'] = 84,    ['shoes_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['helmet_1'] = 126,    ['helmet_2'] = 2,
    }
  },
  }
