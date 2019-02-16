function OnMengyan011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	local target = keys.target

	ability:ApplyDataDrivenModifier(caster,caster,"modifier_shushan_mengyan011_action", {})
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_shushan_mengyan011_pause", {})

	caster:EmitSound("shushan_mengyan.abilitymengyan011_jump")

	local high = (target:GetOrigin().z-caster:GetOrigin().z)
	local vUp = math.max(high/128*50,50)

	caster.__ability_mengyan_011_end = false

	caster:SetContextThink(DoUniqueString("OnMengyan011SpellStart_effect"),
		function ()
            if GameRules:IsGamePaused() then return 0.03 end
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_011_dash.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
			ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
			ParticleManager:DestroyParticleSystemTime(effectIndex,0.03)
			if caster.__ability_mengyan_011_end == true then
				return nil
			else
				return 0.03
			end
		end, 
	0.03)
	MoveUnitToTargetJump(caster,target,1500,vUp,
		function()
			local damage_table = {
				victim = keys.target,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags(),
	    		damage_percent = 1,
			}

			if high < 0 then
				local damage_max = math.min(-high/32,20)
				local damage_min = math.max(1,damage_max)
				damage_table.damage_percent = damage_min
			end
			caster:PerformAttack(keys.target,false,true,true,false,false,false,true)
			caster:EmitSound("shushan_mengyan.abilitymengyan011")

			UnitDamageTarget(damage_table) 
			caster.__ability_mengyan_011_end = true
			caster:RemoveModifierByName("modifier_shushan_mengyan011_pause")

			local effectIndex_end = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_011_end.vpcf",PATTACH_CUSTOMORIGIN,target)
			ParticleManager:SetParticleControlEnt(effectIndex_end , 0, target, 5, "attach_origin", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(effectIndex_end , 1, target, 5, "attach_origin", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(effectIndex_end , 3, target, 5, "attach_origin", Vector(0,0,0), true)
			ParticleManager:DestroyParticleSystemTime(effectIndex_end,3.0)
			local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_011_sword.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "attach_origin", Vector(0,0,0), true)
			ParticleManager:DestroyParticleSystem(effectIndex2)
		end)
end

function OnMengyan012AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	local target = keys.target

	caster:EmitSound("shushan_mengyan.abilitymengyan012")

	local chance = RandomInt(0,20)
	if chance<=10 and IsMengyanSwordOpen(caster) == false then
		UnitStunTarget( caster,target,keys.stun_duration)
		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,(2.0/caster:GetBaseAttackTime())*100/caster:GetAttackSpeed())
		local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_012_stun.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystemTime(effectIndex2,2.0)
	elseif IsMengyanSwordOpen(caster) == true then
		local count = 4
		caster:SetContextThink(DoUniqueString("OnMengyan012AttackStart"),
			function ()
            	if GameRules:IsGamePaused() then return 0.03 end
            	if count > 0 then
            		count = count - 1
            		local targets = FindUnitsInRadius(
						caster:GetTeam(),		
						caster:GetOrigin(),		
						nil,					
						500,				
					    DOTA_UNIT_TARGET_TEAM_ENEMY,
						ability:GetAbilityTargetType(),
						0, 
						FIND_ANY_ORDER,
						false
					)
					for k,v in pairs(targets) do
						local damage_table = {
							victim = v,
							attacker = caster,
							ability = keys.ability,
							damage_type = keys.ability:GetAbilityDamageType(), 
						    damage_flags = keys.ability:GetAbilityTargetFlags(),
						}
						UnitDamageTarget(damage_table) 
					end
					
					return 0.1
				else
					return nil
				end
			end, 
		0.1)
		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,(1/caster:GetBaseAttackTime())*100/caster:GetAttackSpeed())
		
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_012_sword.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControl(effectIndex,1,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControl(effectIndex,2,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControlForward(effectIndex, 2, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex,3,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControlForward(effectIndex, 3, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex,4,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControlForward(effectIndex, 4, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex,5,caster:GetOrigin()+Vector(0,0,80))
		ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
	end
end

function IsMengyanSwordOpen(caster)
	if caster:HasModifier("modifier_shushan_mengyan011_action") then
		return true
	end
	return false
end

function OnMengyan013SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability

	if IsMengyanSwordOpen(caster) == false then

		caster:SetContextThink(DoUniqueString("OnMengyan011SpellStart_effect"),
			function ()
	            if GameRules:IsGamePaused() then return 0.03 end
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/mengyan/abillity_mengyan_013.vpcf",PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
				ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
				local ability01 = caster:FindAbilityByName("ability_shushan_mengyan011")
				ability01:ApplyDataDrivenModifier(caster,caster,"modifier_shushan_mengyan011_action", {})
				local targets = FindUnitsInRadius(
					caster:GetTeam(),		
					caster:GetOrigin(),		
					nil,					
					500,				
				    DOTA_UNIT_TARGET_TEAM_ENEMY,
					ability:GetAbilityTargetType(),
					0, 
					FIND_ANY_ORDER,
					false
				)
				for k,v in pairs(targets) do
					local damage_table = {
						victim = v,
						attacker = caster,
						ability = keys.ability,
						damage_type = keys.ability:GetAbilityDamageType(), 
					    damage_flags = keys.ability:GetAbilityTargetFlags(),
					}
					UnitDamageTarget(damage_table) 
					UnitStunTarget(caster,v,3.0)
				end

				caster:EmitSound("shushan_mengyan.abilitymengyan013_clap")
				return nil
			end,
		0.3)
	elseif IsMengyanSwordOpen(caster) == true then
		local count = 3

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

		caster:SetContextThink(DoUniqueString("OnMengyan011SpellStart_effect"),
			function ()
	            if GameRules:IsGamePaused() then return 0.03 end
	            if count > 0 then
	            	count = count -1

	            	MoveUnitToFaceFixedTime(caster,600,0.3,
						function()
							local randomvec = RandomVector(1)
							local effectIndex = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_013_sword_open.vpcf",PATTACH_CUSTOMORIGIN,caster)
							ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin()+Vector(0,0,80))
							ParticleManager:SetParticleControl(effectIndex,1,caster:GetOrigin()+Vector(0,0,80))
							ParticleManager:SetParticleControl(effectIndex,2,caster:GetOrigin()+Vector(0,0,80))
							ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)

							local targets = FindUnitsInRadius(
								caster:GetTeam(),		
								caster:GetOrigin(),		
								nil,					
								500,				
							    DOTA_UNIT_TARGET_TEAM_ENEMY,
								ability:GetAbilityTargetType(),
								0, 
								FIND_ANY_ORDER,
								false
							)
							for k,v in pairs(targets) do
								local damage_table = {
									victim = v,
									attacker = caster,
									ability = keys.ability,
									damage_type = keys.ability:GetAbilityDamageType(), 
								    damage_flags = keys.ability:GetAbilityTargetFlags(),
								}
								UnitDamageTarget(damage_table) 
							end

							caster:EmitSound("shushan_mengyan.abilitymengyan013")
						end
					)

					return 0.3
				else
					return nil
				end
			end, 
		0.0)
	end
end

function OnMengyan014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local ability = keys.ability

	ability:ApplyDataDrivenModifier(caster,target,"modifier_shushan_mengyan014_target_pause", {})
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_shushan_mengyan014_pause", {})

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

	local count = 3.5
	local isStep2End = false
	caster.__ability_mengyan_014_end = false


	caster:SetContextThink(DoUniqueString("OnMengyan011SpellStart_effect"),
		function ()
            if GameRules:IsGamePaused() then return 0.03 end

            if target:IsNull() or target == nil then 
            	caster:RemoveModifierByName("modifier_shushan_mengyan014_pause")
            	if caster:HasModifier("modifier_shushan_mengyan011_action") then
					caster:RemoveModifierByName("modifier_shushan_mengyan011_action")
				end
            	return nil
            end

            if count > 1.6 then
				target:RemoveGesture(ACT_DOTA_DIE)
            	target:StartGesture(ACT_DOTA_DIE)
            	local effectIndex = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_014.vpcf",PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
				ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
				caster:EmitSound("shushan_mengyan.abilitymengyan014")
            elseif count <= 1.6 and count > 0 and isStep2End == false then
            	isStep2End = true
            	caster:SetContextThink(DoUniqueString("OnMengyan014SpellStart_effect"),
					function ()
			            if GameRules:IsGamePaused() then return 0.03 end
						local effectIndex_dash = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_011_dash.vpcf",PATTACH_CUSTOMORIGIN,caster)
						ParticleManager:SetParticleControl(effectIndex_dash,0,caster:GetOrigin())
						ParticleManager:SetParticleControlForward(effectIndex_dash,0,caster:GetForwardVector())
						ParticleManager:DestroyParticleSystemTime(effectIndex_dash,0.03)
						if caster.__ability_mengyan_014_end == true then
							return nil
						else
							return 0.03
						end
					end, 
				0.03)
				local effectIndex_soul = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_01_xiqv_soul.vpcf",PATTACH_CUSTOMORIGIN,target)
				ParticleManager:SetParticleControl(effectIndex_soul,0,target:GetOrigin())
				ParticleManager:DestroyParticleSystemTime(effectIndex_soul,2.0)

				local face = (target:GetOrigin() - caster:GetOrigin()):Normalized()
				MoveUnitToTargetPoint(caster,target:GetOrigin()+face*300,1500,
	            	function()
	            		caster.__ability_mengyan_014_end = true
	            	end
	            )
	            caster:EmitSound("shushan_mengyan.abilitymengyan014_void")
            elseif count <= 0 then
            	local effectIndex_end = ParticleManager:CreateParticle("particles/heroes/mengyan/ability_mengyan_014_end.vpcf",PATTACH_CUSTOMORIGIN,target)
				ParticleManager:SetParticleControl(effectIndex_end,0,target:GetOrigin())
				ParticleManager:DestroyParticleSystemTime(effectIndex_end,2.0)
				target:RemoveGesture(ACT_DOTA_DIE)
				caster:RemoveModifierByName("modifier_shushan_mengyan014_pause")
				target:RemoveModifierByName("modifier_shushan_mengyan014_target_pause")

				if caster:HasModifier("modifier_shushan_mengyan011_action") then
					caster:RemoveModifierByName("modifier_shushan_mengyan011_action")
				end

				local damage_table = {
					victim = target,
					attacker = caster,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
				    damage_flags = keys.ability:GetAbilityTargetFlags(),
				}
				damage_table.damage_percent = 1 + 2 * (1 - target:GetHealth() / target:GetMaxHealth())
				caster:PerformAttack(target,false,true,true,false,false,false,true)
				UnitDamageTarget(damage_table) 
				caster:EmitSound("shushan_mengyan.abilitymengyan014_end")

				return nil
			end

			count = count - 0.2
			return 0.2
		end, 
	0.0)
end