modifier_item_0217 = class({})

local public = modifier_item_0217

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

function public:OnCreated( kv )
	if IsServer() then
		-- self:GetCaster():SetCustomAttribute('','modifier_item_0217',v)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy( kv )
	if IsServer() then
		-- self:GetCaster():SetCustomAttribute('','modifier_item_0217',0)
	end
end

--------------------------------------------------------------------------------