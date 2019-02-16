modifier_item_suit_hanxue = class({})

local public = modifier_item_suit_hanxue

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
	return 'item_0578'
end

--------------------------------------------------------------------------------

function public:CheckChance()
	return RandomFloat(0, 100) <= 15
end

--------------------------------------------------------------------------------