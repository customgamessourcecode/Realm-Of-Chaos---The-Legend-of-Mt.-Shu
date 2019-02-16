-- 发呆状态
if _G["DungeonBoss_IdleState"] == nil then
	_G["DungeonBoss_IdleState"] =
	{
		Enter = function (self, env)
			return env.thisEntity:IsIdle()
		end,
		OnEnter = function (self, env)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			-- env.thisEntity:ForcePlayActivityOnce(ACT_DOTA_ATTACK)
			if (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() >= 50 then
				env.thisEntity:MoveToPositionAggressive(env.SpawnEntity:GetOrigin())
			end
			return 0.7
		end,
	}
end

-- 超过限定距离往回走状态
if _G["DungeonBoss_GoBackState"] == nil then
	_G["DungeonBoss_GoBackState"] =
	{
		Enter = function (self, env)
			return (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() >= 2000
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(300)
			env.thisEntity.__heal_amount = env.thisEntity:GetMaxHealth() * 0.05
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			env.thisEntity:MoveToPosition(env.SpawnEntity:GetOrigin())
			env.thisEntity:Heal(env.thisEntity.__heal_amount, nil)

			if (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() <= 200 then
				env.thisEntity:SetNextStateTime(0)
			end
			return 0.2
		end,
	}
end

-- 攻击状态
if _G["DungeonBoss_AttackState"] == nil then
	_G["DungeonBoss_AttackState"] =
	{
		Enter = function (self, env)
			return env.thisEntity:IsAttacking()
		end,
		OnEnter = function (self, env)
			env.thisEntity.__aggro_target = env.thisEntity:GetAttackTarget()
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local target = env.thisEntity.__aggro_target
			if target and target:IsNull()==false and (env.thisEntity:GetOrigin() - target:GetOrigin()):Length2D() <= 1000 then
				env.thisEntity:MoveToTargetToAttack(target)
			else
				env.thisEntity:MoveToPositionAggressive(env.SpawnEntity:GetOrigin())
			end
			return 0.35
		end,
	}
end

-- 施法状态
if _G["DungeonBoss_CastAbilityState"] == nil then
	_G["DungeonBoss_CastAbilityState"] =
	{
		Enter = function (self, env)
			local ability = env.thisEntity:GetAbilityByIndex(0)

			if GameRules:GetCustomGameDifficulty() > 5 then
				if FindOnePlayersHeroInRadius(env.thisEntity, 700) == nil then return end
				return ability and ability:IsCooldownReady() and not ability:IsPassive()
			end

			return ability and ability:IsCooldownReady() and not ability:IsPassive() and env.thisEntity:IsAttacking()
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(1.5)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local ability = env.thisEntity:GetAbilityByIndex(0)
			PylAI:CastAbility( env.thisEntity, ability)
			return 1
		end,
	}
end




------------------------------------------------------------------------------------------------------------------------------

-- 巡逻状态
if _G["DungeonUnit_MoveState"] == nil then
	_G["DungeonUnit_MoveState"] =
	{
		Enter = function (self, env)
			return not env.thisEntity:IsAttacking()
		end,
		OnEnter = function (self, env)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local CurrentWaitingEntity = env.CurrentWaitingEntity
			local WaitingTime = env.WaitingTime
			local thisEntity = env.thisEntity
			local GoBackDistance = env.GoBackDistance
			local SpawnEntity = env.SpawnEntity
			
			-- 获取最短距离
			local children = SpawnEntity:GetChildren()
			local shortestEnt = SpawnEntity
			local shortestDistance = (SpawnEntity:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
			for i,v in ipairs(children) do
				local d = (v:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
				if d < shortestDistance then
					shortestDistance = d
					shortestEnt = v
				end
			end

			-- 如果最短距离超过GoBackDistance则返回
			if shortestEnt and shortestDistance >= GoBackDistance then
				thisEntity:MoveToPosition(shortestEnt:GetOrigin())
				return 1
			end

			-- 移动到下一个点
			local distance = (CurrentWaitingEntity:GetOrigin() - thisEntity:GetOrigin()):Length2D()
			if distance > 50 then
				thisEntity:MoveToPositionAggressive(CurrentWaitingEntity:GetOrigin())
			else
				local secs = CurrentWaitingEntity:Attribute_GetFloatValue("WaitingSecs",-1)
				if secs <= 0 or GameRules:GetGameTime() - WaitingTime >= secs then
					WaitingTime = GameRules:GetGameTime()

					local children = CurrentWaitingEntity:GetChildren()
					if #children > 0 then
						env.CurrentWaitingEntity = children[#children]
					else
						env.CurrentWaitingEntity = SpawnEntity
					end

					thisEntity:MoveToPositionAggressive(CurrentWaitingEntity:GetOrigin())
					
				end
			end

			return 0.3
		end,
	}
end

-- 攻击状态
if _G["DungeonUnit_AttackState"] == nil then
	_G["DungeonUnit_AttackState"] =
	{
		Enter = function (self, env)
			return env.thisEntity:IsAttacking()
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(10)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local thisEntity = env.thisEntity
			local GoBackDistance = env.GoBackDistance
			local SpawnEntity = env.SpawnEntity

			-- 获取最短距离
			local children = SpawnEntity:GetChildren()
			local shortestEnt = SpawnEntity
			local shortestDistance = (SpawnEntity:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
			for i,v in ipairs(children) do
				local d = (v:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
				if d < shortestDistance then
					shortestDistance = d
					shortestEnt = v
				end
			end

			-- 如果最短距离超过GoBackDistance则返回
			if shortestEnt and shortestDistance >= GoBackDistance then
				thisEntity:MoveToPosition(shortestEnt:GetOrigin())
				return 1
			end

			return 1
		end,
	}
end


-- 发呆状态
if _G["DungeonUnitEasy_IdleState"] == nil then
	_G["DungeonUnitEasy_IdleState"] =
	{
		Enter = function (self, env)
			return env.thisEntity:IsIdle()
		end,
		OnEnter = function (self, env)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			-- env.thisEntity:ForcePlayActivityOnce(ACT_DOTA_ATTACK)
			if (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() >= 50 then
				env.thisEntity:MoveToPositionAggressive(env.SpawnEntity:GetOrigin())
			end
			return 2
		end,
	}
end

-- 超过限定距离往回走状态
if _G["DungeonUnitEasy_GoBackState"] == nil then
	_G["DungeonUnitEasy_GoBackState"] =
	{
		Enter = function (self, env)
			return (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() >= 2000
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(300)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			env.thisEntity:MoveToPosition(env.SpawnEntity:GetOrigin())

			if (env.thisEntity:GetOrigin() - env.SpawnEntity:GetOrigin()):Length2D() <= 200 then
				env.thisEntity:SetNextStateTime(0)
			end
			return 2
		end,
	}
end