
-- @var thisEntity

-- 当AI创建
function Spawn()
	thisEntity:AddStateMachine(_G["DungeonBoss_CastAbilityState"])
	thisEntity:AddStateMachine(_G["DungeonBoss_GoBackState"])
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
	return thisEntity:StateMachineThink(_ENV)
end