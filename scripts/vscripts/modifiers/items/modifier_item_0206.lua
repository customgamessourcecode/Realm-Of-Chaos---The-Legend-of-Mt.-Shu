modifier_item_0206 = class({})

local public = modifier_item_0206

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
		-- self:GetCaster():SetCustomAttribute('','modifier_item_0206',v)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy( kv )
	if IsServer() then
		-- self:GetCaster():SetCustomAttribute('','modifier_item_0206',0)
	end
end

--------------------------------------------------------------------------------