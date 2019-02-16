creature_16_boss_ability03 = class({})

local public = creature_16_boss_ability03

function public:OnSpellStart()
	local caster = self:GetCaster()
	local casterOrigin = caster:GetOrigin()
	local maxTimes = self:GetSpecialValueFor("max_times")
	local times = 0
	local face = caster:GetForwardVector()
	face.z = 0

	Timer(DoUniqueString("Creature16BOSS_Ability03_Start"), caster, function ()
		times = times + 1

		local origin = casterOrigin + RandomVector(RandomFloat(0, self:GetSpecialValueFor("radius")))

		local count = self:GetSpecialValueFor("count")
		local angle = 360/count
		local distance = self:GetSpecialValueFor("distance")
		local speed = self:GetSpecialValueFor("speed")
		local point = origin + face*distance
		local name = DoUniqueString("Creature16BOSS_Ability03_Linear")

		for i=1,count do
			local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

			local info = 
		    {
		        Ability = self,
		        EffectName = "particles/avalon/abilities/creature_16_boss/ability01/creature_16_boss_ability01.vpcf",
		        vSpawnOrigin = origin,
		        fDistance = distance,
		        fStartRadius = 256,
		        fEndRadius = 256,
		        Source = caster,
		        bHasFrontalCone = false,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 10.0,
		        vVelocity = (p-origin):Normalized() * speed,
		        bProvidesVision = true,
		        iVisionRadius = 500,
		        iVisionTeamNumber = caster:GetTeamNumber(),
		        ExtraData = {x=origin.x,y=origin.y,z=origin.z,name=name}
		    }
		    ProjectileManager:CreateLinearProjectile(info)
		end

		if times >= maxTimes then
			return nil
		end

		return 1
	end)
end

function public:OnProjectileHit_ExtraData(hTarget, vLocation, data)
	if hTarget then
		local origin = Vector(data.x,data.y,data.z)

		if hTarget:Attribute_GetIntValue(data.name, 0) == 1 then return end

		hTarget:Attribute_SetIntValue(data.name, 1)

		if hTarget:HasModifier("modifier_shushan_evade") then return end

		local targetPoint = hTarget:GetOrigin()
		local distance = self:GetSpecialValueFor("distance")
		local forward = (targetPoint-origin):Normalized()
		forward.z = 0

		local dist = distance - (targetPoint-origin):Length2D()
		local damage_count = 0
		local speed = self:GetSpecialValueFor("speed")
		local endTime = GameRules:GetGameTime() + dist/speed
		local s = speed/(1/FrameTime())
		local d = 0

		hTarget:AddNewModifier(hTarget, nil, "modifier_custom_stun", {duration=dist/speed})

		Timer(DoUniqueString("creature_16_boss_ability03"), self:GetCaster(), function ()
			if GameRules:GetGameTime() >= endTime then
				FindClearSpaceForUnit(hTarget, hTarget:GetOrigin(), true)
				return
			end

			local point = hTarget:GetOrigin()
			if GridNav:IsBlocked(point) or not GridNav:IsTraversable(point) then
			else
				hTarget:SetOrigin(point + forward*s)
			end

			d = d + s
			local count = math.floor(d/self:GetSpecialValueFor("damage_distance")) - damage_count

			for i=1,count do
				ApplyDamage({
					attacker = self:GetCaster(),
					victim = hTarget,
					damage = self:GetAbilityDamage(),
					damage_type = DAMAGE_TYPE_MAGICAL,
				})
				damage_count = damage_count + 1
			end

			return FrameTime()
		end)
	end

	return true
end