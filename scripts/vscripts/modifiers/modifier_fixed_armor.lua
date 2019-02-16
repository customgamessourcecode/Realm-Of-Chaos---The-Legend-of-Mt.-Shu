
modifier_fixed_armor = class({})

local public = modifier_fixed_armor

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
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:GetModifierPhysicalArmorBonus()
	return self.__fixedArmor or 0
end

--------------------------------------------------------------------------------

function public:OnCreated()
	self:FixedArmor()
end

function public:FixedArmor()
	local armor = self:GetParent():GetPhysicalArmorValue()
	local old = (0.06 * armor) / (1 + 0.06 * armor)
	local fixed = (0.9 * old) / (0.052 - 0.048 * old)
	self.__fixedArmor = fixed - armor
end