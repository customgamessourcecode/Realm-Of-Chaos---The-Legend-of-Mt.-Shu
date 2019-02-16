modifier_item_0223 = class({})

local public = modifier_item_0223

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
	return 'item_0223'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierPreAttack_BonusDamage()
	return 500
end

--------------------------------------------------------------------------------