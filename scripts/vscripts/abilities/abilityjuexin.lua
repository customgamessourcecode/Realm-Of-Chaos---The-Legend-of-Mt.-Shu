function OnJuexin011Effect( keys )
	local caster = keys.caster
	local path = shushan_GetEffectName(caster,"ability_shushan_juexin011")
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
	ParticleManager:SetParticleControlForward(p,0,caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(p)

	if shushan_GetEffectName(caster,"ability_shushan_juexin011_step")~="" then
		local p1 = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin011_step"), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(p1, 0, caster, 5, "follow_origin", caster:GetOrigin(), true)
		caster.__ability_juexin_011_effect = p1
	end
end

function OnJuexin011EffectDestroy( keys )
	local caster = keys.caster
	local p = caster.__ability_juexin_011_effect
	if p~=nil then
		ParticleManager:DestroyParticle(p, true)
		ParticleManager:DestroyParticleSystem(p)
		caster.__ability_juexin_011_effect = nil
	end
end

function OnJuexin011AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities

	for k,v in pairs(targets) do
		local cx = v:GetOrigin().x
		local cy = v:GetOrigin().y
		local theta = GetRadBetweenTwoVec2D(caster:GetOrigin()+caster:GetForwardVector(),caster:GetOrigin())
		local ux = math.cos(theta)
		local uy = math.sin(theta)
		local px = caster:GetOrigin().x
		local py = caster:GetOrigin().y

		if IsPointInCircularSector(cx,cy,ux,uy,keys.Radius,math.pi/3,px,py) then
			local knifeTable = {
				Target = v,
				Source = caster,
				Ability = keys.ability,	
				EffectName = "particles/heroes/juexin/ability_juexin_014_sword.vpcf",
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
			ProjectileManager:CreateTrackingProjectile(knifeTable)
		end
	end
end

function OnJuexin011Hit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local ability = keys.ability

	local damage_table={
			ability = ability,
			victim=target, 
			attacker=caster, 
			damage_type=ability:GetAbilityDamageType(),
			damage_flags=ability:GetAbilityTargetFlags()
		}
	UnitDamageTarget(damage_table)
	if IsFaceBack(caster,target,math.pi/2) then
		UnitDamageTarget(damage_table)
	end
	caster:PerformAttack(target,false,true,true,false,false,false,true)
end

function OnJuexin012AttackStart(keys)
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

	if shushan_GetEffectName(caster,"ability_shushan_juexin012") == "particles/heroes/juexin/ability_juexin_012.vpcf" then
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin012"),PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,1,target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex)
	else
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin012"),PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin()+Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex,1,target:GetOrigin()+Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex,2,target:GetOrigin()+Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex,3,target:GetOrigin()+Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex,4,target:GetOrigin()+Vector(0,0,128))
		ParticleManager:DestroyParticleSystem(effectIndex)
	end
	
	if IsFaceBack(caster,target,math.pi/2) then
		UnitDamageTarget(damage_table)
	end
end

function OnJuexin013SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local illusion = create_illusion(keys,caster:GetOrigin()+caster:GetForwardVector()*300,100,0,20.0)

	-- 觉醒
	if caster.__juexing_la then
		create_illusion(keys,caster:GetOrigin()-caster:GetForwardVector()*300,100,0,20.0)
		create_illusion(keys,caster:GetOrigin()-caster:GetRightVector()*300,100,0,20.0)
		create_illusion(keys,caster:GetOrigin()+caster:GetRightVector()*300,100,0,20.0)
	end
end

function OnJuexin014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local count = 24

	UnitStunTarget(caster,keys.target,3.6)

	if shushan_GetEffectName(caster,"ability_shushan_juexin014")~="" then
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin014"),PATTACH_CUSTOMORIGIN_FOLLOW,keys.target)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, keys.target, 5, "absorigin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 1, keys.target, 5, "absorigin", Vector(0,0,0), true)
	end

	caster:SetContextThink(DoUniqueString("OnJuexin014ShotKnifeToUnit"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			OnJuexin014ShotKnifeToUnit(keys,count)
			count = count - 1
			if count > 0 then
				return 0.1
			else
				return nil
			end
		end
	, 0.1)
end

function OnJuexin014ShotKnifeToUnit(keys,count)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unit = CreateUnitByName(
		"npc_shushan_unit_juexin014_knife"
		,keys.target:GetOrigin() + Vector(math.cos(math.pi/12*count)*RandomInt(150,250),math.sin(math.pi/12*count)*RandomInt(150,250),0)
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local rad = GetRadBetweenTwoVec2D(unit:GetOrigin(),keys.target:GetOrigin())
	unit:SetForwardVector(Vector(math.cos(rad),math.sin(rad),-1))

	unit:SetOrigin(unit:GetOrigin() + Vector(0,0,300)) 

	local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin014_smoke"),PATTACH_CUSTOMORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(effectIndex,0,unit:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,1,unit:GetOrigin())

	caster:SetContextThink(DoUniqueString("npc_shushan_unit_juexin014_knife_release"),
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_juexin014_smoke"),PATTACH_CUSTOMORIGIN_FOLLOW,caster)
			ParticleManager:SetParticleControl(effectIndex,0,unit:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex,1,unit:GetOrigin())
			local swordTable = {
				Target = keys.target,
				Source = unit,
				Ability = keys.ability,	
				EffectName = shushan_GetEffectName(caster,"ability_shushan_juexin014_sword"),
				iMoveSpeed = 1500,
				vSourceLoc=  unit:GetAbsOrigin(),
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
			ProjectileManager:CreateTrackingProjectile(swordTable)
			unit:ForceKill(true)
			unit:SetOrigin(unit:GetOrigin() - Vector(0,0,300))
			return nil
		end
	,2.4-(24-count)*0.05)
end

function OnJuexin014Hit(keys)
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
end