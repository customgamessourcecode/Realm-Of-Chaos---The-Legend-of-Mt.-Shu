
local GameMode = GameRules:GetGameModeEntity()

--[[
延迟调用函数，同一函数在延迟时间内只能调用一次

@params delay  int
@params unique any_type  保证独立的值，比如EntityIndex,SteamID
@params func   function
@params ...    func's params
]]
local __DelayDispatchLock = {}
function DelayDispatch(delay, unique, func, ... )
	local index = tostring(unique)..tostring(func)
	local time = __DelayDispatchLock[index] or 0

	if Time() - time > delay then
		__DelayDispatchLock[index] = Time()
		local a,b,c,d,e,f,g,h,i,j,k = ...

		GameMode:SetContextThink(index, function ()
			func(a,b,c,d,e,f,g,h,i,j,k)
			return nil
		end, delay)
	end
end

--[[
遍历table
function(key,value) end
返回true可以中止循环

@params t table
@params f function
]]
function Each(t,f)
	for k,v in pairs(t) do
		if f(k,v) == true then return end
	end
end

--[[
遍历所有玩家的英雄
function(hero) end
返回true可以中止循环

@params f function
]]
function EachHero(f)
	local count = PlayerResource:GetPlayerCount()
	for i=0,count do
		local player = PlayerResource:GetPlayer(i)
		if player then
			local hero = player:GetAssignedHero() 
			if hero then
				if f(hero) == true then return end
			end
		end
	end
end

--[[
遍历所有玩家
function(player) end
返回true可以中止循环

@params f function
]]
function EachPlayer(f)
	local count = PlayerResource:GetPlayerCount()
	for i=0,count do
		local player = PlayerResource:GetPlayer(i)
		if player then
			if f(player) == true then return end
		end
	end
end

--[[
遍历所有玩家ID
function(player) end
返回true可以中止循环

@params f function
]]
function EachPlayerID(f)
	local count = PlayerResource:GetPlayerCount()
	for i=0,count do
		local player = PlayerResource:GetPlayer(i)
		if player then
			if f(i) == true then return end
		end
	end
end

--[[
遍历所有玩家的steamid
function(steamid) end
返回true可以中止循环

@params f function
]]
function EachSteamID(f)
	local count = PlayerResource:GetPlayerCount()
	for i=0,count do
		local steamid = tostring(PlayerResource:GetSteamID(i))
		if steamid ~= "0" then
			if f(steamid) == true then return end
		end
	end
end

--[[
获取两个实体的距离

@params ent1 handle
@params ent2 handle
@return int
]]
function GetDistance(ent1, ent2)
	return (ent1:GetOrigin() - ent2:GetOrigin()):Length2D()
end

--[[
计时器，对SetContextThink的简化
1.游戏暂停将不会继续执行
2.实体死亡将不会继续执行，英雄单位会跳过这个条件
3.实体无效将不会继续执行

调用方式
Timer([unique_str,] func)
Timer([unique_str,] delay, func)
Timer([unique_str,] entity, func)
Timer([unique_str,] entity, delay, func)

@params entity handle
@params delay  int
@params func   function
@params unique_str string 可选
]]
function Timer(...)
	local arg1,arg2,arg3,arg4 = ...
	local entity,delay,func,unique_str

	if type(arg1) == "string" then
		unique_str = arg1
		arg1,arg2,arg3 = arg2,arg3,arg4
	else
		unique_str = DoUniqueString("Timer")
	end

	if type(arg1) == "function" then
		entity = GameMode
		delay = 0
		func = arg1
	
	elseif type(arg1) == "number" and type(arg2) == "function" then
		entity = GameMode
		delay = arg1
		func = arg2

	elseif type(arg1) == "table" and type(arg2) == "function" then
		entity = arg1
		delay = 0
		func = arg2

	elseif type(arg1) == "table" and type(arg2) == "number" and type(arg3) == "function" then
		entity = arg1
		delay = arg2
		func = arg3

	end

	if type(entity) ~= "table" or type(delay) ~= "number" or type(func) ~= "function" then
		return
	end

	entity:SetContextThink(unique_str, function ()
		if entity:IsNull() then
			return nil
		end
		if not entity:IsAlive() then
			if entity.IsHero and entity:IsHero() then
			else
				return nil
			end
		end
		if GameRules:IsGamePaused() then
			return 0.1
		end
		return func()
	end, delay)
end

--[[
等待N秒后执行

调用方式
Timer([unique_str,] delay, func)
Timer([unique_str,] entity, delay, func)

@params entity handle
@params delay  int
@params func   function
@params unique_str string 可选
]]
function Wait(arg1,arg2,arg3,arg4)
	local entity,delay,func,unique_str

	if type(arg1) == "string" then
		unique_str = arg1
		arg1,arg2,arg3 = arg2,arg3,arg4
	else
		unique_str = DoUniqueString("Timer")
	end

	if type(arg1) == "number" and type(arg2) == "function" then
		entity = GameMode
		delay = arg1
		func = arg2

	elseif type(arg1) == "table" and type(arg2) == "number" and type(arg3) == "function" then
		entity = arg1
		delay = arg2
		func = arg3
	end
	
	if type(entity) ~= "table" or type(delay) ~= "number" or type(func) ~= "function" then
		return
	end

	entity:SetContextThink(unique_str, function ()
		if entity:IsNull() then
			return nil
		end
		if not entity:IsAlive() then
			if entity.IsHero and entity:IsHero() then
			else
				return nil
			end
		end
		if GameRules:IsGamePaused() then
			return 0.1
		end
		func()
		return nil
	end, delay)
end

--[[
|=========================================================================
| 复制table
|=========================================================================
| @param {table} t
| @return table
]]
function copy_table( t )
	if type(t) ~= "table" then return nil end
	local result = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			result[k] = copy_table( v )
		else
			result[k] = v
		end
	end
	return result
end

--[[
|=========================================================================
| 过滤table中元素
|=========================================================================
| @param {table} t
| @param {function} func
| @return table
]]
function table.filter( t, func )
	if #t == 0 then return t end

	local i = 1
	while i <= #t do
		if func(t[i]) == true then
			table.remove(t,i)
			i = i - 1
		end
		i = i + 1
	end

	return t
end

--[[
|=========================================================================
| 详细打印table
|=========================================================================
| @param {table} t
]]
function print_table( t, tab )
	if t == nil then print('<nil>') return end
	tab = tab or ''
	if tab == '' then print(t) end
	print(tab..'{')
	for k,v in pairs(t) do
		if type(v) == "table" then
			if type(k) == "string" then
				print(tab..'    "'..k..'"',tostring(v))
			else
				print(tab..'    '..k,tostring(v))
			end
			print_table( v, tab..'    ' )
		else
			if type(k) == "string" then
				print(tab..'    "'..k..'"',tostring(v)..' ('..type(v)..')')
			else
				print(tab..'    '..k,tostring(v)..' ('..type(v)..')')
			end
		end
	end
	print(tab..'}')
end

--[[
|=========================================================================
| 判断是否为闰年
|=========================================================================
| @param {int} year
| @return boolean
]]
function IsLeapYear(year)
	return (year%4 == 0 and year%100 ~= 0) or (year%400 == 0)
end

--[[
|=========================================================================
| 获取UNIX时间戳
|=========================================================================
| 以UTC时间为标准
|
| @param {string} datetime 只支持格式'2016-10-13 01:01:01'
| @return int
]]
function tounixtime(datetime)
	local datetime = vlua.split(datetime,' ')
	local date = vlua.split(datetime[1],'-')
	local time = vlua.split(datetime[2],':')
	local sec = tonumber(time[3]) + tonumber(time[2])*60 + tonumber(time[1])*60*60 + (tonumber(date[3]) - 1)*86400
	
	local year = tonumber(date[1])
	local m = tonumber(date[2]) - 1
	for i=1,m do
		if i==1 or i==3 or i==5 or i==7 or i==8 or i==10 or i==12 then
			sec = sec + 31 * 86400
		elseif i==4 or i==6 or i==9 or i==11 then
			sec = sec + 30 * 86400
		else
			if IsLeapYear(year) then
				sec = sec + 29 * 86400
			else
				sec = sec + 28 * 86400
			end
		end
	end

	local day = 0
	for i=1970,year-1 do
		if IsLeapYear(i) then
			day = day + 366
		else
			day = day + 365
		end
	end
	sec = sec + day * 86400
	return sec
end

--[[
|=========================================================================
| 把UNIX时间戳转换成日期格式
|=========================================================================
| 以UTC时间为标准，输出格式'2016-10-13 01:01:01'
|
| @param {int} unixtime
| @param {boolean} [returnTable] 可选，如果为true返回table
| @return string|table
]]
function format_date( unixtime, returnTable )
	local day = math.floor(unixtime/86400)
	local year = 1970
	while day > 366 do
		if IsLeapYear(year) then
			day = day - 366
			unixtime = unixtime - 366*86400
		else
			day = day - 365
			unixtime = unixtime - 365*86400
		end
		year = year + 1
	end

	day = math.floor(unixtime/86400)
	_day = 0
	local month = 0
	for i=1,12 do
		local d
		if i==1 or i==3 or i==5 or i==7 or i==8 or i==10 or i==12 then
			d = 31
		elseif i==4 or i==6 or i==9 or i==11 then
			d = 30
		else
			if IsLeapYear(year) then
				d = 29
			else
				d = 28
			end
		end
		_day = _day + d
		if day-_day < 0 then
			month = i
			unixtime = unixtime - (_day-d)*86400
			break
		end
	end

	local day = math.floor(unixtime/86400)
	unixtime = unixtime - day*86400
	local h = math.floor(unixtime/3600)
	unixtime = unixtime - h*3600
	local m = math.floor(unixtime/60)
	unixtime = unixtime - m*60

	if returnTable then
		return {
			year = year,
			month = month,
			date = day+1,
			hours = h,
			minutes = m,
			seconds = unixtime,
		}
	end

	return string.format('%d-%02d-%02d %02d:%02d:%02d',year,month,day+1,h,m,unixtime)
end

--[[
|=========================================================================
| 获取当前时间
|=========================================================================
| @return string,int
]]
function date_now()
	local time = math.floor(UTC_TIME + GameRules:GetGameTime())
	return format_date(time),time
end

--[[
|=========================================================================
| 判断星期几
|=========================================================================
| @param {int} week 区间[1,7]
| @return boolean
]]
function today_is_week(week)
	local time = math.floor(UTC_TIME + GameRules:GetGameTime())
	local date = format_date(time,true)
	local y = date.year
	local m = date.month
	local d = date.date
	if m == 1 or m == 2 then
		m = m + 12
		y = y - 1
	end
	-- print(math.floor((d+2*m+3*(m+1)/5+y+y/4-y/100+y/400) % 7)+1)
	return math.floor((d+2*m+3*(m+1)/5+y+y/4-y/100+y/400) % 7)+1 == week
end

--[[
|=========================================================================
| 根据日期获取星期几604800
|=========================================================================
| @param {table} date
| @return int
]]
function get_week(date)
	if date == nil then
		local time = math.floor(UTC_TIME + GameRules:GetGameTime())
		date = format_date(time,true)
	elseif type(date) == "string" then
		date = format_date(tounixtime(date),true)
	end
	local y = date.year
	local m = date.month
	local d = date.date

	return math.floor((d+2*m+3*(m+1)/5+y+y/4-y/100+y/400) % 7)+1
end


--[[
|=========================================================================
| 创建特效
|=========================================================================
|
|{
|	Path = "",
|	Attach = PATTACH_CUSTOMORIGIN,
|	ControlPoints = {
|		[0] = "CASTER",
|		[1] = Vector(100,100,0),
|		[2] = "TARGET01",
|	},
|	ControlPointEnts = {
|		[3] =
|		{
|			target = "CASTER"
|			attachment = "attach_hitloc",
|		},
|	},
|},
|
| @param {table} t
| @return int
]]
function create_particle(t, caster, target01, target02, target03, target04)
	local p = ParticleManager:CreateParticle(t.Path, t.Attach, caster)

	if t.ControlPoints then
		for k,v in pairs(t.ControlPoints) do
			if v == "CASTER" then
				ParticleManager:SetParticleControl(p, k, caster:GetOrigin())
			elseif v == "TARGET01" then
				ParticleManager:SetParticleControl(p, k, target01:GetOrigin())
			elseif v == "TARGET02" then
				ParticleManager:SetParticleControl(p, k, target02:GetOrigin())
			elseif v == "TARGET03" then
				ParticleManager:SetParticleControl(p, k, target03:GetOrigin())
			elseif v == "TARGET04" then
				ParticleManager:SetParticleControl(p, k, target04:GetOrigin())
			else
				ParticleManager:SetParticleControl(p, k, v)
			end
		end
	end
	
	if t.ControlPointEnts then
		for k,v in pairs(t.ControlPointEnts) do
			local target = nil
			if v.target == "CASTER" then
				target = caster
			elseif v.target == "TARGET01" then
				target = target01
			elseif v.target == "TARGET02" then
				target = target02
			elseif v.target == "TARGET03" then
				target = target03
			elseif v.target == "TARGET04" then
				target = target04
			end
			if target then
				ParticleManager:SetParticleControlEnt(p, k, target, 5, v.attachment, target:GetOrigin(), true)
			end
		end
	end

	return p
end


--[[
设置所有技能等级到指定的等级
]]
function SetAllAbilitiesToLevel(unit, level)
	local abilityCount = unit:GetAbilityCount()-1
	for i=0,abilityCount do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(level)
		end
	end
end


--[[
根据技能来获取范围内的单位
]]
function FindUnitsInRadiusForAbility(ability, orgin, radius, order)
	local iOrder = order or FIND_UNITS_EVERYWHERE
	return FindUnitsInRadius(ability:GetCaster():GetTeam(), orgin, nil, radius,
										ability:GetAbilityTargetTeam(),
										ability:GetAbilityTargetType(),
										ability:GetAbilityTargetFlags(), 
										iOrder, false)
end


function FindOnePlayersHeroInRadius(unit, radius)
	local origin = unit:GetOrigin()
	local count = PlayerResource:GetPlayerCount()
	local thisHero,thisDist = nil,999999
	for i=0,count do
		local player = PlayerResource:GetPlayer(i)
		if player then
			local hero = player:GetAssignedHero()
			if hero and hero:IsAlive() then
				local d = (hero:GetOrigin() - origin):Length2D()
				if d <= radius then
					if thisHero == nil or d <= thisDist then
						thisHero = hero
						thisDist = d
					end
				end
			end
		end
	end

	return thisHero
end