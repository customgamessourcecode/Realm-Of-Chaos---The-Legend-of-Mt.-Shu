

CustomAttributesConfig = {
	"str",
	"agi",
	"int",
	"hp",
	"mana",
	"armor",
	"magic_armor",
	"health_regen",
	"health_regen_pct",
	"mana_regen",
	"attack_speed",
	"move_speed",
	"sword_coefficient",
	"knife_coefficient",
	"blade_coefficient",
	"caster_coefficient",
	"lancer_coefficient",
	"sword_damage",
	"knife_damage",
	"blade_damage",
	"caster_damage",
	"lancer_damage",
	"state",	--境界
	"merits",	--功德
	"karma",	--业力
	"dogen",	--道元
	"damage_outgoing",
	"incoming_damage",
}

-- 境界升级需求
StateUpgradeRequireTable = {
	[0]  = {three_attrs = 80,	merits = 45,	level=15,	time=0},
	[1]  = {three_attrs = 120,	merits = 130,	level=25,	time=0},
	[2]  = {three_attrs = 220,  merits = 220,	level=30,	time=0},
	[3]  = {three_attrs = 300,  merits = 300,	level=35,	time=0},
	[4]  = {three_attrs = 350,  merits = 450,	level=45,	time=0},
	[5]  = {three_attrs = 420,  merits = 700,	level=50,	time=0},
	[6]  = {three_attrs = 570,  merits = 880,	level=65,	time=0},
	[7]  = {three_attrs = 840,  merits = 1160,	level=75,	time=0},
	[8]  = {three_attrs = 1160,	merits = 1360,	level=85,	time=0},
	[9]  = {three_attrs = 1400,	merits = 1500,	level=95,	time=0},
	[10] = {three_attrs = 1700,	merits = 1800,	level=100,	time=0},
	[11] = {three_attrs = 2000, merits = 2000,	level=100,	time=0},
}

-- 物品自定义属性
ItemCustomAttributes = {
	["item_0001"] = {
		["str"] = 0,
		["agi"]	= 0,
		["int"] = 0,
		["hp"] = 0,
		["mana"] = 0,
		["armor"] = 0,
		["magic_armor"] = 0,
		["health_regen"] = 0,
		["mana_regen"] = 0,
		["attack_speed"] = 0,
		["move_speed"] = 0,
		["sword_coefficient"] = 0,
		["knife_coefficient"] = 0,
		["blade_coefficient"] = 0,
		["caster_coefficient"] = 0,
		["lancer_coefficient"] = 0,
		["state"] = 0,
		["merits"] = 0,
		["damage_outgoing"] = 0,
	}
}