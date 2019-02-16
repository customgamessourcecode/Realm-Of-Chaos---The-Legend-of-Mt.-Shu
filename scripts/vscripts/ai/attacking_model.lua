
function ShuShanAddAttackingState(unit, ent)
	local SpawnIndex = tostring(ent:GetEntityIndex())
	local prefix = "Attacking_State_"..SpawnIndex.."_"

	-- 进攻路劲
	if _G[prefix.."1"] then
		unit:AddStateMachine(_G[prefix.."1"])
	else
		local Enter = function (self, env)
			return true
		end

		local OnEnter = function (self, env)
		end

		local OnLeave = function (self, env)
		end

		local OnUpdate = function (self, env)
			local children = env.SpawnEntity:GetChildren()
			env.thisEntity:MoveToPositionAggressive(children[#children-self:GetOffset()]:GetOrigin())

			if (children[#children-self:GetOffset()]:GetOrigin() - env.thisEntity:GetOrigin()):Length2D() <= 100 then
				env.thisEntity:RemoveStateMachine(self)

				local state = _G[prefix..self:GetOffset()+2]
				if state then
					env.thisEntity:AddStateMachine(state)
				else
					env.thisEntity:AddStateMachine(_G["Attacking_AttackToFort"])
				end
			end

			return 0.2
		end

		local num = #ent:GetChildren()
		for i=1,num do
			local state = {
				GetOffset = function ()
					return i - 1
				end,
				Enter = Enter,
				OnEnter = OnEnter,
				OnLeave = OnLeave,
				OnUpdate = OnUpdate,
			}
			_G[prefix..i] = state
		end

		_G["Attacking_AttackToFort"] =
		{
			Enter = Enter,
			OnEnter = OnEnter,
			OnLeave = OnLeave,
			OnUpdate = function ( self, env )
				if ShushanFort:IsNull() then return end
				env.thisEntity:MoveToPositionAggressive(ShushanFort:GetOrigin() + Vector(400,-400,0))
				return 1.5
			end,
		}

		unit:AddStateMachine(_G[prefix.."1"])
	end

	-- 攻击状态
	if _G["Attacking_AttackState"] then
		unit:AddStateMachine(_G["Attacking_AttackState"])
	else
		_G["Attacking_AttackState"] =
		{
			Enter = function (self, env)
				return env.thisEntity:IsAttacking()
			end,
			OnEnter = function (self, env)
				env.thisEntity:SetNextStateTime(2)
			end,
			OnLeave = function (self, env)
			end,
			OnUpdate = function (self, env)
				local CurrentWaitingEntity = env.CurrentWaitingEntity
				local thisEntity = env.thisEntity
				local GoBackDistance = env.GoBackDistance
				local SpawnEntity = env.SpawnEntity

				-- 获取最短距离
				local children = SpawnEntity:GetChildren()
				local shortestEnt
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
					return 3
				end

				if ShushanFort:IsNull() then return end
				env.thisEntity:MoveToPositionAggressive(ShushanFort:GetOrigin())

				return 1.5
			end,
		}
		unit:AddStateMachine(_G["Attacking_AttackState"])
	end
end

-- 施法状态
if _G["AttackingBoss_CastAbilityState"] == nil then
	_G["AttackingBoss_CastAbilityState"] =
	{
		Enter = function (self, env)
			local ent = env.thisEntity

			-- local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
			-- local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
			-- local iFlagFilter = DOTA_UNIT_TARGET_FLAG_NONE
			-- local iOrder = FIND_UNITS_EVERYWHERE
			-- local entities = FindUnitsInRadius(ent:GetTeam(), ent:GetOrigin(), nil, 1000, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)

			return FindOnePlayersHeroInRadius(ent, 1000) ~= nil
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(3)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local ent = env.thisEntity
			local ability

			if ent:GetHealthPercent() <= 50 then
				local count = 0
				for i=0,6 do
					if ent:GetAbilityByIndex(i) ~= nil then
						count = count + 1
					end
				end
				env.__ability_count = count - 1
			end

			if ent:GetHealthPercent() <= 50 then
				local count = env.__ability_count
				ability = ent:GetAbilityByIndex(RandomInt(0, count))
			else
				ability = ent:GetAbilityByIndex(RandomInt(0, 1))
			end

			-- local ability

			-- if ent:GetHealthPercent() <= 50 then
			-- 	if env.__ability_count == nil then
			-- 		local count = 0
			-- 		for i=0,6 do
			-- 			if ent:GetAbilityByIndex(i) ~= nil then
			-- 				count = count + 1
			-- 			end
			-- 		end
			-- 		env.__ability_count = count - 1
			-- 	end
				
			-- 	local count = env.__ability_count
			-- 	local min = 0

			-- 	if RollPercentage(50) then min = 2 end

			-- 	ability = ent:GetAbilityByIndex(RandomInt(min, count))
			-- 	if not ability:IsCooldownReady() then
			-- 		for i=0,count do
			-- 			ability = ent:GetAbilityByIndex(RandomInt(min, count))
			-- 			if ability:IsCooldownReady() then break end
			-- 		end
			-- 	end
			-- else
			-- 	ability = ent:GetAbilityByIndex(RandomInt(0, 1))
			-- 	if not ability:IsCooldownReady() then
			-- 		if ability:GetAbilityIndex() == 0 then
			-- 			ability = ent:GetAbilityByIndex(1)
			-- 		else
			-- 			ability = ent:GetAbilityByIndex(0)
			-- 		end
			-- 	end
			-- end 

			PylAI:CastAbility( ent, ability, true )
			return 3.1
		end,
	}
end


-- 精英怪施法状态
if _G["AttackingElite_CastAbilityState"] == nil then
	_G["AttackingElite_CastAbilityState"] =
	{
		Enter = function (self, env)
			local ent = env.thisEntity

			-- local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
			-- local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
			-- local iFlagFilter = DOTA_UNIT_TARGET_FLAG_NONE
			-- local iOrder = FIND_UNITS_EVERYWHERE
			-- local entities = FindUnitsInRadius(ent:GetTeam(), ent:GetOrigin(), nil, 1000, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
			return FindOnePlayersHeroInRadius(ent, 1000) ~= nil
		end,
		OnEnter = function (self, env)
			env.thisEntity:SetNextStateTime(3)
		end,
		OnLeave = function (self, env)
		end,
		OnUpdate = function (self, env)
			local ent = env.thisEntity
			local ability = ent:GetAbilityByIndex(RandomInt(0, 3))

			if ability and not ability:IsCooldownReady() then
				for i=0,3 do
					ability = ent:GetAbilityByIndex(RandomInt(0, 3))
					if ability and ability:IsCooldownReady() then break end
				end
			end

			PylAI:CastAbility(ent, ability, true)
			return 3.1
		end,
	}
end