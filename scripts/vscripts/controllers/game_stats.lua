
if GameStats == nil then
	GameStats = RegisterController('game_stats')
	GameStats.__data = {}
	setmetatable(GameStats,GameStats)
end

local public = GameStats

function public:Data()
	return self.__data
end

--[[
设置一个值
]]
function public:Set(name, key, value)
	local t = self.__data[name]
	if t == nil then
		t = {}
		self.__data[name] = t
	end
	t[key] = value
end

--[[
插入一个值
]]
function public:Insert(name, key, value)
	local t = self.__data[name]
	if t == nil then
		t = {}
		self.__data[name] = t
	end
	local a = t[key]
	if a == nil then
		a = {}
		t[key] = a
	end
	table.insert(a,value)
end

--[[
自增+1
]]
function public:Increment(name, key)
	local t = self.__data[name]
	if t == nil then
		t = {}
		self.__data[name] = t
	end
	if t[key] == nil then
		t[key] = 0
	end
	if type(t[key]) == "number" then
		t[key] = t[key] + 1
	end
end

-- 统计
function public:Total()
	local data = self:Data()
	return data
end

-- 
function public:Timeline()
	local data = {}
	self:Data()["Timeline"] = data

	-- Timer(60, function ()
	-- 	return 60
	-- end)
end
