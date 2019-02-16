
if QuestsCtrl == nil then
	QuestsCtrl = RegisterController('quests')
	QuestsCtrl.player_quests_manager={}
	QuestsCtrl.quests_special_hunting = {}
	QuestsCtrl.player_quests_special_hunting = {}
	QuestsCtrl.player_quests_special_hunting_count = {}
	QuestsCtrl.npc_minimap_pos ={}
	setmetatable(QuestsCtrl,QuestsCtrl)
end

local public = QuestsCtrl

SHUSHAN_HUNTING_QUESTS_SUBMIT_MAX_COUNT = 10

-- 初始化
function public:init()
	_G['QuestsKV'] = LoadKeyValues("scripts/quests/quests.kv")

	-- 整理任务
	local npc_quests = {}
	self.__npc_quests = npc_quests

	-- 对任务进行处理
	for quest_name, quest_data in pairs(QuestsKV) do
		local npc_name = quest_data['AcceptNPC']
		if npc_quests[npc_name] == nil then
			npc_quests[npc_name] = {}
		end
		npc_quests[npc_name][quest_name] = quest_data

		if quest_data["IsQuestGroup"] == 1 then
			quest_data["SubQuests"] = {["1"] = { Type="FINISH_CHILD_QUEST", MaxCount=quest_data["Quests"]["RequestMissionCount"] }}
		end

		-- 获取所有狩猎任务
		if quest_data["IsHuntingQuest"] == 1 then
			local data = self.quests_special_hunting[quest_data["Level"]]
			if not data then
				data = {}
				self.quests_special_hunting[quest_data["Level"]] = data
			end

			table.insert(data,quest_name)
		end
	end

	-- 获取所有NPC
	local all_npc = Entities:FindAllByName('quests_npc')
	local npc_entindexs = {}
	self.__all_npc = {}

	for k,v in pairs(all_npc) do
		local unitname = v:GetUnitName()
		local modifierName = "modifier_"..unitname
		LinkLuaModifier(modifierName,"modifiers/npc_task/"..modifierName,LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier(modifierName.."_hero_touching","modifiers/npc_task/"..modifierName.."_hero_touching",LUA_MODIFIER_MOTION_NONE)

		self.__all_npc[unitname] = v
		npc_entindexs[unitname] = v:GetEntityIndex()
		v:AddNewModifier(v, nil, modifierName, nil)

		if NPCShops[unitname] then
			EachSteamID(function (steamid)
				UnitStates:new(steamid,v,"shop")
			end)
		end
	end

	-- 算命先生
	EachSteamID(function (steamid)
		UnitStates:new(steamid,self.__all_npc["npc_task_fortune_teller"],"quest-accept")
	end)

	-- 犯人
	local spawn_entities = Entities:FindAllByName("spawn_point_fanren")
	local spawn_ent = spawn_entities[RandomInt(1, #spawn_entities)]
	if spawn_ent then
		local modifierName = "modifier_npc_task_fanren"
		LinkLuaModifier(modifierName,"modifiers/npc_task/"..modifierName,LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier(modifierName.."_hero_touching","modifiers/npc_task/"..modifierName.."_hero_touching",LUA_MODIFIER_MOTION_NONE)

		local unit = CreateUnitByName("npc_task_fanren", spawn_ent:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		unit:AddNewModifier(unit, nil, modifierName, nil)
		self.__all_npc["npc_task_fanren"] = unit
	end

	-- NPC小地图位置比例
	local NPCMinimapPos = {}
	for unitname,unit in pairs(self.__all_npc) do
		local pos = unit:GetOrigin()
		local x = math.abs((GetWorldMinX()-pos.x)/(GetWorldMaxX()-GetWorldMinX()))
		local y = 1-math.abs((GetWorldMinY()-pos.y)/(GetWorldMaxY()-GetWorldMinY()))
		NPCMinimapPos[unitname] = {x=x, y=y}
	end

	self.npc_minimap_pos = NPCMinimapPos
	CustomNetTables:SetTableValue("Common", "NPCMinimapPosition",  NPCMinimapPos)
	CustomNetTables:SetTableValue("Common", "all_npc_task_entity_index",  npc_entindexs)

	-- 注册事件
	ListenToGameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), self)
	Avalon:Listen("bag_changed", Dynamic_Wrap(self,"OnBagChanged"), self)
	Avalon:Listen("quests_update", Dynamic_Wrap(self,"Update"), self)
	Avalon:Listen("quests_give_reward", Dynamic_Wrap(self,"GiveReward"), self)
	Avalon:Listen("quests_accept_quest_success", Dynamic_Wrap(self,"OnPlayerAcceptedQuests"), self)
	Avalon:Listen("quests_accept_quest_fail", Dynamic_Wrap(self,"OnPlayerAccetQuestFail"), self)
	Avalon:Listen("quests_finished_quest", Dynamic_Wrap(self,"OnPlayerFinishedQuests"), self)
	Avalon:Listen("quests_submited_quest", Dynamic_Wrap(self,"OnPlayerSubmitedQuests"), self)
	Avalon:Listen("quests_subquest_finished", Dynamic_Wrap(self,"OnSubquestFinished"), self)
	Avalon:Listen("quests_subquest_go_to_target", Dynamic_Wrap(self,"OnSubquestGoToTarget"), self)
	Avalon:BindConform("quests_get_logical_formula_var_value", Dynamic_Wrap(self,"GetLogicalFormulaVarValue"), self)
	Avalon:BindConform("quests_get_npc_quests", Dynamic_Wrap(self,"GetNPCQuests"), self)
	Avalon:BindConform("quests_get_all_npc", Dynamic_Wrap(self,"GetAllNPC"), self)
end

function CDOTA_BaseNPC_Hero:GetQuestsMnanager()
	return public(self)
end

--[[
Return player's quests manager

@return CQuestsManager
]]
function public:__call(hero)
	assert(hero and hero:IsHero(), 'Invalid hero')
	if not hero.__HasCustomSelectHero then return end

	local playerQuests = self.player_quests_manager[hero:GetSteamID()]

	if playerQuests == nil then
		playerQuests = CQuestsManager(hero)
		self.player_quests_manager[hero:GetSteamID()] = playerQuests

		Timer(1, function ()
			self:UpdateUnitStates(hero)    -- 更新NPC状态
			return 5
		end)

		Timer(1, function ()
			self:HuntingQuestRefresh(hero) -- 刷新狩猎任务

			local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]
			CustomNetTables:SetTableValue( "Common", "hunting_list_"..hero:GetSteamID(), hunting_list )
			return 1
		end)
	end

	return playerQuests
end

-- 获取NPC的所有任务
function public:GetNPCQuests(npc_name)
	return self.__npc_quests[npc_name]
end

-- 获取所有NPC
function public:GetAllNPC()
	return self.__all_npc
end

-- 单位被击杀
function public:OnEntityKilled(keys)
	local victim = EntIndexToHScript(keys.entindex_killed or -1)
	local attacker = EntIndexToHScript(keys.entindex_attacker or -1)

	if attacker:IsRealHero() then
		local questManager = self(attacker)
		questManager:OnEntityKilled(victim)
	else
		local hero = attacker:GetOwner()
		if hero == nil or not hero.IsRealHero or not hero:IsRealHero() then return end

		local questManager = self(hero)
		questManager:OnEntityKilled(victim)
	end
end

function public:UpdateQuests(hero)
	local qm = self(hero)
	if qm == nil then return end
	
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "quests_event_update", {table=qm:table()})
	self:UpdateUnitStates(hero)
end

function public:Update(hero)
	DelayDispatch(0.2, hero:GetEntityIndex(), self.UpdateQuests, self, hero)
end

-- 当玩家接受任务
function public:OnPlayerAcceptedQuests(hero, quest)
	hero:ShowCustomMessage({type="left",msg="#avalon_msg_accepted_quest", args={quest_name=quest:GetName()} ,class="", log=true})

	self:OnAcceptHuntingQuest(hero, quest)
	hero:GetBag():Update()

	local questManager = self(hero)

	-- 接受任务
	QuestsCtrl:TouchCustomType(hero, 'hero_levelup', function (subquest, data)
		data["Level"] = hero:GetLevel()
		if data["Level"] >= data["MaxLevel"] then
			return true
		end
	end)

	-- 完成任务
	QuestsCtrl:TouchCustomType(hero, 'submit_quest', function (subquest, data)
		local quest2 = questManager:GetQuest(data["Quest"])
		if quest2 == nil then
			local list = questManager:GetSharedNameQuest(data["Quest"])
			if list then
				quest2 = list[1]
			end
		end
		if quest2 == nil then return end

		data["Count"] = quest2:GetSubmitCount()
		if data["Count"] >= data["MaxCount"] then
			return true
		end
	end)

	self:Update(hero)

	-- 显示气泡
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
		{text=quest:GetName().."_accepted_bubble",args=quest:GetTextArgs(),unit=quest:GetAcceptNPC():GetEntityIndex()})

	-- 特效
	local p = ParticleManager:CreateParticle("particles/avalon/quests/quests_accepted/quests_accepted_flash.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(p, 0, hero:GetOrigin())
	ParticleManager:DestroyParticleSystem(p)

	-- 音效
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "play_sound", {sound="CustomGameUI.QuestAccepted"})
end

-- 当玩家完成任务
function public:OnPlayerFinishedQuests(hero, quest)
	hero:ShowCustomMessage({type="left",msg="#avalon_msg_finished_quest", args={quest_name=quest:GetName()} ,class="", log=true})
	self:OnFinishHuntingQuest(hero, quest)

	-- 狩猎任务自动提交
	if quest:GetQuestData()["IsHuntingQuest"] == 1 then
		quest:Submit()
	end

	self:Update(hero)
end

-- 当玩家提交任务
function public:OnPlayerSubmitedQuests(hero, quest)
	hero:ShowCustomMessage({type="left",msg="#avalon_msg_submited_quest", args={quest_name=quest:GetName()} ,class="", log=true})

	local questManager = self(hero)

	-- 如果完成狩猎任务
	self:OnSubmitedHuntingQuest(hero, quest)

	-- 完成任务
	QuestsCtrl:TouchCustomType(hero, 'submit_quest', function (subquest, data)
		local quest2 = questManager:GetQuest(data["Quest"])
		if quest2 == nil then
			local list = questManager:GetSharedNameQuest(data["Quest"])
			if list then
				quest2 = list[1]
			end
		end

		if quest2 == nil then return end

		data["Count"] = quest2:GetSubmitCount()
		if data["Count"] >= data["MaxCount"] then
			return true
		end
	end)

	self:Update(hero)

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
		{text=quest:GetName().."_submited_bubble",args=quest:GetTextArgs(),unit=quest:GetSubmitNPC():GetEntityIndex()})

	local p = ParticleManager:CreateParticle("particles/avalon/quests/quests_finished/quests_finished_starfall.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(p, 0, hero:GetOrigin())
	ParticleManager:DestroyParticleSystem(p)

	-- 犯人换点
	if quest:GetName() == "quest_shared_jiminggoudao_good"
	or quest:GetName() == "quest_shared_jiminggoudao_bad"
	or quest:GetName() == "quest_shared_jiminggoudao_none"
	then
		local spawn_entities = Entities:FindAllByName("spawn_point_fanren")
		local spawn_ent = spawn_entities[RandomInt(1, #spawn_entities)]
		local unit = self:GetAllNPC()["npc_task_fanren"]
		if (spawn_ent:GetOrigin() - unit:GetOrigin()):Length2D() <= 50 then
			for i,v in ipairs(spawn_entities) do
				if v == spawn_ent then
					table.remove(spawn_entities,i)
					break
				end
			end
		end
		spawn_ent = spawn_entities[RandomInt(1, #spawn_entities)]
		if spawn_ent then
			unit:SetOrigin(spawn_ent:GetOrigin())
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "play_sound", {sound="CustomGameUI.QuestSubmited"})
end

-- 当玩家接受任务失败
function public:OnPlayerAccetQuestFail(hero, quest)
	hero:ShowCustomMessage({type="left",msg="#avalon_msg_accept_quest_fail", args={quest_name=quest:GetName()} ,class="", log=true})

	self:Update(hero)
end

-- 当完成任务目标
function public:OnSubquestFinished(hero, quest, subquest, arg1, arg2, arg3, arg4)
	
	local _type = subquest:GetType()

	if _type == QUESTS_TARGET_TYPE_FIND_UNIT then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
			{text=quest:GetName().."_subquest_bubble_"..subquest:GetIndex(),args=quest:GetTextArgs(),unit=hero:GetEntityIndex()})

	elseif _type == QUESTS_TARGET_TYPE_FIND_ITEM then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
			{text="avalon_quests_subquest_find_item_finished_bubble",args=subquest:GetTextArgs(),unit=hero:GetEntityIndex()})

	elseif _type == QUESTS_TARGET_TYPE_KILL_UNIT then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
			{text="avalon_quests_subquest_kill_unit_finished_bubble",args=subquest:GetTextArgs(),unit=hero:GetEntityIndex()})

	end

end

-- 当背包发生改变
function public:OnBagChanged(hero, bag)
	local questManager = self(hero)
	if questManager == nil then return end
	questManager:OnBagChanged(bag)
end

-- 英雄靠近NPC
function public:OnTouching(npc, hero)
	local questManager = self(hero)
	if questManager == nil then return end
	questManager:OnTouching(npc)
end

-- 判断是否靠近NPC
function public:HasTouchingHero(npc, hero)
	return hero:HasModifier("modifier_"..npc:GetUnitName().."_hero_touching")
end

-- 给予奖励
function public:GiveReward(hero, quest, name, value, count)
	-- 如果value是一个字符串，做特殊处理
	if type(value) == "string" then
		if string.find(value,"i%[(.*)%]") == 1 then
			local str = string.gsub(value,"i%[%s*([%d%.]+)%s*,%s*([%d%.]+)%s*%]","%1,%2")
			if str == value then return end

			local list = vlua.split(str, ",")
			value = RandomInt(tonumber(list[1]), tonumber(list[2]))

		elseif string.find(value,"f%[(.*)%]") == 1 then
			local str = string.gsub(value,"f%[%s*([%d%.]+)%s*,%s*([%d%.]+)%s*%]","%1,%2")
			if str == value then return end

			local list = vlua.split(str, ",")
			value = RandomFloat(tonumber(list[1]), tonumber(list[2]))

		else
			error("Invalid reward")
		end
	end

	value = value * count

	if hero:IsFate("bukuai") and quest:GetQuestData()["IsHuntingQuest"] == 1 then
		value = value * 2
	end

	-- 物品奖励
	if string.find(name,"item_") == 1 then
		local bag = hero:GetBag()
		if not bag then return end

		for i=1,value do
			if name == "item_0014" then
				bag:CreateItem(name)
				GameStats:Increment("ItemsSpawnCount", name)
			else
				hero:AddItemByName(name)
				GameStats:Increment("ItemsSpawnCount", name)
			end
		end

		hero:ShowCustomMessage({
			type="message-box",
			role="avalon_quests_obtain_rewards", 
			list={
				{
					text="avalon_quests_rewards_msg_format",
					args={name = name, value = value}
				}
			},
			duration=10,
		})

		return
	end

	-- 显示消息
	hero:ShowCustomMessage({
		type="message-box",
		role="avalon_quests_obtain_rewards", 
		list={
			{
				text="avalon_quests_rewards_msg_format",
				args={name = "avalon_quests_reward_"..name, value = value}
			}
		},
		duration=10,
	})

	-- 奖励
	if name == "ATTRIBUTE_MOVE_SPEED" then
		hero:ModifyCustomAttribute("move_speed", quest:GetName(), value)
	elseif name == "EWeapon" then
		if hero:GetUnitLabel() == "shushan_sword" then
			hero:AddItemByName("item_0092")
		elseif hero:GetUnitLabel() == "shushan_knife" then
			hero:AddItemByName("item_0093")
		elseif hero:GetUnitLabel() == "shushan_blade" then
			hero:AddItemByName("item_0094")
		elseif hero:GetUnitLabel() == "shushan_caster" then
			hero:AddItemByName("item_0095")
		elseif hero:GetUnitLabel() == "shushan_lancer" then
			hero:AddItemByName("item_0096")
		end
	elseif name == "DWeapon" then
		if hero:GetUnitLabel() == "shushan_sword" then
			hero:AddItemByName("item_0098")
		elseif hero:GetUnitLabel() == "shushan_knife" then
			hero:AddItemByName("item_0099")
		elseif hero:GetUnitLabel() == "shushan_blade" then
			hero:AddItemByName("item_0100")
		elseif hero:GetUnitLabel() == "shushan_caster" then
			hero:AddItemByName("item_0101")
		elseif hero:GetUnitLabel() == "shushan_lancer" then
			hero:AddItemByName("item_0102")
		end
	elseif name == "CWeapon" then
		if hero:GetUnitLabel() == "shushan_sword" then
			hero:AddItemByName("item_0106")
		elseif hero:GetUnitLabel() == "shushan_knife" then
			hero:AddItemByName("item_0107")
		elseif hero:GetUnitLabel() == "shushan_blade" then
			hero:AddItemByName("item_0108")
		elseif hero:GetUnitLabel() == "shushan_caster" then
			hero:AddItemByName("item_0109")
		elseif hero:GetUnitLabel() == "shushan_lancer" then
			hero:AddItemByName("item_0110")
		end
	elseif name == "EXP" then
		if quest:GetName() == "quest_zhiwangbuyu" then
			if hero:GetLevel() < 25 then
				hero:AddExperience(value, DOTA_ModifyXP_Unspecified, false, false)
			end
		else
			hero:AddExperience(value, DOTA_ModifyXP_Unspecified, false, false)
		end
	elseif name == "Gold" then
		hero:GiveGold(value)
	elseif name == "yuanhui" then
		hero:GiveYuanHui(value)
	elseif name == "merits" then
		hero:ModifyCustomAttribute("merits", quest:GetName(), value)
	elseif name == "karma" then
		hero:ModifyCustomAttribute("karma", quest:GetName(), value)
	elseif name == "dogen" then
		hero:ModifyCustomAttribute("dogen", quest:GetName(), value)
	elseif name == "hunting_points" then
		hero:GiveHuntingPoints(value)
	elseif name == "learn_teleport" then
		hero:FindAbilityByName("ability_shushan_teleport"):SetLevel(1)
	elseif name == "juexin" then
		hero.__juexing_la = true

		if hero:GetUnitName() == "npc_dota_hero_legion_commander" then
			hero:FindAbilityByName("ability_shushan_moluo014"):SetLevel(2)
			
		elseif hero:GetUnitName() == "npc_dota_hero_slark" then
			hero:FindAbilityByName("ability_hsj_lixinning011"):SetLevel(2)

		elseif hero:GetUnitName() == "npc_dota_hero_spectre" then
			hero:FindAbilityByName("ability_shushan_mengyan011"):SetLevel(2)

		elseif hero:GetUnitName() == "npc_dota_hero_lina" then
			hero:FindAbilityByName("ability_hsj_humei013"):SetLevel(2)

		elseif hero:GetUnitName() == "npc_dota_hero_templar_assassin" then
			hero:FindAbilityByName("ability_shushan_muyue012"):SetLevel(2)
		end
	elseif name == "shengling" then
		if hero:GetUnitLabel() == "shushan_lancer" 
			or hero:GetUnitLabel() == "shushan_blade" 
			then
			for i=0,5 do
				local item = hero:GetItemInSlot(i)
				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0504" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0513")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_xiezi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0505" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0514")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_maozi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0506" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0515")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_yifu",args={}}},
							duration=10,
						})
					end
				end
			end

		elseif hero:GetUnitLabel() == "shushan_sword" 
			or hero:GetUnitLabel() == "shushan_knife"
			then
			for i=0,5 do
				local item = hero:GetItemInSlot(i)
				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0507" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0516")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_xiezi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0508" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0517")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_maozi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0509" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0518")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_yifu",args={}}},
							duration=10,
						})
					end
				end
			end

		elseif hero:GetUnitLabel() == "shushan_caster" then
			for i=0,5 do
				local item = hero:GetItemInSlot(i)
				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0501" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0510")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_xiezi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0502" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0511")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_maozi",args={}}},
							duration=10,
						})
					end
				end

				if item and not item:IsNull() then
					if item:GetAbilityName() == "item_0503" then
						hero:RemoveItem(item)
						hero:AddItemByName("item_0512")
					else
						hero:ShowCustomMessage({
							type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_yifu",args={}}},
							duration=10,
						})
					end
				end
				
			end
		end


	elseif name == "kaiyi" then
		hero:AddNewModifier(hero, nil, "modifier_quests_reward_kaiyi", nil)
	end
end

-- 获取逻辑公式变量值
function public:GetLogicalFormulaVarValue(hero, var_name, quest_name)
	-- 等级
	if var_name == "$level" then
		return hero:GetLevel()

	-- 功德
	elseif var_name == "$merits" then
		return hero:GetCustomAttribute("merits",0)

	-- 境界
	elseif var_name == "$state" then
		return hero:GetCustomAttribute("state",0)

	-- 冷却时间
	elseif var_name == "$is_cooldown_ready" then
		local quest = self(hero):GetQuest(quest_name)
		if quest then
			return quest:IsCooldownReady()
		end
		return true

	-- 能否接受狩猎任务
	elseif var_name == "$can_accept_hunting" then
		local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]
		if hunting_list then
			for i,data in ipairs(hunting_list) do
				if data.is_accept or data.is_finished then
					return false
				end
			end

			return true
		end
		return false

	-- 境界
	elseif var_name == "$difficulty" then
		return GameRules:GetCustomGameDifficulty()
	end
end

--[[
exmple: 
QuestsCtrl:TouchCustomType(hero, 'buy_items', function (subquest, data)
	-- code
end)
]]
function public:TouchCustomType(hero, name, func)
	local questManager = self(hero)
	questManager:TouchCustomType(name, func)
end

function public:UpdateUnitStates(hero)
	local questManager = self(hero)

	-- 创建此玩家的单位状态标签
	for unitname,unit in pairs(self.__all_npc) do
		local npc_quests = self:GetNPCQuests(unitname)
		if npc_quests then
			local hasAccept = false
			for quest_name in pairs(npc_quests) do
				if questManager:CanAccept(quest_name) then
					hasAccept = true
					break
				end
			end

			self.npc_minimap_pos[unitname].can_accept = hasAccept

			if hasAccept then
				UnitStates:new(hero:GetSteamID(),unit,"quest-accept")
			else
				UnitStates:del(hero:GetSteamID(),unit,"quest-accept")
			end
		end

		local hasFinished = false
		local hasProcessing = false
		for quest_name,quest in pairs(questManager:GetAllQuests()) do
			if quest:GetSubmitNPC():GetUnitName() == unitname then
				if quest:IsAccepted() then
					hasProcessing = true
				elseif quest:IsFinished() then
					hasFinished = true
				end
			end
			if hasProcessing and hasFinished then break end
		end

		self.npc_minimap_pos[unitname].is_finished = hasFinished
		CustomNetTables:SetTableValue("Common", "NPCMinimapPosition",  self.npc_minimap_pos)
		
		if hasFinished then
			UnitStates:new(hero:GetSteamID(),unit,"quest-finished")
		else
			UnitStates:del(hero:GetSteamID(),unit,"quest-finished")
		end

		if hasProcessing then
			UnitStates:new(hero:GetSteamID(),unit,"quest-processing")
		else
			UnitStates:del(hero:GetSteamID(),unit,"quest-processing")
		end
	end
end

function public:OnSubquestGoToTarget(hero, subquest)
	if subquest:GetType() == QUESTS_TARGET_TYPE_FIND_UNIT then
		local allNPC = self:GetAllNPC()
		local NPC = allNPC[subquest.__npc_name]
		if NPC then

			if (hero:GetOrigin() - NPC:GetOrigin()):Length2D() >= 2000 then
				local ability = hero:FindAbilityByName("ability_shushan_teleport")
				if ability and ability:GetLevel() > 0 then
					hero:CastAbilityOnPosition(NPC:GetOrigin(), ability, hero:GetPlayerOwnerID())
				end
			end

			Wait(0.25, function ()
				hero:MoveToPosition(NPC:GetOrigin())
			end)
		end

	elseif subquest:GetType() == QUESTS_TARGET_TYPE_KILL_UNIT then
		local units = Entities:FindAllByUnitName(subquest.__kill_unit_name)
		local count = #units
		if count > 0 then
			if count == 1 then
				hero:MoveToPosition(units[1]:GetOrigin())
			else
				local pos = hero:GetOrigin()
				local unit = units[1]
				local len = (unit:GetOrigin() - pos):Length2D()
				for i,v in ipairs(units) do
					local _l = (v:GetOrigin() - pos):Length2D()
					if _l < len then
						len = _l
						unit = v
					end
				end
				hero:MoveToPosition(unit:GetOrigin())
			end
		end

	elseif subquest:GetType() == QUESTS_TARGET_TYPE_FIND_ITEM then
		Avalon:Throw(hero,"error_msg_can_not_find_item")
	end
end


---------------------------------------------------------------------------------------

-- 通缉任务等级
function public:GetHuntingQuestLevel( hero )
	local state = hero:GetCustomAttribute("state",0)
	local level = -1

	if state >= 1 and state <= 3 then
		level = 1
	elseif state >= 4 and state <= 6 then
		level = 2
	elseif state >= 7 and state <= 9 then
		level = 3
	elseif state >= 10 and state <= 11 then
		level = 4
	elseif state >= 12 and state <= 13 then
		level = 5
	end

	return level
end

-- 通缉任务刷新
function public:HuntingQuestRefresh(hero)
	local level = self:GetHuntingQuestLevel( hero )

	if level == -1 then return end

	local quest_list = self.quests_special_hunting[level]
	if not quest_list then return end

	-- 大于最大数量不再刷新
	local countKey = tostring(hero:GetEntityIndex())..tostring(level)
	local count = self.player_quests_special_hunting_count[countKey] or 0
	if count >= SHUSHAN_HUNTING_QUESTS_SUBMIT_MAX_COUNT then return end

	local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]
	local questManager = self(hero)
	local can_accept_quest_list = {}
	
	if not hunting_list then
		hunting_list = {}
		self.player_quests_special_hunting[hero:GetEntityIndex()] = hunting_list
	end

	-- 找出可以添加的任务
	for i,quest_name in ipairs(quest_list) do
		local can_add = true
		for i,data in ipairs(hunting_list) do
			if data.quest_name == quest_name then
				can_add = false
				break
			end
		end
		if can_add then
			local quest_data = QuestsKV[quest_name]
			local quest = questManager:GetQuest(quest_name)
			if quest then
				if quest:IsCooldownReady() then
					table.insert(can_accept_quest_list,quest_name)
				end
			else
				table.insert(can_accept_quest_list,quest_name)
			end
		end
	end

	if #can_accept_quest_list == 0 then return end

	-- 随机任务
	for i=1,6 do
		local data = hunting_list[i]

		if data == nil then
			data = {
				cooldown_start_time = 0,
				cooldown_end_time = 0,
				is_accept = false,
				is_finished = false,
			}
			hunting_list[i] = data
		end

		if data.quest_name == nil and GameRules:GetGameTime() >= data.cooldown_end_time and count < SHUSHAN_HUNTING_QUESTS_SUBMIT_MAX_COUNT then
			local pos = RandomInt(1, #can_accept_quest_list)
			data.quest_name = can_accept_quest_list[pos]
			table.remove(can_accept_quest_list,pos)

			count = count + 1
			self.player_quests_special_hunting_count[countKey] = count
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "hunting_quests_event_update", {})
	CustomNetTables:SetTableValue( "Common", "hunting_list_"..hero:GetSteamID(), hunting_list )

end

function public:OnAcceptHuntingQuest(hero, quest)
	local quest_name = quest:GetName()
	if string.find(quest_name,"quest_special_hunting_") ~= 1 then return end

	local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]

	for i,data in ipairs(hunting_list) do
		if data.quest_name == quest_name then
			data.is_accept = true
			data.is_finished = false
			break
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "hunting_quests_event_update", {})
	CustomNetTables:SetTableValue( "Common", "hunting_list_"..hero:GetSteamID(), hunting_list )
end

function public:OnFinishHuntingQuest(hero, quest)
	local quest_name = quest:GetName()
	if string.find(quest_name,"quest_special_hunting_") ~= 1 then return end

	local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]

	for i,data in ipairs(hunting_list) do
		if data.quest_name == quest_name then
			data.is_accept = true
			data.is_finished = true
			break
		end
	end
end

function public:OnSubmitedHuntingQuest(hero, quest)
	local quest_name = quest:GetName()
	if string.find(quest_name,"quest_special_hunting_") ~= 1 then return end

	local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]

	for i,data in ipairs(hunting_list) do
		if data.quest_name == quest_name then
			data.quest_name = nil
			data.is_accept = false
			data.is_finished = false
			data.cooldown_start_time = GameRules:GetGameTime()
			data.cooldown_end_time = data.cooldown_start_time + 60
			quest:StartCooldown(60)
			break
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "hunting_quests_event_update", {})
	CustomNetTables:SetTableValue( "Common", "hunting_list_"..hero:GetSteamID(), hunting_list )
end

function public:OnStateUpgrade(hero)
	-- local hunting_list = self.player_quests_special_hunting[hero:GetEntityIndex()]
	-- if not hunting_list then return end

	-- for i,data in ipairs(hunting_list) do
	-- 	if data.quest_name then
	-- 		local quest = self(hero):GetQuest(data.quest_name)
	-- 		if quest then
	-- 			if quest:IsSubmited() then
	-- 				data.quest_name = nil
	-- 			end
	-- 		else
	-- 			data.quest_name = nil
	-- 		end
	-- 	end
	-- end
end