local Keys = {
 ["ESC"] = 322,
 ["F1"] = 288,
 ["F2"] = 289,
 ["F3"] = 170,
 ["F5"] = 166,
 ["F6"] = 167,
 ["F7"] = 168,
 ["F8"] = 169,
 ["F9"] = 56,
 ["F10"] = 57,
 ["~"] = 243,
 ["1"] = 157,
 ["2"] = 158,
 ["3"] = 160,
 ["4"] = 164,
 ["5"] = 165,
 ["6"] = 159,
 ["7"] = 161,
 ["8"] = 162,
 ["9"] = 163,
 ["-"] = 84,
 ["="] = 83,
 ["BACKSPACE"] = 177,
 ["TAB"] = 37,
 ["Q"] = 44,
 ["W"] = 32,
 ["E"] = 38,
 ["R"] = 45,
 ["T"] = 245,
 ["Y"] = 246,
 ["U"] = 303,
 ["P"] = 199,
 ["["] = 39,
 ["]"] = 40,
 ["ENTER"] = 18,
 ["CAPS"] = 137,
 ["A"] = 34,
 ["S"] = 8,
 ["D"] = 9,
 ["F"] = 23,
 ["G"] = 47,
 ["H"] = 74,
 ["K"] = 311,
 ["L"] = 182,
 ["LEFTSHIFT"] = 21,
 ["Z"] = 20,
 ["X"] = 73,
 ["C"] = 26,
 ["V"] = 0,
 ["B"] = 29,
 ["N"] = 249,
 ["M"] = 244,
 [","] = 82,
 ["."] = 81,
 ["-"] = 84,
 ["LEFTCTRL"] = 36,
 ["LEFTALT"] = 19,
 ["SPACE"] = 22,
 ["RIGHTCTRL"] = 70,
 ["HOME"] = 213,
 ["PAGEUP"] = 10,
 ["PAGEDOWN"] = 11,
 ["DELETE"] = 178,
 ["LEFT"] = 174,
 ["RIGHT"] = 175,
 ["TOP"] = 27,
 ["DOWN"] = 173,
 ["NENTER"] = 201,
 ["N4"] = 108,
 ["N5"] = 60,
 ["N6"] = 107,
 ["N+"] = 96,
 ["N-"] = 97,
 ["N7"] = 117,
 ["N8"] = 61,
 ["N9"] = 118
}

Config = {}

Config.CheckOwnership = false -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = true -- If true, police will be able to search players' trunks.

Config.Locale = "fr"

Config.OpenKey = Keys["Y"]

-- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 10

Config.localWeight = {
 alive_chicken = 200 ,
bag = 100 ,
batterie = 500 ,
batterie_rech = 500 ,
huile = 350 ,
huiles = 350 ,
bait = 50 ,
bandage = 100 ,
biere = 100 ,
blackberry = 250 ,
blowpipe = 1500 ,
bolcacahuetes = 100 ,
bolchips = 100 ,
bolnoixcajou = 100 ,
bolpistache = 100 ,
cannabis = 500 ,
cappuccino = 250 ,
carokit = 2000 ,
carotool = 2000 ,
champagne = 500 ,
clip = 300 ,
clothe = 500 ,
coke = 250 ,
coke_pooch = 500 ,
contrat = 1 ,
copper = 450 ,
cutted_wood = 1000 ,
diamond = 450 ,
drill = 3000 ,
drpepper = 250 ,
eau = 250 ,
energy = 250 ,
essence = 1000 ,
fabric = 100 ,
fish = 100 ,
fishingrod = 1000 ,
fixkit = 1500 ,
fixtool = 1500 ,
gazbottle = 2000 ,
gitanes = 60 ,
gold = 450 ,
golem = 250 ,
grand_cru = 250 ,
grapperaisin = 1 ,
hamburger = 300 ,
hamburger2 = 400 ,
ice = 250 ,
icetea = 250 ,
iron = 450 ,
jager = 250 ,
jagerbomb = 250 ,
jagercerbere = 250 ,
jusfruit = 250 ,
jus_raisin = 250 ,
kebab = 300 ,
limonade = 250 ,
malbora = 60 ,
marijuana = 600 ,
martini = 250 ,
medikit = 1000 ,
menthe = 250 ,
menu = 400 ,
meth = 500 ,
meth_pooch = 600 ,
metreshooter = 250 ,
mixapero = 250 ,
mojito = 250 ,
opium = 800 ,
opium_pooch = 900 ,
packaged_chicken = 250 ,
packaged_plank = 250 ,
pain = 250 ,
pastis = 250 ,
patate = 150 ,
pay_works = 1 ,
petrol = 1000 ,
petrol_raffin = 1000 ,
pizza = 300 ,
radio = 300 ,
raisin = 100 ,
rhum = 250 ,
rhumcoca = 250 ,
rhumfruit = 250 ,
sandwich = 200 ,
saucisson = 200 ,
shushi = 250 ,
slaughtered_chicken = 400 ,
soda = 250 ,
stone = 3000 ,
tabacblond = 250 ,
tabacblondsec = 150 ,
tabacbrun = 250 ,
tabacbrunsec = 150 ,
teqpaf = 250 ,
tequila = 250 ,
medicaments = 250 ,
turtle = 500 ,
turtle_meat = 250 ,
viande = 100 ,
viande_meat = 100 ,
vine = 300 ,
vodka = 250 ,
vodkaenergy = 250 ,
vodkafruit = 250 ,
biere = 250 ,
sake = 250 ,
caisse = 1000 ,
caissemed = 2000 ,
washed_stone = 3000 ,
whisky = 250 ,
whiskycoca = 250 ,
wood = 1000 ,
wool = 500 ,
WEAPON_KNIFE = 2000 ,
WEAPON_KNUCKLE = 2000 ,
WEAPON_NIGHTSTICK = 2000 ,
WEAPON_HAMMER = 2000 ,
WEAPON_BAT = 2000 ,
WEAPON_GOLFCLUB = 2000 ,
WEAPON_CROWBAR = 2000 ,
WEAPON_BOTTLE = 2000 ,
WEAPON_DAGGER = 2000 ,
WEAPON_HATCHET = 2000 ,
WEAPON_MACHETE = 2000 ,
WEAPON_FLASHLIGHT = 2000 ,
WEAPON_SWITCHBLADE = 2000 ,
WEAPON_PROXMINE = 2000 ,
WEAPON_BZGAS = 2000 ,
WEAPON_SMOKEGRENADE = 2000 ,
WEAPON_MOLOTOV = 2000 ,
WEAPON_FIREEXTINGUISHER = 2000 ,
WEAPON_PETROLCAN = 2000 ,
WEAPON_SNOWBALL = 2000 ,
WEAPON_FLARE = 2000 ,
WEAPON_BALL = 2000 ,
WEAPON_REVOLVER = 2000 ,
WEAPON_POOLCUE = 2000 ,
WEAPON_PIPEWRENCH = 2000 ,
WEAPON_PISTOL = 2000 ,
WEAPON_PISTOL_MK2 = 2000 ,
WEAPON_COMBATPISTOL = 2000 ,
WEAPON_APPISTOL = 2000 ,
WEAPON_PISTOL50 = 2000 ,
WEAPON_SNSPISTOL = 2000 ,
WEAPON_HEAVYPISTOL = 2000 ,
WEAPON_VINTAGEPISTOL = 2000 ,
WEAPON_STUNGUN = 2000 ,
WEAPON_FLAREGUN = 2000 ,
WEAPON_MARKSMANPISTOL = 2000 ,
WEAPON_MICROSMG = 3000 ,
WEAPON_MINISMG = 3000 ,
WEAPON_SMG = 3000 ,
WEAPON_SMG_MK2 = 3000 ,
WEAPON_ASSAULTSMG = 3000 ,
WEAPON_MG = 3000 ,
WEAPON_COMBATMG = 3000 ,
WEAPON_COMBATMG_MK2 = 3000 ,
WEAPON_COMBATPDW = 3000 ,
WEAPON_GUSENBERG = 3000 ,
WEAPON_MACHINEPISTOL = 3000 ,
WEAPON_ASSAULTRIFLE = 5000 ,
WEAPON_ASSAULTRIFLE_MK2 = 5000 ,
WEAPON_CARBINERIFLE = 5000 ,
WEAPON_CARBINERIFLE_MK2 = 5000 ,
WEAPON_ADVANCEDRIFLE = 5000 ,
WEAPON_SPECIALCARBINE = 5000 ,
WEAPON_BULLPUPRIFLE = 5000 ,
WEAPON_COMPACTRIFLE = 5000 ,
WEAPON_PUMPSHOTGUN = 5000 ,
WEAPON_SWEEPERSHOTGUN = 5000 ,
WEAPON_SAWNOFFSHOTGUN = 5000 ,
WEAPON_BULLPUPSHOTGUN = 5000 ,
WEAPON_ASSAULTSHOTGUN = 5000 ,
WEAPON_MUSKET = 5000 ,
WEAPON_HEAVYSHOTGUN = 5000 ,
WEAPON_DBSHOTGUN = 5000 ,
WEAPON_SNIPERRIFLE = 5000 ,
WEAPON_HEAVYSNIPER = 5000 ,
WEAPON_HEAVYSNIPER_MK2 = 8000 ,
WEAPON_MARKSMANRIFLE = 8000 ,
WEAPON_GRENADELAUNCHER = 8000 ,
WEAPON_GRENADELAUNCHER_SMOKE = 8000 ,
WEAPON_RPG = 8000 ,
WEAPON_MINIGUN = 8000 ,
WEAPON_FIREWORK = 8000 ,
WEAPON_RAILGUN = 8000 ,
WEAPON_HOMINGLAUNCHER = 8000 ,
WEAPON_GRENADE = 8000 ,
WEAPON_STICKYBOMB = 8000 ,
WEAPON_COMPACTLAUNCHER = 8000 ,
WEAPON_SNSPISTOL_MK2 = 8000 ,
WEAPON_REVOLVER_MK2 = 8000 ,
WEAPON_DOUBLEACTION = 8000 ,
WEAPON_SPECIALCARBINE_MK2 = 5000 ,
WEAPON_BULLPUPRIFLE_MK2 = 5000 ,
WEAPON_PUMPSHOTGUN_MK2 = 5000 ,
WEAPON_MARKSMANRIFLE_MK2 = 5000 ,
WEAPON_RAYPISTOL = 5000 ,
WEAPON_RAYCARBINE = 5000 ,
WEAPON_RAYMINIGUN = 5000 
}

Config.VehicleLimit = {
 [0] = 25000, --Compact
 [1] = 40000, --Sedan
 [2] = 50000, --SUV
 [3] = 25000, --Coupes
 [4] = 30000, --Muscle
 [5] = 10000, --Sports Classics
 [6] = 5000, --Sports
 [7] = 5000, --Super
 [8] = 5000, --Motorcycles
 [9] = 50000, --Off-road
 [10] = 150000, --Industrial
 [11] = 70000, --Utility
 [12] = 100000, --Vans
 [13] = 0, --Cycles
 [14] = 5000, --Boats
 [15] = 20000, --Helicopters
 [16] = 0, --Planes
 [17] = 40000, --Service
 [18] = 40000, --Emergency
 [19] = 0, --Military
 [20] = 150000, --Commercial
 [21] = 0 --Trains
}

Config.VehiclePlate = {
 taxi = "TAXI",
 cop = "LSPD",
 ambulance = "EMS0",
 mecano = "MECA"
}
