creature_20_boss_ability03 = class({})

local public = creature_20_boss_ability03

function public:OnSpellStart()
	local caster = self:GetCaster()

	-- 眩晕
	caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=60})
    caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")

    self.__this_target = self:GetCursorTarget()
    self.__this_name = DoUniqueString("creature_20_boss_ability03")

	local info = 
    {
        Target = self:GetCursorTarget(),
        Source = caster,
        Ability = self,  
        EffectName = "",
        bDodgeable = false,
        iMoveSpeed = self:GetSpecialValueFor("speed"),
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber(),
        ExtraData = {name=self.__this_name}
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function public:OnProjectileHit_ExtraData(hTarget, vLocation, data)
    if data.name ~= self.__this_name then return end

    local caster = self:GetCaster()
    FindClearSpaceForUnit(caster, vLocation, true)
    caster:RemoveModifierByName("modifier_custom_stun")

	if hTarget then
        hTarget:Kill(self, caster)
        caster:Heal(caster:GetMaxHealth()*(self:GetSpecialValueFor("heal_pct")/100), caster)

        local path = "particles/heroes/moluo/ability_moluo01_explosion_vip.vpcf"
        local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
        ParticleManager:SetParticleControl(p, 1, hTarget:GetOrigin())
        ParticleManager:SetParticleControl(p, 2, hTarget:GetOrigin())
        ParticleManager:SetParticleControl(p, 3, hTarget:GetOrigin())
        ParticleManager:SetParticleControl(p, 4, hTarget:GetOrigin())
        ParticleManager:SetParticleControl(p, 5, hTarget:GetOrigin())
        ParticleManager:SetParticleControl(p, 10, hTarget:GetOrigin())
        ParticleManager:DestroyParticleSystem(p)
	end
end

function public:OnProjectileThink_ExtraData(vLocation, data)
	local caster = self:GetCaster()
    if data.name == self.__this_name and (caster:GetOrigin() - self.__this_target:GetOrigin()):Length2D() <= 2000 then
        caster:SetOrigin(GetGroundPosition(vLocation, caster))
        return
    end

    self.__this_name = nil
    caster:RemoveModifierByName("modifier_custom_stun")
end

function public:GetCastRange()
    return 1000
end