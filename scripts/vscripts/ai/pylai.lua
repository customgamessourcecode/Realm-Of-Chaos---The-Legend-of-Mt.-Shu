

if PylAI == nil then
	PylAI = class({})
end

function PylAI:Init(entity)
	local UnitAI = {}
	function UnitAI:GoToSpawner()
		local spawner = entity.SpawnEnt
		
		local distance=GetDistance(spawner,entity)
		if distance>=200 then
			entity:MoveToPosition(spawner:GetOrigin())
		end
	end

	function UnitAI:AttackToTarget(ai_target)
		local spawner = entity.SpawnEnt

		local distance=GetDistance(spawner,entity)
		if distance>=200 then
			entity:MoveToPositionAggressive(ai_target:GetOrigin())
		end
	end

	function UnitAI:CastAbilityRandomUnit(ability)
		local unit = PylAI:FindRadiusOneUnit(entity,300)
		if unit~=nil and unit:IsNull()==false then
			if ability:IsCooldownReady() then
				PylAI:CastAbility(entity,ability)
			end
		else
			local distance = GetDistance(entity.SpawnEnt,entity)
		    if distance>300 then
		    	UnitAI:GoToSpawner()
		    end
		end
	end

	function UnitAI:CreateBaseAI(MAXDIS,MAXHATEDIS)
		if entity.IsAIstart == true then
			local SpawnEnt = entity.SpawnEnt
			local unitName = entity:GetUnitName()
			local findNum =  string.find(unitName, 'boss')

			if findNum ~= nil then
				local ability=entity:GetAbilityByIndex(0)

				if ability ~= nil then
					UnitAI:CastAbilityRandomUnit(ability)
				end
			end
		   
		    local distance = GetDistance(SpawnEnt,entity)
		    if distance>=MAXDIS then
		    	UnitAI:GoToSpawner()
		    end
		end
	end
	return UnitAI
end
--施法
function PylAI:CastAbility( unit, ability, isAttackingBoss)
	if not ability then return end
	if ability:IsInAbilityPhase() or not ability:IsCooldownReady() or unit:IsChanneling() then
		return
	end

	if GameRules:GetCustomGameDifficulty() <= 5 then
		if unit:IsStunned() or unit:IsSilenced() then
			return
		end
	end

	if isAttackingBoss then
		unit:AddNewModifier(unit, nil, "modifier_shushan_boss_casting", {duration=1.5})
	end
	
	if ability:IsUnitTarget() then
		-- print(unit:GetUnitName().." Cast "..ability:GetAbilityName())
	    local target = PylAI:FindRadiusOneUnit( unit,ability:GetCastRange(), ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType())
		if target then
			unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())

			local radius = ability:GetLevelSpecialValueFor("radius", 1) or 110
			local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
			ParticleManager:SetParticleControl(p,0,unit:GetOrigin())
			ParticleManager:SetParticleControlEnt(p, 1, target, 5, "follow_origin", target:GetOrigin(), true)
			ParticleManager:SetParticleControl(p,2,Vector(radius,radius,radius))
			ParticleManager:SetParticleControl(p,3,target:GetOrigin())
			ParticleManager:DestroyParticleSystem(p)
			-- print("target:",target:GetUnitName())

		end
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		-- print(unit:GetUnitName().." Cast "..ability:GetAbilityName())
	    local target = PylAI:FindRadiusOneUnit( unit,ability:GetCastRange() )
	    -- print(target:GetUnitName())
	    if target then
			unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())

			local radius = ability:GetLevelSpecialValueFor("radius", 1) or 200
			local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
			ParticleManager:SetParticleControl(p,0,unit:GetOrigin())
			ParticleManager:SetParticleControl(p,1,target:GetOrigin())
			ParticleManager:SetParticleControl(p,2,Vector(radius,radius,radius))
			ParticleManager:SetParticleControl(p,3,target:GetOrigin())
			ParticleManager:DestroyParticleSystem(p)

		end
	elseif ability:IsNoTarget() then
		-- print("IsNoTarget()")
		-- print(unit:GetUnitName().." Cast "..ability:GetAbilityName())
		unit:CastAbilityNoTarget(ability, -1)

		local radius = ability:GetLevelSpecialValueFor("radius", 1) or 200
		local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
		ParticleManager:SetParticleControl(p,0,unit:GetOrigin())
		ParticleManager:SetParticleControl(p,1,unit:GetOrigin())
		ParticleManager:SetParticleControl(p,2,Vector(radius,radius,radius))
		ParticleManager:SetParticleControl(p,3,unit:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)
	end
end

function PylAI:FindRadiusOneUnit( entity, range, team, types )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, 
		team or DOTA_UNIT_TARGET_TEAM_ENEMY, 
		types or DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
		0, false )
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function PylAI:WeakestEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
		0, false )
	if enemies ~= nil then
		local minHP = nil
		local target = nil 

		for _,enemy in pairs(enemies) do
			local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
			local HP = enemy:GetHealth()
			if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
				minHP = HP
				target = enemy
			end
		end
	end

	return target
end
