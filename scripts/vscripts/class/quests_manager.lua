
--@class CQuestsManager

if CQuestsManager == nil then
	CQuestsManager = class({})
end

-- vars
local public = CQuestsManager
local tinsert = table.insert

-- 构造函数
function public:constructor(hero)
	self.__hero = hero
	self.__quests = {}
	self.__table_data = {}
end

function public:GetHero()
	return self.__hero
end

function public:GetQuest(quest_name)
	return self.__quests[quest_name]
end

function public:GetAllQuests()
	return self.__quests
end

-- 获取已经接受的任务
function public:GetAcceptedQuests()
	local t = {}

	for quest_name,quest in pairs(self.__quests) do
		if quest:IsAccepted() then
			t[quest_name] = quest
		end
	end

	return t
end

-- 获取已经完成的任务
function public:GetFinishedQuests()
	local t = {}

	for quest_name,quest in pairs(self.__quests) do
		if quest:IsFinished() then
			t[quest_name] = quest
		end
	end
	
	return t
end

-- 获取已经完成提交的任务
function public:GetSubmitedQuests()
	local t = {}

	for quest_name,quest in pairs(self.__quests) do
		if quest:IsSubmited() then
			t[quest_name] = quest
		end
	end
	
	return t
end

-- 获取已经失败的任务
function public:GetFailedQuests()
	local t = {}

	for quest_name,quest in pairs(self.__quests) do
		if quest:IsFailed() then
			t[quest_name] = quest
		end
	end
	
	return t
end

-- 接受任务
function public:AcceptQuest(quest_name)
	local quest_data = QuestsKV[quest_name]
	if quest_data == nil then return end
	if not self:CanAccept(quest_name) then return end

	if self.__quests[quest_name] == nil then
		local quest = CQuests(self,quest_name)
		self.__quests[quest_name] = quest

		if quest:TouchAcceptFail() then
			Avalon:Fire("quests_accept_quest_fail",self:GetHero(),quest)
		else
			quest:GiveAcceptRewards()
			Avalon:Fire("quests_accept_quest_success",self:GetHero(),quest)
		end
	else
		local quest = self.__quests[quest_name]
		if quest:Reset() then
			Avalon:Fire("quests_accept_quest_success",self:GetHero(),quest)
		else
			Avalon:Fire("quests_accept_quest_fail",self:GetHero(),quest)
		end
	end
end

-- 提交任务
function public:SubmitQuest(quest_name)
	local quest = self:GetQuest(quest_name)
	quest:Submit()
end

-- 解析公式
function public:ParseLogicalFormula(str, quest_name)
	if not str or str == "" then return true end
	local hero = self:GetHero()
	
	local vars = {}
	for w in string.gmatch(str, "%$[%w_]+") do
		if vars[w] == nil then
			vars[w] = Avalon:Conform("quests_get_logical_formula_var_value", hero, w, quest_name)
		end
	end

	for k,v in pairs(vars) do
		str = string.gsub(str,k,tostring(v))
	end

	local a,b = pcall(loadstring('return '..str))
	if TurnCustomGameDebug then
		-- print('[ParseLogicalFormula]',str,a,b)
	end
	return b == true
end

function public:CanAcceptSharedNameQuest(shared_name)
	if not shared_name or shared_name == "" then return true end

	for _quest_name,quest in pairs(self.__quests) do
		local isShared = quest:GetSharedName() == shared_name
		if (quest:IsAccepted() or quest:IsFinished() or quest:IsNotAccepted()) and isShared then
			return false
		elseif quest:IsSubmited() and not quest:IsRepeat() and isShared then
			return false
		end
	end

	return true
end

function public:HasSubmitedSharedNameQuest(shared_name)
	if not shared_name or shared_name == "" then return true end

	for _quest_name,quest in pairs(self.__quests) do
		if quest:GetSharedName() == shared_name and quest:GetSubmitCount() > 0 then
			return true
		end
	end

	return false
end

function public:GetSharedNameQuest(shared_name)
	if not shared_name or shared_name == "" then return nil end

	local list = nil
	for _quest_name,quest in pairs(self.__quests) do
		if quest:GetSharedName() == shared_name then
			if list == nil then list = {} end
			table.insert(list,quest)
		end
	end

	return list
end

-- 判断能否接受任务
function public:CanAccept(quest_name)
	if quest_name == "" then return false end

	-- 如果任务已经存在任务列表
	if self.__quests[quest_name] ~= nil then
		local quest = self.__quests[quest_name]
		if quest:IsAccepted() or quest:IsFinished() or quest:IsNotAccepted() then
			return false
		end
		if quest:IsSubmited() then
			local SharedName = quest:GetSharedName()
			if not self:CanAcceptSharedNameQuest(SharedName) then
				return false
			end
			return quest:IsRepeat()
		end
		return false
	end

	-- 不存在任务列表开始判断
	local quest_data = QuestsKV[quest_name]
	if quest_data == nil then return false end

	-- 如果是共享任务
	local SharedName = quest_data["SharedName"]
	if SharedName and not self:CanAcceptSharedNameQuest(SharedName) then
		return false
	end

	local Precondition = quest_data["Precondition"]
	local PreQuests = Precondition["PreQuests"]
	local LogicalFormula = Precondition["LogicalFormula"]

	-- 判断逻辑公式
	if self:ParseLogicalFormula(LogicalFormula, quest_name) == false then
		return false
	end

	-- 判断前置任务
	local preQuestsMaxCount = 0
	local preQuestsCount = 0

	for quest_name,open in pairs(PreQuests) do
		preQuestsMaxCount = preQuestsMaxCount + 1
		local quest = self:GetQuest(quest_name)
		if quest then
			if open == 1 and quest:GetSubmitCount() > 0 then
				preQuestsCount = preQuestsCount + 1
			end
		elseif self:HasSubmitedSharedNameQuest(quest_name) then
			preQuestsCount = preQuestsCount + 1
		end
	end

	return preQuestsCount == preQuestsMaxCount
end

-- 获取可接受任务
function public:GetAcceptableQuests(npc_name)
	local npc_quests = Avalon:Conform("quests_get_npc_quests", npc_name)
	if npc_quests == nil then return nil end

	local t = {}

	for quest_name in pairs(npc_quests) do
		if self:CanAccept(quest_name) then
			tinsert(t,quest_name)
		end
	end

	return t
end

-- 获取全部可接受任务
function public:GetAllAcceptableQuests()
	local quests = {}
	for quest_name,v in pairs(QuestsKV) do
		if self:CanAccept(quest_name) then
			quests[quest_name] = v
		end
	end
	return quests
end

function public:SubmitItems()
	local acceptedQuests = self:GetAcceptedQuests()

	for quest_name,quest in pairs(acceptedQuests) do
		quest:SubmitItems()
	end
end

function public:TouchCustomType(name, func)
	local acceptedQuests = self:GetAcceptedQuests()

	for quest_name,quest in pairs(acceptedQuests) do
		quest:TouchCustomType(name, func)
	end
end

-- 生成任务信息
function public:table()
	local t = self.__table_data

	for quest_name,quest in pairs(self:GetAllQuests()) do
		if quest:IsAccepted() or quest:IsFinished() then
			t[quest_name] = quest:table()
		else
			t[quest_name] = nil
		end
	end

	return t
end

-- 单位被击杀
function public:OnEntityKilled(unit)
	local acceptedQuests = self:GetAcceptedQuests()

	for quest_name,quest in pairs(acceptedQuests) do
		quest:OnEntityKilled(unit)
	end
end

-- 当背包发生改变
function public:OnBagChanged(bag)
	local acceptedQuests = self:GetAcceptedQuests()

	for quest_name,quest in pairs(acceptedQuests) do
		quest:OnBagChanged(bag)
	end

	local finishedQuests = self:GetFinishedQuests()

	for quest_name,quest in pairs(finishedQuests) do
		quest:OnBagChanged(bag)
	end
end

-- 英雄靠近NPC
function public:OnTouching(npc)
	local acceptedQuests = self:GetAcceptedQuests()

	for quest_name,quest in pairs(acceptedQuests) do
		quest:OnTouching(npc)
	end
end
