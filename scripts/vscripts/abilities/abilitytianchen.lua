function OnTianchen011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = keys.target_points[1]
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local forwardVec = Vector( math.cos(pointRad) * 1500 , math.sin(pointRad) * 1500 , 0 )

	local swordTable = {
		Target 				= caster,
		Ability				= keys.ability,
		EffectName			= shushan_GetEffectName(caster,"ability_shushan_tianchen011"),
		vSpawnOrigin		= vecCaster + Vector(0,0,128),
		fDistance			= 1500,
		fStartRadius		= 120,
		fEndRadius			= 120,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= forwardVec,
		bProvidesVision		= true,
		iVisionRadius		= 400,
		iVisionTeamNumber	= caster:GetTeamNumber(),
		iSourceAttachment 	= PATTACH_CUSTOMORIGIN
	} 

	ProjectileManager:CreateLinearProjectile(swordTable)
	caster:EmitSound("Hero_Magnataur.ShockWave.Particle")

	for i=1,2 do
		local iVec = Vector( math.cos(pointRad + math.pi/18*(i+0.5)) * 1500 , math.sin(pointRad + math.pi/18*(i+0.5)) * 1500 , 0 )
		swordTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(swordTable)
		
		iVec = Vector( math.cos(pointRad - math.pi/18*(i+0.5)) * 1500 , math.sin(pointRad - math.pi/18*(i+0.5)) * 1500 , 0 )
		swordTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(swordTable)
	end
end

function OnTianchen011SpellStartForJueXing( keys )
	if keys.caster.__juexing_la then
		keys.target_points = {keys.target:GetOrigin()}
		OnTianchen011SpellStart(keys)
	end
end

function OnTianchen011Hit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
end

function OnTianchen012SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local seed = RandomInt(0, 100)
	
	if seed > 50 then
		keys.ability:EndCooldown()
		caster:CastAbilityOnTarget(target, keys.ability, caster:GetPlayerOwnerID())
	end

	local vVec = (target:GetOrigin()-caster:GetOrigin()):Normalized()

	local info = 
    {
        Ability = keys.ability,
        EffectName = shushan_GetEffectName(caster,"ability_shushan_tianchen012"),
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = 600,
        fStartRadius = 300,
        fEndRadius = 300,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        vVelocity =  Vector(vVec.x*1500,vVec.y*1500,0),
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function OnTianchen012Hit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
	caster:PerformAttack(target,false,true,true,false,false,false,true)
end

function OnTianchen013SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster.tianchen_013_time = GameRules:GetGameTime()
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/tianchen/ability_tianchen_013.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())

	caster.tianchen_013_effectIndex = effectIndex
end

function OnTianchen013SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	ParticleManager:DestroyParticle(caster.tianchen_013_effectIndex,true)
	ParticleManager:DestroyParticleSystem(caster.tianchen_013_effectIndex)
	caster.tianchen_013_time = GameRules:GetGameTime() - caster.tianchen_013_time
	
	caster:StartGesture(ACT_DOTA_CHANNEL_END_ABILITY_3)

	local info = 
    {
        Ability = keys.ability,
        EffectName = shushan_GetEffectName(caster,"ability_shushan_tianchen013"),
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = 1000,
        fStartRadius = 800,
        fEndRadius = 800,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        vVelocity = Vector(caster:GetForwardVector().x * 1500,caster:GetForwardVector().y * 1500,0),
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function OnTianchen013Hit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
	target:SetModifierStackCount("modifier_tianchen03_slow",caster,math.ceil(caster.tianchen_013_time)*4)
end

function OnTianchen014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetpoint = keys.target_points[1]
	caster.tianchen_014_sword_vector = caster:GetOrigin() + (targetpoint - caster:GetOrigin()):Normalized() * 1000
	-- caster:SwapAbilities("ability_shushan_tianchen014","ability_shushan_tianchen0142",false,true)
	local ability = caster:FindAbilityByName("ability_shushan_tianchen0142")
	ability:SetLevel(1)
	ability:SetActivated(true)
	keys.ability:SetActivated(false)
end

function OnTianchen014Hit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
end

function OnTianchen0142SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local distance = 0
	local speed = 50

	local vecCaster = caster:GetOrigin()
	local targetPoint = caster.tianchen_014_sword_vector
	if not targetPoint then return end

	local forward = (targetPoint - vecCaster):Normalized()
	local distanceAB = GetDistanceBetweenTwoVec2D(targetPoint,vecCaster)
	forward.z = 0

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/tianchen/ability_tianchen_0142.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())

	caster:StartGesture(ACT_DOTA_CHANNEL_END_ABILITY_4)
	caster:SetForwardVector(forward)

	caster:SetContextThink(DoUniqueString("OnTianchen013SpellStart_timer"), 
		function()
			distance = distance + speed
			if distance < distanceAB and GridNav:CanFindPath(caster:GetOrigin(),caster:GetOrigin() + forward*speed) then
				caster:SetOrigin(vecCaster + Vector(0,0,64)  + forward*distance)
				ParticleManager:SetParticleControl(effectIndex, 3, vecCaster + Vector(0,0,128) + forward*distance)
				ParticleManager:SetParticleControlForward(effectIndex, 3, forward)
				return 0.03
			else
				ParticleManager:DestroyParticle(effectIndex,true)
				ParticleManager:DestroyParticleSystem(effectIndex)
				caster:RemoveGesture(ACT_DOTA_CHANNEL_END_ABILITY_4)
				FindClearSpaceForUnit(caster,caster:GetOrigin(),false)
				caster:SetOrigin(GetGroundPosition(caster:GetOrigin(),caster))
				-- caster:SwapAbilities("ability_shushan_tianchen014","ability_shushan_tianchen0142",true,false)
				local ability = caster:FindAbilityByName("ability_shushan_tianchen014")
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
				ability:SetActivated(true)
				keys.ability:SetActivated(false)
				return nil
			end
		end,
	0.03)
end

function OnTianchenAttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local count = 0
	caster:SetContextThink(DoUniqueString("OnTianchen015SpellStart_timer"), 
		function()
			count = count + 1
			if count <= 5 then
				local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_tianchen015"), PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
				ParticleManager:SetParticleControlForward(effectIndex, 0, RandomVector(1))
				local damage_table = {
					ability = keys.ability,
					victim = target,
					attacker = caster,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = keys.ability:GetAbilityTargetFlags()
				}
				UnitDamageTarget(damage_table)
				return 0.1
			else
				return nil
			end
		end,
	0.1)
end