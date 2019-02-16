
SHUSHAN_WING_TIAN_GANG_ZHAN_YI = 1	-- 天罡战翼
SHUSHAN_WING_WAN_HE_FA_YI = 2		-- 万核法翼
SHUSHAN_WING_SHI_HUN_MO_YI = 3		-- 噬魂魔翼
SHUSHAN_WING_JIN_WU_YU_YI = 4		-- 金乌羽翼

ShuShanWingsConfig = 
{
	-- 天罡战翼
	[SHUSHAN_WING_TIAN_GANG_ZHAN_YI] =
	{
		SuitableUnits =
		{
			"npc_dota_hero_juggernaut",
			"npc_dota_hero_phantom_lancer",
		},
		Levels =
		{
			[1] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 20,
					["agi"] = 20,
					["int"] = 20,
					["armor"] = 10,
					["move_speed"] = 50,
					["sword_damage"] = 10,
					["knife_damage"] = 10,
					["blade_damage"] = 10,
					["caster_damage"] = 10,
					["lancer_damage"] = 10,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv01",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/tian_gang_zhan_yi/tian_gang_zhan_yi_lv01_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[2] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 30,
					["agi"] = 30,
					["int"] = 30,
					["armor"] = 20,
					["move_speed"] = 75,
					["sword_damage"] = 20,
					["knife_damage"] = 15,
					["blade_damage"] = 15,
					["caster_damage"] = 15,
					["lancer_damage"] = 20,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv02",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/tian_gang_zhan_yi/tian_gang_zhan_yi_lv02_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[3] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 30,
				},
				["Attributes"] =
				{
					["str"] = 40,
					["agi"] = 40,
					["int"] = 40,
					["armor"] = 30,
					["move_speed"] = 100,
					["sword_damage"] = 30,
					["knife_damage"] = 20,
					["blade_damage"] = 20,
					["caster_damage"] = 20,
					["lancer_damage"] = 30,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv03",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/tian_gang_zhan_yi/tian_gang_zhan_yi_lv03_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[4] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 50,
				},
				["Attributes"] =
				{
					["str"] = 60,
					["agi"] = 60,
					["int"] = 60,
					["armor"] = 60,
					["move_speed"] = 125,
					["sword_damage"] = 40,
					["knife_damage"] = 25,
					["blade_damage"] = 25,
					["caster_damage"] = 25,
					["lancer_damage"] = 40,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv04",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/tian_gang_zhan_yi/tian_gang_zhan_yi_lv04_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[5] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 70,
				},
				["Attributes"] =
				{
					["str"] = 100,
					["agi"] = 100,
					["int"] = 100,
					["armor"] = 100,
					["move_speed"] = 150,
					["sword_damage"] = 50,
					["knife_damage"] = 30,
					["blade_damage"] = 30,
					["caster_damage"] = 30,
					["lancer_damage"] = 50,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv05",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/tian_gang_zhan_yi/tian_gang_zhan_yi_lv05_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
		},
	},

	-- 万核法翼
	[SHUSHAN_WING_WAN_HE_FA_YI] =
	{
		SuitableUnits =
		{
			"npc_dota_hero_crystal_maiden",
		},
		Levels =
		{
			[1] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 20,
					["agi"] = 20,
					["int"] = 20,
					["armor"] = 5,
					["move_speed"] = 50,
					["sword_damage"] = 10,
					["knife_damage"] = 10,
					["blade_damage"] = 10,
					["caster_damage"] = 15,
					["lancer_damage"] = 10,
				},
				["Modifiers"] =
				{
					"wan_he_fa_yi_lv01",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/wan_he_fa_yi/wan_he_fa_yi_lv01_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[2] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 30,
					["agi"] = 30,
					["int"] = 30,
					["armor"] = 10,
					["move_speed"] = 75,
					["sword_damage"] = 15,
					["knife_damage"] = 15,
					["blade_damage"] = 15,
					["caster_damage"] = 30,
					["lancer_damage"] = 15,
				},
				["Modifiers"] =
				{
					"wan_he_fa_yi_lv02",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/wan_he_fa_yi/wan_he_fa_yi_lv02_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[3] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 30,
				},
				["Attributes"] =
				{
					["str"] = 40,
					["agi"] = 40,
					["int"] = 40,
					["armor"] = 15,
					["move_speed"] = 100,
					["sword_damage"] = 20,
					["knife_damage"] = 20,
					["blade_damage"] = 20,
					["caster_damage"] = 45,
					["lancer_damage"] = 20,
				},
				["Modifiers"] =
				{
					"wan_he_fa_yi_lv03",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/wan_he_fa_yi/wan_he_fa_yi_lv03_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[4] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 50,
				},
				["Attributes"] =
				{
					["str"] = 60,
					["agi"] = 60,
					["int"] = 60,
					["armor"] = 30,
					["move_speed"] = 125,
					["sword_damage"] = 25,
					["knife_damage"] = 25,
					["blade_damage"] = 25,
					["caster_damage"] = 60,
					["lancer_damage"] = 25,
				},
				["Modifiers"] =
				{
					"wan_he_fa_yi_lv04",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/wan_he_fa_yi/wan_he_fa_yi_lv04_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[5] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 70,
				},
				["Attributes"] =
				{
					["str"] = 100,
					["agi"] = 100,
					["int"] = 100,
					["armor"] = 50,
					["move_speed"] = 150,
					["sword_damage"] = 30,
					["knife_damage"] = 30,
					["blade_damage"] = 30,
					["caster_damage"] = 75,
					["lancer_damage"] = 30,
				},
				["Modifiers"] =
				{
					"wan_he_fa_yi_lv05",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/wan_he_fa_yi/wan_he_fa_yi_lv05_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
		},
	},

	-- 噬魂魔翼
	[SHUSHAN_WING_SHI_HUN_MO_YI] =
	{
		SuitableUnits =
		{
			"npc_dota_hero_phantom_assassin",
			"npc_dota_hero_centaur",
		},
		Levels =
		{
			[1] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 20,
					["agi"] = 20,
					["int"] = 20,
					["armor"] = 5,
					["move_speed"] = 50,
					["sword_damage"] = 10,
					["knife_damage"] = 15,
					["blade_damage"] = 15,
					["caster_damage"] = 10,
					["lancer_damage"] = 10,
				},
				["Modifiers"] =
				{
					"shi_hun_mo_yi_lv01",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/shi_hun_mo_yi/shi_hun_mo_yi_lv01_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[2] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 30,
					["agi"] = 30,
					["int"] = 30,
					["armor"] = 10,
					["move_speed"] = 75,
					["sword_damage"] = 15,
					["knife_damage"] = 30,
					["blade_damage"] = 30,
					["caster_damage"] = 15,
					["lancer_damage"] = 15,
				},
				["Modifiers"] =
				{
					"shi_hun_mo_yi_lv02",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/shi_hun_mo_yi/shi_hun_mo_yi_lv02_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[3] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 30,
				},
				["Attributes"] =
				{
					["str"] = 40,
					["agi"] = 40,
					["int"] = 40,
					["armor"] = 15,
					["move_speed"] = 100,
					["sword_damage"] = 20,
					["knife_damage"] = 45,
					["blade_damage"] = 45,
					["caster_damage"] = 20,
					["lancer_damage"] = 20,
				},
				["Modifiers"] =
				{
					"shi_hun_mo_yi_lv03",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/shi_hun_mo_yi/shi_hun_mo_yi_lv03_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[4] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 50,
				},
				["Attributes"] =
				{
					["str"] = 60,
					["agi"] = 60,
					["int"] = 60,
					["armor"] = 30,
					["move_speed"] = 125,
					["sword_damage"] = 25,
					["knife_damage"] = 60,
					["blade_damage"] = 60,
					["caster_damage"] = 25,
					["lancer_damage"] = 25,
				},
				["Modifiers"] =
				{
					"shi_hun_mo_yi_lv04",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/shi_hun_mo_yi/shi_hun_mo_yi_lv04_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[5] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 70,
				},
				["Attributes"] =
				{
					["str"] = 100,
					["agi"] = 100,
					["int"] = 100,
					["armor"] = 50,
					["move_speed"] = 150,
					["sword_damage"] = 30,
					["knife_damage"] = 75,
					["blade_damage"] = 75,
					["caster_damage"] = 30,
					["lancer_damage"] = 30,
				},
				["Modifiers"] =
				{
					"shi_hun_mo_yi_lv05",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/shi_hun_mo_yi/shi_hun_mo_yi_lv05_p.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
		},
	},

	-- 金乌羽翼
	[SHUSHAN_WING_JIN_WU_YU_YI] =
	{
		SuitableUnits =
		{
		},
		Levels =
		{
			[1] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 0,
				},
				["Attributes"] =
				{
					["str"] = 30,
					["agi"] = 30,
					["int"] = 30,
					["armor"] = 10,
					["move_speed"] = 50,
					["sword_damage"] = 15,
					["knife_damage"] = 15,
					["blade_damage"] = 15,
					["caster_damage"] = 15,
					["lancer_damage"] = 15,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv01",
					"wan_he_fa_yi_lv01",
					"shi_hun_mo_yi_lv01",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/jin_wu_yu_yi/jin_wu_yu_yi_lv01_arc.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[2] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 10,
				},
				["Attributes"] =
				{
					["str"] = 45,
					["agi"] = 45,
					["int"] = 45,
					["armor"] = 15,
					["move_speed"] = 75,
					["sword_damage"] = 30,
					["knife_damage"] = 30,
					["blade_damage"] = 30,
					["caster_damage"] = 30,
					["lancer_damage"] = 30,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv02",
					"wan_he_fa_yi_lv02",
					"shi_hun_mo_yi_lv02",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/jin_wu_yu_yi/jin_wu_yu_yi_lv02_arc.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[3] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 30,
				},
				["Attributes"] =
				{
					["str"] = 60,
					["agi"] = 60,
					["int"] = 60,
					["armor"] = 25,
					["move_speed"] = 100,
					["sword_damage"] = 45,
					["knife_damage"] = 45,
					["blade_damage"] = 45,
					["caster_damage"] = 45,
					["lancer_damage"] = 45,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv03",
					"wan_he_fa_yi_lv03",
					"shi_hun_mo_yi_lv03",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/jin_wu_yu_yi/jin_wu_yu_yi_lv03_arc.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[4] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 50,
				},
				["Attributes"] =
				{
					["str"] = 80,
					["agi"] = 80,
					["int"] = 80,
					["armor"] = 40,
					["move_speed"] = 125,
					["sword_damage"] = 60,
					["knife_damage"] = 60,
					["blade_damage"] = 60,
					["caster_damage"] = 60,
					["lancer_damage"] = 60,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv04",
					"wan_he_fa_yi_lv04",
					"shi_hun_mo_yi_lv04",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/jin_wu_yu_yi/jin_wu_yu_yi_lv04_arc.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
			[5] =
			{
				["Cost"] =
				{
					type = CURRENCY_TYPE_HUNTING_POINTS,
					amount = 70,
				},
				["Attributes"] =
				{
					["str"] = 120,
					["agi"] = 120,
					["int"] = 120,
					["armor"] = 70,
					["move_speed"] = 150,
					["sword_damage"] = 75,
					["knife_damage"] = 75,
					["blade_damage"] = 75,
					["caster_damage"] = 75,
					["lancer_damage"] = 75,
				},
				["Modifiers"] =
				{
					"tian_gang_zhan_yi_lv05",
					"wan_he_fa_yi_lv05",
					"shi_hun_mo_yi_lv05",
				},
				["Particles"] =
				{
					{
						Path = "particles/avalon/wings/jin_wu_yu_yi/jin_wu_yu_yi_lv05_arc.vpcf",
						Attach = PATTACH_POINT_FOLLOW,
						ControlPointEnts = {
							[0] = {target = "CASTER", attachment = "attach_wing"}
						},
					},
				},
			},
		},
	},
}

CustomNetTables:SetTableValue("Common", "ShuShanWingsConfig", ShuShanWingsConfig)