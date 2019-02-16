
local __avalon_custom_events = Avalon:Forever('__avalon_custom_events',{})
local __avalon_custom_conform_events = Avalon:Forever('__avalon_custom_conform_events',{})

--[[
=========================================================================
Avalon自定义事件-触发事件
=========================================================================
@param {string} event
@param {params} ...
@return void
]]
function Avalon:Fire(event, ...)
	local eventList = __avalon_custom_events[event]
	if not eventList then return end

	for i,t in ipairs(eventList) do
		if t.context == nil then
			t.func(...)
		else
			t.func(t.context, ...)
		end
	end
end

--[[
=========================================================================
Avalon自定义事件-监听事件
=========================================================================
@param {string}   event
@param {function} func
@param {table}    context
@return void
]]
function Avalon:Listen(event, func, context)
	assert(type(event) == "string","[Avalon:Listen] param 1 is not a string")
	assert(type(func) == "function","[Avalon:Listen] param 2 is not a function")
	assert(type(context) == "table" or type(context) == "nil","[Avalon:Listen] param 3 is not a table")

	local eventList = __avalon_custom_events[event]
	if eventList == nil then
		eventList = {}
		__avalon_custom_events[event] = eventList
	end

	table.insert(eventList,{func=func,context=context})
end

--[[
=========================================================================
抛出错误，在UI监听"avalon_throw_error"事件即可收到发出的错误
=========================================================================
@param {handle}   unit
@param {string}   text
@param {value} returnValue
@return value
]]
function Avalon:Throw(unit, text, returnValue)
	CustomGameEventManager:Send_ServerToPlayer(unit:GetPlayerOwner(), "avalon_throw_error", {text=text})
	return returnValue
end

--[[
=========================================================================
抛出错误给所以玩家，在UI监听"avalon_throw_error"事件即可收到发出的错误
=========================================================================
@param {string}   text
@param {value} returnValue
@return value
]]
function Avalon:ThrowAll(text, returnValue)
	CustomGameEventManager:Send_ServerToAllClients("avalon_throw_error", {text=text})
	return returnValue
end

--[[
=========================================================================
Avalon确认事件-触发事件
=========================================================================
@param {string} event
@param {params} ...
@return value
]]
function Avalon:Conform(event, ...)
	local t = __avalon_custom_conform_events[event]
	if not t then return end

	if t.context == nil then
		return t.func(...)
	else
		return t.func(t.context, ...)
	end
end

--[[
=========================================================================
Avalon确认事件-绑定确认函数
=========================================================================
@param {string}   event
@param {function} func
@param {table}    context
@return void
]]
function Avalon:BindConform(event, func, context)
	assert(type(event) == "string","[Avalon:Listen] param 1 is not a string")
	assert(type(func) == "function","[Avalon:Listen] param 2 is not a function")
	assert(type(context) == "table" or type(context) == "nil","[Avalon:Listen] param 3 is not a table")

	__avalon_custom_conform_events[event] = {func=func,context=context}
end