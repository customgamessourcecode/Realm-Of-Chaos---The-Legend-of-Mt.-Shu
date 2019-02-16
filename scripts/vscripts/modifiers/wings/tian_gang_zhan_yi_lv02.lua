
tian_gang_zhan_yi_lv02 = class({})

local public = tian_gang_zhan_yi_lv02

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

function public:CheckChance()
	return RandomFloat(0, 100) <= 5
end

--------------------------------------------------------------------------------