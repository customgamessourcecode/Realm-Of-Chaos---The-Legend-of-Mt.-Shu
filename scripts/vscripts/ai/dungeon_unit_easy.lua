
-- @var thisEntity

-- 当AI创建
function Spawn()
	thisEntity:AddStateMachine(_G["DungeonUnitEasy_IdleState"])
	thisEntity:AddStateMachine(_G["DungeonUnitEasy_GoBackState"])
end

-- 每秒执行一次，如果返回数字将成为下一次执行的时间
function Think()
	return thisEntity:StateMachineThink(_ENV)
end