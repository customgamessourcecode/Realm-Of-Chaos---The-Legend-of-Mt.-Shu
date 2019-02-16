
if UnitStates == nil then
	UnitStates = RegisterController('unit_states')
	UnitStates.__unit_states = {}
	setmetatable(UnitStates,UnitStates)
end

local public = UnitStates

--[[
state:
	shop
	quest-accept
	quest-finished
]]

function public:new(steamid, unit, name)
	local pstates = self.__unit_states[steamid]
	if not pstates then
		pstates = {}
		self.__unit_states[steamid] = pstates
	end

	local states = pstates[unit:GetEntityIndex()]
	if not states then
		states = {}
		pstates[unit:GetEntityIndex()] = states
	end

	if not self:HasState(steamid, unit, name) then
		table.insert(states,name);
		self:Update(steamid)
	end
end

function public:HasState(steamid, unit, name)
	local pstates = self.__unit_states[steamid]
	if not pstates then
		pstates = {}
		self.__unit_states[steamid] = pstates
	end
	local states = pstates[unit:GetEntityIndex()]
	if not states then return false end

	for i,v in ipairs(states) do
		if name == v then
			return true
		end
	end

	return false
end

function public:del(steamid, unit, name)
	local pstates = self.__unit_states[steamid]
	if not pstates then return false end
	local states = pstates[unit:GetEntityIndex()]
	if not states then return false end

	for i,v in ipairs(states) do
		if name == v then
			table.remove(states,i)
			self:Update(steamid)
			return true
		end
	end

	return false
end

function public:Update(steamid)
	CustomNetTables:SetTableValue("Common", "unit_states_"..steamid, self.__unit_states[steamid] )
end