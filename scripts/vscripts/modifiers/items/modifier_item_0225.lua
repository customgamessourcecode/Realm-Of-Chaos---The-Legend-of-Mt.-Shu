modifier_item_0225 = class({})

local public = modifier_item_0225

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
	return 'item_0225'
end

--------------------------------------------------------------------------------


function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierTotalDamageOutgoing_Percentage()
	return 3
end

--------------------------------------------------------------------------------