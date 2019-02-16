modifier_item_suit_jiuli = class({})

local public = modifier_item_suit_jiuli

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
	return 'item_0567'
end

--------------------------------------------------------------------------------

function public:OnCreated()
	if IsServer() then
		self:SetStackCount(self:GetCustomDamageBounsCount())
	end
end

--------------------------------------------------------------------------------

function public:GetCustomDamageBounsCount()
	return math.floor((1-self:GetCaster():GetHealth()/self:GetCaster():GetMaxHealth())*100)
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnTakeDamage(keys)
	if IsServer() then
		local target = keys.target or keys.unit

		-- 攻击敌人
		if target == self:GetCaster() and attacker ~= self:GetCaster() then
			self:SetStackCount(self:GetCustomDamageBounsCount())
		end
	end
end

--------------------------------------------------------------------------------

function public:GetModifierTotalDamageOutgoing_Percentage()
	return 0.3*self:GetStackCount()
end

--------------------------------------------------------------------------------