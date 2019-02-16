function OnMuyue011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin() 
	local targetPoint = keys.target_points[1]
	local ability = keys.ability

	if GetDistanceBetweenTwoVec2D(vecCaster,targetPoint) > ability:GetCastRange() then 
		ability:EndCooldown() 
		return 
	end

	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local forwardVec = Vector( math.cos(pointRad) * 1500 , math.sin(pointRad) * 1500 , 0 ):Normalized()

	caster:EmitSound("shushan_mengyan.abilitymuyue011_whirling")
	caster:EmitSound("shushan_mengyan.abilitymuyue011_blink_out")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shushan_muyue011_pause", {})
	caster:SetForwardVector(Vector(math.cos(pointRad),math.sin(pointRad),0))
	caster:RemoveGesture(ACT_DOTA_CHANNEL_END_ABILITY_1)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:AddNoDraw()

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_011_blink.vpcf",PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex)

	local BulletTable = {
	    Ability        	 	=   keys.ability,
		EffectName			=	"particles/heroes/muyue/ability_muyue_011.vpcf",
		vSpawnOrigin		=	vecCaster,
		vSpawnOriginNew		=	vecCaster,
		fDistance			=	5000,
		fStartRadius		=	300,
		fEndRadius			=	300,
		Source         	 	=   caster,
		bHasFrontalCone		=	false,
		bRepalceExisting 	=  	false,
		iUnitTargetTeams	=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
		iUnitTargetTypes	=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
		iUnitTargetFlags	=	"DOTA_UNIT_TARGET_FLAG_NONE",
		fExpireTime     	=   GameRules:GetGameTime() + 10.0,
		bDeleteOnHit    	=   true,
		vVelocity       	=   forwardVec,
		bProvidesVision		=	true,
		iVisionRadius		=	400,
		iVisionTeamNumber 	= 	caster:GetTeamNumber()
	}

	local speed = 2000
    local high = targetPoint.z - vecCaster.z
	local upSpeed = math.max(high/128*50,50)

	ShushanCreateProjectileThrowToTargetPoint(BulletTable,caster,targetPoint,speed,-upSpeed,
		function(targets)
			caster:RemoveNoDraw()
			caster:RemoveModifierByName("modifier_shushan_muyue011_pause")
    		caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
			if targets~=nil and #targets ~= 0 then
				for k,v in pairs(targets) do
					if v~=nil and v:IsNull()==false then
						local findName = string.find(v:GetUnitName(),"boss")
						if findName~=nil or v.__is_elite==true then
							OnMuyue011KillBoss(caster,v,ability)
							return
						end
					end
				end
				ability:StartCooldown(5.0)
				OnMuyue011DamageUnits(caster,targets,targetPoint,ability)
			else
				ability:EndCooldown()
				if IsAroundBlock(targetPoint)==true then
					OnMuyue011Rest(caster,targetPoint,ability)
				elseif GridNav:IsBlocked(targetPoint)==false and GridNav:IsTraversable(targetPoint) then
					OnMuyue011DamageUnits(caster,targets,targetPoint,ability)
				else
					if caster:HasModifier("modifier_shushan_muyue011_wall") then
						caster:StartGesture(ACT_DOTA_CHANNEL_END_ABILITY_1)
					end
				end
			end
		end
	)
end

function OnMuyue011Rest(caster,targetPoint,ability)
	FindClearSpaceForUnit(caster,targetPoint,false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shushan_muyue011_wall", {})
	caster:StartGesture(ACT_DOTA_CHANNEL_END_ABILITY_1)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_011_blink_wall.vpcf",PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex)
	caster:EmitSound("shushan_mengyan.abilitymuyue011_blink_in")
end

function OnMuyue011DamageUnits(caster,targets,targetPoint,ability)
	local pointRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	caster:SetOrigin(targetPoint)
	FindClearSpaceForUnit(caster,targetPoint,false)
	caster:RemoveModifierByName("modifier_shushan_muyue011_wall")
    caster:RemoveGesture(ACT_DOTA_CHANNEL_END_ABILITY_1)
    caster:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
	caster:SetForwardVector(Vector(math.cos(pointRad),math.sin(pointRad),0))
	caster:Stop()

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_011_blink_end.vpcf",PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex)
	caster:EmitSound("shushan_mengyan.abilitymuyue011_blink_in")

	for k,v in pairs(targets) do
		local damage_table = {
			ability= ability,
			victim = v,
			attacker = caster,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(), 
		    damage_flags = ability:GetAbilityTargetFlags(),
		}
		UnitDamageTarget(damage_table) 
	end
end

function Muyue011GetMovePath(vecCaster,bossForward)
	local baseDistance = 500

	for i=1,baseDistance do
		if GridNav:CanFindPath(vecCaster,vecCaster+bossForward*(baseDistance-i)) then
			return baseDistance-i
		end
	end

	return 0
end

function OnMuyue011KillBoss(caster,v,ability)
	local bossForward = v:GetForwardVector()
	local vecTarget = v:GetOrigin()

	caster:SetOrigin(v:GetOrigin()-bossForward*100+Vector(0,0,256))
	caster:SetForwardVector(bossForward)
	caster:RemoveModifierByName("modifier_shushan_muyue011_wall")
    caster:RemoveGesture(ACT_DOTA_CHANNEL_END_ABILITY_1)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shushan_muyue011_pause", {})
	ability:ApplyDataDrivenModifier(caster, v, "modifier_shushan_muyue011_target", {})
	v:StartGesture(ACT_DOTA_DIE)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_011_blink_kill.vpcf",PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex)
	caster:EmitSound("shushan_mengyan.abilitymuyue011_blink_in")
	caster:EmitSound("shushan_mengyan.abilitymuyue011_kill")
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))

	caster:SetContextThink(DoUniqueString("OnMuyue011KillBoss"), 
		function()
			local targetPoint = v:GetOrigin()-bossForward*Muyue011GetMovePath(caster:GetOrigin(),bossForward)
    		local high = targetPoint.z - caster:GetOrigin().z
			local upSpeed = math.max(high/128*50,50)

			local damage_table = {
				victim = v,
				attacker = caster,
				ability = ability,
				damage_type = ability:GetAbilityDamageType(), 
				damage_flags = 0,
			}
			UnitDamageTarget(damage_table)

			MoveUnitToTargetPointJump(caster,targetPoint,2000,upSpeed,
				function()
					caster:RemoveModifierByName("modifier_shushan_muyue011_pause")
					caster:Stop()
					if v~=nil and v:IsNull() == false and v:IsAlive() then
						caster:MoveToPositionAggressive(vecTarget)
					end
				end)
			local time = 2.0
			if v~=nil and v:IsNull() == false then
				v:SetContextThink(DoUniqueString("modifier_shushan_muyue011_target"), 
					function() 
						if GameRules:IsGamePaused() then return 0.03 end
						time = time - 0.2
						if time <= 0 then
							v:RemoveModifierByName("modifier_shushan_muyue011_target")
							v:RemoveGesture(ACT_DOTA_DIE)
							return nil
						end
						return 0.2
					end,
				0.2)
			end
			return nil
		end,
	0.7)
end

function OnMuyue012AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local vecCaster = caster:GetOrigin()
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,target:GetOrigin())

	local chance = RandomInt(0,100)

	if chance>=keys.chance then
		return
	end

	if caster.ability_muyue_012_count == nil then
		caster.ability_muyue_012_count = 1
	end

	if caster.ability_muyue_012_count > 3 then
		caster.ability_muyue_012_count = 1
	else
		caster.ability_muyue_012_count = caster.ability_muyue_012_count + 1
	end

	local count = caster.ability_muyue_012_count

	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,(1/caster:GetBaseAttackTime())*100/caster:GetAttackSpeed())

	target:SetContextThink(DoUniqueString("OnTianchen015SpellStart_timer"), 
		function()
			count = count - 1
			if count >= 0 then
				caster:EmitSound("shushan_mengyan.abilitymuyue012_shot")
				local randomPi = RandomFloat(-2*math.pi,2*math.pi)
				local forwardVec = Vector(math.cos(pointRad+randomPi), math.sin(pointRad+randomPi),RandomFloat(0,1))

				local BulletTable = {
				    Ability        	 	=   keys.ability,
					EffectName			=	"particles/heroes/muyue/ability_muyue_012.vpcf",
					vSpawnOrigin		=	vecCaster,
					vSpawnOriginNew		=	vecCaster,
					fDistance			=	5000,
					fStartRadius		=	60,
					fEndRadius			=	60,
					Source         	 	=   caster,
					bHasFrontalCone		=	false,
					bRepalceExisting 	=  	false,
					iUnitTargetTeams	=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
					iUnitTargetTypes	=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
					iUnitTargetFlags	=	"DOTA_UNIT_TARGET_FLAG_NONE",
					fExpireTime     	=   GameRules:GetGameTime() + 10.0,
					bDeleteOnHit    	=   true,
					vVelocity       	=   forwardVec,
					bProvidesVision		=	true,
					iVisionRadius		=	400,
					iVisionTeamNumber 	= 	caster:GetTeamNumber(),
				}

				local speed = 2000
				local acc = 200
				local iVelo = 1000

				ShushanCreateProjectileMoveToTarget(BulletTable,caster,target,speed,iVelo,-acc,
					function(v)
						if v:IsNull()==false and v~=nil then
							local damage_table = {
								victim = v,
								attacker = caster,
								ability = keys.ability,
								damage_type = keys.ability:GetAbilityDamageType(), 
								damage_flags = 0,
							}
							UnitDamageTarget(damage_table)
							caster:PerformAttack(keys.target,false,true,true,false,false,false,true)
							caster:EmitSound("shushan_mengyan.abilitymuyue012_hit")
						end
					end
				)
				return 0.1
			else
				return nil
			end
		end,
	0.1)
end


function OnMuyue013SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin() 
	local targetPoint = keys.target_points[1]
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)

	local maxRad = math.pi*150/180
	
	caster:EmitSound("shushan_mengyan.abilitymuyue012_shot")

	for i=0,6 do
		local forwardVec = Vector(math.cos(pointRad-maxRad/2+maxRad/6*i)*1500,math.sin(pointRad-maxRad/2+maxRad/6*i)*1500,0):Normalized()

		local BulletTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/heroes/muyue/ability_muyue_012.vpcf",
			vSpawnOrigin		=	vecCaster,
			vSpawnOriginNew		=	vecCaster,
			fDistance			=	5000,
			fStartRadius		=	120,
			fEndRadius			=	120,
			Source         	 	=   caster,
			bHasFrontalCone		=	false,
			bRepalceExisting 	=  false,
			iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
			iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
			iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
			fExpireTime     =   GameRules:GetGameTime() + 10.0,
			bDeleteOnHit    =   false,
			vVelocity       =   forwardVec,
			bProvidesVision	=	true,
			iVisionRadius	=	400,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iReflexCount = 0,
			bReflexByBlock = true,
		}

		ShushanCreateProjectileMoveToTargetPoint(BulletTable,caster,2000,0,0,
			function(v,vecProjectile,reflexCount)
				if v:IsNull()==false and v~=nil then
					if v:GetUnitName() == "LV13_fb_20_boss_fushuizhifeng" and vecProjectile.z >= 456 then
						return
					end

					local reflexDamageIncrease = math.min(reflexCount,10)
					reflexDamageIncrease = math.max(reflexCount,1)
					local damage_table = {
						victim = v,
						attacker = caster,
						ability = keys.ability,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = keys.ability:GetAbilityTargetFlags(),
		    			damage_percent = reflexDamageIncrease,
					}
					UnitDamageTarget(damage_table)
					caster:PerformAttack(keys.target,false,true,true,false,false,false,true)
					caster:EmitSound("shushan_mengyan.abilitymuyue012_hit")
				end
			end
		)
	end
end

function OnMuyue014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local ability = keys.ability
	local time = 3.0

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_014_aeons.vpcf",PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,1,Vector(500,500,500))
	ParticleManager:DestroyParticleSystemTime(effectIndex,3.0)

	local hitblockTag = DoUniqueString("hitblock")

	local hitblock = {
		circlePoint = vecCaster,
		radius = 500,
		tag = hitblockTag,
	}
	table.insert(Shushan_Custom_Hit_Block,hitblock)

	caster:EmitSound("shushan_mengyan.abilitymuyue014")

	caster:SetContextThink(DoUniqueString("modifier_shushan_muyue014"), 
		function() 
			if GameRules:IsGamePaused() then return 0.03 end
			time = time - 0.03
			if time > 0 then
				local targets = FindUnitsInRadius(
			        caster:GetTeam(),       --caster team
			        vecCaster,                    --find position
			        nil,                    --find entity
			        500,       --find radius
			        ability:GetAbilityTargetTeam(),
			        ability:GetAbilityTargetType(),
			        ability:GetAbilityTargetFlags(), 
			        FIND_CLOSEST,
			        false
			    )
				for k,v in pairs(targets) do
					if v:HasModifier("modifier_ability_shushan_muyue014")==false then
			    		ability:ApplyDataDrivenModifier(caster, v, "modifier_ability_shushan_muyue014", {})
			    	end
			    end
			else
				local targets = FindUnitsInRadius(
			        caster:GetTeam(),       --caster team
			        vecCaster,                    --find position
			        nil,                    --find entity
			        500,       --find radius
			        ability:GetAbilityTargetTeam(),
			        ability:GetAbilityTargetType(),
			        ability:GetAbilityTargetFlags(), 
			        FIND_CLOSEST,
			        false
			    )
				for k,v in pairs(targets) do
					v:RemoveModifierByName("modifier_ability_shushan_muyue014")
					local damage_table = {
						victim = v,
						attacker = caster,
						ability = keys.ability,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = keys.ability:GetAbilityTargetFlags(),
					}
					UnitDamageTarget(damage_table)
			    end
			    for index,block in pairs(Shushan_Custom_Hit_Block) do
					if block.tag == hitblockTag then
						table.remove(Shushan_Custom_Hit_Block,index)
					end
				end
				return nil
			end
			return 0.03
		end,
	0.03)
end