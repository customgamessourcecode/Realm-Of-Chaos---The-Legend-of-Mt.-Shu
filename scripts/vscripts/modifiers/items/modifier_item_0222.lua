modifier_item_0222 = class({})

local public = modifier_item_0222

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
	return 'item_0222'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierHealthBonus()
	return 3000
end

--------------------------------------------------------------------------------