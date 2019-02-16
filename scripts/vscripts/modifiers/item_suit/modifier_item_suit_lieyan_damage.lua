modifier_item_suit_lieyan_damage = class({})

local public = modifier_item_suit_lieyan_damage

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
	return 'item_0194'
end

--------------------------------------------------------------------------------

function public:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		UnitDamageTarget({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage_percent = 0.2
		})
	end
end

--------------------------------------------------------------------------------