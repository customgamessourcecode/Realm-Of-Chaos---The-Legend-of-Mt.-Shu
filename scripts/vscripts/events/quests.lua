
-- 接受任务
CustomEvents('quests_event_accept_quest', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	local quest_name = data.quest_name or ""
	local kv = QuestsKV[quest_name]
	if kv == nil then return end

	if kv["IsHuntingQuest"] ~= 1 and not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	local qm = QuestsCtrl(hero)

	qm:AcceptQuest(quest_name)

	CustomEvents['avalon_event_select_npc'](e, data)
end)

-- 提交任务
CustomEvents('quests_event_submit_quest', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	local quest_name = data.quest_name or ""
	local kv = QuestsKV[quest_name]
	if kv == nil then return end

	if kv["IsHuntingQuest"] ~= 1 and not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	local qm = QuestsCtrl(hero)

	qm:SubmitQuest(quest_name)

	CustomEvents['avalon_event_select_npc'](e, data)
end)

-- 请求任务tooltip数据
CustomEvents('quests_event_show_quest_tooltip', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	local questManager = hero:GetQuestsMnanager()
	local quest_name = data.quest_name or ""
	local quest_data = QuestsKV[quest_name]
	local quest_table

	local quest = questManager:GetQuest(quest_name);
	if quest then
		if quest:IsAccepted() or quest:IsFinished() then
			quest_table = quest:table()
		end
		if quest:IsGroupChild() then
			local d = QuestsKV[quest:GetParentQuest():GetName()]
			if d then
				quest_data = d["Quests"][quest:GetChildKey()]
			end
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, 'quests_event_show_quest_tooltip_response', {
		unit=data.unit, quest_name=quest_name, quest_data = quest_data, quest_table=quest_table})
end)

-- 提交任务物品
CustomEvents('quests_event_submit_quest_items', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	local qm = QuestsCtrl(hero)

	qm:SubmitItems()

	CustomEvents['avalon_event_select_npc'](e, data)
end)

-- 获取全部可接受任务
CustomEvents('quests_event_all_can_accept_quests', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local qm = QuestsCtrl(hero)
	CustomGameEventManager:Send_ServerToPlayer(player,"quests_event_all_can_accept_quests_respone",qm:GetAllAcceptableQuests());
end)

-- 请求任务数据
CustomEvents('quests_event_get_quest_content', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local questManager = hero:GetQuestsMnanager()
	local quest_name = data.quest_name or ""
	local quest_data = QuestsKV[quest_name]
	local quest_table

	local quest = questManager:GetQuest(quest_name);
	if quest then
		if quest:IsAccepted() or quest:IsFinished() then
			quest_table = quest:table()
		end
		if quest:IsGroupChild() then
			local d = QuestsKV[quest:GetParentQuest():GetName()]
			if d then
				quest_data = d["Quests"][quest:GetChildKey()]
			end
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, 'quests_event_get_quest_content_respone', {
		quest_name=quest_name, quest_data = quest_data, quest_table=quest_table})
end)

-- 前往NPC
CustomEvents('quests_event_go_to_npc', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local qm = QuestsCtrl(hero)
	local quest = qm:GetQuest(data.quest_name or "")

	if not quest then

		if data.is_accept == 1 then
			local quest_data = QuestsKV[data.quest_name or ""]
			if not quest_data then return end

			local unitname = quest_data["AcceptNPC"]
			for name,unit in pairs(QuestsCtrl:GetAllNPC()) do
				if unitname == name then
					hero:MoveToNPC(unit)
				end
			end
		end

		return
	end

	local pos
	if data.is_accept == 1 then
		pos = quest:GetAcceptNPC():GetOrigin()
	else
		pos = quest:GetSubmitNPC():GetOrigin()
	end

	if (hero:GetOrigin() - pos):Length2D() >= 2000 then
		local ability = hero:FindAbilityByName("ability_shushan_teleport")
		if ability and ability:GetLevel() > 0 then
			hero:CastAbilityOnPosition(pos, ability, hero:GetPlayerOwnerID())
		end
	end

	Wait(0.25, function ()
		hero:MoveToPosition(pos)
	end)
	
end)

-- 设置是否任务追踪
CustomEvents('quests_event_set_can_show_to_mini_quests_frame', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local quest_name = data.quest_name or ""

	local qm = QuestsCtrl(hero)

	local quest = qm:GetQuest(quest_name)
	if not quest then return end

	quest:SetCanShowToMiniQuestFrame(data.enable == 1)
end)

-- 前往下一个目标点
CustomEvents('quests_event_go_to_next_target', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local quest_name = data.quest_name or ""

	local qm = QuestsCtrl(hero)

	local quest = qm:GetQuest(quest_name)
	if not quest then return end
	if quest:IsFinished() or quest:IsSubmited() then return end

	for k,subquest in pairs(quest:GetSubquests()) do
		if not subquest:IsFinished() then
			subquest:GoToTarget()
			break
		end
	end
end)