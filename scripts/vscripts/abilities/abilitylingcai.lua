ABILITY_Lingcai_ICEBOUND_UNIT_NAME="npc_shushan_unit_Lingcai_icebound"
ABILITY_Lingcai_ICEBOUND_LIFETIME=11
ABILITY_Lingcai_ICEBOUND_HITBOX=250
ABILITY_Lingcai_ICEBOUND_DAMAGE_RANGE=250
ABILITY_Lingcai_ICEBOUND_BREAK_DELAY=0.2
ABILITY_Lingcai_ICEBOUND_GC_INTERVAL=0.03

g_Lingcai_icebound_set={}
function LingcaiAbilityGC()
	local time_now=GameRules:GetGameTime()
	for _,ib in pairs(g_Lingcai_icebound_set) do
		if not ib.time_to_remove or time_now>=ib.time_to_remove then
			LingcaiRemoveIcebound(ib)
		end
	end
end

function LingcaiRemoveIcebound(icebound)
	if icebound then
		if icebound.effect_index then
			ParticleManager:DestroyParticle(icebound.effect_index,true)
		end
		g_Lingcai_icebound_set[icebound]=nil
	end
end

function LingcaiFindIceboundsInRadius(pos,radius)
	local icebounds={}
	for _,ib in pairs(g_Lingcai_icebound_set) do
		if (ib.pos-pos):Length2D()<=radius and not ib.ready_to_break then
			table.insert(icebounds,ib)
		end
	end
	table.sort(icebounds,
		function (a,b)
			return (a.pos-pos):Length2D()<(b.pos-pos):Length2D()
		end)
	return icebounds
end

function LingcaiCreateIcebound(caster,pos,lifetime)
	if not caster then return nil end
	pos = pos or caster:GetOrigin()
	lifetime = lifetime or ABILITY_Lingcai_ICEBOUND_LIFETIME
	local icebound={}
	icebound.pos=pos
	icebound.time_to_remove=GameRules:GetGameTime()+lifetime
	icebound.ready_to_break=false
	local effect_index=ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_011_a.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleControl(effect_index, 0, pos)
	icebound.effect_index=effect_index

	g_Lingcai_icebound_set[icebound]=icebound

	local game_ent = GameRules:GetGameModeEntity()
	if not game_ent.started_Lingcai_gc then
		game_ent.started_Lingcai_gc=true
		game_ent:SetContextThink(
			"Lingcai_ability_gc",
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				LingcaiAbilityGC()
				return ABILITY_Lingcai_ICEBOUND_GC_INTERVAL
			end,0)
	end
	return icebound
end

--[[
icebound	-- table icebound
OnBreak		-- function OnBreak(caster,icebound,count,nearby_icebound)
count		-- tracert count  (do not input)
]]
function LingcaiBreakIcebound(icebound,OnBreak,count)
	--print("LingcaiBreakIcebound count="..tostring(count))
	if not icebound then return end
	count = count or 0

	icebound.ready_to_break=true
	local icebounds=LingcaiFindIceboundsInRadius(icebound.pos,ABILITY_Lingcai_ICEBOUND_HITBOX)

	if OnBreak then
		--OnBreak(icebound,count,nearby_icebounds)
		OnBreak(icebound,count,icebounds)
	end

	local time_now=GameRules:GetGameTime()
	for _,ib in pairs(icebounds) do
		ib.ready_to_break=true
		Timer.Loop (tostring(ib).."ready_to_break") (
			ABILITY_Lingcai_ICEBOUND_BREAK_DELAY,1,
			function ()
				LingcaiBreakIcebound(ib,OnBreak,count+1)
			end
			)
	end
	LingcaiRemoveIcebound(icebound)
end

function LingcaiBreakIceboundsInRadius(caster,pos,radius)
	local icebound_cnt=0

	local AbilityLingcai02=caster:FindAbilityByName("ability_shushan_lingcai012")
	local Lingcai02_StunEnemyDuration=0
	local Lingcai02_damage_table
	if AbilityLingcai02 then 
		Lingcai02_StunEnemyDuration=AbilityLingcai02:GetLevelSpecialValueFor("stun_enemy_duration",AbilityLingcai02:GetLevel())
		Lingcai02_damage_table={
			ability = AbilityLingcai02,
			victim=nil, 
			attacker=caster, 
			damage_type=AbilityLingcai02:GetAbilityDamageType(),
			damage_flags=AbilityLingcai02:GetAbilityTargetFlags()
		}
	end

	local AbilityLingcai04=caster:FindAbilityByName("ability_shushan_lingcai014")
	local Lingcai04_freeze_damage_table
	if AbilityLingcai04 then
		Lingcai04_freeze_damage_table={
			ability = AbilityLingcai04,
			victim=nil, 
			attacker=caster, 
			damage_type=AbilityLingcai04:GetAbilityDamageType(),
			damage_flags=AbilityLingcai04:GetAbilityTargetFlags()
		}
	end

	local icebounds=LingcaiFindIceboundsInRadius(caster:GetAbsOrigin(),ABILITY_Lingcai_ICEBOUND_HITBOX)
	--print("#icebounds="..tostring(#icebounds))

	local LstDmgCnt={}
	for _,ib in pairs(icebounds) do
		if not ib.ready_to_break then
			icebound_cnt=icebound_cnt+1
			LingcaiBreakIcebound(
				ib,
				function (icebound,count,nearby_icebounds) 
					--print(tostring(#nearby_icebounds))
					local is_stun_unit=(#nearby_icebounds==0)
					local enemies = FindUnitsInRadius(
						caster:GetTeamNumber(),
						icebound.pos,
						nil,
						ABILITY_Lingcai_ICEBOUND_DAMAGE_RANGE,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
						FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
						false)
					for _,v in pairs(enemies) do
						if not v:IsMagicImmune() or v:HasModifier("modifier_shushan_lingcai04_freeze") then
							if AbilityLingcai04 and v:HasModifier("modifier_shushan_lingcai04_freeze") then
								v:RemoveModifierByName("modifier_shushan_lingcai04_freeze")
								v:RemoveModifierByName("modifier_shushan_lingcai04_slowdown")
								Lingcai04_freeze_damage_table.victim=v
								ParticleManager:DestroyParticle(v.ability_Lingcai_04_effect_index,true)
								UnitDamageTarget(Lingcai04_freeze_damage_table)
							end

							if AbilityLingcai02 then
								if not LstDmgCnt[v] or LstDmgCnt[v]<count then
									LstDmgCnt[v]=count
									Lingcai02_damage_table.victim=v
									UnitDamageTarget(Lingcai02_damage_table)
								end
								if is_stun_unit then
									--UtilStun:UnitStunTarget(caster,v,Lingcai02_StunEnemyDuration)
								end
							end
						end
					end
					if caster.ability_Lingcai_04_effect_index_table~=nil then
						for k,v in pairs(caster.ability_Lingcai_04_effect_index_table) do
							ParticleManager:DestroyParticle(v,true)	
						end
					end
					local effectOrigin = icebound.pos
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_011.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(effectIndex, 0, effectOrigin)
					caster:EmitSound("Hero_Crystal.CrystalNova.Yulsaria")
				end
			)
		end
	end
	print("(icebound_cnt))"..tostring(icebound_cnt))
	return icebound_cnt
end

function OnLingcai01SpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local Targets=FindUnitsInRadius(
		Caster:GetTeamNumber(),
		Caster:GetAbsOrigin(),
		nil,
		keys.radius,
		Ability:GetAbilityTargetTeam(),
		Ability:GetAbilityTargetType(),
		Ability:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
		false)
	local damage_table={
		ability = keys.ability,
		victim=nil, 
		attacker=Caster, 
		damage_type=Ability:GetAbilityDamageType(),
		damage_flags=Ability:GetAbilityTargetFlags()
	}
	for _,v in pairs(Targets) do
		damage_table.victim=v
		UnitDamageTarget(damage_table)

		Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_name, {})
	end
	LingcaiCreateIcebound(Caster)
	local effectOrigin = Caster:GetOrigin()
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_011.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, effectOrigin)

	for i=1,9 do
		local Ability=keys.ability
		local Caster=keys.caster
		local effectOriginTargets = Caster:GetOrigin() + Vector(math.cos(i*2*math.pi/9)*300,math.sin(i*2*math.pi/9)*300,0)
		local Targets=FindUnitsInRadius(
			Caster:GetTeamNumber(),
			effectOriginTargets,
			nil,
			keys.radius,
			Ability:GetAbilityTargetTeam(),
			Ability:GetAbilityTargetType(),
			Ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
			false)
		local damage_table={
			ability = keys.ability,
			victim=nil, 
			attacker=Caster, 
			damage_type=Ability:GetAbilityDamageType(),
			damage_flags=Ability:GetAbilityTargetFlags()
		}
		for _,v in pairs(Targets) do
			damage_table.victim=v
			UnitDamageTarget(damage_table)

			Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_name, {})
		end
		LingcaiCreateIcebound(Caster,effectOriginTargets)
		local effectIndexTargets = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_011.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effectIndexTargets, 0, effectOriginTargets)
	end
end

function OnLingcai02SpellStart(keys)
	if (LingcaiBreakIceboundsInRadius(keys.caster, keys.caster:GetOrigin(), keys.radius)==0) then
		--UtilStun:UnitStunTarget(keys.caster,keys.caster,keys.stun_self_duration)
	end
end

function OnLingcai03SpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local TargetPoint=keys.target_points[1]
	local VecStart=Caster:GetOrigin()
	local Direction=(TargetPoint-VecStart):Normalized()
	local TickInterval=keys.tick_interval
	local MovePerTick=keys.speed*TickInterval
	local tick=0
	local tick_max=keys.length/MovePerTick

	local damage_table={
		ability=Ability,
		victim=nil, 
		attacker=Caster, 
		damage_type=Ability:GetAbilityDamageType(),
		damage_flags=Ability:GetAbilityTargetFlags()
	}

	local HasDamaged={}
	Caster:SetContextThink(
		"Lingcai03_in_spelling",
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			local VecPos=VecStart+Direction*MovePerTick*tick
			local enemies = FindUnitsInRadius(
						Caster:GetTeamNumber(),
						VecPos,
						nil,
						keys.width,
						Ability:GetAbilityTargetTeam(),
						Ability:GetAbilityTargetType(),
						Ability:GetAbilityTargetFlags(),
						FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
						false)
			for _,v in pairs(enemies) do
				if not HasDamaged[v] then
					HasDamaged[v]=true
					damage_table.victim=v
					UnitDamageTarget(damage_table)

					Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_name, {})
				end
			end

			LingcaiCreateIcebound(Caster,VecPos)

			local effectOrigin = VecPos
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_011.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(effectIndex, 0, effectOrigin)
			Caster:EmitSound("Hero_Crystal.CrystalNova")

			tick=tick+1
			if tick>=tick_max then return nil end
			return TickInterval
		end,0)
end

function OnLingcai04SpellStart(keys)
	local Ability=keys.ability
	local Caster=keys.caster
	local TickInterval=keys.tick_interval
	local tick=0
	local tick_max=keys.duration/TickInterval
	local tick_persec=math.floor(1/TickInterval)
	if tick_persec==0 then tick_persec=1 end

	local AOE_damage_table={
		ability = keys.ability,
		victim=nil, 
		attacker=Caster, 
		damage_type=Ability:GetAbilityDamageType(),
		damage_flags=Ability:GetAbilityTargetFlags()
	}

	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, Caster, 5, "attach_hitloc", Vector(0,0,0), true)
	Caster.ability_Lingcai_04_caster_effect_index = effectIndex

	Caster:SetContextThink(
		"Lingcai04_in_spelling",
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			local bApplyModifier=(tick>0 and tick%tick_persec==0)
			local left_time=(tick_max-tick)*TickInterval
			local enemies = FindUnitsInRadius(
						Caster:GetTeamNumber(),
						Caster:GetOrigin(),
						nil,
						keys.radius,
						Ability:GetAbilityTargetTeam(),
						Ability:GetAbilityTargetType(),
						Ability:GetAbilityTargetFlags(),
						FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
						false)
			for _,v in pairs(enemies) do
				AOE_damage_table.victim=v
				UnitDamageTarget(AOE_damage_table)

				if bApplyModifier then
					if not v:HasModifier(keys.debuff_freeze_name) then
						local new_stack=v:GetModifierStackCount(keys.debuff_slowdown_name,Caster)+1
						if v:HasModifier(keys.debuff_slowdown_name) then
							Caster:RemoveModifierByName(keys.debuff_slowdown_name)
						end
						Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_slowdown_name, {})
						v:SetModifierStackCount(keys.debuff_slowdown_name, Caster, new_stack)

						if new_stack>=keys.stack_slow_max then
							Ability:ApplyDataDrivenModifier(Caster, v, keys.debuff_freeze_name, {duration=left_time})
							Caster:EmitSound("Ability.PowershotPull.Stinger")
							local effectOrigin = v:GetOrigin()
							local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", PATTACH_CUSTOMORIGIN, v)
							ParticleManager:SetParticleControlEnt(effectIndex , 0, Caster, 5, "attach_hitloc", Vector(0,0,0), true)
							v.ability_Lingcai_04_effect_index = effectIndex
							Caster.ability_Lingcai_04_effect_index_table = {}
							table.insert(Caster.ability_Lingcai_04_effect_index_table,effectIndex)
						end
					end
				end
			end

			LingcaiCreateIcebound(Caster,Caster:GetOrigin())

			tick=tick+1
			if tick>=tick_max or not Caster:IsAlive() then 
				LingcaiBreakIceboundsInRadius(Caster,Caster:GetOrigin(),keys.radius)
				--UtilStun:UnitStunTarget(Caster,Caster,keys.stun_self_duration)
				ParticleManager:DestroyParticle(Caster.ability_Lingcai_04_caster_effect_index,true)
				return nil 
			end
			return TickInterval
		end,0)
end

function OnLingcai02ActionDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)
end

function OnLingcai04IconDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_lingcai04_bonus_action", nil)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
end

function OnLingcai04ActionDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)
end

function OnLingcai021SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	local ability = keys.ability

	OnLingcai021SpellStartMain(caster,targets,ability)
	OnLingcai021FireAdd(caster)
end

function OnLingcai021SpellStartMain(caster,targets,ability)
	local damage_table={
			ability = ability,
			victim=nil, 
			attacker=caster, 
			damage_type=ability:GetAbilityDamageType(),
			damage_flags=ability:GetAbilityTargetFlags()
		}
	for _,v in pairs(targets) do
		damage_table.victim = v
		UnitDamageTarget(damage_table)
	end
	OnLingcai021FireAdd(caster)
end

function OnLingcai021FireEffect(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	OnLingcai021FireEffectMain(caster,targetPoint)
end

function OnLingcai021FireEffectMain(caster,targetPoint)
	local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_lingcai021"), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
end


function OnLingcai021FireAdd(caster)
	if caster.ability_lingcai_021_fire == nil then
		caster.ability_lingcai_021_fire = {}
	end

	if #caster.ability_lingcai_021_fire < 10 then
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_lingcai022"), PATTACH_CUSTOMORIGIN, caster)
		local obs_number = tostring(RandomInt(1, 10))
		ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_orbs_"..obs_number, Vector(0,0,0), true)
		table.insert(caster.ability_lingcai_021_fire,effectIndex)
	end
end

function OnLingcai022SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local count = #caster.ability_lingcai_021_fire

	for k,v in pairs(caster.ability_lingcai_021_fire) do
		ParticleManager:DestroyParticle(v,true)
		ParticleManager:DestroyParticleSystem(v)
	end
	caster.ability_lingcai_021_fire = {}

	caster:SetContextThink(DoUniqueString("Lincai022ShotFireToUnit"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			Lincai022ShotFireToUnit(caster,target,keys.ability)
			count = count - 1
			if count > 0 then
				return 0.2
			else
				return nil
			end
		end
	, 0.2)
end

function Lincai022ShotFireToUnit(caster,unit,ability)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,150)

	local fireTable = {
		Target = unit,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/heroes/lingcai/ability_lingcai_022.vpcf",
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
	ProjectileManager:CreateTrackingProjectile(fireTable)
end

function OnLingcai022HitUnit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage_table={
			ability = keys.ability,
			victim=target, 
			attacker=caster, 
			damage_type=keys.ability:GetAbilityDamageType(),
			damage_flags=keys.ability:GetAbilityTargetFlags()
		}
	
	UnitDamageTarget(damage_table)
	UnitStunTarget( caster,target,0.5)
end

function OnLingcai023Effect(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/ability_lingcai_023_hand.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_attack2", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,5.0)
	if shushan_GetEffectName(caster,"ability_shushan_lingcai023")~="" then
		local effectIndex2 = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_lingcai023"), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex2 , 1, caster, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex2 , 3, caster, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex2 , 4, caster, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystemTime(effectIndex2,5.0)
	end
end
	

function OnLingcai023AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability
	local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),
			keys.target:GetOrigin(),
			nil,
			400,
			ability:GetAbilityTargetTeam(),
			ability:GetAbilityTargetType(),
			ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,--[[FIND_CLOSEST,]]
			false)

	keys.target:EmitSound("ShuShanAbility.LingCai.A023Boom")
	OnLingcai021SpellStartMain(caster,targets,ability)
	OnLingcai021FireEffectMain(caster,keys.target:GetOrigin())
end

function OnLingcai024PhaseStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if shushan_GetEffectName(caster,"ability_shushan_lingcai024")~="" then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_024_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	end
end

function OnLingcai024SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local forward = (targetPoint - caster:GetOrigin()):Normalized()
	local ability = keys.ability

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lingcai/abilitry_lingcai_024.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,128)+forward*150)
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin()+forward*1000+Vector(0,0,128)+forward*150)
	ParticleManager:SetParticleControl(effectIndex, 9, caster:GetOrigin()+Vector(0,0,128)+forward*150)


	if shushan_GetEffectName(caster,"ability_shushan_lingcai024")~="" then
		local effectIndex = ParticleManager:CreateParticle(shushan_GetEffectName(caster,"ability_shushan_lingcai024"), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,128)+forward*150)
		ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin()+forward*1000+Vector(0,0,128)+forward*150)
	end

	local effectIndex_b = ParticleManager:CreateParticle("particles/heroes/lingcai/ability_lingcai_024_spark.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex_b, 0, caster:GetAttachmentOrigin(PATTACH_POINT) + Vector(forward.x * 150,forward.y * 150,60))
	ParticleManager:SetParticleControl(effectIndex_b, 8, forward)

	local targets = FindUnitsInLine(
			caster:GetTeamNumber(),
			targetPoint,
			caster:GetOrigin()+forward*1000,
			nil,
			400,
			ability:GetAbilityTargetTeam(),
			ability:GetAbilityTargetType(),
			ability:GetAbilityTargetFlags()
		)

	for k,v in pairs(targets) do
		local damage_table={
			ability = keys.ability,
			victim=v, 
			attacker=caster, 
			damage_type=keys.ability:GetAbilityDamageType(),
			damage_flags=keys.ability:GetAbilityTargetFlags()
		}
	
		UnitDamageTarget(damage_table)
	end
end


function OnLingcai024SpellStartForJueXing( keys )
	if keys.caster.__juexing_la then
		keys.target_points = {keys.target:GetOrigin()}
		OnLingcai024SpellStart(keys)
	end
end



Timer = {}

local Timer = Timer

setmetatable(Timer, Timer)

function Timer.Wait(name)
    return function(t, func)
        local ent   = GameRules:GetGameModeEntity()

        ent:SetThink(func, DoUniqueString(name), t)
    end
end

function Timer.Loop(name)
    return function(t, count, func)
        if not func then
            count, func = -1, count
        end
        
        local times = 0
        local function func2()
            times               = times + 1
            local t2, count2    = func(times)
            t, count = t2 or t, count2 or count
            
            if t == true or times == count then
                return nil
            end

            return t
        end
        
        local ent   = GameRules:GetGameModeEntity()
        
        ent:SetThink(func2, DoUniqueString(name), t)
    end
end