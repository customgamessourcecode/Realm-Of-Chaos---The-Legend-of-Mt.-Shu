modifier_item_suit_jihan_for_enemy = class({})

local public = modifier_item_suit_jihan_for_enemy

--------------------------------------------------------------------------------

function public:IsDebuff()
	return true
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

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

-- 护甲加成
function public:GetModifierAttackSpeedBonus_Constant()
	return -20
end

--------------------------------------------------------------------------------