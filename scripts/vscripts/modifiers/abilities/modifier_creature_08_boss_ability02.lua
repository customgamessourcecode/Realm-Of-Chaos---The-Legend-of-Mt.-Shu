
modifier_creature_08_boss_ability02 = class({})

local public = modifier_creature_08_boss_ability02

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
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local path = "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
		local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(p, 0, caster, 5, "attach_hitloc", caster:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(p, 1, caster, 5, "attach_hitloc", caster:GetOrigin(), true)

		self.__particle = p
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy( kv )
	if IsServer() then
		ParticleManager:DestroyParticle(self.__particle, false)
	end
end

--------------------------------------------------------------------------------