creature_08_boss_ability02 = class({})
LinkLuaModifier("modifier_creature_08_boss_ability02","modifiers/abilities/modifier_creature_08_boss_ability02",LUA_MODIFIER_MOTION_NONE)

local public = creature_08_boss_ability02

function public:OnSpellStart()
	local caster = self:GetCaster()

	-- 眩晕
	caster:AddNewModifier(caster, nil, "modifier_creature_08_boss_ability02", {duration=60})
    caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")

    self.__this_target = self:GetCursorTarget()
    self.__this_name = DoUniqueString("creature_08_boss_ability02")

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
    caster:RemoveModifierByName("modifier_creature_08_boss_ability02")
    
	if hTarget then

        ApplyDamage({
            attacker = caster,
            victim = hTarget,
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
        })

        local path = "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf"
        local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
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
    caster:RemoveModifierByName("modifier_creature_08_boss_ability02")
end

function public:GetCastRange()
    return 1000
end