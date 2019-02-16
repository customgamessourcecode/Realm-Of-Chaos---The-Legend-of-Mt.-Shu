modifier_item_suit_poyu_effect = class({})

local public = modifier_item_suit_poyu_effect

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
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

-- 护甲加成
function public:GetModifierPhysicalArmorBonus()
	return -50
end

--------------------------------------------------------------------------------