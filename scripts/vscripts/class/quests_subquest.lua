
--@class CQuestsSubquest
if CQuestsSubquest == nil then
	CQuestsSubquest = class({})
end

local public = CQuestsSubquest

QUESTS_TARGET_TYPE_FIND_UNIT = 1 --寻找单位
QUESTS_TARGET_TYPE_KILL_UNIT = 2 --击杀单位
QUESTS_TARGET_TYPE_FIND_ITEM = 3 --收集物品
QUESTS_TARGET_TYPE_FINISH_CHILD_QUEST = 4 --完成子任务，任务组特有
QUESTS_TARGET_TYPE_CUSTOM = 5 --自定义

function public:constructor(quest, index, targetData)
	self.__quest = quest
	self.__target_index = index
	self.__subquest_data = targetData
	self.__finished = false
	self.__table_data = {}

	local typeName = targetData["Type"]

	if typeName == "FIND_UNIT" then
		self.__type = QUESTS_TARGET_TYPE_FIND_UNIT
		self.__npc_name = targetData["Target"]

	elseif typeName == "KILL_UNIT" then
		self.__type = QUESTS_TARGET_TYPE_KILL_UNIT
		self.__kill_unit_name = targetData["Target"]
		self.__kill_unit_max_count = targetData["MaxCount"]
		self.__kill_unit_count = 0

	elseif typeName == "FIND_ITEM" then
		self.__type = QUESTS_TARGET_TYPE_FIND_ITEM
		self.__find_item_name = targetData["Target"]
		self.__find_item_max_count = targetData["MaxCount"]
		self.__find_item_count = 0
		self.__find_item_give_submit_rewards_count = 0
		self.__submit_item_npc_name = targetData["SubmitNPC"]
		self.__is_any_item_num = targetData["MaxCount"] == -1

	elseif typeName == "FINISH_CHILD_QUEST" then
		self.__type = QUESTS_TARGET_TYPE_FINISH_CHILD_QUEST
		self.__submited_child_quest_max_count = targetData["MaxCount"]
		self.__submited_child_quest_count = 0

	elseif typeName == "CUSTOM" then
		self.__type = QUESTS_TARGET_TYPE_CUSTOM
		self.__function_name = targetData["Function"]

		local custom_data = {}
		for k,v in pairs(targetData) do
			custom_data[k] = v
		end
		self.__custom_data = custom_data

	end
end

function public:GetQuest()
	return self.__quest
end

function public:GetIndex()
	return self.__target_index
end

function public:GetType()
	return self.__type
end

function public:IsFinished()
	return self.__finished
end

function public:Reset()
	local _type = self:GetType()
	local quest = self:GetQuest()

	if not quest:IsSubmited() then
		return false
	end
	if not quest:IsRepeat() and not quest:IsGroupChild() then
		return false
	end

	self.__finished = false

	if _type == QUESTS_TARGET_TYPE_KILL_UNIT then
		self.__kill_unit_count = 0
	elseif _type == QUESTS_TARGET_TYPE_FIND_ITEM then
		self.__find_item_count = 0
		self.__find_item_give_submit_rewards_count = 0
		if self.__is_any_item_num then self.__find_item_max_count = -1 end
		
	elseif _type == QUESTS_TARGET_TYPE_FINISH_CHILD_QUEST then
		self.__submited_child_quest_count = 0

	elseif _type == QUESTS_TARGET_TYPE_CUSTOM then
		for k,v in pairs(self.__subquest_data) do
			self.__custom_data[k] = v
		end
	end

	return true
end

function public:GetTextArgs()
	local _type = self:GetType()

	if _type == QUESTS_TARGET_TYPE_FIND_ITEM then
		local MaxCount = self.__find_item_max_count
		if MaxCount == -1 then
			MaxCount = self.__find_item_count
		end
		return {
			Target = self.__find_item_name,
			MaxCount = MaxCount,
		}

	elseif _type == QUESTS_TARGET_TYPE_KILL_UNIT then
		return {
			Target = self.__kill_unit_name,
			MaxCount = self.__kill_unit_count,
		}
	end
end

function public:GetSubmitItemName(npcname)
	if self:GetType() ~= QUESTS_TARGET_TYPE_FIND_ITEM then return nil end
	if self:IsFinished() then return nil end
	if self.__submit_item_npc_name ~= npcname then return nil end

	if self.__submit_item_npc_name then
		return {itemname=self.__subquest_data["Target"],count=self.__find_item_max_count-self.__find_item_count}
	end

	return nil
end

function public:table()
	local _type = self:GetType()
	local t = self.__table_data

	if _type == QUESTS_TARGET_TYPE_KILL_UNIT then
		t["MaxCount"] = self.__kill_unit_max_count
		t["Count"] = self.__kill_unit_count
		t["Target"] = self.__kill_unit_name

	elseif _type == QUESTS_TARGET_TYPE_FIND_ITEM then
		t["MaxCount"] = self.__find_item_max_count
		t["Count"] = self.__find_item_count
		t["Target"] = self.__find_item_name
		t["SubmitNPC"] = self.__submit_item_npc_name

	elseif _type == QUESTS_TARGET_TYPE_FIND_UNIT then
		t["Target"] = self.__npc_name

	elseif _type == QUESTS_TARGET_TYPE_FINISH_CHILD_QUEST then
		t["MaxCount"] = self.__submited_child_quest_max_count
		t["Count"] = self.__submited_child_quest_count

	elseif _type == QUESTS_TARGET_TYPE_CUSTOM then
		for k,v in pairs(self.__custom_data) do
			t[k] = v
		end

	end

	t['Type'] = _type
	t["IsFinished"] = self.__finished

	return t
end

function public:Update()
	self:GetQuest():Finish()
end

function public:OnEntityKilled(unit)
	if self:GetType() == QUESTS_TARGET_TYPE_KILL_UNIT and not self:IsFinished() then
		local unitName = unit:GetUnitName()
		if unitName == self.__kill_unit_name then
			if self.__kill_unit_count < self.__kill_unit_max_count then
				self.__kill_unit_count = self.__kill_unit_count + 1

				if self.__kill_unit_count == self.__kill_unit_max_count then
					self.__finished = true

					local quest = self:GetQuest()
					local hero = quest:GetHero()
					Avalon:Fire("quests_subquest_finished", hero, quest, self)
				end

				self:Update()
			end
		end
	end
end

function public:OnBagChanged(bag)
	if self:GetType() == QUESTS_TARGET_TYPE_FIND_ITEM and not self.__submit_item_npc_name then
		local item_num = bag:GetNumItemInBag(self.__find_item_name)
		self.__find_item_count = item_num
		if self.__find_item_max_count == -1 then
			local max = -1
			
			local data = self.__subquest_data["SubmitRewards"]
			if data then
				local RequireCount = (data["RequireCount"] or 1)
				max = RequireCount
			end

			self.__finished = self.__find_item_count >= max
		else
			self.__finished = (self.__find_item_count >= self.__find_item_max_count)
		end

		if self.__finished and not self.__is_show_bubble then
			self.__is_show_bubble = true
			local quest = self:GetQuest()
			local hero = quest:GetHero()
			Avalon:Fire("quests_subquest_finished", hero, quest, self)

		elseif not self.__finished then
			self.__is_show_bubble = false
			
		end
		self:Update()
	end
end

function public:GiveSubmitItemsRewards()
	if self:GetType() == QUESTS_TARGET_TYPE_FIND_ITEM then
		local data = self.__subquest_data["SubmitRewards"]
		if data then
			if self.__find_item_max_count == -1 then
				local submitMaxCount = math.floor(self.__find_item_max_count / (data["RequireCount"] or 1))
				local count = submitMaxCount - self.__find_item_give_submit_rewards_count

				self.__find_item_give_submit_rewards_count = self.__find_item_give_submit_rewards_count + count
				self:GetQuest():GiveRewards(data, count)
			else
				local submitMaxCount = math.floor(self.__find_item_max_count / (data["RequireCount"] or 1))
				local count = submitMaxCount - self.__find_item_give_submit_rewards_count

				self.__find_item_give_submit_rewards_count = self.__find_item_give_submit_rewards_count + count
				self:GetQuest():GiveRewards(data, count)
			end
		end
	end
end

-- 提交物品
function public:SubmitItems()
	if self:GetType() == QUESTS_TARGET_TYPE_FIND_ITEM then

		if self:GetQuest():IsFinished() and self:IsFinished() and self.__submit_item_npc_name == nil then

			local bag = self:GetQuest():GetHero():GetBag()
			if not bag then return false end

			local item_num = bag:GetNumItemInBag(self.__find_item_name)

			if self.__find_item_max_count == -1 then
				local data = self.__subquest_data["SubmitRewards"]
				if data then
					local RequireCount = (data["RequireCount"] or 1)
					self.__find_item_max_count = math.floor(item_num / RequireCount) * RequireCount
				else
					self.__find_item_max_count = item_num
				end
			end

			if item_num < self.__find_item_max_count then
				return false
			end

			local count = bag:RemoveItemByName(self.__find_item_name, self.__find_item_max_count)

			if count > 0 then
				return false
			end
				

		elseif not self:IsFinished() and self.__submit_item_npc_name then
			local itemname = self.__find_item_name
			local bag = self:GetQuest():GetHero():GetBag()
			if not bag then return false end

			local item_num = bag:GetNumItemInBag(self.__find_item_name)

			if self.__find_item_max_count == -1 then
				local data = self.__subquest_data["SubmitRewards"]
				if data then
					local RequireCount = (data["RequireCount"] or 1)
					self.__find_item_max_count = math.floor(item_num * RequireCount) * RequireCount
				else
					self.__find_item_max_count = item_num
				end
			end

			local count = self.__find_item_max_count - self.__find_item_count

			self.__find_item_count = self.__find_item_count + count - bag:RemoveItemByName(itemname, count)

			self.__finished = (self.__find_item_count >= self.__find_item_max_count)

			if not self.__finished and self.__is_any_item_num then
				self.__find_item_max_count = -1
			end
		end

		self:GiveSubmitItemsRewards()
		self:Update()
		return true
	end

	return true
end

-- 触发自定义事件
function public:TouchCustomType(name, func)
	if self:GetType() == QUESTS_TARGET_TYPE_CUSTOM and self.__function_name == name and not self:IsFinished() then
		if func(self, self.__custom_data) == true then
			self.__finished = true
		end
		self:Update()
	end
end

-- 英雄靠近NPC
function public:OnTouching(npc)
	if self:GetType() == QUESTS_TARGET_TYPE_FIND_UNIT and not self:IsFinished() then
		if npc and not npc:IsNull() and npc:GetUnitName() == self.__npc_name then
			self.__finished = true

			local data = self.__subquest_data["FindRewards"]
			if data then
				self:GetQuest():GiveRewards(data)
			end

			local quest = self:GetQuest()
			local hero = quest:GetHero()
			-- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_quest_bubble", 
			-- 	{text=quest:GetName().."_bubble_subquest_" .. tostring(self.__target_index) .. "_text",unit=npc:GetEntityIndex()})

			Avalon:Fire("quests_subquest_finished", hero, quest, self, npc)
			self:Update()
		end
	end
end

-- 完成子任务
function public:OnSubmitedChildQuest()
	if self:GetType() == QUESTS_TARGET_TYPE_FINISH_CHILD_QUEST and not self:IsFinished() then
		if self.__submited_child_quest_count < self.__submited_child_quest_max_count then
			self.__submited_child_quest_count = self.__submited_child_quest_count + 1

			if self.__submited_child_quest_count == self.__submited_child_quest_max_count then
				self.__finished = true
			end

			self:Update()
		end
	end
end

function public:GoToTarget()
	Avalon:Fire("quests_subquest_go_to_target", self:GetQuest():GetHero(), self)
end