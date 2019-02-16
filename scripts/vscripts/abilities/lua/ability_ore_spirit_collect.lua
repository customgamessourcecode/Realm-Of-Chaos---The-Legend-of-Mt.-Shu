ability_ore_spirit_collect = class({})

local public = ability_ore_spirit_collect
ability_ore_spirit_collect_lv1 = public
ability_ore_spirit_collect_lv2 = public
ability_ore_spirit_collect_lv3 = public
ability_ore_spirit_collect_lv4 = public
ability_ore_spirit_collect_lv5 = public

function public:OnSpellStart()
	CollectOreSystem:SetOreUnit( self:GetCaster(), self:GetCursorTarget() )
end

-- if IsClient() then
-- 	require("config.collect_ore_config")
-- end

-- --------------------------------------------------------------------------------

-- function public:OnSpellStart()
-- 	if self:GetCaster():GetOwner():IsFate("wakuangzongshi") then
-- 		CustomNetTables:SetTableValue("Abilities", "ability_ore_spirit_collect_"..tostring(self:GetCaster():GetEntityIndex()),  {channel_time=0.5})
-- 	else
-- 		CustomNetTables:SetTableValue("Abilities", "ability_ore_spirit_collect_"..tostring(self:GetCaster():GetEntityIndex()),  {channel_time=1})
-- 	end
	
-- 	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.5)
-- 	self:GetCaster():EmitSound("CollectOreSystem.CollectOres")
-- 	self.__channel_think_time = 0

-- 	local target = self:GetCursorTarget()
-- 	self.__current_target = target
-- 	target.__has_spirit_collecting = true
-- end

-- --------------------------------------------------------------------------------

-- function public:OnChannelThink(flInterval)
-- 	self.__channel_think_time = self.__channel_think_time + flInterval
-- 	if self.__channel_think_time >= 0.5 then
-- 		self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.5)
-- 		self:GetCaster():EmitSound("CollectOreSystem.CollectOres")
-- 		self.__channel_think_time = 0
-- 	end
-- end

-- --------------------------------------------------------------------------------

-- function public:OnChannelFinish(bInterrupted)
-- 	local target = self:GetCursorTarget() or self.__current_target
-- 	target.__has_spirit_collecting = false

-- 	if bInterrupted then
-- 		self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
-- 		return
-- 	end
	
-- 	local caster = self:GetCaster()
-- 	local points = target.__collect_ore_system_points
-- 	if points == nil or points <= 0 then return caster:Stop() end

-- 	local target_unitname = target:GetUnitName()
-- 	local caster_collect_data = caster.__collect_ore_system_collect_data
-- 	if caster_collect_data == nil then
-- 		caster_collect_data = {}
-- 		caster.__collect_ore_system_collect_data = caster_collect_data
-- 	end
-- 	if caster_collect_data[target_unitname] == nil then
-- 		caster_collect_data[target_unitname] = 0
-- 	end

-- 	local collect_speed = self:GetSpecialValueFor("collect_speed")
-- 	local name = self:GetName()

-- 	if points <= collect_speed then
-- 		target.__collect_ore_system_points = 0
-- 		CollectOreSystem:RespawnFakeOreUnit(target)
-- 		CollectOreSystem:AddExp(caster:GetOwner(), points)
-- 		caster:RemoveGesture(ACT_DOTA_ATTACK)
-- 		caster_collect_data[target_unitname] = caster_collect_data[target_unitname] + points

-- 		self:AutoCastNextTarget(caster, target, false, CollectOreSystem:UpgradeAbility(caster:GetOwner()), name)
-- 	else
-- 		target.__collect_ore_system_points = points - collect_speed
-- 		CollectOreSystem:AddExp(caster:GetOwner(), collect_speed)
-- 		caster_collect_data[target_unitname] = caster_collect_data[target_unitname] + collect_speed

-- 		self:AutoCastNextTarget(caster, target, true, CollectOreSystem:UpgradeAbility(caster:GetOwner()), name)
-- 	end

-- 	if caster_collect_data[target_unitname] >= target.__collect_ore_system_max_points then
-- 		caster_collect_data[target_unitname] = 0
-- 		CollectOreSystem:DropItems( caster:GetOwner(), target )
-- 	end

-- 	CollectOreSystem.__all_ores_points[target:GetEntityIndex()] = target.__collect_ore_system_points
-- 	CustomNetTables:SetTableValue("Common", "CollectOreSystem_AllOresPoints", CollectOreSystem.__all_ores_points )
-- 	CollectOreSystem:UpdateExp(caster:GetOwner())
-- end

-- --------------------------------------------------------------------------------

-- function public:AutoCastNextTarget(caster, target, bIsContinue, bIsNewAbility, abilityName)
-- 	local ability

-- 	if bIsNewAbility then
-- 		for i=1,5 do
-- 			ability = caster:FindAbilityByName("ability_ore_spirit_collect_lv"..i)
-- 			if ability then break end
-- 		end
-- 	else
-- 		ability = self
-- 	end

-- 	if ability == nil or ability:IsNull() then return end

-- 	if bIsContinue then
-- 		caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
-- 	else
-- 		-- local newOre,len = nil,0
-- 		-- local str = string.match(abilityName,".*_lv(%d+)") or "1"
-- 		-- local level = tonumber(str)

-- 		-- for i,v in ipairs(CollectOreSystem.__all_ores) do
-- 		-- 	if v ~= target and v.__collect_ore_system_points > 0 then
-- 		-- 		local data = CollectOreFakeUnitConfig[v:GetUnitName()]
-- 		-- 		if (newOre == nil) or (level >= data["Level"] and (v:GetOrigin() - caster:GetOrigin()):Length2D() < len) then
-- 		-- 			newOre = v
-- 		-- 			len = (v:GetOrigin() - caster:GetOrigin()):Length2D()
-- 		-- 		end
-- 		-- 	end
-- 		-- end
-- 		-- caster:CastAbilityOnTarget(newOre, ability, caster:GetPlayerOwnerID())
-- 		caster:GetAbilityByIndex(0):CastAbility()
-- 	end
-- end

-- --------------------------------------------------------------------------------

-- function public:GetChannelTime()
-- 	return CustomNetTables:GetTableValue("Abilities", "ability_ore_spirit_collect_"..tostring(self:GetCaster():GetEntityIndex())).channel_time or 1
-- end

-- --------------------------------------------------------------------------------

-- function public:CastFilterResultTarget( hTarget )
-- 	local tableData = CustomNetTables:GetTableValue("Common", "CollectOreSystem_AllOresPoints")
-- 	if tableData == nil then 
-- 		return UF_FAIL_DEAD
-- 	end
-- 	local points = tableData[tostring(hTarget:GetEntityIndex())] or 0
-- 	if points <= 0 then
-- 		return UF_FAIL_DEAD
-- 	end
-- 	if string.find(hTarget:GetUnitName(),"npc_fake_ore_") == 1 then
-- 		local str = string.match(self:GetName(),".*_lv(%d+)") or "1"
-- 		local level = tonumber(str)
-- 		if level >= CollectOreFakeUnitConfig[hTarget:GetUnitName()].Level then
-- 			return UF_SUCCESS
-- 		end
-- 		return UF_FAIL_OTHER
-- 	end
-- 	return UF_FAIL_OTHER
-- end

-- --------------------------------------------------------------------------------