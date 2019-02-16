--[[
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
["damage_outgoing"] = 0,
]]


item_suit_table = {
	------------------------------------------------------------------------------
	-- 碧河甲+落日靴
	["biheluori"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 25,
			["health_regen"] = 100,
			["move_speed"] = 100,
		},
		["modifiers"] = {
			"modifier_item_suit_biheluori",
		},
		["requestItems"] = {"item_0021","item_0017"},
	},

	------------------------------------------------------------------------------
	-- 天师套装 = 天师道冠+天师道服+天师道靴
	["tianshi"]={
		level = 1,
		["attributes"] = {
			["str"] = 15,
			["agi"] = 15,
			["int"] = 35,
			["hp"] = 500,
			["mana"] = 1000,
			["mana_regen"] = 100,
			["move_speed"] = 100,
			["sword_coefficient"] = 5,
			["blade_coefficient"] = 5,
			["knife_coefficient"] = 5,
			["caster_coefficient"] = 25,
			["lancer_coefficient"] = 5,
			["damage_outgoing"] = 10,
		},
		["requestItems"] = {"item_0036","item_0046","item_0043"},
	},

	------------------------------------------------------------------------------
	-- 太极道冠+太极道服+太极道靴
	["taiji"]={
		level = 1,
		["attributes"] = {
			["str"] = 20,
			["agi"] = 20,
			["int"] = 55,
			["hp"] = 1000,
			["mana"] = 2000,
			["mana_regen"] = 200,
			["move_speed"] = 150,
			["sword_coefficient"] = 10,
			["blade_coefficient"] = 10,
			["knife_coefficient"] = 10,
			["caster_coefficient"] = 35,
			["lancer_coefficient"] = 10,
			["damage_outgoing"] = 15,
		},
		["requestItems"] = {"item_0140","item_0141","item_0142"},
	},

	------------------------------------------------------------------------------
	-- 真武太极道冠+真武太极道服+真武太极道靴
	["zhenwutaiji"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 70,
			["hp"] = 1500,
			["mana"] = 3000,
			["mana_regen"] = 300,
			["move_speed"] = 200,
			["sword_coefficient"] = 15,
			["blade_coefficient"] = 15,
			["knife_coefficient"] = 15,
			["caster_coefficient"] = 45,
			["lancer_coefficient"] = 15,
			["damage_outgoing"] = 20,
		},
		["requestItems"] = {"item_0143","item_0144","item_0145"},
	},
	
	------------------------------------------------------------------------------
	-- 九龙套装 = 九龙战靴+九龙战甲+九龙战盔
	["jiulong"]={
		level = 1,
		["attributes"] = {
			["str"] = 40,
			["agi"] = 40,
			["int"] = 30,
			["hp"] = 2000,
			["health_regen"] = 200,
			["sword_coefficient"] = 5,
			["blade_coefficient"] = 5,
			["knife_coefficient"] = 5,
			["caster_coefficient"] = 5,
			["lancer_coefficient"] = 5,
			["damage_outgoing"] = 5,
			["incoming_damage"] = -5,
		},
		["requestItems"] = {"item_0129","item_0130","item_0131"},
	},

	------------------------------------------------------------------------------
	-- 烈炎头盔+烈焰战靴
	["lieyan"]={
		level = 1,
		["attributes"] = {
			["str"] = 25,
			["agi"] = 20,
			["int"] = 20,
			["hp"] = 1000,
			["mana"] = 1000,
			["health_regen"] = 100,
			["sword_coefficient"] = 15,
			["blade_coefficient"] = 15,
			["knife_coefficient"] = 15,
			["caster_coefficient"] = 15,
			["lancer_coefficient"] = 15,
		},
		["modifiers"] = {
			"modifier_item_suit_lieyan",
		},
		["requestItems"] = {"item_0194","item_0195"},
	},

	------------------------------------------------------------------------------
	-- 冰封头盔+冰封战靴
	["bingfeng"]={
		level = 1,
		["attributes"] = {
			["str"] = 20,
			["agi"] = 20,
			["int"] = 25,
			["hp"] = 1000,
			["mana"] = 1000,
			["health_regen"] = 100,
			["sword_coefficient"] = 5,
			["blade_coefficient"] = 5,
			["knife_coefficient"] = 5,
			["caster_coefficient"] = 30,
			["lancer_coefficient"] = 5,
		},
		["modifiers"] = {
			"modifier_item_suit_bingfeng",
		},
		["requestItems"] = {"item_0192","item_0193"},
	},

	------------------------------------------------------------------------------
	-- 冰焰神盔+冰焰神袍+冰焰神靴
	["bingyan"]={
		level = 1,
		["attributes"] = {
			["str"] = 60,
			["agi"] = 60,
			["int"] = 60,
			["hp"] = 3000,
			["mana"] = 3000,
			["health_regen"] = 300,
			["sword_coefficient"] = 35,
			["blade_coefficient"] = 35,
			["knife_coefficient"] = 35,
			["caster_coefficient"] = 35,
			["lancer_coefficient"] = 35,
		},
		["modifiers"] = {
			"modifier_item_suit_bingyan",
		},
		["requestItems"] = {"item_0204","item_0186","item_0205"},
	},

	------------------------------------------------------------------------------
	-- 巫族战袍+巫族皮靴+巫族战盔+巫族武器
	["wuzu"]={
		level = 1,
		["attributes"] = {
			["str"] = 80,
			["agi"] = 80,
			["int"] = 80,
			["armor"] = 50,
			["hp"] = 3000,
			["health_regen"] = 300,
		},
		["modifiers"] = {
			"modifier_item_suit_wuzu",
		},
		["requestItems"] = {"item_0236","item_0237","item_0238",{"item_0231","item_0232","item_0233","item_0234","item_0235"}},
	},

	------------------------------------------------------------------------------
	-- 无相战靴+无相战盔+无相战甲
	["wuxiang"]={
		level = 1,
		["attributes"] = {
			["str"] = 90,
			["agi"] = 90,
			["int"] = 70,
			["magic_armor"] = 25,
			["hp"] = 3500,
			["health_regen"] = 200,
			["move_speed"] = 100,
			["blade_damage"] = 50,
			["lancer_damage"] = 50,
			["blade_coefficient"] = 60,
			["lancer_coefficient"] = 60,
		},
		["modifiers"] = {
		},
		["requestItems"] = {"item_0365","item_0366","item_0367"},
	},

	------------------------------------------------------------------------------
	-- 绝影之尘+绝影头环+绝影衣
	["jueying"]={
		level = 1,
		["attributes"] = {
			["str"] = 70,
			["agi"] = 110,
			["int"] = 70,
			["magic_armor"] = 25,
			["hp"] = 3500,
			["health_regen"] = 200,
			["move_speed"] = 100,
			["sword_damage"] = 50,
			["knife_damage"] = 50,
			["sword_coefficient"] = 60,
			["knife_coefficient"] = 60,
		},
		["modifiers"] = {
		},
		["requestItems"] = {"item_0368","item_0369","item_0370"},
	},

	------------------------------------------------------------------------------
	-- 弥光鞋+弥光宝盔+弥光法袍
	["miguang"]={
		level = 1,
		["attributes"] = {
			["str"] = 70,
			["agi"] = 70,
			["int"] = 110,
			["magic_armor"] = 25,
			["hp"] = 3500,
			["health_regen"] = 200,
			["move_speed"] = 100,
			["caster_coefficient"] = 60,
			["caster_damage"] = 50,
		},
		["modifiers"] = {
		},
		["requestItems"] = {"item_0371","item_0372","item_0373"},
	},

	------------------------------------------------------------------------------
	-- 雾然挂饰+雾然戒指
	["wuran"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 30,
			["hp"] = 1000,
			["health_regen"] = 100,
			["blade_coefficient"] = 15,
			["lancer_coefficient"] = 15,
		},
		["modifiers"] = {
			"modifier_item_suit_wuran"
		},
		["requestItems"] = {"item_0374","item_0375"},
	},

	------------------------------------------------------------------------------
	-- 断邪链+断邪指环
	["duanxie"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 30,
			["hp"] = 750,
			["health_regen"] = 100,
			["sword_coefficient"] = 15,
			["knife_coefficient"] = 15,
		},
		["modifiers"] = {
			"modifier_item_suit_duanxie"
		},
		["requestItems"] = {"item_0376","item_0377"},
	},

	------------------------------------------------------------------------------
	-- 阴泽护腕+阴泽魔镜
	["yinze"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 30,
			["hp"] = 500,
			["health_regen"] = 100,
			["sword_coefficient"] = 5,
			["blade_coefficient"] = 5,
			["knife_coefficient"] = 5,
			["caster_coefficient"] = 25,
			["lancer_coefficient"] = 5,
		},
		["modifiers"] = {
			"modifier_item_suit_yinze"
		},
		["requestItems"] = {"item_0378","item_0379"},
	},

	------------------------------------------------------------------------------
	-- 六道天冠+六道天衣+六道天靴
	["liudao"]={
		level = 1,
		["attributes"] = {
			["str"] = 90,
			["agi"] = 90,
			["int"] = 90,
			["hp"] = 4000,
			["mana"] = 4000,
			["health_regen"] = 500,
			["sword_coefficient"] = 45,
			["blade_coefficient"] = 45,
			["knife_coefficient"] = 45,
			["caster_coefficient"] = 45,
			["lancer_coefficient"] = 45,
		},
		["modifiers"] = {
			"modifier_item_suit_liudao"
		},
		["requestItems"] = {"item_0429","item_0430","item_0431"},
	},

	------------------------------------------------------------------------------
	-- 石川宝盔+石川宝靴+石川宝甲
	["shichuan"]={
		level = 1,
		["attributes"] = {
			["str"] = 70,
			["agi"] = 40,
			["int"] = 40,
			["hp"] = 4000,
			["health_regen"] = 300,
			["sword_coefficient"] = 20,
			["blade_coefficient"] = 20,
			["knife_coefficient"] = 20,
			["caster_coefficient"] = 20,
			["lancer_coefficient"] = 20,
		},
		["modifiers"] = {
			"modifier_item_suit_shichuan"
		},
		["requestItems"] = {"item_0407","item_0408","item_0409"},
	},

	------------------------------------------------------------------------------
	-- 娲神魔靴+娲神魔盔+娲神魔甲
	["washenmo"]={
		level = 1,
		["attributes"] = {
			["str"] = 80,
			["agi"] = 80,
			["hp"] = 4000,
			["health_regen"] = 500,
			["sword_damage"] = 20,
			["knife_damage"] = 20,
			["blade_damage"] = 20,
			["lancer_damage"] = 20,
			["sword_coefficient"] = 30,
			["blade_coefficient"] = 30,
			["lancer_coefficient"] = 30,
		},
		["modifiers"] = {
			"modifier_item_suit_washenmo"
		},
		["requestItems"] = {"item_0434","item_0435","item_0436"},
	},

	------------------------------------------------------------------------------
	-- 娲神仙鞋+娲神仙冠+娲神仙袍
	["washenxian"]={
		level = 1,
		["attributes"] = {
			["agi"] = 80,
			["int"] = 80,
			["hp"] = 3500,
			["health_regen"] = 500,
			["caster_damage"] = 20,
			["knife_damage"] = 20,
			["knife_coefficient"] = 30,
			["caster_coefficient"] = 30,
		},
		["modifiers"] = {
			"modifier_item_suit_washenxian"
		},
		["requestItems"] = {"item_0437","item_0438","item_0439"},
	},

	------------------------------------------------------------------------------
	-- 圣灵冠+圣灵甲+圣灵靴
	["shengling"]={
		level = 1,
		["attributes"] = {
			["str"] = 120,
			["agi"] = 120,
			["int"] = 120,
			["hp"] = 6000,
			["armor"] = 40,
			["health_regen"] = 2000,
			["health_regen_pct"] = 2,
			["caster_damage"] = 30,
			["sword_damage"] = 30,
			["knife_damage"] = 30,
			["blade_damage"] = 30,
			["lancer_damage"] = 30,
			["sword_coefficient"] = 60,
			["blade_coefficient"] = 60,
			["knife_coefficient"] = 60,
			["caster_coefficient"] = 60,
			["lancer_coefficient"] = 60,
		},
		["modifiers"] = {
			"modifier_item_suit_shengling"
		},
		["requestItems"] = {"item_0440","item_0441","item_0442"},
	},

	------------------------------------------------------------------------------
	-- 涅槃冲霄鞋+焚月苍炎冠+赤凤九霄袍
	["niepan"]={
		level = 1,
		["attributes"] = {
			["str"] = 110,
			["agi"] = 110,
			["int"] = 130,
			["hp"] = 6000,
			["armor"] = 40,
			["health_regen"] = 1000,
			["health_regen_pct"] = 3,
			["caster_damage"] = 30,
			["caster_coefficient"] = 60,
		},
		["modifiers"] = {
			-- "modifier_item_suit_niepan"
		},
		["requestItems"] = {"item_0501","item_0502","item_0503"},
	},

	------------------------------------------------------------------------------
	-- 自在乾天靴+归元天罡盔+极意无上铠
	["guiyuan"]={
		level = 1,
		["attributes"] = {
			["str"] = 130,
			["agi"] = 110,
			["int"] = 110,
			["hp"] = 10000,
			["armor"] = 40,
			["health_regen"] = 1000,
			["health_regen_pct"] = 3,
			["blade_damage"] = 30,
			["lancer_damage"] = 30,
			["blade_coefficient"] = 60,
			["lancer_coefficient"] = 60,
		},
		["modifiers"] = {
			-- "modifier_item_suit_guiyuan"
		},
		["requestItems"] = {"item_0504","item_0505","item_0506"},
	},

	------------------------------------------------------------------------------
	-- 玄陨震天靴+千炼大乘盔+天命八荒甲
	["zhanyun"]={
		level = 1,
		["attributes"] = {
			["str"] = 110,
			["agi"] = 130,
			["int"] = 110,
			["hp"] = 8000,
			["armor"] = 40,
			["health_regen"] = 1000,
			["health_regen_pct"] = 3,
			["sword_damage"] = 30,
			["knife_damage"] = 30,
			["sword_coefficient"] = 60,
			["knife_coefficient"] = 60,
		},
		["modifiers"] = {
			-- "modifier_item_suit_zhanyun"
		},
		["requestItems"] = {"item_0507","item_0508","item_0509"},
	},

	------------------------------------------------------------------------------
	-- 圣灵*涅槃冲霄鞋+圣灵*焚月苍炎冠+圣灵*赤凤九霄袍
	["niepan_sl"]={
		level = 1,
		["attributes"] = {
			["str"] = 130,
			["agi"] = 130,
			["int"] = 150,
			["hp"] = 6000,
			["armor"] = 40,
			["health_regen"] = 2000,
			["health_regen_pct"] = 3,
			["caster_damage"] = 50,
			["caster_coefficient"] = 80,
		},
		["modifiers"] = {
			"modifier_item_suit_niepan"
		},
		["requestItems"] = {"item_0510","item_0511","item_0512"},
	},

	------------------------------------------------------------------------------
	-- 圣灵*自在乾天靴+圣灵*归元天罡盔+圣灵*极意无上铠
	["guiyuan_sl"]={
		level = 1,
		["attributes"] = {
			["str"] = 150,
			["agi"] = 130,
			["int"] = 130,
			["hp"] = 10000,
			["armor"] = 40,
			["health_regen"] = 2000,
			["health_regen_pct"] = 3,
			["blade_damage"] = 50,
			["lancer_damage"] = 50,
			["blade_coefficient"] = 80,
			["lancer_coefficient"] = 80,
		},
		["modifiers"] = {
			"modifier_item_suit_guiyuan"
		},
		["requestItems"] = {"item_0513","item_0514","item_0515"},
	},

	------------------------------------------------------------------------------
	-- 圣灵*玄陨震天靴+圣灵*千炼大乘盔+圣灵*天命八荒甲
	["zhanyun_sl"]={
		level = 1,
		["attributes"] = {
			["str"] = 130,
			["agi"] = 150,
			["int"] = 130,
			["hp"] = 8000,
			["armor"] = 40,
			["health_regen"] = 2000,
			["health_regen_pct"] = 3,
			["sword_damage"] = 50,
			["knife_damage"] = 50,
			["sword_coefficient"] = 80,
			["knife_coefficient"] = 80,
		},
		["modifiers"] = {
			"modifier_item_suit_zhanyun"
		},
		["requestItems"] = {"item_0516","item_0517","item_0518"},
	},

	------------------------------------------------------------------------------
	-- 破羽迷靴+破羽战盔+破羽霜甲
	["poyu"]={
		level = 1,
		["attributes"] = {
			["str"] = 60,
			["agi"] = 60,
			["int"] = 60,
			["hp"] = 3000,
			["mana"] = 3000,
			["health_regen"] = 300,
			["sword_coefficient"] = 15,
			["blade_coefficient"] = 15,
			["knife_coefficient"] = 15,
			["caster_coefficient"] = 15,
			["lancer_coefficient"] = 15,
		},
		["modifiers"] = {
			"modifier_item_suit_poyu"
		},
		["requestItems"] = {"item_0522","item_0523","item_0524"},
	},

	------------------------------------------------------------------------------
	-- 冰烈炎霜袍+冰烈武器
	["binglie"]={
		level = 1,
		["attributes"] = {
			["str"] = 40,
			["agi"] = 40,
			["int"] = 40,
			["hp"] = 2000,
			["armor"] = 20,
			["health_regen"] = 200,
			["health_regen_pct"] = 1,
			["move_speed"] = 50,
			["sword_coefficient"] = 25,
			["blade_coefficient"] = 25,
			["knife_coefficient"] = 25,
			["caster_coefficient"] = 25,
			["lancer_coefficient"] = 25,
		},
		["modifiers"] = {
			"modifier_item_suit_binglie"
		},
		["requestItems"] = {"item_0535",{"item_0199","item_0200","item_0201","item_0202","item_0203"}},
	},

	------------------------------------------------------------------------------
	-- 极寒头环+极寒护手
	["jihan"]={
		level = 1,
		["attributes"] = {
			["str"] = 50,
			["agi"] = 50,
			["int"] = 50,
			["hp"] = 3000,
			["armor"] = 30,
			["health_regen"] = 200,
			["sword_coefficient"] = 30,
			["blade_coefficient"] = 30,
			["knife_coefficient"] = 30,
			["caster_coefficient"] = 30,
			["lancer_coefficient"] = 30,
		},
		["modifiers"] = {
			"modifier_item_suit_jihan"
		},
		["requestItems"] = {"item_0539","item_0540"},
	},

	------------------------------------------------------------------------------
	-- 黎殇战角+黎殇魔旗
	["lishang"]={
		level = 1,
		["attributes"] = {
			["str"] = 60,
			["agi"] = 60,
			["int"] = 30,
			["hp"] = 5000,
			["armor"] = 40,
			["health_regen"] = 500,
			["sword_coefficient"] = 15,
			["blade_coefficient"] = 15,
			["knife_coefficient"] = 40,
			["caster_coefficient"] = 15,
			["lancer_coefficient"] = 40,
		},
		["modifiers"] = {
			"modifier_item_suit_lishang"
		},
		["requestItems"] = {"item_0544","item_0545"},
	},

	------------------------------------------------------------------------------
	-- 冥炎宝羽+冥府幽蝶
	["buluominghe"]={
		level = 1,
		["attributes"] = {
		},
		["modifiers"] = {
			"modifier_item_suit_buluominghe"
		},
		["requestItems"] = {"item_0549","item_0484"},
	},

	------------------------------------------------------------------------------
	-- 巫邪甲+巫邪靴+巫邪盔
	["wuxie_one"]={
		level = 1,
		["attributes"] = {
			["str"] = 80,
			["agi"] = 80,
			["int"] = 80,
			["hp"] = 3000,
			["armor"] = 50,
			["health_regen"] = 300,
			["sword_coefficient"] = 25,
			["blade_coefficient"] = 25,
			["lancer_coefficient"] = 25,
		},
		["modifiers"] = {
			"modifier_item_suit_wuxie"
		},
		["requestItems"] = {"item_0560","item_0561","item_0562"},
	},

	------------------------------------------------------------------------------
	-- 巫邪袍+巫邪鞋+巫邪帽
	["wuxie_two"]={
		level = 1,
		["attributes"] = {
			["str"] = 80,
			["agi"] = 80,
			["int"] = 80,
			["hp"] = 2000,
			["armor"] = 40,
			["health_regen"] = 200,
			["caster_damage"] = 20,
			["knife_damage"] = 20,
			["knife_coefficient"] = 30,
			["caster_coefficient"] = 30,
		},
		["modifiers"] = {
			"modifier_item_suit_wuxie_two"
		},
		["requestItems"] = {"item_0563","item_0564","item_0565"},
	},

	------------------------------------------------------------------------------
	-- 天穹神靴+天穹神冠+天穹神衣
	["tianqiong"]={
		level = 1,
		["attributes"] = {
			["str"] = 120,
			["agi"] = 120,
			["int"] = 120,
			["hp"] = 6000,
			["armor"] = 40,
			["health_regen"] = 2000,
			["health_regen_pct"] = 2,
			["caster_damage"] = 20,
			["sword_damage"] = 20,
			["knife_damage"] = 20,
			["blade_damage"] = 20,
			["lancer_damage"] = 20,
			["sword_coefficient"] = 60,
			["blade_coefficient"] = 60,
			["knife_coefficient"] = 60,
			["caster_coefficient"] = 60,
			["lancer_coefficient"] = 60,
		},
		["modifiers"] = {
			"modifier_item_suit_tianqiong"
		},
		["requestItems"] = {"item_0581","item_0582","item_0583"},
	},

	------------------------------------------------------------------------------
	-- 行龙靴+行龙铠+行龙盔
	["xinglong"]={
		level = 1,
		["attributes"] = {
			["str"] = 55,
			["agi"] = 55,
			["int"] = 40,
			["sword_coefficient"] = 30,
			["blade_coefficient"] = 30,
			["knife_coefficient"] = 30,
			["caster_coefficient"] = 25,
			["lancer_coefficient"] = 30,
			["damage_outgoing"] = 15,
			["incoming_damage"] = -15,
		},
		["requestItems"] = {"item_0132","item_0530","item_0529"},
	},

	------------------------------------------------------------------------------
	-- 寒雪妖服+寒雪妖帽
	["hanxue"]={
		level = 1,
		["attributes"] = {
			["str"] = 25,
			["agi"] = 25,
			["int"] = 25,
			["armor"] = 15,
			["sword_coefficient"] = 10,
			["blade_coefficient"] = 10,
			["knife_coefficient"] = 10,
			["caster_coefficient"] = 10,
			["lancer_coefficient"] = 10,
		},
		["modifiers"] = {
			"modifier_item_suit_hanxue"
		},
		["requestItems"] = {"item_0578","item_0579"},
	},

	------------------------------------------------------------------------------
	-- 真武太极道冠（淬炼）+真武太极道服（淬炼）+真武太极道靴（淬炼）
	["zhenwutaiji_cuilian"]={
		level = 1,
		["attributes"] = {
			["str"] = 30,
			["agi"] = 30,
			["int"] = 70,
			["hp"] = 2500,
			["mana"] = 3000,
			["mana_regen"] = 300,
			["move_speed"] = 200,
			["armor"] = 30,
			["sword_coefficient"] = 15,
			["blade_coefficient"] = 15,
			["knife_coefficient"] = 15,
			["caster_coefficient"] = 45,
			["lancer_coefficient"] = 15,
			["damage_outgoing"] = 25,
		},
		["requestItems"] = {"item_0570","item_0571","item_0572"},
	},

	------------------------------------------------------------------------------
	-- 九黎耳环+九黎战盔+九黎战甲
	["jiuli"]={
		level = 1,
		["attributes"] = {
			["str"] = 80,
			["agi"] = 80,
			["int"] = 80,
			["hp"] = 3500,
			["health_regen"] = 200,
			["move_speed"] = 100,
			["armor"] = 30,
			["sword_coefficient"] = 30,
			["blade_coefficient"] = 30,
			["knife_coefficient"] = 30,
			["caster_coefficient"] = 30,
			["lancer_coefficient"] = 30,
		},
		["modifiers"] = {
			"modifier_item_suit_jiuli"
		},
		["requestItems"] = {"item_0567","item_0568","item_0569"},
	},
}
