modifier_item_suit_wuxie = class({})

local public = modifier_item_suit_wuxie

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
	return 'item_0560'
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		caster:Heal(caster:GetMaxHealth()*0.15, nil)
	end
end

--------------------------------------------------------------------------------