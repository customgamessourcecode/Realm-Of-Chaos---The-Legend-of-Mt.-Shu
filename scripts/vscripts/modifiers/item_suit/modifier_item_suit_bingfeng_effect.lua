modifier_item_suit_bingfeng_effect = class({})

local public = modifier_item_suit_bingfeng_effect

--------------------------------------------------------------------------------

function public:IsDebuff()
	return true
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
	return 'item_0192'
end

--------------------------------------------------------------------------------

function public:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

--------------------------------------------------------------------------------

function public:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end

--------------------------------------------------------------------------------

function public:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		UnitDamageTarget({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
		})
	end
end

--------------------------------------------------------------------------------

function public:OnRefresh( kv )
	if IsServer() then
		UnitDamageTarget({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
		})
	end
end

--------------------------------------------------------------------------------