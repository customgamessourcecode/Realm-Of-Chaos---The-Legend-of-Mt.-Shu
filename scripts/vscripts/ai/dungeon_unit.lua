
-- @var thisEntity
-- @var GoBackDistance 返回距离
-- @var SpawnEntity 出生所在的实体
-- @var CurrentWaitingEntity 当前所在停留的实体
-- @var WaitingTime 一开始等待的时间

-- 当AI创建
function Spawn()

	local children = SpawnEntity:GetChildren()
	if #children > 0 then
		CurrentWaitingEntity = SpawnEntity
		WaitingTime = GameRules:GetGameTime()
	end

	thisEntity:AddStateMachine(_G["DungeonUnit_MoveState"])
	thisEntity:AddStateMachine(_G["DungeonUnit_AttackState"])
end

-- 每1秒执行一次，如果返回数字将成为下一次执行的时间
function Think()
	return thisEntity:StateMachineThink(_ENV)
end