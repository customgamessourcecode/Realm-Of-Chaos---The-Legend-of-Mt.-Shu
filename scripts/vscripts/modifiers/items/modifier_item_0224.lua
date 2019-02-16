modifier_item_0224 = class({})

local public = modifier_item_0224

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
	return 'item_0224'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierManaBonus()
	return 1000
end

--------------------------------------------------------------------------------