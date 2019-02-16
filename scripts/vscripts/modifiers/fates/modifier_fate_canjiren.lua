
modifier_fate_canjiren = class({})

local public = modifier_fate_canjiren

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
	return 'sven_gods_strength'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_IncomingDamage
end

--------------------------------------------------------------------------------

-- 伤害吸收
function public:GetModifierIncomingDamage_Percentage()
	return -15
end

--------------------------------------------------------------------------------