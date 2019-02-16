modifier_item_suit_buluominghe = class({})

local public = modifier_item_suit_buluominghe

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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'item_0549'
end

--------------------------------------------------------------------------------