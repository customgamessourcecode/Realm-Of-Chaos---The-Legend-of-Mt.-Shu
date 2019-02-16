
-- 选择NPC，返回相关选项
CustomEvents('avalon_event_select_npc', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	local npcname = npc:GetUnitName()
	local questsManager = QuestsCtrl(hero)

	local btnList = {}
	local submitItems = {}
	local hasSubmitItems = false
	local accept_quest_type = hero:setting('accept_quest_type')

	-- 已接受的任务
	local allQuests = questsManager:GetAllQuests()
	for quest_name, quest in pairs(allQuests) do
		repeat

		local quest_data = quest:GetQuestData()

		if quest_data["SharedName"] ~= nil and accept_quest_type ~= 'free' then
			if string.find(quest_name,'_'..accept_quest_type) == nil then
				break
			end
		end

		-- 获取需要提交的物品
		if quest:IsAccepted() then
			local items = quest:GetSubmitItems(npcname)
			if #items > 0 then
				hasSubmitItems = true
				for i,v in ipairs(items) do
					submitItems[v.itemname] = (submitItems[v.itemname] or 0) + v.count
				end
			end
		end
		
		-- 获取已接受和已完成的任务
		if quest:IsAccepted() or quest:IsFinished() then
			if quest:GetSubmitNPC() == npc then
				table.insert(btnList,{
					display = "quest",
					quest_name = quest_name,
					state = quest:GetState(),
					SharedName = quest_data["SharedName"],
				})
			end

		-- 获取已经提交了的可重复任务
		elseif questsManager:CanAccept(quest_name) then
			if quest:GetAcceptNPC() == npc then
				table.insert(btnList,{
					display = "quest",
					quest_name = quest_name,
					state = -1,
					SharedName = quest_data["SharedName"],
				})
			end
		end
		
		until true
	end

	-- 可接受任务
	local acceptableQuests = questsManager:GetAcceptableQuests(npc:GetUnitName())
	if acceptableQuests then
		for _,quest_name in pairs(acceptableQuests) do
			repeat

			local quest_data = QuestsKV[quest_name]

			if quest_data["SharedName"] ~= nil and accept_quest_type ~= 'free' then
				if string.find(quest_name,'_'..accept_quest_type) == nil then
					break
				end
			end

			if not questsManager:GetQuest(quest_name) and npcname == quest_data["AcceptNPC"] then
				table.insert(btnList,{
					display = "quest",
					quest_name = quest_name,
					state = -1,
					SharedName = quest_data["SharedName"],
				})
			end

			until true
		end
	end

	-- 需要提交的任务物品
	if hasSubmitItems then
		table.insert(btnList,1,{
			display = "submit-quest-items",
			items = submitItems,
		})
	end

	-- 售卖的物品
	local shopItems = NPCShops[npcname]
	if shopItems then
		for itemname,v in pairs(shopItems) do
			if v.fate then
				if hero:IsFate(v.fate) then
					table.insert(btnList,{
						display = "item",
						itemname = itemname,
						cost = v.cost or GetItemCost(itemname),
						tooltip = v.tooltip
					})
				end
			else
				table.insert(btnList,{
					display = "item",
					itemname = itemname,
					cost = v.cost or GetItemCost(itemname),
					tooltip = v.tooltip
				})
			end
		end
	end

	-- 蜀山掌门 - 提升境界
	if npcname == "npc_task_shushanzhangmen" then
		table.insert(btnList,{
			display = "state-upgrade",
		})

	-- 算命先生
	elseif npcname == "npc_task_fortune_teller" then
		table.insert(btnList,{
			display = "fortune-teller",
		})

	-- 铁血堂堂主
	-- elseif npcname == "npc_task_tiexuetangtangzhu" then
		-- table.insert(btnList,{
		-- 	display = "fortune-teller",
		-- })

	-- 黑市商人
	elseif npcname == "npc_task_heishishangren" then

		local gamblingChance = nil

		if hero:IsFate("dushen") then
			gamblingChance = 100
		end

		for itemname,conf in pairs(GamblingConfig) do
			table.insert(btnList,{
				display = "gambling",
				itemname = itemname,
				gold = conf.gold,
				chance = gamblingChance or conf.chance,
			})
		end

		if hero:IsFate("dushen") then
			for itemname,conf in pairs(GamblingConfigForFate) do
				if hero:GetCustomAttribute("state",0) >= conf.state then
					table.insert(btnList,{
						display = "gambling",
						itemname = itemname,
						gold = conf.gold,
						chance = conf.chance,
					})
				end
			end
		end

		if hero:HasVIP() then
			table.insert(btnList,{
				display = "heishishangren_three2one",
				list = ShuShanHeiShiShangRenThreeToOne(hero)
			})
		end

	end


	-- 技能学习
	local list = LearnExtraAbilities:GetCanLearnAbilities(hero, npc)
	if list then
		for i,v in ipairs(list) do
			table.insert(btnList,v)
		end
	end

	-- 技能升级
	local list = LearnExtraAbilities:GetCanUpgradeAbilities(hero, npc)
	if list then
		for i,v in ipairs(list) do
			table.insert(btnList,v)
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_event_select_npc_response", {btnList = btnList, unit=data.unit})
end)