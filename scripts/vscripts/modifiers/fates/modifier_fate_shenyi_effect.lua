
modifier_fate_shenyi_effect = class({})

local public = modifier_fate_shenyi_effect

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
	return 'keeper_of_the_light_illuminate'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

--------------------------------------------------------------------------------

-- 伤害吸收
function public:GetModifierHealthRegenPercentage()
	return 5
end

--------------------------------------------------------------------------------