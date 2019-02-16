
modifier_fate_qingqiushanhouren = class({})

local public = modifier_fate_qingqiushanhouren

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
	return 'ancient_apparition_cold_feet'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_MoveSpeedPercentage
end

--------------------------------------------------------------------------------

function public:GetModifierMoveSpeedBonus_Percentage()
	return 30
end