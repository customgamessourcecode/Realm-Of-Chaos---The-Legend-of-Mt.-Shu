
function CreatureEliteAbility01( keys )
	local caster = keys.caster
	local target = keys.target

	ApplyDamage({
        attacker = caster,
        victim = target,
        damage = keys.ability:GetAbilityDamage()*(caster.__this_wave or 1),
        damage_type = keys.ability:GetAbilityDamageType(),
    })
end

function CreatureEliteAbility02( keys )
	local caster = keys.caster

	local p = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,1,Vector(keys.Radius,keys.Radius,keys.Radius))
	ParticleManager:SetParticleControl(p,5,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,6,caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(p)

	local t = {
		attacker = caster,
        damage = keys.ability:GetAbilityDamage()*(caster.__this_wave or 1),
        damage_type = keys.ability:GetAbilityDamageType(),
    }

	local entities = keys.target_entities or {}
	for i,v in ipairs(entities) do
		if not v:IsNull() and v:IsAlive() then
			t.victim = v
			ApplyDamage(t)
		end
	end
end

-------------------------------------------------------------------------------------------------------------

function Creature04BOSS_Ability01( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local point = keys.target_points[1]
	local pointList = {point}

	for i=1,2 do
		table.insert(pointList,RotatePosition(origin, QAngle(0,15*i,0), point))
		table.insert(pointList,RotatePosition(origin, QAngle(0,-15*i,0), point))
	end

	for i,p in ipairs(pointList) do
		local info = 
	    {
	        Ability = keys.ability,
	        EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
	        vSpawnOrigin = origin,
	        fDistance = 2000,
	        fStartRadius = 50,
	        fEndRadius = 100,
	        Source = caster,
	        bHasFrontalCone = false,
	        bReplaceExisting = false,
	        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        fExpireTime = GameRules:GetGameTime() + 10.0,
	        vVelocity = (p-origin):Normalized() * 1800,
	        bProvidesVision = true,
	        iVisionRadius = 500,
	        iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	end
	
end


function Creature04BOSS_Ability03( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local count = keys.Count
	local angle = 360/count
	local distance = keys.Distance
	local speed = keys.Speed
	local point = origin + caster:GetForwardVector()*distance

	for i=1,count do
		local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

		local info = 
	    {
	        Ability = keys.ability,
	        EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
	        vSpawnOrigin = origin,
	        fDistance = distance,
	        fStartRadius = 50,
	        fEndRadius = 100,
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
	        iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	end

	Wait(DoUniqueString("Creature04BOSS_Ability03"), caster, distance/speed, function ()
		for i=1,count do
			local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

			local info = 
		    {
		        Ability = keys.ability,
		        EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
		        vSpawnOrigin = p,
		        fDistance = 1500,
		        fStartRadius = 50,
		        fEndRadius = 100,
		        Source = caster,
		        bHasFrontalCone = false,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 10.0,
		        vVelocity = (origin-p):Normalized() * 1800,
		        bProvidesVision = true,
		        iVisionRadius = 500,
		        iVisionTeamNumber = caster:GetTeamNumber()
		    }
		    ProjectileManager:CreateLinearProjectile(info)
		end
	end)
end


-------------------------------------------------------------------------------------------------------------

function Creature08BOSS_Ability01( keys )
	local caster = keys.caster
	local entities = keys.target_entities
	local ability = keys.ability
	local maxCount = keys.Count

	local count = 0
	Timer(DoUniqueString("Creature08BOSS_Ability01"), caster, function ()
		for i,v in ipairs(entities) do
			if not v:IsNull() and v:IsAlive() then
				ability:ApplyDataDrivenThinker(caster, v:GetOrigin(), "modifier_creature_08_boss_ability01", {duration=keys.Interval*(maxCount-count)})
			end
		end

		count = count + 1

		if count >= maxCount then
			return nil
		end
		return keys.Interval
	end)
end


function Creature08BOSS_Ability03( keys )
	local caster = keys.caster
	caster:AddNewModifier(caster, nil, "modifier_creature_08_boss_ability02", {duration=60})

	Creature08BOSS_Ability03_ToAir(caster, keys.ability, 800, 0.3, 0, keys.MaxCount)
end

function Creature08BOSS_Ability03_ToAir( caster, ability, height, duration, count )
	local origin = caster:GetOrigin()
	local h = 0
	local speed = (height/duration)/(1/FrameTime())
	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")

	Timer("Creature08BOSS_Ability03_ToAir", caster, function ()
		h = h + speed
		caster:SetOrigin(origin+Vector(0,0,h))

		if h >= height then
			Wait("Creature08BOSS_Ability03_ToTarget_Wait", caster, 0.50, function ()
				Creature08BOSS_Ability03_ToTarget( caster, ability, height, 0.3, count )
			end)
			return nil
		end

		return FrameTime()
	end)
end

function Creature08BOSS_Ability03_ToTarget( caster, ability, height, duration, count )
	count = count + 1

	local entities = FindUnitsInRadiusForAbility(ability, caster:GetOrigin(), 1200)
	local targetPoint

	if #entities > 0 then
		local unit = entities[RandomInt(1, #entities)]
		targetPoint = unit:GetOrigin()
	else
		targetPoint = GetGroundPosition(caster:GetOrigin(), caster)
	end
	
	local speed = 2500/(1/FrameTime())
	local face = (targetPoint - caster:GetOrigin()):Normalized()
	local time = GameRules:GetGameTime() + (caster:GetOrigin() - targetPoint):Length()/2500
	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")

	local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability_a.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,1,targetPoint)
	ParticleManager:SetParticleControl(p,2,Vector(150,150,150))
	ParticleManager:DestroyParticleSystem(p)

	Timer("Creature08BOSS_Ability03_ToTarget", caster, function ()
		local pos = caster:GetOrigin()
		caster:SetOrigin(pos+face*speed)

		if GameRules:GetGameTime() >= time then

			-- 特效
			local path = "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf"
			local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(p, 0, targetPoint)
			ParticleManager:DestroyParticleSystem(p)

			-- 伤害
			local entities = FindUnitsInRadiusForAbility(ability, caster:GetOrigin(), ability:GetSpecialValueFor("radius"))
			for i,v in ipairs(entities) do
				ApplyDamage({
		            attacker = caster,
		            victim = v,
		            damage = ability:GetAbilityDamage(),
		            damage_type = ability:GetAbilityDamageType(),
		        })
			end

			-- 退出条件
			if count >= 3 then
				caster:RemoveModifierByName("modifier_creature_08_boss_ability02")
				FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
				return nil
			end

			-- 继续
			Creature08BOSS_Ability03_ToAir( caster, ability, height, duration, count )
			return nil
		end

		return FrameTime()
	end)
end

-------------------------------------------------------------------------------------------------------------

function Creature12BOSS_Ability02( keys )
	local caster = keys.caster
	local entities = keys.target_entities
	local ability = keys.ability
	local maxCount = keys.Count

	local count = 0
	Timer(DoUniqueString("Creature12BOSS_Ability02"), caster, function ()
		for i,v in ipairs(entities) do
			if not v:IsNull() and v:IsAlive() then
				local d = keys.Interval*(maxCount-count) + 0.5*(count+1)
				ability:ApplyDataDrivenThinker(caster, v:GetOrigin(), "modifier_creature_12_boss_ability02", {duration=d})
			end
		end

		count = count + 1

		if count >= maxCount then
			return nil
		end
		return keys.Interval
	end)
end

-------------------------------------------------------------------------------------------------------------

function Creature16BOSS_Ability01( keys )
	local caster = keys.caster
	local target = keys.target
	local origin = target:GetOrigin()

	local count = keys.Count
	local angle = 360/count
	local distance = keys.Distance
	local speed = keys.Speed
	local point = origin + caster:GetForwardVector()*distance

	for i=1,count do
		local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

		local info = 
	    {
	        Ability = keys.ability,
	        EffectName = "particles/avalon/abilities/creature_16_boss/ability01/creature_16_boss_ability01.vpcf",
	        vSpawnOrigin = origin,
	        fDistance = distance,
	        fStartRadius = 128,
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
	        iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	end
end

-------------------------------------------------------------------------------------------------------------

function Creature20BOSS_Ability02( keys )
	local caster = keys.caster

	if caster.__Ability02_motion == nil then
		caster.__Ability02_motion = caster:CreateMotion()
	end

	local motion = caster.__Ability02_motion
	local point = keys.target_points[1]

	motion:OnEnd(function ()
		local p = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(p, 1, Vector(keys.Radius,keys.Radius,keys.Radius))
		ParticleManager:SetParticleControl(p, 5, caster:GetOrigin())
		ParticleManager:SetParticleControl(p, 6, caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)

		local ability = keys.ability
		local ents = FindUnitsInRadiusForAbility(ability, caster:GetOrigin(), keys.Radius)
		for i,v in ipairs(ents) do
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration=2})
			ApplyDamage({
	            attacker = caster,
	            victim = v,
	            damage = ability:GetAbilityDamage(),
	            damage_type = ability:GetAbilityDamageType(),
	        })
		end
	end)

	caster:StartGesture(ACT_DOTA_ATTACK)
	motion:Jump(caster:GetOrigin(), point, 4000, 0.6, "modifier_custom_stun")
end

function Creature20BOSS_Ability01_Damage(keys)
	if keys.caster and keys.caster:HasModifier("modifier_creature_20_boss_ability01_caster") then
		ApplyDamage({
            attacker = keys.caster,
            victim = keys.target,
            damage = keys.ability:GetAbilityDamage(),
            damage_type = keys.ability:GetAbilityDamageType(),
        })
	end
end

-------------------------------------------------------------------------------------------------------------

function Creature24BOSS_Ability01( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local count = keys.Count
	local face = caster:GetForwardVector()
	local angle = 360/count
	local radius = keys.Radius
	local point = origin + face*radius

	for i=1,count do
		local p = RotatePosition(origin, QAngle(0,i*angle,0), point)

		local unit = CreateUnitByName("shushan_wave_24_stone01", p, false, nil, nil, caster:GetTeam())
		unit:SetBaseMaxHealth(caster:GetMaxHealth()*0.1)
		unit:SetHealth(unit:GetMaxHealth())
		unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		unit:SetBodygroup(0, RandomInt(0, 5))

		local f = (origin-p):Normalized()
		f.z=0
		unit:SetForwardVector(f)

		Wait("Creature24BOSS_Ability01_Think", unit, keys.Duration, function ()
			if not unit:IsNull() and unit:IsAlive() then
				unit:AddNoDraw()
				unit:ForceKill(true)

				if caster:IsNull() or not caster:IsAlive() then
					return nil
				end

				local u = CreateUnitByName("shushan_wave_24_little", unit:GetOrigin(), true, nil, nil, caster:GetTeam())
				u:SetBaseDamageMax(caster:GetBaseDamageMax()*0.2)
				u:SetBaseDamageMin(caster:GetBaseDamageMin()*0.2)
				u:SetBaseMaxHealth(caster:GetMaxHealth()*0.2)
				u:SetMaxHealth(caster:GetMaxHealth()*0.2)
				u:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
				u:SetHealth(u:GetMaxHealth())
				Timer("Creature24BOSS_Ability01_Think", u, function ()
					if not caster:IsNull() and caster:IsAlive() then
						u:MoveToPositionAggressive(caster:GetOrigin()+RandomVector(150))
					else
						u:ForceKill(true)
					end
					return 3
				end)

				local path = "particles/avalon/abilities/creature_24_boss/ability02/creature_24_boss_ability02_immortal1.vpcf"
				local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, u)
				ParticleManager:SetParticleControl(p, 0, u:GetOrigin())
				ParticleManager:SetParticleControl(p, 1, Vector(50,50,50))
				ParticleManager:SetParticleControl(p, 2, u:GetOrigin())
				ParticleManager:SetParticleControl(p, 3, u:GetOrigin())
				ParticleManager:DestroyParticleSystem(p)
			end
		end)
	end
end

function Creature24BOSS_Ability02( keys )
	local caster = keys.caster

	local unit = CreateUnitByName("shushan_wave_24_stone02", caster:GetOrigin()+RandomVector(keys.Radius), false, nil, nil, caster:GetTeam())
	unit:SetBaseMaxHealth(caster:GetMaxHealth()*0.25)
	unit:SetHealth(unit:GetMaxHealth())
	unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
	unit:SetBodygroup(0, RandomInt(0, 5))

	Wait("Creature24BOSS_Ability02_Think", unit, keys.Duration, function ()
		if not unit:IsNull() and unit:IsAlive() then
			unit:AddNoDraw()
			unit:ForceKill(true)

			if caster:IsNull() or not caster:IsAlive() then
				return nil
			end

			caster:Heal(caster:GetMaxHealth()*(keys.HealPercent/100), keys.ability)

			local ability = keys.ability
			local ents = FindUnitsInRadiusForAbility(ability, caster:GetOrigin(), keys.Radius*3)
			for i,v in ipairs(ents) do
				v:AddNewModifier(caster, nil, "modifier_stunned", {duration=keys.StunDuration})
				ApplyDamage({
		            attacker = caster,
		            victim = v,
		            damage = ability:GetAbilityDamage(),
		            damage_type = ability:GetAbilityDamageType(),
		        })
			end

			local path = "particles/avalon/abilities/creature_24_boss/ability02/creature_24_boss_ability02_immortal1.vpcf"
			local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
			ParticleManager:SetParticleControl(p, 1, Vector(150,150,150))
			ParticleManager:SetParticleControl(p, 2, caster:GetOrigin())
			ParticleManager:SetParticleControl(p, 3, caster:GetOrigin())
			ParticleManager:DestroyParticleSystem(p)
		end
	end)
end


-------------------------------------------------------------------------------------------------------------

function Creature28BOSS_Ability01( keys )
	local caster = keys.caster
	local target = keys.unit

	if not target or target:IsNull() then return end

	if target:IsRealHero() then
		--caster:Heal(caster:GetMaxHealth()*0.1, keys.ability)
	end
end

function Creature28BOSS_Ability01_2( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local face = caster:GetForwardVector()
	local ability = keys.ability

	local times = 0
	Timer(DoUniqueString("Creature28BOSS_Ability01_2"), caster, function ()

		times = times + 1

		local point = origin + face * 150 * times
		local count = 8 * times
		local angle = 360/count

		for i=1,count do
			local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

			ability:ApplyDataDrivenThinker(caster, p, "modifier_creature_28_boss_ability01_damage", {duration=1})
		end

		if times >= 3 then
			return nil
		end

		return 0.5
	end)
end

function Creature28BOSS_Ability02( keys )
	local entities = keys.target_entities
	if entities == nil then return end

	local caster = keys.caster
	local ability = keys.ability
	local maxCount = keys.Count

	local count = 0
	Timer(DoUniqueString("Creature28BOSS_Ability02"), caster, function ()
		for i,v in ipairs(entities) do
			if not v:IsNull() and v:IsAlive() then
				ability:ApplyDataDrivenThinker(caster, v:GetOrigin(), "modifier_creature_28_boss_ability02", {duration=keys.Interval*(maxCount-count)})
			end
		end

		count = count + 1

		if count >= maxCount then
			return nil
		end
		return keys.Interval
	end)
end

function Creature28BOSS_Ability03( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local count = keys.Count
	local angle = 360/count
	local distance = keys.Distance
	local speed = keys.Speed
	local point = origin + caster:GetForwardVector()*distance

	for i=1,count do
		local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effect, 0, origin)
		ParticleManager:SetParticleControl(effect, 1, (p-origin):Normalized() * speed)
		ParticleManager:SetParticleControl(effect, 2, Vector(0,distance/speed,0))
		ParticleManager:DestroyParticleSystem(effect)

		local info = 
	    {
	        Ability = keys.ability,
	        EffectName = "",
	        vSpawnOrigin = origin,
	        fDistance = distance,
	        fStartRadius = 50,
	        fEndRadius = 100,
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
	        iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	end

	Wait(DoUniqueString("Creature28BOSS_Ability03"), caster, distance/speed, function ()
		for i=1,count do
			local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

			local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effect, 0, p)
			ParticleManager:SetParticleControl(effect, 1, (origin-p):Normalized() * speed)
			ParticleManager:SetParticleControl(effect, 2, Vector(0,distance/speed,0))
			ParticleManager:DestroyParticleSystem(effect)

			local info = 
		    {
		        Ability = keys.ability,
		        EffectName = "",
		        vSpawnOrigin = p,
		        fDistance = distance,
		        fStartRadius = 50,
		        fEndRadius = 100,
		        Source = caster,
		        bHasFrontalCone = false,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 10.0,
		        vVelocity = (origin-p):Normalized() * speed,
		        bProvidesVision = true,
		        iVisionRadius = 500,
		        iVisionTeamNumber = caster:GetTeamNumber()
		    }
		    ProjectileManager:CreateLinearProjectile(info)
		end
	end)
end

function Creature28BOSS_Ability04( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local ability = keys.ability
	local endTime = GameRules:GetGameTime() + keys.Duration

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_creature_28_boss_ability04", {duration=keys.Duration})

	Timer("Creature28BOSS_Ability04_Think", caster, function ()
		if GameRules:GetGameTime() >= endTime then
			return nil
		end

		for i=1,RandomInt(1, 3) do
			local pos = origin + RandomVector(RandomFloat(0, keys.Radius))
			ability:ApplyDataDrivenThinker(caster, pos, "modifier_creature_28_boss_ability04_damage", {duration=1.5})
		end

		return 0.1
	end)
end

function Creature28BOSS_Ability04Kill( keys )
	if keys.caster and keys.caster:HasModifier("modifier_creature_28_boss_ability04") then
		keys.target:Kill(keys.ability, keys.caster)
	end
end


-------------------------------------------------------------------------------------------------------------

function OnCreature032_01ProjectileOnHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local forwardVec = caster:GetForwardVector()
	local forwardCos = forwardVec.x
	local forwardSin = forwardVec.y

	for i=1,3 do
		local rollRad = -math.pi/4
		local rollRadVec = rollRad - math.pi/2
		local shotVector =  Vector(math.cos(rollRad)*forwardCos - math.sin(rollRad)*forwardSin,
								 forwardSin*math.cos(rollRad) + forwardCos*math.sin(rollRad),
								 0)
		local shotVector2 =  Vector(math.cos(rollRadVec)*forwardCos - math.sin(rollRadVec)*forwardSin,
								 forwardSin*math.cos(rollRadVec) + forwardCos*math.sin(rollRadVec),
								 0)

		local BulletTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/avalon_bosses/creature_032_projectile.vpcf",
			vSpawnOrigin		=	caster:GetOrigin() - caster:GetForwardVector()*300 - shotVector2:Normalized() * 300 * i + Vector(0,0,64),
			vSpawnOriginNew		=	caster:GetOrigin() - caster:GetForwardVector()*300 - shotVector2:Normalized() * 300 * i + Vector(0,0,64),
			fDistance			=	1500,
			fStartRadius		=	300,
			fEndRadius			=	300,
			Source         	 	=   caster,
			bHasFrontalCone		=	false,
			bRepalceExisting 	=  false,
			iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
			iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
			iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
			fExpireTime     =   GameRules:GetGameTime() + 10.0,
			bDeleteOnHit    =   true,
			vVelocity       =   shotVector,
			bProvidesVision	=	true,
			iVisionRadius	=	400,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ShushanCreateProjectileMoveToTargetPoint(BulletTable,caster,keys.MoveSpeed,keys.Acceleration1,keys.Acceleration2)
	end

	for i=1,3 do
		local rollRad = math.pi/4
		local rollRadVec = rollRad + math.pi/2
		local shotVector =  Vector(math.cos(rollRad)*forwardCos - math.sin(rollRad)*forwardSin,
								 forwardSin*math.cos(rollRad) + forwardCos*math.sin(rollRad),
								 0)
		local shotVector2 =  Vector(math.cos(rollRadVec)*forwardCos - math.sin(rollRadVec)*forwardSin,
								 forwardSin*math.cos(rollRadVec) + forwardCos*math.sin(rollRadVec),
								 0)

		local BulletTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/avalon_bosses/creature_032_projectile.vpcf",
			vSpawnOrigin		=	caster:GetOrigin() - caster:GetForwardVector()*300 - shotVector2:Normalized() * 300 * i + Vector(0,0,64),
			vSpawnOriginNew		=	caster:GetOrigin() - caster:GetForwardVector()*300 - shotVector2:Normalized() * 300 * i + Vector(0,0,64),
			fDistance			=	1500,
			fStartRadius		=	300,
			fEndRadius			=	300,
			Source         	 	=   caster,
			bHasFrontalCone		=	false,
			bRepalceExisting 	=  false,
			iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
			iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
			iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
			fExpireTime     =   GameRules:GetGameTime() + 10.0,
			bDeleteOnHit    =   false,
			vVelocity       =   shotVector,
			bProvidesVision	=	true,
			iVisionRadius	=	400,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ShushanCreateProjectileMoveToTargetPoint(BulletTable,caster,keys.MoveSpeed,keys.Acceleration1,keys.Acceleration2,
			function(v)
				local damage_table = {
                    ability = keys.ability,
                    victim = v,
                    attacker = caster,
                    damage = keys.ability:GetAbilityDamage(),
                    damage_type = keys.ability:GetAbilityDamageType(),
                    damage_flags = keys.ability:GetAbilityTargetFlags()
                }
                ApplyDamage(damage_table)
			end)
	end
end

function Creature32BOSS_Ability03Start(keys)
	local caster = keys.caster
	local target = keys.target

	local path = "particles/avalon/abilities/creature_32_boss/ability03/creature_32_boss_ability03.vpcf"
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
	ParticleManager:SetParticleControlEnt(p, 1, target, 5, "absorigin", target:GetOrigin(), true)
	ParticleManager:SetParticleControl(p, 4, target:GetOrigin())
	ParticleManager:SetParticleControl(p, 9, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(p)
end

function Creature32BOSS_Ability03Effect( keys )
	local caster = keys.caster
	local target = keys.target
	
	if target and not target:IsNull() and target:IsAlive() and not target:HasModifier("modifier_shushan_evade") then
		target:Kill(keys.ability, caster)
		caster:Heal(caster:GetMaxHealth() * 0.05, keys.ability)
	end
end


function Creature32BOSS_Ability04( keys )
	local caster = keys.caster
	local enemies = keys.target_entities
	if not enemies then return end

	for i,target in ipairs(enemies) do

		local path = "particles/avalon/abilities/creature_32_boss/ability03/creature_32_boss_ability03.vpcf"
		local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
		ParticleManager:SetParticleControlEnt(p, 1, target, 5, "absorigin", target:GetOrigin(), true)
		ParticleManager:SetParticleControl(p, 4, target:GetOrigin())
		ParticleManager:SetParticleControl(p, 9, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)

		Wait("Creature32BOSS_Ability04Think", target, 1.4, function ()
			if not target:IsNull() and target:IsAlive() and not target:HasModifier("modifier_shushan_evade") then
				local origin = target:GetOrigin()
				local point = origin + caster:GetForwardVector()*1500
				local count = 10
				local angle = 360/count

				for i=1,count do
					local p = RotatePosition(origin, QAngle(0,angle*i,0), point)

					local info = 
				    {
				        Ability = keys.ability,
				        EffectName = "particles/avalon/abilities/creature_32_boss/ability04/creature_32_boss_ability04.vpcf",
				        vSpawnOrigin = origin,
				        fDistance = 1500,
				        fStartRadius = 50,
				        fEndRadius = 100,
				        Source = caster,
				        bHasFrontalCone = false,
				        bReplaceExisting = false,
				        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				        fExpireTime = GameRules:GetGameTime() + 10.0,
				        vVelocity = (p-origin):Normalized() * 500,
				        bProvidesVision = true,
				        iVisionRadius = 100,
				        iVisionTeamNumber = caster:GetTeamNumber()
				    }
				    ProjectileManager:CreateLinearProjectile(info)
				end

				target:Kill(keys.ability, caster)
				caster:Heal(caster:GetMaxHealth() * 0.05, keys.ability)
			end
		end)
	end
end

function Creature32BOSS_Ability05( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local ability = keys.ability
	local endTime = GameRules:GetGameTime() + keys.Duration

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_creature_32_boss_ability05", {duration=keys.Duration})

	Timer("Creature32BOSS_Ability05_Think", caster, function ()
		if GameRules:GetGameTime() >= endTime then
			return nil
		end

		for i=1,RandomInt(1, 3) do
			local pos = origin + RandomVector(RandomFloat(0, keys.Radius))
			ability:ApplyDataDrivenThinker(caster, pos, "modifier_creature_32_boss_ability05_damage", {duration=1.5})
		end

		return 0.75
	end)
end

function Creature32BOSS_Ability05Kill( keys )
	if keys.caster and keys.caster:HasModifier("modifier_creature_32_boss_ability05") then
		keys.target:Kill(keys.ability, keys.caster)

		local caster = keys.caster
		local u = CreateUnitByName("creature_32_boss_guihun", keys.target:GetOrigin(), true, nil, nil, caster:GetTeam())
		u:SetBaseDamageMax(caster:GetBaseDamageMax()*0.25)
		u:SetBaseDamageMin(caster:GetBaseDamageMin()*0.25)
		u:SetBaseMaxHealth(caster:GetMaxHealth()*0.25)
		u:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		u:SetHealth(u:GetMaxHealth())
	end
end

function Creature32BOSS_Ability05Damage( keys )
	ApplyDamage({
        attacker = keys.caster,
        victim = keys.target,
        damage = keys.ability:GetAbilityDamage(),
        damage_type = keys.ability:GetAbilityDamageType(),
    })
    if not keys.target:IsAlive() then
    	local caster = keys.caster
		local u = CreateUnitByName("creature_32_boss_guihun", keys.target:GetOrigin(), true, nil, nil, caster:GetTeam())
		u:SetBaseDamageMax(caster:GetBaseDamageMax()*0.25)
		u:SetBaseDamageMin(caster:GetBaseDamageMin()*0.25)
		u:SetBaseMaxHealth(caster:GetMaxHealth()*0.25)
		u:SetMaxHealth(caster:GetMaxHealth()*0.25)
		u:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		u:SetHealth(u:GetMaxHealth())
    end
end