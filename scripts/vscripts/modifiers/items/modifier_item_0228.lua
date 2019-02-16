modifier_item_0228 = class({})

local public = modifier_item_0228

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
	return 'item_0228'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierIncomingDamage_Percentage()
	return -3
end

--------------------------------------------------------------------------------