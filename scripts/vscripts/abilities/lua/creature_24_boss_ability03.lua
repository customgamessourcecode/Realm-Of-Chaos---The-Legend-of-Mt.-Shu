creature_24_boss_ability03 = class({})

local public = creature_24_boss_ability03

function public:OnSpellStart()
	local caster = self:GetCaster()
    local origin = caster:GetOrigin()
    local face = caster:GetForwardVector()
    face.z = 0
    local point = origin + face*550
    point.z = point.z + 200

    local stick = CreateUnitByName("shushan_wave_24_stick", point, true, nil, nil, caster:GetTeam())
    stick:AddNewModifier(caster, nil, "modifier_invulnerable", nil)

    caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=4})

    local angle = 10
    local times = 0
    local angleVec = QAngle(0,0,0)
    local name = DoUniqueString("creature_24_boss_ability03")
    local radius = self:GetSpecialValueFor("radius")

    Timer("creature_24_boss_ability03_think", caster, 0, function ()

        angleVec.y = angleVec.y + angle
        local pos = RotatePosition(origin, angleVec, point)
        local f = (origin-pos):Normalized()
        f.z = 0
        stick:SetOrigin(pos)
        stick:SetForwardVector(f)

        local info = 
        {
            Ability = self,
            EffectName = "",
            vSpawnOrigin = origin,
            fDistance = radius,
            fStartRadius = 256,
            fEndRadius = 256,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 3.0,
            vVelocity = -f * 10000,
            bProvidesVision = true,
            iVisionRadius = 500,
            iVisionTeamNumber = caster:GetTeamNumber(),
            ExtraData = {name=name}
        }
        ProjectileManager:CreateLinearProjectile(info)

        if angleVec.y >= 360 then
            angleVec.y = 0
            times = times + 1
            name = DoUniqueString("creature_24_boss_ability03")

            if times >= self:GetSpecialValueFor("max_times") then
                stick:RemoveSelf()
                caster:RemoveModifierByName("modifier_custom_stun")
                return nil
            end
        end

        return FrameTime()
    end)
end

function public:OnProjectileHit_ExtraData(hTarget, vLocation, data)
	if hTarget then
        local caster = self:GetCaster()

        if hTarget.__creature_24_boss_ability03_name == data.name then
            return
        end

        hTarget.__creature_24_boss_ability03_name = data.name

        hTarget:AddNewModifier(caster, nil, "modifier_stunned", {duration=self:GetSpecialValueFor("stun_duration")})
        ApplyDamage({
            attacker = caster,
            victim = hTarget,
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
        })

	end
end