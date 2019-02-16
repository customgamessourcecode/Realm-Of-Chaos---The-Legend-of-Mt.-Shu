
--[[
测试专用脚本
例如在控制台输入 -quests 就会调用CustomTest['quests']函数
在CustomTest中的每个函数都会接受playerid, player, hero, args三个参数
]]


if not TurnCustomGameDebug then return end

if CustomTest == nil then
	CustomTest = {}
	CustomTest.__print = _G["print"]
	setmetatable(CustomTest,CustomTest)
end

local public = CustomTest

-- local __print = CustomTest.__print
-- _G["print"] = function( ... )
-- 	__print(...)

-- 	local t = {...}
-- 	for i=1,#t do
-- 		t[i] = tostring(t[i])
-- 	end
-- 	CustomMessage:all({
-- 		type = "log",
-- 		msg = table.concat(t,'    '),
-- 		styles = {
-- 			color = "#36B8FF",
-- 		}
-- 	})
-- end

function public:__call(name, playerid, player, args)
	if self[name] ~= nil then
		print("====== Start custom test "..name.." ======")
		self[name](self,playerid, player, player:GetAssignedHero(), args)
		print("======  End custom test "..name.."  ======")
	elseif name ~= "item" then
		print("Not found test "..name)
		print("Similar:")
		for k in pairs(self) do
			if string.find(k,name) then
				print("-- @"..k)
			end
		end
	end
end

---------------------------------------------------------------

function public:attacking_start()
	SpawnSystemCtrl:GetAttackingSpawner():test()
end

---------------------------------------------------------------

function public:quests(playerid, player, hero, args)
	local qm = QuestsCtrl(hero)
	DeepPrintTable(qm:table())
end

function public:quests_update(playerid, player, hero, args)
	QuestsCtrl:UpdateQuests(hero)
end

---------------------------------------------------------------

function public:bag(playerid, player, hero, args)
	local bag = hero:GetBag()
	if #args == 0 then
		bag:Look(function(bagSlot,itemIndex,item)
			print("[Bag] Slot: " .. bagSlot .. "\titemIndex: " .. itemIndex)
		end)

	elseif args[1] == "create" and type(args[2]) == "string" then
		local charges = tonumber(args[3] or 1)
		if bag:CreateItem(args[2], charges) then
			print("Create Item:"..args[2].." success")
		else
			print("Create Item:"..args[2].." fail")
		end
	end
end

---------------------------------------------------------------

function public:createunit(playerid, player, hero, args)
	if #args == 0 then
		local unit = CreateUnitByName("npc_dota_lesser_eidolon", hero:GetOrigin() + RandomVector(200), true, nil, nil, DOTA_TEAM_BADGUYS)
	elseif args[1] == "health" then
		local unit = CreateUnitByName("npc_dota_lesser_eidolon", hero:GetOrigin() + RandomVector(200), true, nil, nil, DOTA_TEAM_BADGUYS)

		local health = tonumber(args[2])
		if health then
			unit:SetMaxHealth(health)
			unit:SetBaseMaxHealth(health)
			unit:SetHealth(unit:GetMaxHealth())
		end
	else
		local unitname = args[1]
		local unit = CreateUnitByName(unitname, hero:GetOrigin() + RandomVector(200), true, nil, nil, DOTA_TEAM_BADGUYS)
		unit:SetControllableByPlayer(playerid, true)

		if unit then
			for i,v in ipairs(args) do
				if v == "health" then
					local health = tonumber(args[i+1])
					if health then
						unit:SetMaxHealth(health)
						unit:SetBaseMaxHealth(health)
						unit:SetHealth(unit:GetMaxHealth())
					end
				end
			end
		end
			
	end
end

---------------------------------------------------------------

function public:hero(playerid, player, hero, args)
	-- if args[1] == "1" and hero:GetUnitName() ~= "npc_dota_hero_juggernaut" then
	-- 	PlayerResource:ReplaceHeroWith(playerid, "npc_dota_hero_juggernaut", 0, 0)

	-- elseif args[1] == "2" and hero:GetUnitName() ~= "npc_dota_hero_crystal_maiden" then
	-- 	PlayerResource:ReplaceHeroWith(playerid, "npc_dota_hero_crystal_maiden", 0, 0)

	-- end
	hero:AddItemByName("item_0204")
	hero:AddItemByName("item_0186")
	hero:AddItemByName("item_0205")
	hero:AddItemByName("item_0182")
	hero:AddItemByName("item_0185")
	hero:AddItemByName("item_0320")

	hero:SetCustomAttribute('merits','nb',500)
	hero:SetCustomAttribute('state','nb',3)
end

---------------------------------------------------------------

function public:outputlocal()
	local kv = LoadKeyValues("scripts/test/tooltips.txt")

	local t = {}

	for k,v in pairs(kv) do
		t[k] = {
			["key"]= k,
		    ["source"]= "resource",
		    ["schinese"]= v,
		    ["english"]= ""
		}
	end

	local out = io.open("d:/dota2_lua_api.txt","w")
    if out then
        out:write(json.encode(t))
        out:close()
    end
end

---------------------------------------------------------------

function public:attrs(playerid, player, hero, args)
	for k,v in pairs(hero:GetAllCustomAttribute()) do
		print(string.format("%15s:%d",k,v))
	end
end

function public:attrs2(playerid, player, hero, args)
	for k,v in pairs(hero:StatisticalAttributes()) do
		print(string.format("%15s:%d",k,v))
	end
end

function public:attrchildren(playerid, player, hero, args)
	if type(args[1]) == "string" then
		for k,v in pairs(hero:GetCustomAttributeChildren(args[1])) do
			print(string.format("%15s:%d",k,v))
		end
	else
		DeepPrintTable(hero.__CustomAttributesChildren)
	end
end

---------------------------------------------------------------

function public:item_attrs(playerid, player, hero, args)
	for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item then
			print("--- "..i,item:GetAbilityName())
			for k,v in pairs(item:GetAllCustomAttribute()) do
				print(string.format("%15s:%d",k,v))
			end
		end
	end
end

---------------------------------------------------------------

local MessageRandom = {
	{
		type = "bottom",
		class= "error",
	},
	{
		type = "bottom",
		class= "success",
	},
	{
		type = "bottom",
		class= "info",
	},
	{
		type = "bottom",
		class= "warning",
	},
	{
		type = "left",
		class= "warning",
	},
	{
		type = "left",
		class= "success",
	},
}
function public:msg(playerid, player, hero, args)
	local index = tonumber(args[1]) or RandomInt(1, #MessageRandom)
	local msg = MessageRandom[index]
	CustomMessage:all( msg )
end

---------------------------------------------------------------
function public:currencies(playerid, player, hero, args)
	for k,v in pairs(CurrenciesConfig) do
		print(string.format("%5s:%d",v.name,hero:GetCurrency(k)))
	end
end
---------------------------------------------------------------
-- 给予货币
function public:give(playerid, player, hero, args)
	if args[1] == "gold" then
		hero:ModifyCurrency(CURRENCY_TYPE_GOLD,tonumber(args[2]) or RandomInt(0, 1000))
	elseif args[1] == "wood" then
		hero:ModifyCurrency(CURRENCY_TYPE_WOOD,tonumber(args[2]) or RandomInt(0, 1000))
	elseif args[1] == "yuanhui" then
		hero:ModifyCurrency(CURRENCY_TYPE_YUANHUI,tonumber(args[2]) or RandomInt(0, 1000))
	elseif args[1] == "points" then
		hero:ModifyCurrency(CURRENCY_TYPE_PROTECT_FORT_POINTS,tonumber(args[2]) or RandomInt(0, 1000))
		hero:ModifyCurrency(CURRENCY_TYPE_HUNTING_POINTS,tonumber(args[2]) or RandomInt(0, 1000))
	end
end
---------------------------------------------------------------
function public:setting(playerid, player, hero, args)
	DeepPrintTable(PlayerSetting:all(hero:GetSteamID()))
end
---------------------------------------------------------------
-- 生成NPC的modifier
function public:npctask()
	local basePath = '../../dota_addons/shushan/scripts/vscripts/modifiers'
	local file = assert(io.open(basePath..'/modifier_npc_task.lua',"r"))
	local text1 = file:read("*all")
	file = assert(io.open(basePath..'/modifier_npc_task_hero_touching.lua',"r"))
	local text2 = file:read("*all")
	
	local kv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	for unitname in pairs(kv) do
		if string.find(unitname,"npc_task_") == 1 then
			local copyText = string.gsub(text1,"modifier_npc_task","modifier_"..unitname)
			local out = io.open(basePath..'/npc_task/' .. "modifier_"..unitname .. '.lua',"w")
			if out then
				out:write(copyText)
				out:close()
			end
			copyText = string.gsub(text2,"modifier_npc_task","modifier_"..unitname)
			out = io.open(basePath..'/npc_task/' .. "modifier_"..unitname .. '_hero_touching.lua',"w")
			if out then
				out:write(copyText)
				out:close()
			end
		end
	end
end
---------------------------------------------------------------
function public:_G()
	DeepPrintTable(_G)
end
---------------------------------------------------------------
-- 获取套装属性
function public:suitattrs(playerid, player, hero, args)
	for k,v in pairs(CustomAttributesConfig) do
		print(string.format("%15s:%d",v,SuitSystem:GetAttribute(hero, v)))
	end
end

---------------------------------------------------------------
-- 生成NPC
local npc_text = [[
	"npc_task_0002"	
	{
		// General
		//----------------------------------------------------------------
		"Model"						"models/creeps/neutral_creeps/n_creep_satyr_a/n_creep_satyr_a.vmdl"	// Model.
		"BaseClass"					"npc_dota_creature"
		"SoundSet"					"n_creep_Ranged"
		"GameSoundsFile"			"soundevents/game_sounds_creeps.vsndevts"
		"Level"						"1"
		"ModelScale" 				".9"

		// Abilities
		//----------------------------------------------------------------
		"Ability1"					""			// Ability 1
		"Ability2"					""			// Ability 2
		"Ability3"					""			// Ability 3
		"Ability4"					""			// Ability 4

		// Armor
		//----------------------------------------------------------------
		"ArmorPhysical"				"99"			// Physical protection.
		"MagicalResistance"			"99"

		// Attack
		//----------------------------------------------------------------
		"AttackCapabilities"		"DOTA_UNIT_CAP_NO_ATTACK"

		// Bounds
		//----------------------------------------------------------------
		"RingRadius"				"40"
		"HealthBarOffset"			"170"

		// Movement
		//----------------------------------------------------------------
		"MovementCapabilities"		"DOTA_UNIT_CAP_MOVE_GROUND"
		"MovementSpeed"				"270"	

		// Status
		//----------------------------------------------------------------
		"StatusHealth"				"99999999"  // Base health.
		"StatusHealthRegen"			"100"		// Health regeneration rate.
		"StatusMana"				"0"			// Base mana.
		"StatusManaRegen"			"0.0"		// Mana regeneration rate.		 
		
		// Vision
		//----------------------------------------------------------------
		"VisionDaytimeRange"		"400"		// Range of vision during day light.
		"VisionNighttimeRange"		"400"		// Range of vision at night time.

		// Team
		//----------------------------------------------------------------
		"TeamName"					"DOTA_TEAM_NEUTRALS"						// Team name.
		"CombatClassAttack"			"DOTA_COMBAT_CLASS_ATTACK_PIERCE"
		"CombatClassDefend"			"DOTA_COMBAT_CLASS_DEFEND_BASIC"
		"UnitRelationshipClass"		"DOTA_NPC_UNIT_RELATIONSHIP_TYPE_DEFAULT"
	}
]]
function public:makenpc()
	local npclist = {}
	for k,v in pairs(QuestsKV) do
		npclist[v["AcceptNPC"]] = true

		if v["SubQuests"] then
			for _,t in pairs(v["SubQuests"]) do
				if t["Type"] == "FIND_UNIT" then
					npclist[t["Target"]] = true
				end
			end
		end
	end

	local text = ""
	local chinese = LoadKeyValues("resource/addon_schinese.txt")["Tokens"]
	for k,v in pairs(npclist) do
		-- text = text .. string.gsub(npc_text,'npc_task_0002',k)
		-- text = text .. '\n' .. '\t\t"' .. k .. '"\t\t"' .. tostring(chinese[k]) .. '"'
	end
	out = io.open('d:/npc_text.txt',"w")
	if out then
		out:write(text)
		out:close()
	end
end
---------------------------------------------------------------

function public:qwd()
	local ent = Entities:FindByName(nil, "dota_goodguys_fort")
	if ent then
		ent:AddNewModifier(ent, nil, "modifier_qwd", nil)
	end
end

function public:hg(playerid, player, hero, args)
	FindClearSpaceForUnit(hero, Vector(890.917,-7344.33,341.845),false)
end

function public:effect(playerid, player, hero, args)
	-- local p = ParticleManager:CreateParticle("particles/avalon/evade_effect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	-- ParticleManager:SetParticleControlEnt(p, 0, hero, 5, "follow_origin", hero:GetOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(p, 3, hero, 5, "follow_origin", hero:GetOrigin(), true)
	-- ParticleManager:SetParticleControl(p, 4, Vector(1,0,0))
	-- ParticleManager:SetParticleControl(p, 5, hero:GetOrigin())
	-- hero:AddNewModifier(hero, nil, "modifier_quests_reward_kaiyi", nil)
	-- print(hero:GetAbilityByIndex(0):GetLevel(),hero:GetAbilityByIndex(0):GetSpecialValueFor("total_outdamage"))
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end

function public:nb(playerid, player, hero, args)
	hero:AddItemByName("item_0510")
	hero:AddItemByName("item_0511")
	hero:AddItemByName("item_0512")
	hero:AddItemByName("item_0513")
	hero:AddItemByName("item_0514")
	hero:AddItemByName("item_0515")
	hero:AddItemByName("item_0516")
	hero:AddItemByName("item_0517")
	hero:AddItemByName("item_0518")

	hero:AddItemByName("item_0479")
	hero:AddItemByName("item_0480")
	hero:AddItemByName("item_0481")
	hero:AddItemByName("item_0482")
	hero:AddItemByName("item_0483")
	hero:AddItemByName("item_0484")
	hero:AddItemByName("item_0546")
	hero:AddItemByName("item_0551")

	hero:AddItemByName("item_0088")
	hero:AddItemByName("item_0089")
	hero:AddItemByName("item_0090")
	hero:AddItemByName("item_0091")

	hero:SetCustomAttribute('merits','nb',500)
	hero:FindAbilityByName("ability_shushan_teleport"):SetLevel(1)
	hero:SetCustomAttribute('state','nb',3)
	hero:GiveHuntingPoints(500)
	WingsSystem:Binding(hero, SHUSHAN_WING_TIAN_GANG_ZHAN_YI)
	WingsSystem:SetLevel(hero, 5)
end

function public:whosyourdaddy(playerid, player, hero, args)
	hero:AddNewModifier(hero, nil, "modifier_whosyourdaddy", nil)
	hero:SetHealth(hero:GetMaxHealth())
end

---------------------------------------------------------------

-- 生成物品获得方式
function public:obtain()
	local items = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	local quests = LoadKeyValues("scripts/quests/quests.kv")

	function HasItem(t, itemname)
		local has = false
		for k,v in pairs(t) do
			if k == itemname then
				has = true
			elseif type(v) == "table" then
				has = HasItem(v, itemname)
			elseif v == itemname then
				has = true
			end
			if has then
				return true
			end
		end
		return has
	end

	function QuestHasItems(t, itemname, isReward)
		local has = false
		for k,v in pairs(t) do
			if k == itemname then
				has = true
			elseif type(v) == "table" then
				if isReward or string.find(k,"Reward") ~= nil then
					has = QuestHasItems(v, itemname, true)
				end
			elseif isReward then
				if k == itemname or v == itemname then
					has = true
				end
			end
			if has then
				return true
			end
		end
		return has
	end

	-- /game/shushan/scripts/vscripts/config/obtain_items
	local basePath = "../../../content/dota_addons/shushan/panorama/scripts/custom_game/how_to_obtain_items.js"
	local script_text = [[

// 此文件是物品掉落的静态数据，通过命令-obtain生成

var m_ObtainItemsData = {
]]
	for itemname,item in pairs(items) do
		local text = ""
		
		-- 从任务中查找
		for quest_name,quest_table in pairs(quests) do
			if QuestHasItems(quest_table, itemname) then
				text = text .. "{type:'Quest',name:'" .. quest_name .. "'},"
			end
		end

		-- 从掉落中查找
		for unitname,v in pairs(Dropped_Item_Table) do
			if HasItem(v, itemname) then
				text = text .. "{type:'Kill',name:'" .. unitname .. "'},"
			end
		end

		-- 从商店中查找
		for unitname,v in pairs(NPCShops) do
			if HasItem(v, itemname) then
				text = text .. "{type:'Shop',name:'" .. unitname .. "'},"
			end
		end

		-- 从积分商店中查找
		for name,v in pairs(PointsShops) do
			if HasItem(v, itemname) then
				text = text .. "{type:'Points',name:'" .. name .. "'},"
			end
		end

		-- 从合成中查询
		for _,v in pairs(item_compose_table) do
			if v.composeItem == itemname then
				text = text .. "{type:'Compose'},"
				break
			end
		end

		-- 从采集中查询
		for i,v in ipairs(SpawnSystemCtrl.__plant_list) do
			if v:itemname() == itemname then
				text = text .. "{type:'Plant'},"
				break
			end
		end

		-- 从采矿中查询
		for unitname,t in pairs(CollectOreFakeUnitConfig) do
			for i,v in ipairs(t["DropItems"]) do
				if v.itemname == itemname then
					text = text .. string.format("{type:'CollectOres', chance:%s, name:'%s'},", v.chance, unitname)
					break
				end
			end
		end

		-- 从炼化中查询
		for k,v in pairs(FuseItemsConfig) do
			if k == itemname then
				text = text .. "{type:'FuseItem'},"
			end
		end

		-- 从炼器中查询
		for k,t in pairs(mixing_weapon_config) do
			for i,stages in ipairs(t) do
				for h,g in ipairs(stages) do
					for j,v in ipairs(g) do
						if v.composeItem == itemname then
							text = text .. string.format("{type:'MixingWeapon', stage:%s},", i)
							break
						end
					end
				end
			end
		end

		if #text > 0 then
			script_text = script_text .. "\t'" .. itemname .. "':" .. "[" .. string.sub(text,1,#text-1) .. "],\n"
		end
	end

	script_text = script_text .. "}\n\n"

	script_text = script_text .. [[
GameUI.HowToObtainItems = function (itemname) {
	return m_ObtainItemsData[itemname];
}
]]

	out = io.open(basePath,"w")
	if out then
		out:write(script_text)
		out:close()
	end
end

---------------------------------------------------------------

function public:motion(playerid, player, hero, args)
	local motion = hero:CreateMotion()
	local forward = hero:GetForwardVector()

	motion:Jump(hero:GetOrigin(), hero:GetOrigin() + forward*1000, 3000, 0.3, "modifier_custom_stun")
end

---------------------------------------------------------------

function public:dialog(playerid, player, hero, args)
	ModalDialog(hero, {
		type = "CommonForLua",
		title = "dialog_title_warning",
		text = "shushan_do_you_want_to_go_to_jifengya",
		style = "warning",
		options = {
			{
				key = "YES",
				func = function ()
					print("YES")
				end,
			},
			{
				key = "NO",
				func = function ()
					print("NO")
				end,
			},
		},
	})
end

---------------------------------------------------------------
local hunting_quests_units_filter = {
["LV8_fb_11_boss_canglang"]=1,
["LV8_fb_11_boss_jueying"]=1,
["LV8_fb_11_boss_shikong"]=1,
["LV8_fb_11_boss_wangzui"]=1,
["LV8_fb_11_boss_wuran"]=1,
["LV8_fb_11_boss_duanxie"]=1,
["LV8_fb_11_boss_yingze"]=1,
["LV9_fb_11_boss_canglangfanzhuan"]=1,
["LV9_fb_11_boss_jueyingfanzhuan"]=1,
["LV9_fb_11_boss_shikongfanzhuan"]=1,
["LV9_fb_11_boss_wangzuifanzhuan"]=1,
["LV9_fb_11_boss_wuranfanzhuan"]=1,
["LV9_fb_11_boss_duanxiefanzhuan"]=1,
["LV9_fb_11_boss_yingzefanzhuan"]=1,
["LV9_fb_10_boss_dijianghuanying"]=1, --帝江幻影
["LV9_fb_10_boss_goumanghuanying"]=1, --句芒幻影
["LV9_fb_10_boss_lushouhuanying"]=1, --蓐收幻影
["LV9_fb_10_boss_gonggonghuanying"]=1, --共工幻影
["LV9_fb_10_boss_zhuronghuanying"]=1, --祝融幻影
["LV9_fb_10_boss_zhujiuyinhuanying"]=1, --烛九阴幻影
["LV9_fb_10_boss_qianglianghuanying"]=1, --强良幻影
["LV9_fb_10_boss_shebishihuanying"]=1, --奢比尸幻影
["LV9_fb_10_boss_tianwuhuanying"]=1, --天吴幻影
["LV9_fb_10_boss_yuezihuanying"]=1, --龠兹幻影
["LV9_fb_10_boss_xuanminghuanying"]=1, --玄冥幻影
["LV9_fb_10_boss_houtuhuanying"]=1, --后土幻影
["LV11_fb_10_boss_panguhuanying"]=1, --盘古幻影
["LV5_fb_06_boss_toudanyaoguai"]=1, --
["LV12_fb_20_boss_huangtianmolong"]=1, --
["LV13_fb_20_boss_fushuizhifeng"]=1, --
}

function public:make_wanted_quests()
	local basePath = "../../dota_addons/shushan/scripts/quests/quest_special_hunting.kv"
	local units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	local quests_text = [[
"Quests"
{
]]

	local quest_template = [[
	"quest_shared_example_good"
	{
		"AcceptNPC"						"npc_task_tiandaomenyunyoudizi"
		"IsMainQuest"					"0"
		"IsRepeat"						"1"
		"IsHuntingQuest"				"1"
		"Level"							"Level_num"
		"SharedName"					"shushan_hunting_quests"

		"Precondition" 			
		{
			"PreQuests"
			{
			}
			"LogicalFormula"			"LogicalFormulaText"
		}

		"SubQuests" 
		{
			"1"
			{
				"Type"					"KILL_UNIT"
				"Target"				"npc_dota_lesser_eidolon"
				"MaxCount"				"1"
			}
		}

		// 提交任务给予奖励
		"SubmitRewards"
		{
			"Fixed" 										//固定奖励
			{
				"EXP"				"EXP_num"
				"Gold"				"Gold_num"
				"yuanhui"			"yuanhui_num"
				"hunting_points"	"hunting_points_num"
			}
		}
	}
]]
	local quests_table = {
		[1] = {
			hunting_points = "i[1,2]",
			EXP = "i[200,500]",
			Gold = "i[200,500]",
			yuanhui = "1",
		},
		[2] = {
			hunting_points = "i[2,3]",
			EXP = "i[600,1000]",
			Gold = "i[600,1000]",
			yuanhui = "2",
		},
		[3] = {
			hunting_points = "i[3,7]",
			EXP = "i[1500,2000]",
			Gold = "i[1000,1500]",
			yuanhui = "3",
		},
		[4] = {
			hunting_points = "i[7,12]",
			EXP = "i[2000,2500]",
			Gold = "i[2000,2500]",
			yuanhui = "4",
		},
		[5] = {
			hunting_points = "i[12,25]",
			EXP = "i[2500,3000]",
			Gold = "i[2500,3000]",
			yuanhui = "5",
		},
	}

	for unitname in pairs(units) do
		if string.find(unitname,"_fb_") ~= nil and string.find(unitname,"_boss_") ~= nil and hunting_quests_units_filter[unitname] == nil then
			local level = 1
			local quest_level = 1
			local state_min = 0
			local state_max = 0

			for i=1,15 do
				if string.find(unitname,"LV" .. i .. "_") == 1 then
					level = i
					break
				end
			end

			if level >= 1 and level <= 3 then
				state_min = 1
				state_max = 3
				quest_level = 1
			elseif level >= 4 and level <= 6 then
				state_min = 4
				state_max = 6
				quest_level = 2
			elseif level >= 7 and level <= 9 then
				state_min = 7
				state_max = 9
				quest_level = 3
			elseif level >= 10 and level <= 11 then
				state_min = 10
				state_max = 11
				quest_level = 4
			elseif level >= 12 and level <= 13 then
				state_min = 12
				state_max = 13
				quest_level = 5
			end

			local text = string.gsub(quest_template,"npc_dota_lesser_eidolon",unitname)
			text = string.gsub(text,"quest_shared_example_good","quest_special_hunting_"..unitname)
			text = string.gsub(text,"Level_num",tostring(quest_level))
			text = string.gsub(text,"LogicalFormulaText","$can_accept_hunting")

			for k,v in pairs(quests_table[quest_level]) do
				text = string.gsub(text,k.."_num",v)
			end
			
			quests_text = quests_text .. text
		end
	end

	quests_text = quests_text .. "}"

	out = io.open(basePath,"w")
	if out then
		out:write(quests_text)
		out:close()
	end
end

function public:hunting(playerid, player, hero, args)
	local list = QuestsCtrl.player_quests_special_hunting[hero:GetEntityIndex()]
	for i,v in ipairs(list) do
		v.quest_name = nil
	end
end

---------------------------------------------------------------

function public:config()
	local basePath = "../../../content/dota_addons/shushan/panorama/scripts/custom_game/copy_from_lua_config.js"
	local script_text = [[
GameUI.GetFuseItemsConfig = function () {
	return FuseItemsConfig;
}
GameUI.GetFuseItemsData = function (itemname) {
	return FuseItemsConfig[itemname];
}
GameUI.GetComposeTable = function () {
	return ComposeTable;
}
GameUI.GetComposeData = function (itemname) {
	for (var i = 0; i < ComposeTable.length; i++) {
		if (ComposeTable[i]["composeItem"] === itemname) {
			return ComposeTable[i]
		}
	}
}
GameUI.GetMixingWeaponConfig = function () {
	return MixingWeaponConfig;
}
GameUI.GetMixingWeaponData = function (index, unitname) {
	return MixingWeaponConfig[unitname || Entities.GetUnitName(Players.GetLocalHero())][index];
}
GameUI.GetItemSuitName = function (itemname) {
	for(var j in ItemSuitTable) {
		var requestItems = ItemSuitTable[j]["requestItems"];

		for (var i = 0; i < requestItems.length; i++) {
			if( typeof requestItems[i] === "object" ) {
				var table = requestItems[i];
				for(var k in table) {
					if( table[k] == itemname ) {
						return j;
					}
				}
			}
			else if( requestItems[i] == itemname ) {
				return j;
			}
		}
	}
	return "";
}
GameUI.GetItemSuitData = function (name) {
	return ItemSuitTable[name];
}
GameUI.GetUnitDroppedItems = function (name) {
	return DroppedItemTable[name];
}
GameUI.GetItemConfig = function (name) {
	return ItemConfig[name];
}
GameUI.GetHeiShiShangRenThreeToOneConfig = function (name) {
	return HeiShiShangRenThreeToOneConfig[name];
}
]]
	script_text = script_text .. "\n\n"

	-- 炼化
	local str = json.encode(FuseItemsConfig)
	script_text = script_text .. "\n\nvar FuseItemsConfig = \n" .. str .. "\n\n"

	-- 合成
	local str = json.encode(item_compose_table)
	script_text = script_text .. "\n\nvar ComposeTable = \n" .. str .. "\n\n"

	-- 炼器
	local str = json.encode(mixing_weapon_config)
	script_text = script_text .. "\n\nvar MixingWeaponConfig = \n" .. str .. "\n\n"

	-- 套装
	local str = json.encode(item_suit_table)
	script_text = script_text .. "\n\nvar ItemSuitTable = \n" .. str .. "\n\n"

	-- 掉落
	local str = json.encode(Dropped_Item_Table)
	script_text = script_text .. "\n\nvar DroppedItemTable = \n" .. str .. "\n\n"

	-- 物品配置
	local str = json.encode(ItemConfig)
	script_text = script_text .. "\n\nvar ItemConfig = \n" .. str .. "\n\n"

	-- 黑市商人 - 三换一功能
	local str = json.encode(HeiShiShangRenThreeToOneConfig)
	script_text = script_text .. "\n\nvar HeiShiShangRenThreeToOneConfig = \n" .. str .. "\n\n"

	out = io.open(basePath,"w")
	if out then
		out:write(script_text)
		out:close()
	end
end

---------------------------------------------------------------

function public:ui()
	self:config()
	self:make_wanted_quests()
	self:obtain()

	local units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	local token = LoadKeyValues("resource/addon_schinese.txt")["Tokens"]
	for unitname in pairs(units) do
		if token[unitname] == nil then
			print(unitname)
		end
	end
end

---------------------------------------------------------------

function public:sort(playerid, player, hero, args)
	hero:GetBag():Sort(
		function ( itemIndex1, itemIndex2 )
			if itemIndex1 == itemIndex2 then return false end

			local item1 = EntIndexToHScript(itemIndex1)
			local item2 = EntIndexToHScript(itemIndex2)
			if item1 == nil then return true end
			if item2 == nil then return false end

			local config1 = ItemConfig[item1:GetAbilityName()]
			local config2 = ItemConfig[item2:GetAbilityName()]
			if config1 == nil then return false end
			if config2 == nil then return true end

			local group1 = ItemKindGroup[config1.kind]
			local group2 = ItemKindGroup[config2.kind]

			if group1 == group2 then
				if config1.quality == config2.quality then
					return false
				end
				return config1.quality > config2.quality
			else
				return group1>group2
			end

			return false
		end)
end

function public:gamestats()
	DeepPrintTable(GameStats:Data())
end

function public:extrab(playerid, player, hero, args)
	hero:GiveYuanHui(500)
	hero:SetCustomAttribute("state","extrab",7)
	local questsManager = hero:GetQuestsMnanager()
	questsManager.__quests["quest_shared_heguchuanshuo_good"] = CQuests(questsManager, "quest_shared_heguchuanshuo_good")
	questsManager.__quests["quest_shared_heguchuanshuo_good"].__submited_count = 1
	questsManager.__quests["quest_shared_bingyanzhenjun_good"] = CQuests(questsManager, "quest_shared_bingyanzhenjun_good")
	questsManager.__quests["quest_shared_bingyanzhenjun_good"].__submited_count = 1
end

function public:vote()
	DeepPrintTable(AvalonVoteConfig)
end

function public:dps()
	DeepPrintTable(GetShuShanAttackingBossDPS())

	for k,v in pairs(GetShuShanAttackingBossDPS()) do
		print(k)
		DeepPrintTable(StatsShuShanAttackingBossDPS(k))
	end
end