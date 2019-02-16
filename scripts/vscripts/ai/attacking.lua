
-- @var thisEntity
-- @var GoBackDistance 返回距离
-- @var SpawnEntity 出生所在的实体
	

-- 当AI创建
function Spawn()
	if IsBoss then
		thisEntity:AddStateMachine(_G["AttackingBoss_CastAbilityState"])
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_attacking_boss", nil)

		thisEntity:SetContextThink(DoUniqueString("modifier_attacking_boss"), function ()
			if GameRules:IsGamePaused() then
				EachHero(function (hero)
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_display_bubble",
						{text="shushan_game_pasused_text"..tostring(RandomInt(1, 5)),args={},unit=thisEntity:GetEntityIndex()})
				end)
			end

			return RandomFloat(10, 20)
		end, 0)
	end

	if thisEntity.__is_elite then
		thisEntity:AddStateMachine(_G["AttackingElite_CastAbilityState"])
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_attacking_boss", nil)
	end
	
	ShuShanAddAttackingState(thisEntity, SpawnEntity)
end

-- 每1秒执行一次，如果返回数字将成为下一次执行的时间
function Think()
	return thisEntity:StateMachineThink(_ENV)

	-- 移动到下一个点
	-- local distance = (CurrentEntity:GetOrigin() - thisEntity:GetOrigin()):Length2D()
	-- if distance < 100 then
	-- 	local children = CurrentEntity:GetChildren()
	-- 	if #children > 0 then
	-- 		CurrentEntity = children[#children]
	-- 	end
	-- end

	-- if LastEnt ~= CurrentEntity then
	-- 	LastEnt = CurrentEntity
	-- 	thisEntity:MoveToPositionAggressive(CurrentEntity:GetOrigin())
	-- 	return 0.3
	-- end

	-- if GameRules:GetGameTime() - LastTime >= 2 then
	-- 	LastTime = GameRules:GetGameTime()
	-- 	thisEntity:MoveToPositionAggressive(CurrentEntity:GetOrigin())
	-- end
	
	-- return 0.3
end