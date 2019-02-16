
modifier_no_draw = class({})

local public = modifier_no_draw

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

function public:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		self:GetCaster():AddNoDraw()
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy( kv )
	if IsServer() then
		self:GetCaster():RemoveNoDraw()
	end
end

--------------------------------------------------------------------------------