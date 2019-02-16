modifier_qwd = class({})

local public = modifier_qwd

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

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnAttackStart(keys)
	if IsServer() then
		if keys.target == self:GetCaster() then
			keys.attacker:ForceKill(true)
		end
	end
end