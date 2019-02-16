modifier_item_suit_wuzu = class({})

local public = modifier_item_suit_wuzu

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
	return 'item_0236'
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	self:StartIntervalThink(1)
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetHealthPercent() >= 100 then return end
		caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth()*0.1)
	end
end

--------------------------------------------------------------------------------