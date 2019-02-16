
modifier_fate_xunshoushi_ling_lang = class({})

local public = modifier_fate_xunshoushi_ling_lang

local m_modifier_states = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}

local m_modifier_funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:CheckState()
	return m_modifier_states
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return m_modifier_funcs
end

--------------------------------------------------------------------------------

-- 最大移动速度
function public:GetModifierMoveSpeed_Max()
	return 10000
end

--------------------------------------------------------------------------------

-- 攻击速度加成
function public:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetIncreasedAttackSpeed()*100
end

--------------------------------------------------------------------------------

-- 攻击距离
function public:GetModifierAttackRangeBonus()
	return (self:GetParent():GetModelScale()-0.6)*100
end