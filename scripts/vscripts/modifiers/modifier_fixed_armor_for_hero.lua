
modifier_fixed_armor_for_hero = class({})

local public = modifier_fixed_armor_for_hero

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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function public:OnAttackLanded()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_fixed_armor", {duration=1} )
	end
end