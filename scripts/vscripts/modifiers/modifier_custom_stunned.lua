
modifier_custom_stunned = class({})

local public = modifier_custom_stunned

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

function public:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function public:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function public:CheckState()
	return m_modifier_states
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
	}
end

--------------------------------------------------------------------------------

function public:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function public:GetOverrideAnimationWeight()
	return 2
end

--------------------------------------------------------------------------------