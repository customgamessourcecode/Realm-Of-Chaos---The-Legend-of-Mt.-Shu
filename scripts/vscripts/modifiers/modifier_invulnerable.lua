
modifier_invulnerable = class({})

local public = modifier_invulnerable

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
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end