
modifier_custom_item_0022 = class({})

local public = modifier_custom_item_0022

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
	return 'item_0022'
end

--------------------------------------------------------------------------------

function public:OnCreated()
	self.__heal_percent = self:GetAbility():GetSpecialValueFor("heal_percent")
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierHealthRegenPercentage()
	return self.__heal_percent
end