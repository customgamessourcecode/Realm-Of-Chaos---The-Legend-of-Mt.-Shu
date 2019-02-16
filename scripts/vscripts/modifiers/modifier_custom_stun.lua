
modifier_custom_stun = class({})

local public = modifier_custom_stun

local m_modifier_states = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true,
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