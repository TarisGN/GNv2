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
    { name = 'stretch',  label = 'Vehicule de fonction' },
	{ name = 'dubsta2',  label = 'Vehicule de Patron' }
}

Config.Blips = {
    
    Blip = {
      Pos     = { x = -1832.37, y = -1193.83, z = 13.31 },
      Sprite  = 93,
      Display = 4,
      Scale   = 1.2,
      Colour  = 50,
    },

}

Config.Zones = {

    Cloakrooms = {
        Pos   = { x = -1836.78, y = -1190.765, z = 13.31 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 27,
    },

    Vaults = {
        Pos   = { x = -1827.33, y = -1203.71, z = 13.31 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 23,
    },

     Fridge = {
         Pos   = { x = -1836.78, y = -1197.5, z = 13.31 },
         Size  = { x = 1.6, y = 1.6, z = 1.0 },
         Color = { r = 248, g = 248, b = 255 },
         Type  = 23,
     },

    Vehicles = {
        Pos          = { x = -1841.6, y = -1210.55, z = 12.03 },
        SpawnPoint   = { x = -1838.9, y = -1222.6, z = 12.02 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 23,
        Heading      = 207.43,
    },

    VehicleDeleters = {
        Pos   = { x = -1836.57, y = -1227.48, z = 12.02 },
        Size  = { x = 3.0, y = 3.0, z = 0.2 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 1,
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
        Pos   = { x = -1832.37, y = -1193.83, z = 14.31 },
        Size  = { x = 1.2, y = 1.2, z = 0.8 },
        Color = { r = 0, g = 200, b = 255 },
        Type  = 1,
    },

 SellFarm = {
    Pos   = {x = -826.44, y = -1261.76, z = 5.0},
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
  Color = {r = 136, g = 243, b = 216},
    Name  = "Vente des produits",
    Type  = 1
  },
-----------------------
-------- SHOPS --------

    -- Flacons = {
    --     Pos   = { x = -562.2260, y = 285.2875, z = 81.1763 },
    --     Size  = { x = 1.6, y = 1.6, z = 1.0 },
    --     Color = { r = 238, g = 0, b = 0 },
    --     Type  = 23,
    --     Items = {
    --         { name = 'jager',      label = _U('jager'),   price = 3 },
    --         { name = 'vodka',      label = _U('vodka'),   price = 4 },
    --         { name = 'rhum',       label = _U('rhum'),    price = 2 },
    --         { name = 'whisky',     label = _U('whisky'),  price = 7 },
    --         { name = 'tequila',    label = _U('tequila'), price = 2 },
    --         { name = 'martini',    label = _U('martini'), price = 5 }
    --     },
    -- },

    -- NoAlcool = {
    --     Pos   = { x = 178.028, y = 307.467, z = 104.392 },
    --     Size  = { x = 1.6, y = 1.6, z = 1.0 },
    --     Color = { r = 238, g = 110, b = 0 },
    --     Type  = 23,
    --     Items = {
    --         { name = 'soda',        label = _U('soda'),     price = 4 },
    --         { name = 'jusfruit',    label = _U('jusfruit'), price = 3 },
    --         { name = 'icetea',      label = _U('icetea'),   price = 4 },
    --         { name = 'energy',      label = _U('energy'),   price = 7 },
    --         { name = 'drpepper',    label = _U('drpepper'), price = 2 },
    --         { name = 'limonade',    label = _U('limonade'), price = 1 }
    --     },
    -- },

    Apero = {
        Pos   = { x = 98.675, y = -1809.498, z = 26.095 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 142, g = 125, b = 76 },
        Type  = 23,
        Items = {
            { name = 'bolcacahuetes',   label = _U('bolcacahuetes'),    price = 7 },
            { name = 'bolnoixcajou',    label = _U('bolnoixcajou'),     price = 10 },
            { name = 'bolpistache',     label = _U('bolpistache'),      price = 15 },
            { name = 'bolchips',        label = _U('bolchips'),         price = 5 },
            { name = 'saucisson',       label = _U('saucisson'),        price = 25 },
            { name = 'grapperaisin',    label = _U('grapperaisin'),     price = 15 }
        },
    },

    -- Ice = {
    --     Pos   = { x = 26.979, y = -1343.457, z = 28.517 },
    --     Size  = { x = 1.6, y = 1.6, z = 1.0 },
    --     Color = { r = 255, g = 255, b = 255 },
    --     Type  = 23,
    --     Items = {
    --         { name = 'ice',     label = _U('ice'),      price = 1 },
    --         { name = 'menthe',  label = _U('menthe'),   price = 2 }
    --     },
    -- },

}


-----------------------
----- TELEPORTERS -----

Config.TeleportZones = {
  EnterBuilding = {
    Pos       = { x = 132.608, y = -1293.978, z = 28.269 },
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Hint      = _U('e_to_enter_1'),
    Teleport  = { x = 126.742, y = -1278.386, z = 28.569 }
  },

  ExitBuilding = {
    Pos       = { x = 132.517, y = -1290.901, z = 28.269 },
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Hint      = _U('e_to_exit_1'),
    Teleport  = { x = 131.175, y = -1295.598, z = 28.569 },
  },



--[[
  EnterHeliport = {
    Pos       = { x = 126.843, y = -729.012, z = 241.201 },
    Size      = { x = 2.0, y = 2.0, z = 0.2 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_enter_2),
    Teleport  = { x = -65.944, y = -818.589, z =  320.801 }
  },

  ExitHeliport = {
    Pos       = { x = -67.236, y = -821.702, z = 320.401 },
    Size      = { x = 2.0, y = 2.0, z = 0.2 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_exit_2'),
    Teleport  = { x = 124.164, y = -728.231, z = 241.801 },
  },
]]--
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

-- CONFIG

Config.Cig = {
  'biere',
  'soda'
}

Config.CigResellChances = {
  biere = 45,
  soda = 25,
}

Config.CigResellQuantity= {
  biere = {min = 5, max = 10},
  soda = {min = 5, max = 10},
}

Config.CigPrices = {
  biere = {min = 15, max = 10},
  soda = {min = 15,   max = 15},
}

Config.CigPricesHigh = {
  biere = {min = 45, max = 10},
  soda = {min = 35,   max = 15},
}

Config.Time = {
  biere = 5 * 60,
  soda = 5 * 60,
}







Config.Uniforms = {
  barman_outfit = {
    male = {
        [ 'tshirt_1'] =  15 , [ 'tshirt_2'] =  0 ,
        [ 'torso_1'] =  95 , [ 'torso_2'] =  1 ,
        [ 'decals_1'] =  0 , [ 'decals_2'] =  0 ,
        [ 'arms'] =  11 ,
        [ 'pants_1'] =  71 , [ 'pants_2'] =  0 ,
        [ 'shoes_1'] =  1 , [ 'shoes_2' ] =  0 ,
        [ 'chain_1'] = 0 , [ 'chain_2' ] =  0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 8,    ['torso_2'] = 2,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 5,
        ['pants_1'] = 44,   ['pants_2'] = 4,
        ['shoes_1'] = 0,    ['shoes_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 2
    }
  },
  dancer_outfit_1 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 61,   ['pants_2'] = 9,
        ['shoes_1'] = 16,   ['shoes_2'] = 9,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 22,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 4,
        ['pants_1'] = 22,   ['pants_2'] = 0,
        ['shoes_1'] = 18,   ['shoes_2'] = 0,
        ['chain_1'] = 61,   ['chain_2'] = 1
    
  
  -- dancer_outfit_2 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 62,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 14,
  --       ['pants_1'] = 4,    ['pants_2'] = 0,
  --       ['shoes_1'] = 34,   ['shoes_2'] = 0,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 22,   ['torso_2'] = 2,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 4,
  --       ['pants_1'] = 20,   ['pants_2'] = 2,
  --       ['shoes_1'] = 18,   ['shoes_2'] = 2,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
  --   }
  -- },
  -- dancer_outfit_3 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 4,    ['pants_2'] = 0,
  --       ['shoes_1'] = 34,   ['shoes_2'] = 0,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 22,   ['torso_2'] = 1,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 19,   ['pants_2'] = 1,
  --       ['shoes_1'] = 19,   ['shoes_2'] = 3,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
  --   }
  -- },
  -- dancer_outfit_4 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 61,   ['pants_2'] = 5,
  --       ['shoes_1'] = 34,   ['shoes_2'] = 0,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 82,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 63,   ['pants_2'] = 11,
  --       ['shoes_1'] = 41,   ['shoes_2'] = 11,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
  --   }
  -- },
  -- dancer_outfit_5 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 21,   ['pants_2'] = 0,
  --       ['shoes_1'] = 34,   ['shoes_2'] = 0,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 5,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 63,   ['pants_2'] = 2,
  --       ['shoes_1'] = 41,   ['shoes_2'] = 2,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
  --   }
  -- },
  -- dancer_outfit_6 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 81,   ['pants_2'] = 0,
  --       ['shoes_1'] = 34,   ['shoes_2'] = 0,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 18,   ['torso_2'] = 3,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 63,   ['pants_2'] = 10,
  --       ['shoes_1'] = 41,   ['shoes_2'] = 10,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
  --   }
  -- },
  -- dancer_outfit_7 = {
  --   male = {
  --       ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
  --       ['torso_1'] = 15,   ['torso_2'] = 0,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 40,
  --       ['pants_1'] = 61,   ['pants_2'] = 9,
  --       ['shoes_1'] = 16,   ['shoes_2'] = 9,
  --       ['chain_1'] = 118,  ['chain_2'] = 0
  --   },
  --   female = {
  --       ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
  --       ['torso_1'] = 111,  ['torso_2'] = 6,
  --       ['decals_1'] = 0,   ['decals_2'] = 0,
  --       ['arms'] = 15,
  --       ['pants_1'] = 63,   ['pants_2'] = 6,
  --       ['shoes_1'] = 41,   ['shoes_2'] = 6,
  --       ['chain_1'] = 0,    ['chain_2'] = 0
    }
  }
}
