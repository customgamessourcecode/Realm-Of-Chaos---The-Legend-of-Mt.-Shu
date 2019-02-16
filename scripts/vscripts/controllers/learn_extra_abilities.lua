
if LearnExtraAbilities == nil then
	LearnExtraAbilities = RegisterController('learn_extra_abilities')
	LearnExtraAbilities.__hero_learned_abilities = {}
	LearnExtraAbilities.__learned_xinfa_filter = {}
end

local public = LearnExtraAbilities

--[[
获取可学习的技能
]]
function public:GetCanLearnAbilities(hero, npc)
	local t = LearnExtraAbilitiesConfig[npc:GetUnitName()]
	if t == nil then return end

	local list = {}
	for k,v in pairs(t) do
		if self:CanLearn(hero, v, k) then
			table.insert(list, {display="learn-ability", abilityname=k, config=v})
		end
	end

	if #list == 0 then
		return
	end

	return list
end

--[[
获取可升级的技能
]]
function public:GetCanUpgradeAbilities(hero, npc)
	local list = {}

	for k,v in pairs(self.__hero_learned_abilities) do
		local data = v[hero:GetEntityIndex()]

		if data and data.ability and not data.ability:IsNull() and data.ability:GetLevel() < data.ability:GetMaxLevel() and npc == data.npc then
			table.insert(list, {display="upgrade-learned-ability", ability=data.ability:GetEntityIndex(), require=data.require})
		end
	end

	return list
end

--[[
学习技能
]]
function public:LearnAbility(hero, npc, abilityname)
	local t = LearnExtraAbilitiesConfig[npc:GetUnitName()]
	if t == nil then return end

	if t[abilityname] == nil then return end

	local at = t[abilityname]

	if not self:CanLearn(hero, at, abilityname) then
		return Avalon:Throw(hero,"msg_can_not_learn_extra_abilities")
	end

	if not hero:SpendYuanHui(at.yuanhui) then
		return Avalon:Throw(hero,"msg_can_not_learn_extra_abilities_for_yuanhui")
	end

	local abilityIndex = -1
	if at.label == "daoshu" then
		abilityIndex = 4
	elseif at.label == "xinfa" then
		abilityIndex = 5
		self.__learned_xinfa_filter[abilityname] = true
	end

	local oldAbility = hero:GetAbilityByIndex(abilityIndex)
	hero:RemoveAbility(oldAbility:GetAbilityName())
	local ability = hero:AddAbility(abilityname)
	ability:SetLevel(1)

	local data = self.__hero_learned_abilities[at.label]
	data[hero:GetEntityIndex()] = {ability=ability, npc=npc, require=at.upgrade_require}

	CustomEvents["avalon_event_select_npc"](1,{PlayerID=hero:GetPlayerID(), unit=npc:GetEntityIndex()})
end

--[[
升级技能
]]
function public:UpgradeAbility(hero, npc, abilityname)
	local t = LearnExtraAbilitiesConfig[npc:GetUnitName()]
	if t == nil then return end

	if t[abilityname] == nil then return end

	local at = t[abilityname]
	if at == nil then return end

	if at.label == "xinfa" then

	elseif at.label == "daoshu" then
	end

	local data = self.__hero_learned_abilities[at.label]
	local d = data[hero:GetEntityIndex()]

	if d.ability and not d.ability:IsNull() and d.ability:GetAbilityName() == abilityname and npc == d.npc then
		if d.ability:GetLevel() >= d.ability:GetMaxLevel() then return end
		if hero:GetCustomAttribute("state") < (at.upgrade_require.base_state + d.ability:GetLevel()-1) then
			return Avalon:Throw(hero,"msg_can_not_upgrade_extra_abilities_for_state")
		end

		if not hero:SpendYuanHui(at.upgrade_require.yuanhui) then
			return Avalon:Throw(hero,"msg_can_not_upgrade_extra_abilities_for_yuanhui")
		end
		d.ability:SetLevel(d.ability:GetLevel() + 1)

		hero:ShowCustomMessage({type="left",msg="#shushan_msg_upgrade_ability_success_"..at.label, class="success"})
	end

	CustomEvents["avalon_event_select_npc"](1,{PlayerID=hero:GetPlayerID(), unit=npc:GetEntityIndex()})
end

--[[
是否可学习的道术技能
]]
function public:CanLearn(hero, t, abilityname)
	if t == nil then return false end

	-- 英雄限制
	if hero:GetUnitName() == "npc_dota_hero_templar_assassin" and abilityname == "ability_shushan_shushanxinfa" then
		return false
	end

	-- 只能学习一个
	local data = self.__hero_learned_abilities[t.label]
	if data == nil then
		data = {}
		self.__hero_learned_abilities[t.label] = data
	end

	if data[hero:GetEntityIndex()] ~= nil then
		return false
	end

	-- 心法只能学习一个
	if t.label == "xinfa" and self.__learned_xinfa_filter[abilityname] == true then
		return false
	end

	-- 完成任务
	if t.quests then
		local questsManager = hero:GetQuestsMnanager()
		for k,v in pairs(t.quests) do
			local quest = questsManager:GetQuest(v)
			if quest == nil or quest:GetSubmitCount() == 0 then return false end
		end
	end

	-- 达到境界
	if t.state then
		if hero:GetCustomAttribute("state",0) < t.state then
			return false
		end
	end

	-- 元会点Avalon:Throw(hero,"msg_can_not_learn_abilities_for_daoshu")
	if t.yuanhui then
		if hero:GetYuanHui() < t.yuanhui then
			return false
		end
	end

	-- 单位限制
	if t.heroname and #t.heroname > 0 then
		local unitname = hero:GetUnitName()
		for k,v in pairs(t.heroname) do
			if v == unitname then
				return true
			end
		end
	else
		return true
	end

	return false
end