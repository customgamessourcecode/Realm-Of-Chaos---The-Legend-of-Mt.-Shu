
modifier_custom_invisible = class({})

local public = modifier_custom_invisible

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

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierInvisibilityLevel()
	return 1
end

--------------------------------------------------------------------------------

function public:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = not self:GetParent():HasModifier("modifier_shushan_fb_unit_common_to_enemy"),
	}

	return state
end

--------------------------------------------------------------------------------