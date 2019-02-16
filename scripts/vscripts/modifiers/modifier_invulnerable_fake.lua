
modifier_invulnerable_fake = class({})

local public = modifier_invulnerable_fake

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
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierIncomingDamage_Percentage()
	return -10000
end

--------------------------------------------------------------------------------

function public:GetAbsoluteNoDamagePhysical()
	return 1
end

--------------------------------------------------------------------------------

function public:GetAbsoluteNoDamageMagical()
	return 1
end

--------------------------------------------------------------------------------

function public:GetAbsoluteNoDamagePure()
	return 1
end

--------------------------------------------------------------------------------