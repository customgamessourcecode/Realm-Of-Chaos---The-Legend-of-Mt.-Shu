
tian_gang_zhan_yi_lv03 = class({})

local public = tian_gang_zhan_yi_lv03

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
	return RandomFloat(0, 100) <= 10
end

--------------------------------------------------------------------------------