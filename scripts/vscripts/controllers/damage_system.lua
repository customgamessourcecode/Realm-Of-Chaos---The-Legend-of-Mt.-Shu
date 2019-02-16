
if DamageSystem == nil then
	DamageSystem = RegisterController('damage_system')
	setmetatable(DamageSystem,DamageSystem)
end

local public = DamageSystem

-- 获取伤害
function public:GetDamage(damage_table)
	local attacker = damage_table.attacker
	if attacker:IsIllusion() then
		attacker = attacker.shushan_illusion_ownner
	end
	local damage = shushan_GetBaseDamage(damage_table.ability) or 0

	local weaponValue = attacker:GetCustomAttribute(shushan_GetWeaponType(attacker, damage_table.ability).."_coefficient",0)
	local weaponDamageValue = attacker:GetCustomAttribute(shushan_GetWeaponDamageType(attacker, damage_table.ability).."_damage",0)
	local attributeValue = shushan_GetAttribute(attacker,damage_table.ability)
	local practiceValue = attacker:GetCustomAttribute(shushan_GetPracticeType(attacker, damage_table.ability),0)
	local state = attacker:GetCustomAttribute("state",0)
	local level = attacker:GetLevel()
	local damagePecent = damage_table.damage_percent or 1

	damage = shushan_GetBaseDamage(damage_table.ability)*(1+attributeValue/1000)*(1+weaponValue/100)*(1+weaponDamageValue/200)*(1+state/10)*(1+level/100)*(1+practiceValue/100)*damagePecent*shushan_GetDamageIncrease(damage_table)

	return damage
end

-- 造成伤害
function public:Take(damage_table)
	damage_table.inflictor = damage_table.ability
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.damage = self:GetDamage(damage_table)

	ApplyDamage(damage_table)
end

-- 造成范围伤害
function public:TakeInRadius(damage_table)

	local entities
	local owner = damage_table.attacker

	if damage_table.entities == nil then
		iTeamFilter = damage_table.iTeamFilter or DOTA_UNIT_TARGET_TEAM_ENEMY
		iTypeFilter = damage_table.iTypeFilter or DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
		iFlagFilter = damage_table.iFlagFilter or DOTA_UNIT_TARGET_FLAG_NONE
		iOrder = damage_table.iOrder or FIND_UNITS_EVERYWHERE
		entities = FindUnitsInRadius(owner:GetTeam(), damage_table.pos, nil, damage_table.radius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
	else
		entities = damage_table.entities
	end

	for i,unit in ipairs(entities) do
		self:Take({
			attacker = owner,
			victim = unit,
			ability = damage_table.ability,
			damage_percent = damage_table.damage_percent,
			damage_increase = damage_table.damage_increase,
		})
	end
end

--[[
造成伤害
]]
function UnitDamageTarget(damage_table)
	if damage_table.attacker~=nil and damage_table.attacker:IsNull()==false and damage_table.victim~=nil and damage_table.victim:IsNull()==false then
		public:Take(damage_table)
	end
end

--[[
造成伤害
]]
function UnitDamageTargetSimple(attacker,victim,ability,damage_percent)
	local damage_table = {
		victim = victim,
		attacker = attacker,
		ability = ability,
		damage_percent = damage_percent,
	}
	UnitDamageTarget(damage_table)
end

--[[
获取技能的武器类型
]]
function shushan_GetWeaponType(caster, ability)
	if ability == nil then
		return shushan_default_weapon_type[caster:GetUnitName()]
	end
	return shushan_ability_table[ability:GetAbilityName()]["weaponType"]
end

--[[
获取技能的武器伤害类型
]]
function shushan_GetWeaponDamageType(caster, ability)
	if ability == nil then
		return shushan_default_weapon_damage_type[caster:GetUnitName()]
	end
	return shushan_ability_table[ability:GetAbilityName()]["weaponDamageType"]
end

--[[
获取技能的主属性类型
]]
function shushan_GetAttributeType(caster, ability)
	if ability == nil then
		if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
			return "str"
		elseif caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
			return "agi"
		elseif caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
			return "int"
		end
	end
	return shushan_ability_table[ability:GetAbilityName()]["attributeType"]
end

--[[
获取主属性
]]
function shushan_GetAttribute(caster,ability)
	local attributeType = shushan_GetAttributeType(caster, ability)
	if attributeType == "str" then
		return caster:GetStrength()
	elseif attributeType == "agi" then
		return caster:GetAgility()
	elseif attributeType == "int" then
		return caster:GetIntellect()
	end
	return 0
end

--[[
获取
]]
function shushan_GetPracticeType(caster, ability)
	if ability == nil then
		return shushan_default_practice_type[caster:GetUnitName()]
	end
	return shushan_ability_table[ability:GetAbilityName()]["practiceType"]
end

--[[
获取基础伤害
]]
function shushan_GetBaseDamage(ability)
	if ability == nil then
		return 100
	end
	return shushan_ability_table[ability:GetAbilityName()]["baseDamage"]
end

--[[
获取伤害系数
]]
function shushan_GetDamageIncrease(damage_table)
	if damage_table.damage_increase ~= nil then
		return damage_table.damage_increase
	end
	if damage_table.ability == nil then
		return 1.0
	end
	return shushan_ability_table[damage_table.ability:GetAbilityName()]["damageIncrease"]
end