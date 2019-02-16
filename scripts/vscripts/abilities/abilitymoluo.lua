function OnMoluo01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth() * 0.25)
	local deal_damage = 100
	local damage_table = {
				ability=keys.ability,
				victim = keys.target,
				attacker = caster,
				damage = deal_damage,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags(),
			    damage_percent = (keys.DamagePercent or 0)/100 + 1,
			}
	UnitDamageTarget(damage_table) 
	caster:SetBaseStrength(caster:GetBaseStrength() + 1)
	local plyID =  caster:GetPlayerOwnerID()
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo01_explosion_vip.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 2, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlForward(effectIndex, 2, caster:GetForwardVector())
	ParticleManager:SetParticleControlEnt(effectIndex , 5, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 7, caster, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 10, caster, 5, "absorigin", Vector(0,0,0), true)
end

function OnMoluo02Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local plyID =  caster:GetPlayerOwnerID()
	local effectIndex

	effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo02_effect_on_vip.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "absorigin", Vector(0,0,0), true)
	caster.ability_hsj_moluo_02_effect = effectIndex
end

function OnMoluo02Toggle(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				ability=keys.ability,
				victim = v,
				attacker = caster,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags(),
			    damage_percent = (keys.DamagePercent or 0)/100 + 1,
			}
		UnitDamageTarget(damage_table) 
	end
	local damage_table_caster = {
		ability=keys.ability,
		victim = caster,
		attacker = caster,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = keys.ability:GetAbilityTargetFlags(),
		damage_percent = 0.02,
	}
	UnitDamageTarget(damage_table_caster) 
end

function OffMoluo02Toggle(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	ParticleManager:DestroyParticle(caster.ability_hsj_moluo_02_effect,false)
end

function OnMoluo03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities

	if keys.ability == nil then
		caster:RemoveModifierByName("passive_moluo03_attack")
	end

	local deal_damage = 100
	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		local effectIndex1 = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_03_sword.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControl(effectIndex1,0,caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex1,1,caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex1,2,caster:GetOrigin())
		ParticleManager:SetParticleControlForward(effectIndex1, 2, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex1,3,caster:GetOrigin())
		ParticleManager:SetParticleControlForward(effectIndex1, 3, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex1,4,caster:GetOrigin())
		ParticleManager:SetParticleControlForward(effectIndex1, 4, RandomVector(1))
		ParticleManager:SetParticleControl(effectIndex1,5,caster:GetOrigin())
	end

	for _,v in pairs(targets) do
		local damage_table = {
				ability=keys.ability,
			    victim = v,
			    attacker = caster,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = keys.ability:GetAbilityTargetFlags(),
	    	    damage_percent = (keys.DamagePercent or 0)/100 + 1,
		}
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo03_explosion.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,v)
		ParticleManager:SetParticleControl(effectIndex,0,v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,3,v:GetOrigin())
	end
end

function OnMoluo04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex
	local effectIndex2

	effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_03_weapon.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)

	effectIndex2 = ParticleManager:CreateParticle("particles/heroes/minamitsu/ability_minamitsu_03_body.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 3, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 4, caster, 5, "follow_origin", Vector(0,0,0), true)

	caster:SetRenderColor(255, 0, 0)
	caster:SetCustomAttribute("str",'OnMoluo04SpellStart',caster:GetBaseStrength()*2)
	caster:SetCustomAttribute("agi",'OnMoluo04SpellStart',caster:GetBaseAgility()*2)
	caster:SetCustomAttribute("int",'OnMoluo04SpellStart',caster:GetBaseIntellect()*2)
	Wait('ability_lixinning03_sword_release', caster, keys.Duration,
			function()
				caster:SetRenderColor(255, 255, 255)
				caster:SetCustomAttribute("str",'OnMoluo04SpellStart',0)
				caster:SetCustomAttribute("agi",'OnMoluo04SpellStart',0)
				caster:SetCustomAttribute("int",'OnMoluo04SpellStart',0)
				ParticleManager:DestroyParticle(effectIndex,true)
				ParticleManager:DestroyParticle(effectIndex2,true)
			end
	    )
end

function OnMoluo011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local count = keys.count
	local radius = keys.radius
	local ability = keys.ability
	local group = {}

	caster.__ability_moluo_011_end = false

	caster:SetContextThink(DoUniqueString("OnMoluo011SpellStart_effect"),
		function ()
            if GameRules:IsGamePaused() then return 0.03 end
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_011.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
			ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
			ParticleManager:DestroyParticleSystemTime(effectIndex,0.5)
			if caster.__ability_moluo_011_end == true then
				return nil
			else
				return 0.1
			end
		end, 
	0.1)

	PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
	OnMoluo011DashToUnit(caster,target,ability,radius,count,group,target,target:GetOrigin())
end

function OnMoluo011DashToUnit(caster,target,ability,radius,count,group,origintarget,finalOrigin)
	if target:IsNull()==false and target~=nil and count>0 then
		MoveUnitToTarget(caster,target,3000,
			function()
				caster:EmitSound("shushan_moluo.abilitymoluo011")
				local damage_table={
					ability=ability,
					victim=target, 
					attacker=caster, 
					damage_type=ability:GetAbilityDamageType(),
					damage_flags=ability:GetAbilityTargetFlags()
				}
				UnitDamageTarget(damage_table)
				caster:EmitSound("shushan_moluo.abilitymoluo012")
				caster:PerformAttack(targets,false,true,false,false,false,false,false)

				local targets = FindUnitsInRadius(
					caster:GetTeam(),		
					caster:GetOrigin(),		
					nil,					
					radius,				
				    DOTA_UNIT_TARGET_TEAM_ENEMY,
					ability:GetAbilityTargetType(),
					0, 
					FIND_ANY_ORDER,
					false
				)

				local isEnd = true
				for k,unit in pairs(targets) do
					if unit:IsNull() == false and unit ~= nil then
						if OnMoluo011IsUnitInGroup(unit,group) == false then
							table.insert(group,unit)
							count = count - 1
							caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
							caster:SetForwardVector((unit:GetOrigin()-caster:GetOrigin()):Normalized())
							OnMoluo011DashToUnit(caster,unit,ability,radius,count,group,origintarget,finalOrigin)
							isEnd = false
							break
						end
					end
				end
				if isEnd == true then
					caster:RemoveModifierByName("modifier_ability_shushan_moluo011_master")
					caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
					caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
					caster.__ability_moluo_011_end = true
					if origintarget:IsNull()==false and origintarget~=nil then
						FindClearSpaceForUnit(caster, origintarget:GetOrigin(), false)
					else
						FindClearSpaceForUnit(caster, finalOrigin, false)
					end
					caster:SetContextThink(DoUniqueString("OnMoluo011SpellStart_camera"),
						function()
							PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
							if origintarget:IsNull()==false and origintarget~=nil then
								local damage_table={
									ability=ability,
									victim=origintarget, 
									attacker=caster, 
									damage_type=ability:GetAbilityDamageType(),
									damage_flags=ability:GetAbilityTargetFlags()
								}
								UnitDamageTarget(damage_table)
								caster:EmitSound("shushan_moluo.abilitymoluo012")
								caster:PerformAttack(targets,false,true,false,false,false,false,false)
								local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012_end.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,origintarget)
								ParticleManager:SetParticleControl(effectIndex,0,origintarget:GetOrigin())
								ParticleManager:SetParticleControl(effectIndex,1,origintarget:GetOrigin())
								ParticleManager:SetParticleControl(effectIndex,4,origintarget:GetOrigin())
								ParticleManager:DestroyParticleSystem(effectIndex)
							else
								local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012_end.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
								ParticleManager:SetParticleControl(effectIndex,0,finalOrigin)
								ParticleManager:SetParticleControl(effectIndex,1,finalOrigin)
								ParticleManager:SetParticleControl(effectIndex,4,finalOrigin)
								ParticleManager:DestroyParticleSystem(effectIndex)
							end
						end,
					0.5)
				end
			end
		)
	else
		caster:RemoveModifierByName("modifier_ability_shushan_moluo011_master")
		caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
		caster.__ability_moluo_011_end = true
		if origintarget:IsNull()==false and origintarget~=nil then
			FindClearSpaceForUnit(caster, origintarget:GetOrigin(), false)
		else
			FindClearSpaceForUnit(caster, finalOrigin, false)
		end
		caster:SetContextThink(DoUniqueString("OnMoluo011SpellStart_camera"),
			function()
				PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
				if origintarget:IsNull()==false and origintarget~=nil then
					local damage_table={
						ability=ability,
						victim=origintarget, 
						attacker=caster, 
						damage_type=ability:GetAbilityDamageType(),
						damage_flags=ability:GetAbilityTargetFlags()
					}
					UnitDamageTarget(damage_table)
					caster:PerformAttack(targets,false,true,false,false,false,false,false)
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012_end.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,origintarget)
					ParticleManager:SetParticleControl(effectIndex,0,origintarget:GetOrigin())
					ParticleManager:SetParticleControl(effectIndex,1,origintarget:GetOrigin())
					ParticleManager:SetParticleControl(effectIndex,4,origintarget:GetOrigin())
					ParticleManager:DestroyParticleSystem(effectIndex)
				else
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012_end.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
					ParticleManager:SetParticleControl(effectIndex,0,finalOrigin)
					ParticleManager:SetParticleControl(effectIndex,1,finalOrigin)
					ParticleManager:SetParticleControl(effectIndex,4,finalOrigin)
					ParticleManager:DestroyParticleSystem(effectIndex)
				end
			end,
		0.5)
	end
end

function OnMoluo011IsUnitInGroup(unit,group)
	for k,v in pairs(group) do
		if v:IsNull() == false and v ~= nil then
			if unit == v then
				return true
			end
		end
	end
	return false
end


function OnMoluo012AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local ability = keys.ability

	local damage_table={
			ability = keys.ability,
			victim=target, 
			attacker=caster, 
			damage_type=ability:GetAbilityDamageType(),
			damage_flags=ability:GetAbilityTargetFlags()
		}
	UnitDamageTarget(damage_table)
	caster:EmitSound("shushan_moluo.abilitymoluo012")

	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,(1/caster:GetBaseAttackTime())*100/caster:GetAttackSpeed())

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012_end.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target)
	ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,1,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,4,target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex)

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_012.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2 , 0, caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex2, 0, caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex2)
end

function OnMoluo013SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_013_circle.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(effectIndex,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,3,caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,4,caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,5)

	local origin = caster:GetOrigin()

	local count = 10
	caster:SetContextThink(DoUniqueString("OnMoluo013SpellStart"), 
		function()
            if GameRules:IsGamePaused() then return 0.03 end
			OnMoluo013AbsorbSoul(caster,keys.ability,keys.radius,origin)
			if count > 0 then
				count = count - 1
				return 0.5
			else
				return nil
			end
		end, 
	0.5)
end

function OnMoluo013AbsorbSoul(caster,ability,radius,origin)
	local targets = FindUnitsInRadius(
		caster:GetTeam(),		
		origin,		
		nil,					
		radius,				
	    DOTA_UNIT_TARGET_TEAM_ENEMY,
		ability:GetAbilityTargetType(),
		0, 
		FIND_ANY_ORDER,
		false
	)

	for k,target in pairs(targets) do
		caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth() * 0.1)
		local damage_table={
				ability = ability,
				victim=target, 
				attacker=caster, 
				damage_type=ability:GetAbilityDamageType(),
				damage_flags=ability:GetAbilityTargetFlags()
			}
		UnitDamageTarget(damage_table)
		caster:EmitSound("shushan_moluo.abilitymoluo013")
		
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo01_explosion_vip.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 2, target, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlForward(effectIndex, 2, caster:GetForwardVector())
		ParticleManager:SetParticleControlEnt(effectIndex , 5, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 7, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 10, caster, 5, "follow_origin", Vector(0,0,0), true)
	end
end

function OnMoluo014PhaseStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster:EmitSound("shushan_moluo.abilitymoluo014_start")
	caster:SetContextThink(DoUniqueString("abilitymoluo014_end"), 
		function()
            if GameRules:IsGamePaused() then return 0.03 end
			caster:EmitSound("shushan_moluo.abilitymoluo014_End")
			return nil
		end, 
	1.0)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_014_start.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
end

function OnMoluo014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo_014_hand.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex,3,Vector(1,1,1))
	ParticleManager:SetParticleControlEnt(effectIndex , 4, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex,16,Vector(1,1,1))
	ParticleManager:DestroyParticleSystemTime(effectIndex,20.0)

	caster:FindAbilityByName("ability_shushan_moluo012"):SetLevel(2)
end

function OnMoluo014Destroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:FindAbilityByName("ability_shushan_moluo012"):SetLevel(1)
end