function OnHumei01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targets = FindUnitsInRadius(
			caster:GetTeam(),		--caster team
			target:GetOrigin(),		--find position
			nil,					--find entity
			keys.Radius,					--find radius
		    DOTA_UNIT_TARGET_TEAM_ENEMY,
			keys.ability:GetAbilityTargetType(),
			0, 
			FIND_ANY_ORDER,
			false
	)

	for _,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			ability = keys.ability,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = keys.ability:GetAbilityTargetFlags(),
			damage_percent = (keys.DamagePercent or 0)/100 + 1,
		}
		UnitDamageTarget(damage_table)
	end
end

function OnHumei01FireEffect(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local plyID =  caster:GetPlayerOwnerID()
	local effectIndex
	if HasPass(plyID) then
		effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_01_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
	else
		effectIndex = ParticleManager:CreateParticle("particles/heroes/sanae/ability_sanea_02_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
	end
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 6, target:GetOrigin())
end

function OnHumei02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local effectIndex
	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_02_effect.vpcf", PATTACH_CUSTOMORIGIN, target)
	else
		effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", PATTACH_CUSTOMORIGIN, target)
	end
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	Wait(DoUniqueString("OnHumei02SpellStart_DestroyParticle"), caster, 2, function ()
		ParticleManager:DestroyParticle(effectIndex,true)
	end)
end

function OnHumei02FireDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local target = keys.target
	local damage_table = {
		victim = target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags(),
		damage_percent = (keys.DamagePercent or 0)/100 + 1,
	}
	UnitDamageTarget(damage_table)
end

local __OnHumei03_OriginalModel = ""
function OnHumei03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex
	
	effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_minamitsu_03_body.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 3, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 4, caster, 5, "absorigin", Vector(0,0,0), true)

	caster:SetRenderColor(0, 0, 255)
	local unqiue = AttributesCtrl:MultiWeaponDamage(caster,shushan_GetWeaponType(caster,nil),multi)
    
    Wait(DoUniqueString("ability_humei03_modifier_timer"), 
    	keys.Duration,
    	function()
			caster:SetRenderColor(255, 255, 255)
			ParticleManager:DestroyParticle(effectIndex,true)
			AttributesCtrl:ClearMultiWeaponDamage(caster,shushan_GetWeaponType(caster,nil),unqiue)
			return nil
		end)
end

function OnHumei03CreateTracking(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target == nil then
		return
	end

	local plyID =  caster:GetPlayerOwnerID()
	local effectName
	if HasPass(plyID) then
		effectName = "particles/heroes/humei/ability_humei_03_attack.vpcf"
	else
		effectName = "particles/neutral_fx/black_dragon_attack.vpcf"
	end

	for i=1,4 do
		local swordTable = {
			Target = target,
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
			iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = i
		} 
		ProjectileManager:CreateTrackingProjectile(swordTable)
	end
end

function OnHumei03ProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		victim = target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags(),
		damage_percent = (keys.DamagePercent or 0)/100 + 1,
	}
	UnitDamageTarget(damage_table)
end

function OnHumei04Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint =  vecCaster + caster:GetForwardVector() --keys.target_points[1]
	local sparkRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local findVec = Vector(vecCaster.x + math.cos(sparkRad) * keys.DamageLenth/2,vecCaster.y + math.sin(sparkRad) * keys.DamageLenth/2,vecCaster.z)
	local findRadius = math.sqrt(((keys.DamageLenth/2)*(keys.DamageLenth/2) + (keys.DamageWidth/2)*(keys.DamageWidth/2)))
	local DamageTargets = FindUnitsInRadius(
		   caster:GetTeam(),		--caster team
		   findVec,		            --find position
		   nil,					    --find entity
		   findRadius,		            --find radius
		   DOTA_UNIT_TARGET_TEAM_ENEMY,
		   keys.ability:GetAbilityTargetType(),
		   0, FIND_CLOSEST,
		   false
	    )
	local deal_damage = 100
	for _,v in pairs(DamageTargets) do
		local vecV = v:GetOrigin()
		if(IsRadInRect(vecV,vecCaster,keys.DamageWidth,keys.DamageLenth,sparkRad))then
			local damage_table = {
				victim = v,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = 0,
				damage_percent = (keys.DamagePercent or 0)/100 + 1,
			}
			UnitDamageTarget(damage_table)
			UnitStunTarget(caster,v,0.2)
		end
	end
	HumeiSparkParticleControl(caster,targetPoint,keys.ability)
end

function OnHumei04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local unit = CreateUnitByName(
		"npc_dota2x_unit_marisa04_spark"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	caster.effectcircle = ParticleManager:CreateParticle("particles/heroes/marisa/marisa_04_spark_circle.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectcircle,false)
	caster.effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectIndex,false)
	caster.effectIndex_b = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04_spark_wind_b.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectIndex_b,false)
	keys.ability:SetContextNum("ability_marisa_04_spark_unit",unit:GetEntityIndex(),0)

	HumeiSparkParticleControl(caster,targetPoint,keys.ability)
	keys.ability:SetContextNum("ability_marisa_04_spark_lock",FALSE,0)
end

function HumeiSparkParticleControl(caster,targetPoint,ability)
	local unitIndex = ability:GetContext("ability_marisa_04_spark_unit") or -1
	local unit = EntIndexToHScript(unitIndex)
	if not unit then return end

	if(caster.targetPoint == targetPoint)then
		return
	else
		caster.targetPoint = targetPoint
	end

	if(caster.effectIndex_b ~= -1)then
		ParticleManager:DestroyParticleSystem(caster.effectIndex_b,true)
	end

	if(unit == nil or caster.effectIndex == -1 or caster.effectcircle == -1)then
		print(unit)
		print(caster.effectIndex)
		print(caster.effectcircle)
		return
	end

	local plyID =  caster:GetPlayerOwnerID()
	caster.effectIndex_b = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04_spark_wind_b.vpcf", PATTACH_CUSTOMORIGIN, unit)

	forwardRad = GetRadBetweenTwoVec2D(targetPoint,caster:GetOrigin()) 
	vecForward = Vector(math.cos(math.pi/2 + forwardRad),math.sin(math.pi/2 + forwardRad),0)
	unit:SetForwardVector(vecForward)
	vecUnit = caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,160)
	vecColor = Vector(255,255,255)
	unit:SetOrigin(vecUnit)

	ParticleManager:SetParticleControl(caster.effectcircle, 0, caster:GetOrigin())
	
	local effect2ForwardRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint) 
	local effect2VecForward = Vector(math.cos(effect2ForwardRad)*850,math.sin(effect2ForwardRad)*850,0) + caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108)
	
	ParticleManager:SetParticleControl(caster.effectIndex, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControl(caster.effectIndex, 1, effect2VecForward)
	ParticleManager:SetParticleControl(caster.effectIndex, 2, vecColor)
	local forwardRadwind = forwardRad + math.pi
	ParticleManager:SetParticleControl(caster.effectIndex, 8, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
	ParticleManager:SetParticleControl(caster.effectIndex, 9, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108))

	ParticleManager:SetParticleControl(caster.effectIndex_b, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControl(caster.effectIndex_b, 8, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
	ParticleManager:DestroyParticleSystem(caster.effectIndex_b,false)
end


function OnHumei04SpellThink(keys)
	if(keys.ability:GetContext("ability_marisa_04_spark_lock")==FALSE)then
		OnHumei04Think(keys)
	end
end

function OnHumei04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unitIndex = keys.ability:GetContext("ability_marisa_04_spark_unit")

	local unit = EntIndexToHScript(unitIndex)
	if(unit~=nil)then
		unit:RemoveSelf()
		caster.effectcircle = -1
		caster.effectIndex = -1
	end
	keys.ability:SetContextNum("ability_marisa_04_spark_lock",TRUE,0)
end

function OnHumei011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local targets = FindUnitsInRadius(
		   caster:GetTeam(),
		   targetPoint,
		   nil,
		   keys.radius,
		   DOTA_UNIT_TARGET_TEAM_ENEMY,
		   keys.ability:GetAbilityTargetType(),
		   0, 
		   FIND_CLOSEST,
		   false
	    )

	for k,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			ability = keys.ability,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = 0,
		}
		UnitDamageTarget(damage_table)
	end

	if caster:HasModifier("modifier_ability_humei_011_passive") then
		for k,v in pairs(targets) do
			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_shushan_humei011_frozen", {})
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_011_extra_main.vpcf",PATTACH_CUSTOMORIGIN,v)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(100,100,0))
			ParticleManager:SetParticleControl(effectIndex, 2, Vector(1,1,1))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
		caster:RemoveModifierByName("modifier_ability_humei_011_passive")
		caster:SetContextThink(DoUniqueString("modifier_ability_humei_011_passive"), 
			function()
	            if GameRules:IsGamePaused() then return 0.03 end
				keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_ability_humei_011_passive", {})
				return nil
			end, 
		5.0)
	end

	local chance = RandomInt(0,100)
	if chance <= 10 then
		if humei013Ability~=nil and humei013Ability:GetLevel()>0 and caster:HasModifier("modifier_ability_humei_013")==true then
			for k,v in pairs(targets) do
				keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_shushan_humei011_frozen", {})
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_011_extra_main.vpcf",PATTACH_CUSTOMORIGIN,v)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:SetParticleControl(effectIndex, 1, Vector(100,100,0))
				ParticleManager:SetParticleControl(effectIndex, 2, Vector(1,1,1))
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_011.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(500,500,0))
	ParticleManager:SetParticleControl(effectIndex, 2, Vector(1,1,1))
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	caster:EmitSound("shushan_humei.abilityhumei011")

	local humei013Ability = caster:FindAbilityByName("ability_hsj_humei013")
	if humei013Ability~=nil and humei013Ability:GetLevel()>0 and caster:HasModifier("modifier_ability_humei_013")==false then
		keys.ability:EndCooldown()
	end
end

function OnHumei012SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin() 
	local targetPoint = keys.target_points[1]
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local forwardVec = Vector( math.cos(pointRad) * 1500 , math.sin(pointRad) * 1500 , 0 ):Normalized()

	local BulletTable = {
	    Ability        	 	=   keys.ability,
		EffectName			=	"particles/heroes/humei/ability_humei_012_orb.vpcf",
		vSpawnOrigin		=	vecCaster + Vector(0,0,128),
		vSpawnOriginNew		=	vecCaster + Vector(0,0,128),
		fDistance			=	1000,
		fStartRadius		=	keys.radius,
		fEndRadius			=	keys.radius,
		Source         	 	=   caster,
		bHasFrontalCone		=	false,
		bRepalceExisting 	=  false,
		iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
		iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
		iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
		fExpireTime     =   GameRules:GetGameTime() + 10.0,
		bDeleteOnHit    =   true,
		vVelocity       =   forwardVec,
		bProvidesVision	=	true,
		iVisionRadius	=	400,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	caster:EmitSound("shushan_humei.abilityhumei012")

	ShushanCreateProjectileMoveToTargetPoint(BulletTable,caster,1500,-100,300,
		function(v)
			local targets = FindUnitsInRadius(
				   caster:GetTeam(),
				   v:GetOrigin(),
				   nil,
				   500,
				   DOTA_UNIT_TARGET_TEAM_ENEMY,
				   keys.ability:GetAbilityTargetType(),
				   0, 
				   FIND_CLOSEST,
				   false
			    )

			for k,v in pairs(targets) do
				local damage_table = {
					victim = v,
					attacker = caster,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = 0,
				}
				UnitDamageTarget(damage_table)
			end

			local chance = RandomInt(0,100)

			if chance <= 10 then
				for k,v in pairs(targets) do
					local time = 3.0
					v:SetContextThink(DoUniqueString("ability_humei012_fire"), 
						function()
				            if GameRules:IsGamePaused() then return 0.03 end
					        if time > 0 then
					        	time = time - 0.2
								local damage_table = {
									victim = v,
									attacker = caster,
									ability = keys.ability,
									damage_type = keys.ability:GetAbilityDamageType(), 
									damage_flags = 0,
								}
								UnitDamageTarget(damage_table)
								return 0.2
							else
								return nil
							end
						end, 
					0.2)
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_012.vpcf",PATTACH_CUSTOMORIGIN,v)
					ParticleManager:SetParticleControlEnt(effectIndex , 0, v, 5, "attach_hitloc", Vector(0,0,0), true)
					ParticleManager:DestroyParticleSystem(effectIndex,false)
				end
			end

			caster:EmitSound("shushan_humei.abilityhumei012_boom")
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_012_boom.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	)
	local humei013Ability = caster:FindAbilityByName("ability_hsj_humei013")
	if humei013Ability~=nil and humei013Ability:GetLevel()>0 and caster:HasModifier("modifier_ability_humei_013")==false then
		keys.ability:EndCooldown()
	end
end

function OnHumeiAttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local chance = RandomInt(0,100)
	if chance <= 50 then
		keys.ability = caster:FindAbilityByName("ability_hsj_humei011")
		keys.target_points[1] = keys.target:GetOrigin()
		keys.radius = 500
		OnHumei011SpellStart(keys)
	else
		keys.ability = caster:FindAbilityByName("ability_hsj_humei012")
		keys.radius = 120
		keys.target_points[1] = keys.target:GetOrigin()
		OnHumei012SpellStart(keys)
	end
end


function OnHumei013ProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage_table = {
		victim = target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
	caster:PerformAttack(target,false,true,true,false,false,false,true)
end


function OnHumei014Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint =  vecCaster + caster:GetForwardVector() --keys.target_points[1]
	local sparkRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local findVec = Vector(vecCaster.x + math.cos(sparkRad) * keys.DamageLenth/2,vecCaster.y + math.sin(sparkRad) * keys.DamageLenth/2,vecCaster.z)
	local findRadius = math.sqrt(((keys.DamageLenth/2)*(keys.DamageLenth/2) + (keys.DamageWidth/2)*(keys.DamageWidth/2)))
	local DamageTargets = FindUnitsInRadius(
		   caster:GetTeam(),		--caster team
		   findVec,		            --find position
		   nil,					    --find entity
		   findRadius,		            --find radius
		   DOTA_UNIT_TARGET_TEAM_ENEMY,
		   keys.ability:GetAbilityTargetType(),
		   0, FIND_CLOSEST,
		   false
	    )
	for _,v in pairs(DamageTargets) do
		local vecV = v:GetOrigin()
		if(IsRadInRect(vecV,vecCaster,keys.DamageWidth,keys.DamageLenth,sparkRad))then
			local damage_table = {
				victim = v,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = 0
			}
			UnitDamageTarget(damage_table)
			-- UnitStunTarget(caster,v,0.4)
			v:AddNewModifier(v, nil, "modifier_custom_stunned", {duration=0.4})
		end
	end
	HumeiSparkParticleControl(caster,targetPoint,keys.ability)
end

function OnHumei014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local unit = CreateUnitByName(
		"npc_dota2x_unit_marisa04_spark"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	caster.effectcircle = ParticleManager:CreateParticle("particles/heroes/marisa/marisa_04_spark_circle.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectcircle,false)
	caster.effectIndex = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectIndex,false)
	caster.effectIndex_b = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04_spark_wind_b.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:DestroyParticleSystem(caster.effectIndex_b,false)
	keys.ability:SetContextNum("ability_marisa_014_spark_unit",unit:GetEntityIndex(),0)

	Humei014SparkParticleControl(caster,targetPoint,keys.ability)
	keys.ability:SetContextNum("ability_marisa_014_spark_lock",FALSE,0)
end

function Humei014SparkParticleControl(caster,targetPoint,ability)
	local unitIndex = ability:GetContext("ability_marisa_014_spark_unit") or -1
	local unit = EntIndexToHScript(unitIndex)
	if not unit then return end

	if(caster.targetPoint == targetPoint)then
		return
	else
		caster.targetPoint = targetPoint
	end

	if(caster.effectIndex_b ~= -1)then
		ParticleManager:DestroyParticleSystem(caster.effectIndex_b,true)
	end

	if(unit == nil or caster.effectIndex == -1 or caster.effectcircle == -1)then
		return
	end

	local plyID =  caster:GetPlayerOwnerID()
	caster.effectIndex_b = ParticleManager:CreateParticle("particles/heroes/humei/ability_humei_04_spark_wind_b.vpcf", PATTACH_CUSTOMORIGIN, unit)

	forwardRad = GetRadBetweenTwoVec2D(targetPoint,caster:GetOrigin()) 
	vecForward = Vector(math.cos(math.pi/2 + forwardRad),math.sin(math.pi/2 + forwardRad),0)
	unit:SetForwardVector(vecForward)
	vecUnit = caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,160)
	vecColor = Vector(255,255,255)
	unit:SetOrigin(vecUnit)

	ParticleManager:SetParticleControl(caster.effectcircle, 0, caster:GetOrigin())
	
	local effect2ForwardRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint) 
	local effect2VecForward = Vector(math.cos(effect2ForwardRad)*850,math.sin(effect2ForwardRad)*850,0) + caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108)
	
	ParticleManager:SetParticleControl(caster.effectIndex, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControl(caster.effectIndex, 1, effect2VecForward)
	ParticleManager:SetParticleControl(caster.effectIndex, 2, vecColor)
	local forwardRadwind = forwardRad + math.pi
	ParticleManager:SetParticleControl(caster.effectIndex, 8, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
	ParticleManager:SetParticleControl(caster.effectIndex, 9, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108))

	ParticleManager:SetParticleControl(caster.effectIndex_b, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControl(caster.effectIndex_b, 8, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
	ParticleManager:DestroyParticleSystem(caster.effectIndex_b,false)
end


function OnHumei014SpellThink(keys)
	if(keys.ability:GetContext("ability_marisa_014_spark_lock")==FALSE)then
		OnHumei014Think(keys)
	end
end

function OnHumei014SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unitIndex = keys.ability:GetContext("ability_marisa_014_spark_unit")

	local unit = EntIndexToHScript(unitIndex)
	if(unit~=nil)then
		unit:RemoveSelf()
		caster.effectcircle = -1
		caster.effectIndex = -1
	end
	keys.ability:SetContextNum("ability_marisa_014_spark_lock",TRUE,0)
end