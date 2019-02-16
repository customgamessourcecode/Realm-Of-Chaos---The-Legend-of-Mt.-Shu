
LearnExtraAbilitiesConfig =
{
	-- 蜀山大弟子
	["npc_task_shushandadizi"] = 
	{
		-- 御剑术
		["ability_hsj_lixinning01"] = 
		{
			state = 4,
			yuanhui = 10,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_juggernaut","npc_dota_hero_spectre","npc_dota_hero_slark"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 无名铁匠
	["npc_task_wumingtiejiang"] = 
	{
		-- 锻剑法
		["ability_hsj_lixinning02"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_juggernaut","npc_dota_hero_spectre","npc_dota_hero_slark"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 昆仑派大弟子
	["npc_task_kunlunpaidadizi"] = 
	{
		-- 昆仑剑法
		["ability_shushan_kunlunjianfa"] = 
		{
			state = 4,
			yuanhui = 14,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_juggernaut","npc_dota_hero_spectre","npc_dota_hero_slark"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},

		-- 贯穿天地
		["ability_shushan_guanchuantiandi"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_lancer"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 蜀山掌门
	["npc_task_shushanzhangmen"] = 
	{
		-- 蜀山心法
		["ability_shushan_shushanxinfa"] = 
		{
			state = 7,
			yuanhui = 30,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 神秘人（云炼）
	["npc_task_shenmiren"] = 
	{
		-- 逍遥心法
		["ability_hsj_lixinning03"] = 
		{
			state = 4,
			yuanhui = 14,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_assassin","npc_dota_hero_templar_assassin"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 毒千尺
	["npc_task_duqianchi"] = 
	{
		-- 断水毒功
		["ability_shushan_duanshuidugong"] = 
		{
			state = 4,
			yuanhui = 10,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_assassin","npc_dota_hero_templar_assassin"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 铁血门堂主
	["npc_task_tiexuetangtangzhu"] = 
	{
		-- 暗行刃法
		["ability_shushan_anxingrenfa"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_assassin","npc_dota_hero_templar_assassin"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},

		-- 殊途同归
		["ability_shushan_shututonggui"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_lancer"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 极地道人
	["npc_task_jididaoren"] = 
	{
		-- 日轮魔枪
		["ability_shushan_rilunmoqiang"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_phantom_lancer"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},

		-- 炎爆
		["ability_shushan_lingcai013"] = 
		{
			state = 4,
			yuanhui = 10,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lina"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 玄冰宫大祭司
	["npc_task_xuanbinggongdajisi"] = 
	{
		-- 雷击
		["ability_hsj_humei01"] = 
		{
			state = 4,
			yuanhui = 10,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lina"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 摩罗
	["npc_task_shenmiren_moluo"] =
	{
		-- 血海刀法
		["ability_hsj_moluo03"] = 
		{
			state = 4,
			yuanhui = 14,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_centaur","npc_dota_hero_legion_commander"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},

		-- 化血神功
		["ability_hsj_moluo02"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_centaur","npc_dota_hero_legion_commander"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 狐媚
	["npc_task_shenmiren_humei"] = 
	{
		-- 魅惑
		["ability_hsj_humei02"] = 
		{
			state = 4,
			yuanhui = 12,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lina"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},

		-- 妖神心法
		["ability_shushan_yaoshenxinfa"] = 
		{
			state = 7,
			yuanhui = 35,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 猎户
	["npc_task_liehu"] = 
	{
		-- 猎门刀决
		["ability_shushan_liemendaojue"] = 
		{
			state = 4,
			yuanhui = 10,
			quests = {"quest_shared_heguchuanshuo_good"},
			heroname = {"npc_dota_hero_centaur","npc_dota_hero_legion_commander"},
			label = "daoshu",
			upgrade_require =
			{
				yuanhui = 10,
				base_state = 1,
			},
		},
	},

	-- 玄冰宫宫主
	["npc_task_xuanbinggonggongzhu"] = 
	{
		-- 玄冰宫心法
		["ability_shushan_xuanbinggongxinfa"] = 
		{
			state = 7,
			yuanhui = 30,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 昆仑掌门
	["npc_task_kunlunzhangmen"] = 
	{
		-- 昆仑心法
		["ability_shushan_kunlunxinfa"] = 
		{
			state = 7,
			yuanhui = 30,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 凡无住持
	["npc_task_fanwuzhuchi"] = 
	{
		-- 佛门心法
		["ability_shushan_fomenxinfa"] = 
		{
			state = 7,
			yuanhui = 30,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 蚩尤后裔
	["npc_task_chiyouhouyi"] = 
	{
		-- 巫族心法
		["ability_shushan_wuzuxinfa"] = 
		{
			state = 7,
			yuanhui = 30,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 三清雕像
	["npc_task_sanqingdiaoxiang"] = 
	{
		-- 三清心法
		["ability_shushan_sanqingxinfa"] = 
		{
			state = 7,
			yuanhui = 35,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},

	-- 天道轮回石
	["npc_task_tiandaolunhuishi"] = 
	{
		-- 天道门心法
		["ability_shushan_tiandaomenxinfa"] = 
		{
			state = 7,
			yuanhui = 40,
			quests = {"quest_shared_bingyanzhenjun_good"},
			heroname = {},
			label = "xinfa",
			upgrade_require =
			{
				yuanhui = 30,
				base_state = 7,
			},
		},
	},
}