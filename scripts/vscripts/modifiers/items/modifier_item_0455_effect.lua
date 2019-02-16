modifier_item_0455_effect = class({})

local public = modifier_item_0455_effect

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
	return 'item_0455'
end

--------------------------------------------------------------------------------

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)
		self:GetCaster():SetCustomAttribute("merits","modifier_item_0455_effect",1)
	end
end

--------------------------------------------------------------------------------

function public:OnRefresh( kv )
	if IsServer() then
		if self:GetStackCount() >= 200 then return end
		self:SetStackCount(self:GetStackCount()+1)
		self:GetCaster():SetCustomAttribute("merits","modifier_item_0455_effect",self:GetStackCount())
	end
end

--------------------------------------------------------------------------------