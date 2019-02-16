function OnLuxiao011SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_luxiao011"), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")

	MoveUnitToTarget(caster,target,1500,
		function()
			local damage_table={
				ability=keys.ability,
				victim=target, 
				attacker=caster, 
				damage_type=keys.ability:GetAbilityDamageType(),
				damage_flags=keys.ability:GetAbilityTargetFlags()
			}
		
			UnitDamageTarget(damage_table)
			caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
			caster:RemoveModifierByName("modifier_shushan_luxiao011_pause")
			ParticleManager:DestroyParticleSystem(effectIndex,true)
			
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
			OnLuxiao011End(caster,keys.ability)

			caster:StopSound("Hero_StormSpirit.BallLightning.Loop")
			caster:EmitSound("ShuShanAbility.LuXiao.A011.Hit")
		end
	)
end

function OnLuxiao011End(caster,ability)
	caster:SetContextThink(DoUniqueString("OnLuxiao011End"), 
		function()
			local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),
					caster:GetOrigin()+caster:GetForwardVector()*300,
					nil,
					300,
					ability:GetAbilityTargetTeam(),
					ability:GetAbilityTargetType(),
					ability:GetAbilityTargetFlags(),
					FIND_ANY_ORDER,
					false)
			local damage_table={
					ability = ability,
					victim=nil, 
					attacker=caster, 
					damage_type=ability:GetAbilityDamageType(),
					damage_flags=ability:GetAbilityTargetFlags()
				}
			for _,v in pairs(enemies) do
				damage_table.victim = v
				UnitDamageTarget(damage_table)
			end
			local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_luxiao011_end"), PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+caster:GetForwardVector()*300)
			ParticleManager:DestroyParticleSystem(effectIndex)
			caster:EmitSound("Hero_StormSpirit.StaticRemnantExplode")
			return nil
		end,
	0.5)
end

function OnLuxiao012SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local time = 3.5
	local isEnd = false
	local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_luxiao012"), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	caster:EmitSound("Hero_Juggernaut.BladeFuryStart")

	caster:SetContextThink(DoUniqueString("OnLuxiao012SpellStart"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			time = time - 0.1
			if time > 0.5 then
				local enemies = FindUnitsInRadius(
						caster:GetTeamNumber(),
						caster:GetOrigin(),
						nil,
						300,
						keys.ability:GetAbilityTargetTeam(),
						keys.ability:GetAbilityTargetType(),
						keys.ability:GetAbilityTargetFlags(),
						FIND_ANY_ORDER,
						false)
				local damage_table={
						ability = keys.ability,
						victim=nil, 
						attacker=caster, 
						damage_type=keys.ability:GetAbilityDamageType(),
						damage_flags=keys.ability:GetAbilityTargetFlags()
					}
				for _,v in pairs(enemies) do
					damage_table.victim = v
					UnitDamageTarget(damage_table)
				end
			elseif time <= 0.5 and isEnd == false then
				isEnd = true
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
				caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
				local ability011 = caster:FindAbilityByName("ability_shushan_luxiao011")
				OnLuxiao011End(caster,ability011)

				caster:StopSound("Hero_Juggernaut.BladeFuryStart")
				caster:EmitSound("Hero_Juggernaut.BladeFuryStop")
				return nil
			end
			return 0.1
		end
	, 0.1)
end


function OnLuxiao013AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetOrigin()+caster:GetForwardVector()*300,
			nil,
			300,
			keys.ability:GetAbilityTargetTeam(),
			keys.ability:GetAbilityTargetType(),
			keys.ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)
	local damage_table={
			ability = keys.ability,
			victim=nil, 
			attacker=caster, 
			damage_type=keys.ability:GetAbilityDamageType(),
			damage_flags=keys.ability:GetAbilityTargetFlags()
		}
	for _,v in pairs(enemies) do
		damage_table.victim = v
		UnitDamageTarget(damage_table)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/luxiao/ability_luxiao_024_down.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+caster:GetForwardVector()*300)
	ParticleManager:DestroyParticleSystem(effectIndex)
end

function OnLuxiao014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local forward = caster:GetForwardVector()

	for i=0,7 do
		local count = 1
		caster:SetContextThink(DoUniqueString("OnLuxiao014SpellStart"), 
			function()
				local pos = vecCaster + Vector(math.cos(math.pi/4*i)*forward.x - math.sin(math.pi/4*i)*forward.y,
														forward.y*math.cos(math.pi/4*i) + forward.x*math.sin(math.pi/4*i),
														0)*count*100
				OnLuxiao014CreateDamage(keys,pos)
				count = count + 1
				if count > 5 then
					return nil
				end
				return 0.1
			end,
		0.1)
	end
end


function OnLuxiao014CreateDamage(keys,pos)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/luxiao/ability_luxiao_014.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, pos)
	
	if shushan_GetEffectName(caster,"ability_shushan_luxiao014") ~= "" then
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_luxiao014"), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, pos)
		ParticleManager:DestroyParticleSystem(effectIndex)
	end

	local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			pos,
			nil,
			100,
			keys.ability:GetAbilityTargetTeam(),
			keys.ability:GetAbilityTargetType(),
			keys.ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)
	local damage_table={
			ability = keys.ability,
			victim=nil, 
			attacker=caster, 
			damage_type=keys.ability:GetAbilityDamageType(),
			damage_flags=keys.ability:GetAbilityTargetFlags()
		}
	for _,v in pairs(enemies) do
		damage_table.victim = v
		UnitDamageTarget(damage_table)
	end
end

function OnLuxiao014SpellStartForJueXing( keys )
	if keys.caster.__juexing_la then
		OnLuxiao014SpellStart(keys)
	end
end