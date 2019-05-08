Config = {}

-- Ammo given by default to crafted weapons
Config.WeaponAmmo = 42

Config.Recipes = {
	-- Can be a normal ESX item
	["hamburger"] = { 
		{item = "pain", quantity = 2 }, 
		{item = "viande", quantity = 1 },
	},
	["hamburger2"] = { 
		{item = "pain", quantity = 2 }, 
		{item = "viande", quantity = 1 },
	}
	
	-- Can be a weapon, must follow this format
	-- ['WEAPON_ASSAULTRIFLE'] = { 
	-- 	{item = "steel", quantity = 4 }, 
	-- 	{item = "gunpowder", quantity = 2},
	-- }
}

-- Enable a shop to access the crafting menu
Config.Shop = {
	useShop = true,
	shopCoordinates = { x = -1200.90, y = -899, z = 14 },
	shopName = "cuisine",
	shopBlipID = 446,
	zoneSize = { x = 5, y = 5, z = 5 },
	zoneColor = { r = 255, g = 0, b = 0, a = 100 }
}

-- Enable crafting menu through a keyboard shortcut
Config.Keyboard = {
	useKeyboard = false,
	keyCode = 303
}
