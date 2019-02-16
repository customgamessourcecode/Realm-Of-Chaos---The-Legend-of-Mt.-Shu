
if FateSystem == nil then
	FateSystem = RegisterController('fatesystem')
	FateSystem.__player_fate_name = {}
end

local public = FateSystem

function CDOTA_BaseNPC_Hero:IsFate(str)
	return self.__shushan_fate_name == str
end

-- 随机天命
function public:Random(hero)
	if hero.__shushan_fate_name ~= nil then
		-- 显示气泡
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
			{text="shushan_fortune_teller_say",unit=QuestsCtrl:GetAllNPC()["npc_task_fortune_teller"]:GetEntityIndex()})
		return
	end

	if hero.__shushan_random_fate_times == nil then
		hero.__shushan_random_fate_times = 0
	end

	if hero.__shushan_pre_fate_name == nil and hero.__shushan_random_fate_times <= 2 then
		hero.__shushan_random_fate_times = hero.__shushan_random_fate_times + 1

		local list = {}

		for name in pairs(FortuneTellerTable) do
			table.insert(list,name)
		end

		local name = list[RandomInt(1, #list)]
		hero.__shushan_pre_fate_name = name

	end

	ModalDialog(hero, {
		type = "FateDialog",
		name = hero.__shushan_pre_fate_name,
		isvip = hero:HasVIP(),
		ismax = hero.__shushan_random_fate_times >= 3
	})
	
end

-- 再来一次
function public:Again(hero)
	if not hero:HasVIP() then return end
	if hero.__shushan_random_fate_times >= 3 then return end
	hero.__shushan_pre_fate_name = nil
	self:Random(hero)
end

--[[
确定天命
]]
function public:Done(hero)
	if hero.__shushan_pre_fate_name == nil then return end
	if hero.__shushan_fate_name ~= nil then return end

	hero.__shushan_fate_name = hero.__shushan_pre_fate_name

	local name = hero.__shushan_fate_name
	local table = FortuneTellerTable[name]

	local Attributes = table["Attributes"]
	local Modifiers = table["Modifiers"]
	local Items = table["Items"]
	local Currencies = table["Currencies"]

	if Attributes then
		for k,v in pairs(Attributes) do
			hero:SetCustomAttribute(k,'fatesystem',v)
		end
	end

	if Modifiers then
		for i,v in ipairs(Modifiers) do
			hero:AddNewModifier(hero, nil, v, nil)
		end
	end

	if Items then
		for k,v in pairs(Items) do
			for i=1,v do
				hero:AddItemByName(k)
			end
		end
	end

	if Currencies then
		for k,v in pairs(Currencies) do
			if k == "Gold" then
				hero:GiveGold(v)
			end
		end
	end

	self.__player_fate_name[hero:GetEntityIndex()] = name
	CustomNetTables:SetTableValue("Common", "PlayerFateName", self.__player_fate_name)
	UnitStates:del(hero:GetSteamID(),QuestsCtrl.__all_npc["npc_task_fortune_teller"],"quest-accept")

	if name == "shanggujinwu" then
		-- local wingModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		-- 	model = "models/particles/avalon/jinwu_wing2.vmdl",
		-- 	DefaultAnim = ACT_DOTA_IDLE,
		-- 	HoldAnimation = "1"
		-- })
		-- wingModel:FollowEntity(hero,true)
		WingsSystem:Binding(hero,SHUSHAN_WING_JIN_WU_YU_YI)

	elseif name == "wakuangzongshi" then
		CollectOreSystem:OnFateSelected( hero )
	end

	-- -- 显示气泡
	-- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
	-- 	{text="shushan_fortune_teller_say_"..name,unit=QuestsCtrl:GetAllNPC()["npc_task_fortune_teller"]:GetEntityIndex()})
end

--[[
玩家英雄升级
]]
function public:OnLevelUp(hero)
	if hero:IsFate("tiancai") then
		if hero:GetUnitLabel() == "shushan_sword" then
			hero:ModifyCustomAttribute("sword_coefficient", "fatesystemlevelup", 3)

		elseif hero:GetUnitLabel() == "shushan_knife" then
			hero:ModifyCustomAttribute("knife_coefficient", "fatesystemlevelup", 3)

		elseif hero:GetUnitLabel() == "shushan_blade" then
			hero:ModifyCustomAttribute("blade_coefficient", "fatesystemlevelup", 3)

		elseif hero:GetUnitLabel() == "shushan_caster" then
			hero:ModifyCustomAttribute("caster_coefficient", "fatesystemlevelup", 3)

		elseif hero:GetUnitLabel() == "shushan_lancer" then
			hero:ModifyCustomAttribute("lancer_coefficient", "fatesystemlevelup", 3)

		end

	elseif hero:IsFate("wuzu") then
		hero:ModifyCustomAttribute("str", "fatesystemlevelup", 3)
		hero:ModifyCustomAttribute("agi", "fatesystemlevelup", 3)
		hero:ModifyCustomAttribute("int", "fatesystemlevelup", 3)

	elseif hero:IsFate("jinchanzi") then
		hero:ModifyCustomAttribute("merits", "fatesystemlevelup", 3)
	end
end

--[[
当英雄重生
]]
function public:OnRespawn(hero)
	if hero.__shushan_fate_name == nil then return end

	local name = hero.__shushan_fate_name
	local table = FortuneTellerTable[name]

	local Attributes = table["Attributes"]
	local Modifiers = table["Modifiers"]

	if Attributes then
		for k,v in pairs(Attributes) do
			hero:SetCustomAttribute(k,'fatesystem',v)
		end
	end

	if Modifiers then
		for i,v in ipairs(Modifiers) do
			if not hero:HasModifier(v) then
				hero:AddNewModifier(hero, nil, v, nil)
			end
		end
	end
end

--[[
当单位重生
]]
function public:OnKilledUnit(attacker, victim)
	if attacker:IsRealHero() and attacker ~= victim then
		if attacker:IsFate("tonglingshi") then
			local unitname = victim:GetUnitName()
			local newUnit = CreateUnitByName(unitname, victim:GetOrigin(), true, nil, nil, attacker:GetTeam())
			newUnit:SetOwner(attacker)
			newUnit:SetControllableByPlayer(attacker:GetPlayerID(), true)
			newUnit:SetRenderColor(50, 50, 50)
			newUnit:AddNewModifier(newUnit, nil, "modifier_phased", nil)
			Wait("FateSystem_OnKilledUnitTimer", newUnit, 5, function ()
				newUnit:ForceKill(true)
			end)
		end
	end
end

--[[
当闪避成功
]]
function public:OnEvadeSuccess(hero, target)
	if not target or target:IsNull() then return end
	if not hero:IsFate("fanjidashi") then return end
	UnitStunTarget(hero,target,3)
	UnitDamageTargetSimple(hero,target,nil,10)
end