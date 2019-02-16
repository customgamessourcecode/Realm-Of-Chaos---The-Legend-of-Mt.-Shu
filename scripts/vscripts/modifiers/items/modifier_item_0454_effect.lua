modifier_item_0454_effect = class({})

local public = modifier_item_0454_effect

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
	return 'item_0454'
end

--------------------------------------------------------------------------------

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

-- 力量
function public:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

-- 敏捷
function public:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

-- 智力
function public:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)
	end
end

--------------------------------------------------------------------------------

function public:OnRefresh( kv )
	if IsServer() then
		if self:GetStackCount() >= 200 then return end
		self:SetStackCount(self:GetStackCount()+1)
	end
end

--------------------------------------------------------------------------------