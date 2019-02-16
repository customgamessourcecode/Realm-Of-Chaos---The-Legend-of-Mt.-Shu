
modifier_fushuizhifeng_kill_reward = class({})

local public = modifier_fushuizhifeng_kill_reward

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
}

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'phoenix_fire_spirits'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return m_modifier_funcs
end

--------------------------------------------------------------------------------

function public:GetModifierHealthBonus()
	return 20000
end

--------------------------------------------------------------------------------

function public:GetModifierPhysicalArmorBonus()
	return 100
end

--------------------------------------------------------------------------------

function public:GetModifierTotalDamageOutgoing_Percentage()
	return 20
end

--------------------------------------------------------------------------------