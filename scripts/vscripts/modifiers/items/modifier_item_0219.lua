modifier_item_0219 = class({})

local public = modifier_item_0219

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
	return 'item_0219'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierMoveSpeedBonus_Percentage()
	return 5
end

--------------------------------------------------------------------------------