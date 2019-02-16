modifier_item_suit_lishang_effect = class({})

local public = modifier_item_suit_lishang_effect

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
	return 'item_0544'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_TotalDamageOutgoing
end

--------------------------------------------------------------------------------

function public:GetModifierTotalDamageOutgoing_Percentage()
	return 20
end

--------------------------------------------------------------------------------