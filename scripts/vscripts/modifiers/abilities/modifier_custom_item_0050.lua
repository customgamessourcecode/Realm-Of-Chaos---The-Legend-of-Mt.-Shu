
modifier_custom_item_0050 = class({})

local public = modifier_custom_item_0050

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
	return 'item_0050'
end

--------------------------------------------------------------------------------

function public:OnCreated()
	self.__percent = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierIncomingDamage_Percentage()
	return self.__percent
end