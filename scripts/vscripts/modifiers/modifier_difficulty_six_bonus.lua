modifier_difficulty_six_bonus = class({})

local public = modifier_difficulty_six_bonus

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

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_AttackSpeedBonus
end

--------------------------------------------------------------------------------

function public:GetModifierAttackSpeedBonus_Constant()
	return 50
end

--------------------------------------------------------------------------------