
if AICtrl == nil then
	AICtrl = RegisterController('ai')
	-- AICtrl.__units_ai_env = {}
	AICore = {}
	setmetatable(AICtrl,AICtrl)
end

local public = AICtrl

function public:init()
	-- ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
end

function public:__call(unit)
	-- return self.__units_ai_env[unit:GetEntityIndex()]
end

--[[
创建AI
]]
function public:CreateAI(unit, filename, init_data)
	-- if self.__units_ai_env[unit:GetEntityIndex()] ~= nil then return end

	local env = init_data or {}
	env["thisEntity"] = unit
	env["_ENV"] = env
	setmetatable(env,{__index=_G})

	local func = assert(loadfile('ai.'..filename))
	setfenv(func,env)
	func()

	if env["Spawn"] then
		env["Spawn"]()
	end

	local Think = env["Think"]
	if Think then
		Timer(DoUniqueString("AICtrl"), unit, 0, function ()
			return Think() or 1
		end)
	end

	-- self.__units_ai_env[unit:GetEntityIndex()] = env
end

function public:OnEntityKilled(keys)
	-- local victim = EntIndexToHScript(keys.entindex_killed)
	-- self.__units_ai_env[victim:GetEntityIndex()] = nil
end

--[[
有限状态机的实现
]]
function CDOTA_BaseNPC:AddStateMachine(state)
	local list = self.__ai_state_machine_list
	if list == nil then
		list = {}
		self.__ai_state_machine_list = list
	end
	for i,v in ipairs(list) do
		if v == state then
			return
		end
	end
	table.insert(list,state)
end

function CDOTA_BaseNPC:RemoveStateMachine(state)
	local list = self.__ai_state_machine_list
	for i,v in ipairs(list) do
		if v == state then
			if self.__ai_state_machine == state then
				self.__ai_state_machine = nil
			end
			return table.remove(list,i)
		end
	end
end

function CDOTA_BaseNPC:GetCurrentStateMachine()
	return self.__ai_state_machine
end

function CDOTA_BaseNPC:SetNextStateTime(interval)
	self.__ai_next_state_time = GameRules:GetGameTime() + interval
end

function CDOTA_BaseNPC:GetNextStateTime()
	return self.__ai_next_state_time or 0
end

function CDOTA_BaseNPC:StateMachineThink(env)
	local list = self.__ai_state_machine_list
	local currentState = self.__ai_state_machine

	if GameRules:GetGameTime() >= env.thisEntity:GetNextStateTime() then
		for i,state in ipairs(list) do
			if currentState ~= state and state:Enter(env) then
				if currentState then currentState:OnLeave(env) end
				currentState = state
				currentState:OnEnter(env)
				self.__ai_state_machine = currentState
				break
			end
		end
	end

	if currentState == nil then
		return 1
	end
	return currentState:OnUpdate(env) or 1
end

--[[
Following copy from holdout_example

Tower Defense AI

These are the valid orders, in case you want to use them (easier here than to find them in the C code):

DOTA_UNIT_ORDER_NONE
DOTA_UNIT_ORDER_MOVE_TO_POSITION 
DOTA_UNIT_ORDER_MOVE_TO_TARGET 
DOTA_UNIT_ORDER_ATTACK_MOVE
DOTA_UNIT_ORDER_ATTACK_TARGET
DOTA_UNIT_ORDER_CAST_POSITION
DOTA_UNIT_ORDER_CAST_TARGET
DOTA_UNIT_ORDER_CAST_TARGET_TREE
DOTA_UNIT_ORDER_CAST_NO_TARGET
DOTA_UNIT_ORDER_CAST_TOGGLE
DOTA_UNIT_ORDER_HOLD_POSITION
DOTA_UNIT_ORDER_TRAIN_ABILITY
DOTA_UNIT_ORDER_DROP_ITEM
DOTA_UNIT_ORDER_GIVE_ITEM
DOTA_UNIT_ORDER_PICKUP_ITEM
DOTA_UNIT_ORDER_PICKUP_RUNE
DOTA_UNIT_ORDER_PURCHASE_ITEM
DOTA_UNIT_ORDER_SELL_ITEM
DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
DOTA_UNIT_ORDER_MOVE_ITEM
DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
DOTA_UNIT_ORDER_STOP
DOTA_UNIT_ORDER_TAUNT
DOTA_UNIT_ORDER_BUYBACK
DOTA_UNIT_ORDER_GLYPH
DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
DOTA_UNIT_ORDER_CAST_RUNE
]]

function AICore:RandomEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function AICore:WeakestEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

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

	return target
end

function AICore:CreateBehaviorSystem( behaviors )
	local BehaviorSystem = {}

	BehaviorSystem.possibleBehaviors = behaviors
	BehaviorSystem.thinkDuration = 1.0
	BehaviorSystem.repeatedlyIssueOrders = true -- if you're paranoid about dropped orders, leave this true

	BehaviorSystem.currentBehavior =
	{
		endTime = 0,
		order = { OrderType = DOTA_UNIT_ORDER_NONE }
	}

	function BehaviorSystem:Think()
		if GameRules:GetGameTime() >= self.currentBehavior.endTime then
			local newBehavior = self:ChooseNextBehavior()
			if newBehavior == nil then 
				-- Do nothing here... this covers possible problems with ChooseNextBehavior
			elseif newBehavior == self.currentBehavior then
				self.currentBehavior:Continue()
			else
				if self.currentBehavior.End then self.currentBehavior:End() end
				self.currentBehavior = newBehavior
				self.currentBehavior:Begin()
			end
		end

		if self.currentBehavior.order and self.currentBehavior.order.OrderType ~= DOTA_UNIT_ORDER_NONE then
			if self.repeatedlyIssueOrders or
				self.previousOrderType ~= self.currentBehavior.order.OrderType or
				self.previousOrderTarget ~= self.currentBehavior.order.TargetIndex or
				self.previousOrderPosition ~= self.currentBehavior.order.Position then

				-- Keep sending the order repeatedly, in case we forgot >.<
				ExecuteOrderFromTable( self.currentBehavior.order )
				self.previousOrderType = self.currentBehavior.order.OrderType
				self.previousOrderTarget = self.currentBehavior.order.TargetIndex
				self.previousOrderPosition = self.currentBehavior.order.Position
			end
		end

		if self.currentBehavior.Think then self.currentBehavior:Think(self.thinkDuration) end

		return self.thinkDuration
	end

	function BehaviorSystem:ChooseNextBehavior()
		local result = nil
		local bestDesire = nil
		for _,behavior in pairs( self.possibleBehaviors ) do
			local thisDesire = behavior:Evaluate()
			if bestDesire == nil or thisDesire > bestDesire then
				result = behavior
				bestDesire = thisDesire
			end
		end

		return result
	end

	function BehaviorSystem:Deactivate()
		if self.currentBehavior.End then self.currentBehavior:End() end
	end

	return BehaviorSystem
end