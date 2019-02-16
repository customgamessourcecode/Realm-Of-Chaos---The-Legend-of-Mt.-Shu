function OnLiluan01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	keys.ability.ability_sakuya02_point_x = targetPoint.x
	keys.ability.ability_sakuya02_point_y =targetPoint.y
	keys.ability.ability_sakuya02_point_z =targetPoint.z
end

function OnLiluan01SpellDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = Vector(keys.ability.ability_sakuya02_point_x,keys.ability.ability_sakuya02_point_y,keys.ability.ability_sakuya02_point_z)
	local targets = keys.target_entities

	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local pointRad1 = pointRad + math.pi * (keys.DamageRad/180)
	local pointRad2 = pointRad - math.pi * (keys.DamageRad/180)

	local forwardVec = Vector( math.cos(pointRad) * 2000 , math.sin(pointRad) * 2000 , 0 )

	local plyID =  caster:GetPlayerOwnerID()
	local effectName
	if HasPass(plyID) then
		effectName = "particles/heroes/liluan/ability_liluan_01_shot.vpcf"
	else
		effectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
	end

	local knifeTable = {
		Ability				= keys.ability,
		EffectName			= effectName,
		vSpawnOrigin		= vecCaster + Vector(0,0,128),
		fDistance			= keys.DamageRadius,
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

	ProjectileManager:CreateLinearProjectile(knifeTable)

	for i=1,4 do
		local iVec = Vector( math.cos(pointRad + math.pi/18*(i+0.5)) * 2000 , math.sin(pointRad + math.pi/18*(i+0.5)) * 2000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
		iVec = Vector( math.cos(pointRad - math.pi/18*(i+0.5)) * 2000 , math.sin(pointRad - math.pi/18*(i+0.5)) * 2000 , 0 )
		knifeTable.vVelocity = iVec
		ProjectileManager:CreateLinearProjectile(knifeTable)
	end
end

function OnLiluan01DealDamage(keys)
	local caster = keys.caster
	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table) 
end

function OnLiluan02KillSpawn(keys)
	local caster = keys.caster
	if caster.hsj_liluan_phoenix~=nil and caster.hsj_liluan_phoenix:IsNull() == false then
		caster.hsj_liluan_phoenix:ForceKill(true)
	end
end

function OnLiluan02Spawn(keys)
	local caster = keys.caster
	local target = keys.target

	local deal_damage = 100

	target.deal_damage = deal_damage

	local health = caster:GetMaxHealth() * 2

	target:SetBaseMaxHealth(health)
	target:SetMaxHealth(health)
	target:SetHealth(health)
	target:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
	target:SetBaseAttackTime(1 - 2 * 0.1)
	target:SetBaseMoveSpeed(caster:GetBaseMoveSpeed())

	target.hero = caster
	caster.hsj_liluan_phoenix = target
	target:SetOwner(caster)

	local ability = target:AddAbility("ability_hsj_liluan_phoenix")
	ability:SetLevel(1)

	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		 keys.ability:ApplyDataDrivenModifier(target, target, "modifier_ability_liluan_02", nil)
	end

	target:SetBaseMagicalResistanceValue(100)
end

function hsj_OnLiluanPhoenixAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target

	local targets = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, target:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for k,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			ability = keys.ability,
			damage_type = keys.ability:GetAbilityDamageType(), 
		    damage_flags = keys.ability:GetAbilityTargetFlags()
		}

		UnitDamageTarget(damage_table) 
	end

	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_01_boom.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
	end
end

function OnLiluan03DealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local vecTarget = target:GetOrigin()

	local damage_table = {
		victim = target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}

	UnitDamageTarget(damage_table) 
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0,  vecTarget + Vector(0,0,128))

	caster:EmitSound("Hero_Clinkz.SearingArrows")
end

function OnLiluan03SpellStart(keys)
	local caster = keys.caster
	local modifierCount = caster:GetModifierStackCount("modifier_hsj_liluan03_arrow",caster)

	local effectName

	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		effectName = "particles/heroes/liluan/ability_liluan_03_arrow.vpcf"
	else
		effectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	end

	if modifierCount > 0 then
		caster:SetContextThink(DoUniqueString("hsj_ability_Liluan_03"), 
			function ()
				local arrowTable = {
					Target = keys.target,
					Source = caster,
					Ability = keys.ability,	
					EffectName = effectName,
					iMoveSpeed = 1500,
					vSourceLoc= caster:GetAbsOrigin(),
					bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = true,
					iVisionRadius = 100,
					iVisionTeamNumber = caster:GetTeamNumber()
				} 
				ProjectileManager:CreateTrackingProjectile(arrowTable)

				modifierCount = modifierCount - 1
				if modifierCount > 0 then
					local newModifierCount = caster:GetModifierStackCount("modifier_hsj_liluan03_arrow",caster)
					caster:SetModifierStackCount("modifier_hsj_liluan03_arrow" , keys.ability, newModifierCount - 1)
					return 0.1
				else
					return nil
				end
			end, 
		0.1)
	end
end

function OnLiluan03think(keys)
	local caster = keys.caster
	local modifierCount = caster:GetModifierStackCount("modifier_hsj_liluan03_arrow",caster) + 1
	local limit = GetHeroMultiState(caster) + 2

	if modifierCount > limit then
		modifierCount = limit
	end

	caster:SetModifierStackCount("modifier_hsj_liluan03_arrow" , keys.ability, modifierCount)
end

function OnLiluan03AttackLanded(keys)
	local caster = keys.caster
	local modifierCount = caster:GetModifierStackCount("modifier_hsj_liluan03_arrow",caster) + 1
	local limit = GetHeroMultiState(caster) + 2

	if modifierCount >= limit then
		OnLiluan03SpellStart(keys)
		modifierCount = limit
	end

	caster:SetModifierStackCount("modifier_hsj_liluan03_arrow" , keys.ability, modifierCount)
end

function Liluan04OnSpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local tick_interval=keys.tick_interval
	local rate_tick=keys.rate*keys.tick_interval
	local tick=0
	local last_down_tick=0

	local damage_table = {
		attacker = Caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}

	local origin=keys.target_points[1]

	local effectName

	local plyID =  Caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		effectName = "particles/heroes/liluan/ability_liluan_04_arrow.vpcf"
	else
		effectName = "particles/units/heroes/hero_legion_commander/legion_commander_odds_hero_arrow_group.vpcf"
	end

	Caster:SetContextThink(
		"yasaka41_main_loop",
		function ()
			if last_down_tick~=math.floor(tick*rate_tick) then
				last_down_tick=math.floor(tick*rate_tick)
				local rdpos=origin+RandomVector(keys.radius)*RandomFloat(0,1)

				local enemies=FindUnitsInRadius(
					Caster:GetTeamNumber(),
					rdpos,
					nil,
					keys.damage_radius,
					Ability:GetAbilityTargetTeam(),
					Ability:GetAbilityTargetType(),
					Ability:GetAbilityTargetFlags(),
					FIND_ANY_ORDER,
					false)
				for _,v in pairs(enemies) do
					damage_table.victim=v
					UnitDamageTarget(damage_table)
					UnitStunTarget( Caster,v,0.2 )
				end

				local effectIndex = ParticleManager:CreateParticle(effectName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(effectIndex, 0, rdpos)
				ParticleManager:SetParticleControl(effectIndex, 1, rdpos)
				ParticleManager:SetParticleControl(effectIndex, 3, rdpos)
				ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)
			end

			tick=tick+1
			if tick > keys.duration * 10 then
				return nil
			end
			return tick_interval
		end,0)
end