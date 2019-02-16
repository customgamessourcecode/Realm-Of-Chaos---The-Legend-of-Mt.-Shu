ability_shushan_huankong011 = class({})

local public = ability_shushan_huankong011

function public:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local endPoint = self:GetCursorPosition()
	local face = (endPoint - origin):Normalized()
	face.z = 0

	local len = (origin - endPoint):Length2D()
	if len <= 100 then
		endPoint = origin + face*100
	end

	self.__is_traversable = GridNav:CanFindPath(origin,endPoint)

	-- 残影特效
	local p = ParticleManager:CreateParticle("particles/avalon/abilities/ability_shushan_huankong011/ability_shushan_huankong011.vpcf", 
											PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(p, 0, caster, 5, "follow_origin", caster:GetOrigin(), true)
	ParticleManager:DestroyParticleSystem(p)

	local path = shushan_GetEffectName(caster,"ability_shushan_huankong014_end")
	local p3 = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p3, 0, origin)
	ParticleManager:SetParticleControl(p3, 1, endPoint)
	ParticleManager:DestroyParticleSystem(p3)

	-- 眩晕
	caster:AddNewModifier(caster, nil, "modifier_custom_stun2", {duration=1})
	caster:EmitSound("ShuShanAbility.HuanKong.A011")

	local info = 
    {
        Ability = self,
        EffectName = "",
        vSpawnOrigin = origin,
        fDistance = len,
        fStartRadius = 200,
        fEndRadius = 200,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = face * 3500,
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    self.__projectile = ProjectileManager:CreateLinearProjectile(info)
end

function public:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		UnitStunTarget( self:GetCaster(), hTarget, self:GetLevelSpecialValueFor("stun_duration", self:GetLevel()) )
		local damage_table = {
			victim = hTarget,
			attacker = self:GetCaster(),
			ability = self,
		}
		UnitDamageTarget(damage_table)
	else
		self:GetCaster():RemoveModifierByName("modifier_custom_stun2")
		FindClearSpaceForUnit(self:GetCaster(), vLocation, true)
	end
end

function public:OnProjectileThink(vLocation)
	local caster = self:GetCaster()
	if (not self.__is_traversable) and (GridNav:IsBlocked(vLocation) or not GridNav:IsTraversable(vLocation)) then
		self:GetCaster():RemoveModifierByName("modifier_custom_stun2")
		ProjectileManager:DestroyLinearProjectile(self.__projectile)
		FindClearSpaceForUnit(self:GetCaster(), vLocation, true)
		return
	end
	caster:SetOrigin(GetGroundPosition(vLocation, caster))
end