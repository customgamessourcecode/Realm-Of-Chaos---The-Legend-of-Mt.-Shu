
-- 施法状态
if _G["DungeonBoss_FuShuiZhiFeng_CastAbilityState"] == nil then
	_G["DungeonBoss_FuShuiZhiFeng_CastAbilityState"] =
	{
		Enter = function (self, env)
			local ent = env.thisEntity

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
			
			local count = 5
			local min = 0

			if ent:GetHealthPercent() <= 70 then count = 6 end

			ability = ent:GetAbilityByIndex(RandomInt(min, count))
			if not ability:IsCooldownReady() then
				for i=0,count do
					ability = ent:GetAbilityByIndex(RandomInt(min, count))
					if ability:IsCooldownReady() then break end
				end
			end

			PylAI:CastAbility( ent, ability, true)
			return 3.1
		end,
	}
end

-- @var thisEntity

-- 当AI创建
function Spawn()
	thisEntity:AddStateMachine(_G["DungeonBoss_FuShuiZhiFeng_CastAbilityState"])
	thisEntity:AddStateMachine(_G["DungeonBoss_AttackState"])
	thisEntity:AddStateMachine(_G["DungeonBoss_IdleState"])

	thisEntity.SpawnEnt = SpawnEntity
	
	local children = SpawnEntity:GetChildren()
	if #children > 0 then
		local child = children[#children]
		if child.Disable then
			child:Disable()
		end
	end

	if SpawnEntity.__trigger_effect then
		ParticleManager:DestroyParticle(SpawnEntity.__trigger_effect, true)
	end
end

-- 每秒执行一次，如果返回数字将成为下一次执行的时间
function Think()
	if (SpawnEntity:GetOrigin() - thisEntity:GetOrigin()):Length2D() >= 4000 then
 		thisEntity:MoveToPosition(SpawnEntity:GetOrigin())
 		return 2
	end
	return thisEntity:StateMachineThink(_ENV)
end