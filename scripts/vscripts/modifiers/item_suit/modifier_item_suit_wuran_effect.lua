modifier_item_suit_wuran_effect = class({})

local public = modifier_item_suit_wuran_effect

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

function public:GetTexture()
	return 'item_0374'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierEvasion_Constant()
	return 200
end

--------------------------------------------------------------------------------