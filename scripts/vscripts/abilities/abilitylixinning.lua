function Onlixinning01CreateTracking(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = FindUnitsInRadius(
			caster:GetTeam(),		--caster team
			caster:GetOrigin(),		--find position
			nil,					--find entity
			500,					--find radius
		    DOTA_UNIT_TARGET_TEAM_ENEMY,
			keys.ability:GetAbilityTargetType(),
			0, 
			FIND_ANY_ORDER,
			false
	)

	if targets[1] == nil then
		return
	end

	local swordTable = {
		Target = targets[1],
		Source = caster,
		Ability = keys.ability,	
		EffectName = "particles/heroes/lixinning/ability_lixinning01_swords_base_attack.vpcf",
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
	ProjectileManager:CreateTrackingProjectile(swordTable)

	--caster:EmitSound("Voice_Hsj_lixinning.Abilitylixinning012")
end

function Onlixinning01DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex):GetOwner()
	local ability = caster:FindAbilityByName("ability_hsj_lixinning01")

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = ability,
		damage_type = ability:GetAbilityDamageType(), 
	    damage_flags = ability:GetAbilityTargetFlags(),
	    damage_percent = ability:GetLevelSpecialValueFor("damage_percent", ability:GetLevel())/100 + 1,
	}
	UnitDamageTarget(damage_table) 
end

function Onlixinning01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.swordCount == nil then
		caster.swordCount = 0
	end

	if caster.lixinning01Swords == nil then
		caster.lixinning01Swords = {}
	end

	caster.swordCount = 9 + caster.swordCount
	swordCount = 9

	-- ´´½¨ÐÇÐÇ
	for i = caster.swordCount-swordCount,caster.swordCount do
		local vec = Vector(caster:GetOrigin().x + math.cos(i*2*math.pi/swordCount) * 100,caster:GetOrigin().y + math.sin(i*2*math.pi/swordCount) * 100,caster:GetOrigin().z + 100)
		local unit = CreateUnitByName(
		"npc_hsj_unit_lixinning01_sword"
		,vec
		,false
		,caster
		,caster
		,caster:GetTeam()
		)
		unit:SetContextNum("ability_lixinning01_unit_rad",GetRadBetweenTwoVec2D(caster:GetOrigin(),vec),0)
		unit.hero = caster
		unitAbility = unit:FindAbilityByName("ability_hsj_lixinning01_dealdamage")
		unitAbility:SetLevel(1)
		unit.upVector = unit:GetUpVector()
		unit:SetForwardVector(unit.upVector)
		unit:SetOwner(caster)

		Wait('ability_lixinning01_sword_release', unit, keys.AbilityDuration,
			function()
				if not unit:IsNull() and unit ~= nil then
					unit:AddNoDraw()
					unit:ForceKill(true)
					caster.swordCount = caster.swordCount - 1
					table.remove(caster.lixinning01Swords,i)
				end
			end)
		table.insert(caster.lixinning01Swords,unit)
	end
	local duration = keys.AbilityDuration
	caster:SetContextThink(DoUniqueString("ability_lixinning02_modifier_timer"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if duration > 0 then
					duration = duration - 0.02
					Onlixinning01SpellThink(keys)
					return 0.02
				else
					return nil
				end
			end, 
		0.02
	)
end

function Onlixinning01SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vCaster = caster:GetOrigin()
	local swords = caster.lixinning01Swords
	for _,v in pairs(swords) do
		if not v:IsNull() and v ~= nil then
			local vVec = v:GetOrigin() 
			local turnRad = v:GetContext("ability_lixinning01_unit_rad") + math.pi/120
			v:SetContextNum("ability_lixinning01_unit_rad",turnRad,0)
			local turnVec = Vector(vCaster.x + math.cos(turnRad) * 100,vCaster.y + math.sin(turnRad) * 100,vCaster.z + 100)
			v:SetOrigin(turnVec)
			v:SetForwardVector(v.upVector)
		end
	end
end

function Onlixinning01SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	-- for _,v in pairs(caster.lixinning01Swords) do
	-- 	if v:IsNull() and v == nil then
	-- 		table.remove(caster.lixinning01Swords,v)
	-- 	end
	-- end
end

function OnLixinning02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unqiue = AttributesCtrl:AddWeaponDamage(caster,shushan_GetWeaponType(caster,nil),keys.EquipMulti)

	caster:SetContextThink(DoUniqueString("ability_lixinning02_modifier_timer"), 
			function()
				AttributesCtrl:ClearMultiWeaponDamage(caster,shushan_GetWeaponType(caster,nil),unqiue)
				return nil
			end, 
		keys.Duration
	)
end

function OnLixinning2DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities

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
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/wenjian/wenjian_01_effect_explosion.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,v)
		ParticleManager:SetParticleControl(effectIndex,0,v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,2,v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,3,v:GetOrigin())
	end
end

function Onlixinning03AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/juexin/ability_juexin_012_vip_c3.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(effectIndex,1,keys.target:GetOrigin())

	Onlixinning03DealDamage(keys)
end


function Onlixinning03CreateTracking(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	for i=0,2 do

		local unit = CreateUnitByName(
			"npc_hsj_unit_lixinning03_knife"
			,keys.attacker:GetOrigin() + RandomVector(300)
			,false
			,caster
			,caster
			,caster:GetTeam()
		)
		unit:SetOrigin(unit:GetOrigin() + Vector(0,0,200)) 

		local rad = GetRadBetweenTwoVec2D(unit:GetOrigin(),keys.attacker:GetOrigin())
		unit:SetForwardVector(Vector(math.cos(rad),math.sin(rad),-1))

		local swordTable = {
			Target = keys.attacker,
			Source = unit,
			Ability = keys.ability,	
			EffectName = "particles/heroes/juexin/ability_juexin_014_sword.vpcf",
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

		Wait('ability_lixinning03_sword_release', unit, 0.7, 
			function()
				unit:ForceKill(true)
				unit:SetOrigin(unit:GetOrigin() - Vector(0,0,300))
			end)

		ProjectileManager:CreateTrackingProjectile(swordTable)
	end
end

function Onlixinning03DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags(),
	    damage_percent = (keys.DamagePercent or 0)/100 + 1,
	}
	UnitDamageTarget(damage_table) 
end

function OnLixinning011SpellStart(keys)
	OnLixinning011UpSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local duration = 15.0
	local duration_damage = 15.0


	caster:EmitSound("shushan_yunlian.abilityyunlian011")

	if caster.Lixinning011swordCount == nil then
		caster.Lixinning011swordCount = 0
	end

	if caster.lixinning011Swords == nil then
		caster.lixinning011Swords = {}
	end

	swordCount = 6

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yunlian/ability_yunlian_011_circle.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "attach_origin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex2,17.0)

	caster.Lixinning011swordCount = swordCount + caster.Lixinning011swordCount

	for i = caster.Lixinning011swordCount-swordCount,caster.Lixinning011swordCount do
		local duration_unit = 15.0
		local vec = Vector(caster:GetOrigin().x - math.cos(i*2*math.pi/swordCount) * 100,caster:GetOrigin().y - math.sin(i*2*math.pi/swordCount) * 100,caster:GetOrigin().z+150)
		local unit = CreateUnitByName(
		"npc_hsj_unit_lixinning011_sword"
		,vec
		,false
		,caster
		,caster
		,caster:GetTeam()
		)
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/yunlian/ability_yunlian_011_sword_light.vpcf", PATTACH_CUSTOMORIGIN, unit)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, unit, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystemTime(effectIndex,17.0)
		unit:SetModelScale(0.7)
		unit.ability_lixinning011_unit_rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),vec)
		unit.hero = caster
		unit:SetForwardVector((caster:GetOrigin()+Vector(0,0,200)-unit:GetOrigin()):Normalized())
		unit:SetOwner(caster)

		caster:SetContextThink(DoUniqueString("ability_lixinning011_release"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if (caster:IsAlive() == false) or duration_unit <= 0 then
					if not unit:IsNull() and unit ~= nil then
						unit:AddNoDraw()
						unit:ForceKill(true)
						caster.Lixinning011swordCount = caster.Lixinning011swordCount - 1
						table.remove(caster.lixinning011Swords,i)
					end
					return nil
				end
				duration_unit = duration_unit - 0.03
				return 0.03
			end,
		0.03)

		table.insert(caster.lixinning011Swords,unit)
	end
	caster:SetContextThink(DoUniqueString("ability_lixinning011_modifier_timer"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if duration > 0 then
					duration = duration - 0.02

					if caster.ability_lixinning_011_stop ~= true then
						Onlixinning011SpellThink(keys)
					end

					return 0.02
				else
					return nil
				end
			end, 
		0.02
	)
	caster:SetContextThink(DoUniqueString("ability_lixinning011_damage"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if duration_damage > 0 then
					duration_damage = duration_damage - 0.2
					Onlixinning011SpellDamage(keys)
					return 0.2
				else
					return nil
				end
			end, 
		0.2
	)
end


function OnLixinning011UpSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local duration = 15.0
	local duration_damage = 15.0

	if caster.Lixinning011UpswordCount == nil then
		caster.Lixinning011UpswordCount = 0
	end

	if caster.lixinning011UpSwords == nil then
		caster.lixinning011UpSwords = {}
	end

	swordCount = 6

	caster.Lixinning011UpswordCount = swordCount + caster.Lixinning011UpswordCount

	for i = caster.Lixinning011UpswordCount-swordCount,caster.Lixinning011UpswordCount do
		local duration_unit = 15.0
		local vec = Vector(caster:GetOrigin().x + math.cos(i*2*math.pi/swordCount) * 60,caster:GetOrigin().y + math.sin(i*2*math.pi/swordCount) * 60,caster:GetOrigin().z + 150)
		local unit = CreateUnitByName(
		"npc_hsj_unit_lixinning011_sword"
		,vec
		,false
		,caster
		,caster
		,caster:GetTeam()
		)
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/yunlian/ability_yunlian_011_sword_light.vpcf", PATTACH_CUSTOMORIGIN, unit)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, unit, 5, "attach_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystemTime(effectIndex,17.0)

		unit.ability_lixinning011_unit_uprad = GetRadBetweenTwoVec2D(caster:GetOrigin(),vec)
		unit.hero = caster
		unit.upVector = -unit:GetUpVector()
		unit:SetForwardVector(unit.upVector)
		unit:SetOwner(caster)

		caster:SetContextThink(DoUniqueString("ability_lixinning011_release"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if (caster:IsAlive() == false) or duration_unit <= 0 or caster.ability_lixinning_011_stop == true then
					if not unit:IsNull() and unit ~= nil then
						unit:AddNoDraw()
						unit:ForceKill(true)
						caster.Lixinning011UpswordCount = caster.Lixinning011UpswordCount - 1
						table.remove(caster.lixinning011UpSwords,i)
					end
					return nil
				end
				duration_unit = duration_unit - 0.03
				return 0.03
			end,
		0.03)

		table.insert(caster.lixinning011UpSwords,unit)
	end
	caster:SetContextThink(DoUniqueString("ability_lixinning011_modifier_timer"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if duration > 0 then
					duration = duration - 0.02
					Onlixinning011UpSpellThink(keys)
					return 0.02
				else
					return nil
				end
			end, 
		0.02
	)
end

function Onlixinning011SpellDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vCaster = caster:GetOrigin()
	local swords = caster.lixinning011Swords
	for _,v in pairs(swords) do
		if not v:IsNull() and v ~= nil then
			local targets = FindUnitsInRadius(
					v:GetTeam(),		--caster team
					v:GetOrigin(),		--find position
					nil,					--find entity
					100,					--find radius
				    DOTA_UNIT_TARGET_TEAM_ENEMY,
					keys.ability:GetAbilityTargetType(),
					0, 
					FIND_ANY_ORDER,
					false
			)
			for k,v1 in pairs(targets) do
				local damage_table = {
					ability=keys.ability,
					victim = v1,
					attacker = caster,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
				    damage_flags = keys.ability:GetAbilityTargetFlags(),
				}
				UnitDamageTarget(damage_table) 
				caster:EmitSound("shushan_yunlian.abilityyunlian011_hit")
			end
		end
	end
end



function Onlixinning011UpSpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vCaster = caster:GetOrigin()
	local swords = caster.lixinning011UpSwords
	for _,v in pairs(swords) do
		if not v:IsNull() and v ~= nil then
			local vVec = v:GetOrigin() 
			local turnRad = v.ability_lixinning011_unit_uprad + math.pi/60
			v.ability_lixinning011_unit_uprad = turnRad
			local turnVec = Vector(vCaster.x + math.cos(turnRad) * 60,vCaster.y + math.sin(turnRad) * 60,vCaster.z + 150)
			v:SetOrigin(turnVec)
			v:SetForwardVector(v.upVector)
		end
	end
end


function Onlixinning011SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vCaster = caster:GetOrigin()
	local swords = caster.lixinning011Swords
	for _,v in pairs(swords) do
		if not v:IsNull() and v ~= nil then
			local vVec = v:GetOrigin() 
			local turnRad = v.ability_lixinning011_unit_rad + math.pi/60
			v.ability_lixinning011_unit_rad = turnRad
			local turnVec = Vector(vCaster.x + math.cos(turnRad) * 100,vCaster.y + math.sin(turnRad) * 100,vCaster.z+150)
			v:SetOrigin(turnVec)
			v:SetForwardVector((caster:GetOrigin()+Vector(0,0,200)-v:GetOrigin()):Normalized())
		end
	end
end

function OnLixinning012SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target_point=keys.target_points[1]
	local count = 30

	caster:SetContextThink(DoUniqueString("OnLixinning012SpellStart"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:EmitSound("shushan_yunlian.abilityyunlian012_swing")
				if count > 0 then
					count = count - 1
					if count%2==0 then
						local pos = target_point+RandomVector(100)
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/yunlian/ability_yunlian_012.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(effectIndex, 0, pos)
						ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin()-caster:GetForwardVector()*200)
						ParticleManager:SetParticleControl(effectIndex, 3, pos)
						ParticleManager:SetParticleControl(effectIndex, 6, pos)
						ParticleManager:SetParticleControl(effectIndex, 7, pos)
						ParticleManager:SetParticleControl(effectIndex, 8, pos)
						ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)

						local damage_table = {
							victim = nil,
							attacker = caster,
							ability = keys.ability,
							damage_type = keys.ability:GetAbilityDamageType(), 
						    damage_flags = keys.ability:GetAbilityTargetFlags(),
						}
						local enemies=FindUnitsInRadius(
							caster:GetTeam(),		--caster team
							pos,
							nil,
							200,
							keys.ability:GetAbilityTargetTeam(),
							keys.ability:GetAbilityTargetType(),
							keys.ability:GetAbilityTargetFlags(),
							FIND_ANY_ORDER,
							false)
						for _,v in pairs(enemies) do
							damage_table.victim=v
							UnitDamageTarget(damage_table)
						end
					end
					return 0.1
				else
					return nil
				end
			end, 
		0.1
	)
end

function OnLixinning013AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = keys.ability,
		damage_type = keys.ability:GetAbilityDamageType(), 
	    damage_flags = keys.ability:GetAbilityTargetFlags(),
	}
	UnitDamageTarget(damage_table) 
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/yunlian/ability_yunlian_014.vpcf",PATTACH_CUSTOMORIGIN,entity)
	ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,1,Vector(1,1,1))
	ParticleManager:SetParticleControl(effectIndex,2,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,3,target:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,3)

	caster:EmitSound("shushan_yunlian.abilityyunlian013_hit")
end


function OnLixinning014SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local vecTarget = target:GetOrigin()

	local entity = CreateUnitByName(
		"npc_hsj_unit_lixinning011_sword"
		,vecTarget
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lixining/ability_lixinning04_bagua.vpcf",PATTACH_CUSTOMORIGIN,entity)
	ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,3,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,4,target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex,6,target:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,8)

	entity:SetContextThink("ability_lixinning04_swords_release", 
		function()
			entity:RemoveSelf()
			return nil
		end, 
	3.1)

	local duration = 3.0
	caster:SetContextThink(DoUniqueString("ability_lixinning04_swords_timer"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if duration > 0 then
				local vecRandom = Vector(math.cos(RandomFloat(-math.pi,math.pi))*300,math.cos(RandomFloat(-math.pi,math.pi))*300,RandomInt(0, 300))
				entity:SetOrigin(vecTarget + vecRandom)
				caster:EmitSound("shushan_yunlian.abilityyunlian012_swing")

				local rad = GetRadBetweenTwoVec2D(entity:GetOrigin(),vecTarget)
				local forwardVec = Vector( math.cos(rad) * 2000 , math.sin(rad) * 2000 , RandomInt(0, 500))

				local swordTable = {
					Ability				= keys.ability,
					EffectName			= "particles/heroes/lixinning/ability_lixinning04_projectile.vpcf",
					vSpawnOrigin		= entity:GetOrigin(),
					fDistance			= 500,
					fStartRadius		= 120,
					fEndRadius			= 120,
					Source				= entity,
					bHasFrontalCone		= false,
					bReplaceExisting	= false,
					iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType		= DOTA_UNIT_TARGET_FLAG_NONE,
					fExpireTime			= GameRules:GetGameTime() + 10.0,
					bDeleteOnHit		= false,
					vVelocity			= forwardVec,
					bProvidesVision		= true,
					iVisionRadius		= 400,
					iVisionTeamNumber	= caster:GetTeamNumber(),
				} 

				ProjectileManager:CreateLinearProjectile(swordTable)
				local damage_table = {
					victim = keys.target,
					attacker = caster,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
				    damage_flags = keys.ability:GetAbilityTargetFlags(),
				}
				UnitDamageTarget(damage_table) 
				duration = duration - 0.1
				return 0.1
			else
				return nil
			end
		end,
	0.1)
end