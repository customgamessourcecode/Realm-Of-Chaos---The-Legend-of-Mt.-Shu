
modifier_invisible_level = class({})

local public = modifier_invisible_level

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

function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
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