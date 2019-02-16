fb_19_boss_dihen_ability03 = class({})

local public = fb_19_boss_dihen_ability03

function public:OnSpellStart()
	local caster = self:GetCaster()
    local origin = GetGroundPosition(caster:GetOrigin(), caster)
    local face = caster:GetForwardVector()
    face.z = 0
    local point = origin + face*550

    caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=4})

    local times = 0
    local name = DoUniqueString("fb_19_boss_dihen_ability03")
    local radius = self:GetSpecialValueFor("radius")
    local angle = 360/32

    Timer("fb_19_boss_dihen_ability03_think", caster, 0, function ()

    	for i=1,32 do
    		local pos = RotatePosition(origin, QAngle(0,angle*i,0), point)
       		local f = (pos-origin):Normalized()
       		f.z = 0

       		local info = 
	        {
	            Ability = self,
	            EffectName = "particles/avalon/abilities/fb_19_boss_dihen/fb_19_boss_dihen_ability03_master.vpcf",
	            vSpawnOrigin = origin,
	            fDistance = radius,
	            fStartRadius = 64,
	            fEndRadius = 128,
	            Source = caster,
	            bHasFrontalCone = false,
	            bReplaceExisting = false,
	            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            fExpireTime = GameRules:GetGameTime() + 3.0,
	            vVelocity = f * 500,
	            bProvidesVision = true,
	            iVisionRadius = 500,
	            iVisionTeamNumber = caster:GetTeamNumber(),
	            ExtraData = {name=name}
	        }
	        ProjectileManager:CreateLinearProjectile(info)
    	end

        times = times + 1
        name = DoUniqueString("fb_19_boss_dihen_ability03")

        if times >= self:GetSpecialValueFor("max_times") then
            caster:RemoveModifierByName("modifier_custom_stun")
            return nil
        end

        return 1
    end)
end

function public:OnProjectileHit_ExtraData(hTarget, vLocation, data)
	if hTarget then
        local caster = self:GetCaster()

        if hTarget.__fb_19_boss_dihen_ability03_name == data.name then
            return
        end

        hTarget.__fb_19_boss_dihen_ability03_name = data.name

        hTarget:AddNewModifier(caster, nil, "modifier_stunned", {duration=self:GetSpecialValueFor("stun_duration")})
        ApplyDamage({
            attacker = caster,
            victim = hTarget,
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
        })

	end
end