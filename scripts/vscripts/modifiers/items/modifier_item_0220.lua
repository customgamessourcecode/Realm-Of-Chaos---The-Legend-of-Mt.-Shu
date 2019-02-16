modifier_item_0220 = class({})

local public = modifier_item_0220

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
	return 'item_0220'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierAttackSpeedBonus_Constant()
	return 50
end

--------------------------------------------------------------------------------