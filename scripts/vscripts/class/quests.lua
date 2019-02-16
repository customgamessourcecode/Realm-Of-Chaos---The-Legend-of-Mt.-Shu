
--@class CQuests
if CQuests == nil then
	CQuests = class({})
end

local public = CQuests
local tinsert = table.insert

-- Constant: Quest state
QUEST_STATE_NOT_ACCEPTED  = 0
QUEST_STATE_ACCEPTED  = 1
QUEST_STATE_FINISHED  = 2
QUEST_STATE_SUBMITTED = 3
QUEST_STATE_FAILED = 4

-- 构造函数
function public:constructor(manager, quest_name, isGroupChild, parentQuest, childKey)
	self.__manager = manager
	self.__quest_name = quest_name
	self.__state = QUEST_STATE_ACCEPTED
	self.__is_group_child = isGroupChild == true
	self.__parent_quest = parentQuest
	self.__child_key = childKey
	self.__submited_count = 0
	self.__has_give_accept_rewards = false
	self.__has_give_submit_rewards = false
	self.__forever_can_not_accept = false
	self.__has_give_accept_fail_rewards = false
	self.__table_data = {}
	self.__can_show_to_mini_quest_frame = true
	self.__cooldown_end_time = 0

	local accept_npc_name
	local submit_npc_name
	local _this_quest_data
	local _this_quest_subquests

	-- 如果是任务组的子任务
	if self.__is_group_child then
		local parent_quest_data = QuestsKV[parentQuest:GetName()]
		local Quests = parent_quest_data["Quests"]
		_this_quest_data = Quests[childKey]

		if IsInToolsMode() then
			assert(_this_quest_data,'Invalid quest group child')
		end

		accept_npc_name = _this_quest_data["AcceptNPC"]
		submit_npc_name = _this_quest_data["SubmitNPC"] or accept_npc_name

		_this_quest_subquests = _this_quest_data["SubQuests"]
	else
		_this_quest_data = QuestsKV[quest_name]
		accept_npc_name = _this_quest_data["AcceptNPC"]
		submit_npc_name = _this_quest_data["SubmitNPC"] or accept_npc_name

		_this_quest_subquests = _this_quest_data["SubQuests"]
	end
	self.__quest_data = _this_quest_data
	self:AcceptChildQuest()

	-- 文本参数
	self.__text_args = {
		AcceptNPC=accept_npc_name,
		SubmitNPC=submit_npc_name,
	}

	-- 生成目标
	local _subquests = {}
	for k,v in pairs(_this_quest_subquests) do
		_subquests[k] = CQuestsSubquest(self,k,v)

		if v["Type"] == "FIND_UNIT" then
			self.__text_args['arg'..k] = v["Target"]
		elseif v["Type"] == "FIND_ITEM" or v["Type"] == "KILL_UNIT" then
			self.__text_args['arg'..k] = v["Target"]
			self.__text_args['arg'..k.."_max_count"] = v["MaxCount"]
		elseif v["Type"] == "CUSTOM" and v["TextArgs"] ~= nil then
			for k,v in pairs(v["TextArgs"]) do
				self.__text_args[k] = v
			end
		end
	end
	self.__subquests = _subquests

	-- 设置NPC
	local allNPC = Avalon:Conform("quests_get_all_npc")
	self.__accept_npc = allNPC[accept_npc_name]
	self.__submit_npc = allNPC[submit_npc_name]
	self:TouchAcceptedEvent()

	if IsInToolsMode() then
		assert(self.__accept_npc,'Invalid accept NPC')
		assert(self.__submit_npc,'Invalid submit NPC')
		assert(not self.__accept_npc:IsNull(),'Invalid accept NPC')
		assert(not self.__submit_npc:IsNull(),'Invalid submit NPC')
	end
end

-- 尝试触发接受任务失败
function public:TouchAcceptFail()
	local quest_data = self:GetQuestData()
	local AcceptFailRequire = quest_data["AcceptFailRequire"]
	if not AcceptFailRequire then return false end

	if self:GetManager():ParseLogicalFormula(AcceptFailRequire) then
		self:GiveAcceptFailRewards()
		self.__state = QUEST_STATE_FAILED

		-- 接受任务失败
		local OnAcceptFail = quest_data["OnAcceptFail"]
		if OnAcceptFail then
			local func = _G[OnAcceptFail["Function"]]
			
			if type(func) == "function" then
				local t = {quest=self}
				for k,v in pairs(OnAcceptFail) do
					if k ~= "Function" then
						t[k] = v
					end
				end
				func(t)
			elseif IsInToolsMode() then
				print(tostring(OnAcceptFail["Function"]).." is not a function: type "..type(func))
			end
		end

		return true
	end

	return false
end

-- 触发接受任务
function public:TouchAcceptedEvent()
	local quest_data = self:GetQuestData()
	local OnAccepted = quest_data["OnAccepted"]
	if OnAccepted then
		for _,data in pairs(OnAccepted) do
			local func = _G[data["Function"]]
			
			if type(func) == "function" then
				local t = {quest=self}
				for k,v in pairs(data) do
					if k ~= "Function" then
						t[k] = v
					end
				end
				func(t)
			elseif IsInToolsMode() then
				print(tostring(data["Function"]).." is not a function: type "..type(func))
			end
		end
			
	end
end

-- 触发接受任务
function public:TouchSubmitedEvent()
	local quest_data = self:GetQuestData()
	local OnSubmited = quest_data["OnSubmited"]
	if OnSubmited then
		for _,data in pairs(OnSubmited) do
			local func = _G[data["Function"]]
			
			if type(func) == "function" then
				local t = {quest=self}
				for k,v in pairs(data) do
					if k ~= "Function" then
						t[k] = v
					end
				end
				func(t)
			elseif IsInToolsMode() then
				print(tostring(data["Function"]).." is not a function: type "..type(func))
			end
		end
	end
end

function public:GetTextArgs()
	return self.__text_args
end

-- 是否显示到任务追踪面板
function public:CanShowToMiniQuestFrame()
	return self.__can_show_to_mini_quest_frame
end

-- 设置是否显示到任务追踪面板
function public:SetCanShowToMiniQuestFrame(b)
	self.__can_show_to_mini_quest_frame = b
	self:Update()
end

-- 如果是任务组的子任务，则返回任务组
function public:GetParentQuest()
	return self.__parent_quest
end

-- 判断是否已经给予奖励
function public:HasGiveAcceptRewards()
	return self.__has_give_accept_rewards
end

-- 判断是否已经给予奖励
function public:HasGiveSubmitRewards()
	return self.__has_give_submit_rewards
end

function public:HasGiveAcceptFailRewards()
	return self.__has_give_accept_fail_rewards
end

-- 获取任务数据
function public:GetQuestData()
	return self.__quest_data
end

-- 开始冷却
function public:StartCooldown(time)
	self.__cooldown_end_time = GameRules:GetGameTime() + time
end

-- 判断是否没有冷却
function public:IsCooldownReady()
	return GameRules:GetGameTime() >= self.__cooldown_end_time
end

-- 更新
function public:Update()
	Avalon:Fire("quests_update",self:GetHero(),self)
	return self
end

-- 获取管理器
function public:GetManager()
	return self.__manager
end

-- 获取英雄
function public:GetHero()
	return self.__manager:GetHero()
end

-- 获取任务名称
function public:GetName()
	return self.__quest_name
end

-- 获取提交任务的NPC
function public:GetSubmitNPC()
	return self.__submit_npc
end

-- 获取接受任务的NPC
function public:GetAcceptNPC()
	return self.__accept_npc
end

function public:GetChildKey()
	return self.__child_key
end

-- 判断是否是重复任务
function public:IsRepeat()
	if self:IsGroupChild() then
		return false
	else
		return self:GetQuestData()["IsRepeat"] == 1
	end
end

-- 判断是否是主线任务
function public:IsMain()
	if self:IsGroupChild() then
		return false
	else
		return self:GetQuestData()["IsMainQuest"] == 1
	end
end

-- 判断是否是任务组
function public:IsGroup()
	if self:IsGroupChild() then
		return false
	else
		return self:GetQuestData()["IsQuestGroup"] == 1
	end
end

-- 判断是否是任务组的子任务
function public:IsGroupChild()
	return self.__is_group_child
end

function public:GetSharedName()
	if self:IsGroupChild() then
		return ""
	else
		return self:GetQuestData()["SharedName"] or ""
	end
end

-- 获取任务目标
function public:GetSubquests()
	return self.__subquests
end

-- 给予任务奖励
function public:GiveRewards(rewards, count)
	count = count or 1
	local manager = self:GetManager()
	local hero = self:GetHero()

	-- 固定奖励
	local FixedRewards = rewards["Fixed"]
	if FixedRewards then
		for name,value in pairs(FixedRewards) do
			Avalon:Fire("quests_give_reward", hero,self,name,value,count)
		end
	end

	-- 随机奖励
	local RandomRewards = rewards["Random"]
	if RandomRewards then
		local RandomKeys = {}
		for k in pairs(RandomRewards) do
			tinsert(RandomKeys,k)
		end
		local key = RandomKeys[RandomInt(1, #RandomKeys)]
		local rdrewards = RandomRewards[key]
		for name,value in pairs(rdrewards) do
			Avalon:Fire("quests_give_reward", hero,self,name,value,count)
		end
	end

	-- 概率奖励
	local ChanceRewards = rewards["Chance"]
	if ChanceRewards then
		local Limit = ChanceRewards["Limit"]
		local Count = 0
		for k,t in pairs(ChanceRewards) do
			if k ~= "Limit" then
				if RandomFloat(0, 100) <= t.Chance then
					Count = Count + 1
					for name,value in pairs(t) do
						if name ~= "Chance" then
							Avalon:Fire("quests_give_reward", hero,self,name,value,count)
						end
					end
				end
				if Count >= Limit then
					break
				end
			end
		end
	end

	-- 额外奖励
	local ExtraRewards = rewards["Extra"]
	if ExtraRewards then
		for k,t in pairs(ExtraRewards) do
			if manager:ParseLogicalFormula(t["LogicalFormula"]) then
				for name,value in pairs(t) do
					if name ~= "LogicalFormula" then
						Avalon:Fire("quests_give_reward", hero,self,name,value,count)
					end
				end
			end
		end
	end

	return self
end

-- 接受任务给予奖励
function public:GiveAcceptRewards()
	if not self:IsAccepted() then
		return false
	end

	if self:HasGiveAcceptRewards() then
		return false
	end

	self.__has_give_accept_rewards = true
	local quest_data = self:GetQuestData()

	local AcceptRewards = quest_data["AcceptRewards"]
	if AcceptRewards then
		self:GiveRewards(AcceptRewards)
	end

	return true
end

-- 提交任务给予奖励
function public:GiveSubmitRewards()
	if not self:IsSubmited() then
		return false
	end

	if self:HasGiveSubmitRewards() then
		return false
	end

	self.__has_give_submit_rewards = true
	local quest_data = self:GetQuestData()

	local SubmitRewards = quest_data["SubmitRewards"]
	if SubmitRewards then
		self:GiveRewards(SubmitRewards)
	end

	return true
end

-- 接受任务失败给予奖励
function public:GiveAcceptFailRewards()
	if self:HasGiveAcceptFailRewards() then
		return false
	end

	self.__has_give_accept_fail_rewards = true

	local quest_data = self:GetQuestData()

	local AcceptFailRewards = quest_data["AcceptFailRewards"]
	if AcceptFailRewards then
		self:GiveRewards(AcceptFailRewards)
	end

	return true
end

-- 接受子任务，仅有任务组有效
function public:AcceptChildQuest()
	if self.__submit_quest_lock then return end
	if not self:IsAccepted() then return end

	local quest_name = self.__quest_name
	local quest_data = self:GetQuestData()

	if quest_data and quest_data["IsQuestGroup"] == 1 then
		local Quests = quest_data["Quests"]
		local childkeys = {}
		for k in pairs(Quests) do
			if k ~= "RequestMissionCount" then
				tinsert(childkeys,k)
			end
		end

		local __quests = self.__manager:GetAllQuests()
		local childkey = childkeys[RandomInt(1, #childkeys)]
		local _quest_name = quest_name .. '_' .. childkey

		if __quests[_quest_name] then
			__quests[_quest_name]:Reset()
		else
			__quests[_quest_name] = public(self.__manager, _quest_name, true, self, childkey)
		end

		self:GetHero():GetBag():Update()
			
	end

	return self
end

-- 完成任务
function public:Finish()
	if self.__submit_quest_lock then return end
	if self:GetState() == QUEST_STATE_SUBMITTED then return end

	local max_count = 0
	local count = 0
	for _,subquest in pairs(self:GetSubquests()) do
		max_count = max_count + 1
		if subquest:IsFinished() then
			count = count + 1
		end
	end

	if max_count == count and self.__state ~= QUEST_STATE_FINISHED then
		self.__state = QUEST_STATE_FINISHED
		Avalon:Fire("quests_finished_quest", self:GetHero(), self)
	elseif max_count ~= count then
		self.__state = QUEST_STATE_ACCEPTED
	end

	self:Update()

	return self
end

-- 提交任务
function public:Submit()
	if self:GetState() ~= QUEST_STATE_FINISHED then return self end
	self.__submit_quest_lock = true
	
	if not self:SubmitItems() then
		self.__submit_quest_lock = false
		return self
	end

	self.__state = QUEST_STATE_SUBMITTED
	self.__submited_count = self.__submited_count + 1
	self.__submit_quest_lock = false

	self:GiveSubmitRewards()

	self:TouchSubmitedEvent()
	Avalon:Fire("quests_submited_quest", self:GetHero(), self)

	if self:IsGroupChild() then
		self:GetParentQuest():OnSubmitedChildQuest()
		self:Update()
		return self
	end

	self:Update()

	if not self:IsRepeat() then
		self.__table_data = nil
		self.__text_args = nil
	end
	
	return self
end

--[[
重置任务
处于QUEST_STATE_FINISHED则重新检测目标达成条件，比如任务物品被销毁，重置成QUEST_STATE_ACCEPTED
处于QUEST_STATE_SUBMITTED则如果是重复任务，重置成QUEST_STATE_ACCEPTED
]]
function public:Reset()
	if self.__submit_quest_lock then return end

	if not self:IsCooldownReady() then
		return Avalon:Throw(self:GetHero(),"#dota_hud_error_ability_in_cooldown", false)
	end
	if self:IsSubmited() then
		if self:TouchAcceptFail() then
			return false
		end

		if self:IsRepeat() or self:IsGroupChild() then
			for _,subquest in pairs(self:GetSubquests()) do
				subquest:Reset()
			end

			self.__state = QUEST_STATE_ACCEPTED
			self.__has_give_accept_rewards = false
			self.__has_give_submit_rewards = false
			self:GiveAcceptRewards()

			if self:IsGroup() then
				self:AcceptChildQuest()
			end

			self:TouchAcceptedEvent()

			return true
		end
	end

	return false
end

-- 判断任务状态是否为QUEST_STATE_ACCEPTED
function public:IsAccepted()
	return self.__state == QUEST_STATE_ACCEPTED
end

-- 判断任务状态是否为QUEST_STATE_FINISHED
function public:IsFinished()
	return self.__state == QUEST_STATE_FINISHED
end

-- 判断任务状态是否为QUEST_STATE_SUBMITTED
function public:IsSubmited()
	return self.__state == QUEST_STATE_SUBMITTED
end

-- 判断任务状态是否为QUEST_STATE_FAILED
function public:IsFailed()
	return self.__state == QUEST_STATE_FAILED
end

-- 判断任务状态是否为QUEST_STATE_NOT_ACCEPTED
function public:IsNotAccepted()
	return self.__state == QUEST_STATE_NOT_ACCEPTED
end

-- 获取任务状态
function public:GetState()
	return self.__state
end

-- 获取完成次数
function public:GetSubmitCount()
	return self.__submited_count or 0
end

-- 获取提交物品相关信息
function public:GetSubmitItems(npcname)
	local t = {}

	for _,subquest in pairs(self:GetSubquests()) do
		local itemdata = subquest:GetSubmitItemName(npcname)
		if itemdata then
			tinsert(t,itemdata)
		end
	end

	return t
end

function public:SubmitItems()
	for _,subquest in pairs(self:GetSubquests()) do
		if not subquest:SubmitItems() then
			return false
		end
	end
	return true
end

function public:TouchCustomType(name, func)
	for _,subquest in pairs(self:GetSubquests()) do
		subquest:TouchCustomType(name, func)
	end
end

function public:table()
	local t = self.__table_data
	t['State'] = self:GetState()
	t['AcceptNPC'] = self:GetAcceptNPC():GetEntityIndex()
	t['SubmitNPC'] = self:GetSubmitNPC():GetEntityIndex()
	t['CanShowToMiniQuestFrame'] = self:CanShowToMiniQuestFrame()
	t['IsRepeat'] = self:IsRepeat()

	if t["SubQuests"] == nil then t["SubQuests"] = {} end

	local SubQuests = t["SubQuests"]
	for index,subquest in pairs(self:GetSubquests()) do
		SubQuests[index] = subquest:table()
	end

	return t
end

-- 当单位被击杀
function public:OnEntityKilled(unit)
	for _,subquest in pairs(self:GetSubquests()) do
		subquest:OnEntityKilled(unit)
	end
end

-- 背包发生改变
function public:OnBagChanged(bag)
	for _,subquest in pairs(self:GetSubquests()) do
		subquest:OnBagChanged(bag)
	end
end

-- 英雄靠近NPC
function public:OnTouching(npc)
	for _,subquest in pairs(self:GetSubquests()) do
		subquest:OnTouching(npc)
	end
end

-- 完成子任务
function public:OnSubmitedChildQuest()
	if self:IsGroup() then
		for _,subquest in pairs(self:GetSubquests()) do
			subquest:OnSubmitedChildQuest()
		end
		self:AcceptChildQuest()
	end
end