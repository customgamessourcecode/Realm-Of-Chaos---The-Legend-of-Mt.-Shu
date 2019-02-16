modifier_item_0227_effect = class({})

local public = modifier_item_0227_effect

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

function public:GetTexture()
	return 'item_0227'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierDamageOutgoing_Percentage()
	return -5
end

--------------------------------------------------------------------------------