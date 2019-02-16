
modifier_fate_shenyi_aura = class({})

local public = modifier_fate_shenyi_aura

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

function public:IsAura()
	return true
end

--------------------------------------------------------------------------------

function public:GetModifierAura()
	return "modifier_fate_shenyi_effect"
end

--------------------------------------------------------------------------------

function public:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function public:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function public:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function public:GetAuraRadius()
	return 1000
end

--------------------------------------------------------------------------------

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------