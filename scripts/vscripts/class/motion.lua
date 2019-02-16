
--@Class CMotion

--[[
运动器的简单实现

使用方法：

-- 首先创建一个运动器，如果复用率比较高，可以绑定一个运动器，比如技能
local motion = unit:CreateMotion()

-- 简单的调用
-- 跳跃
motion:Jump(unit:GetOrigin(), unit:GetOrigin() + unit:GetForwardVector()*1000, 1200, 1, "modifier_custom_stun")

-- 线性
motion:Linear(unit:GetOrigin(), unit:GetOrigin() + unit:GetForwardVector()*1000, 100, 1, "modifier_custom_stun")

-- 目前支持两个事件
-- 当运动器启动
motion:OnStart(function()
	//todo
end)

-- 当运动器结束
motion:OnEnd(function()
	//todo
end)

-- 如果需要遇到障碍停止
motion:SetStopIfBlocked(true)
]]

if CMotion == nil then
	CMotion = class({})
end

local public = CMotion

--[[
=========================================================================
创建一个运动器
=========================================================================
@return CMotion
]]
function CDOTA_BaseNPC:CreateMotion()
	return public(self)
end

function public:constructor(owner)
	self.__owner = owner
	self.__origin = Vector(0,0,0)
	self.__start_position = Vector(0,0,0)
	self.__end_position = Vector(0,0,0)
	self.__velocity = Vector(0,0,0)
	self.__vertical_velocity = Vector(0,0,0)
	self.__acceleration = 0
	self.__stun_owner = false
	self.__stop_if_blocked = false
	self.__stun_modifier = ""
	self.__on_start = nil
	self.__on_end = nil
	self.__unique = DoUniqueString("__Avalon_Motion__")
	self.__time = 0
	self.__up_vector = Vector(0,0,0)
	self.__duration = 0
	self.__is_running = false
	self.__delay_to_delete_stun = 0
end

--[[
=========================================================================
运动器的刷新函数，不需要外部调用，忽略即可
=========================================================================
@return void
]]
function public:Update()
	local owner = self:GetOwner()

	-- 水平方向的运动
	local pos = self.__velocity*self.__time + 0.5 * (self.__velocity:Normalized() * self.__acceleration * (self.__time * self.__time))

	self.__origin = self.__start_position + pos

	-- 垂直方向的运动
	self.__up_vector = self.__vertical_velocity*self.__time - 0.5*self.__time*self.__time*self.__gravitational_acceleration*Vector(0,0,1)

	local origin = GetGroundPosition(self.__origin, owner)

	-- 保证最低高度在地面
	if self.__up_vector.z+origin.z < origin.z then
		self.__up_vector.z = 0
	end

	owner:SetOrigin(origin + self.__up_vector)

	if self.__on_update ~= nil then
		self.__on_update(self.__time)
	end

	-- 时间结束
	if self.__time >= self.__duration then
		self:Stop()
		return
	end

	-- 是否遇到障碍就停止
	if (self.__stop_if_blocked) and (GridNav:IsBlocked(owner:GetOrigin()) or not GridNav:IsTraversable(owner:GetOrigin())) then
		self:Stop()
		return
	end

	self.__time = self.__time + FrameTime()
end

--[[
=========================================================================
返回此运动器的拥有者
=========================================================================
@return handle
]]
function public:GetOwner()
	return self.__owner
end

--[[
=========================================================================
启动运动器
=========================================================================
@return CMotion
]]
function public:Start()
	self.__owner:Stop()
	self.__time = 0
	self.__is_running = true
	self.__origin = self.__start_position
	self.__up_vector = Vector(0,0,0)
	self.__duration = (self.__start_position - self.__end_position):Length2D() / self.__velocity:Length2D()
	self.__gravitational_acceleration = self.__vertical_velocity/(self.__duration/2)

	if self.__stun_owner then
		self.__owner:AddNewModifier(self.__owner, nil, self.__stun_modifier, {duration = self.__duration + self.__delay_to_delete_stun})
	end

	self:GetOwner():SetContextThink(self.__unique, function ()
		if GameRules:IsGamePaused() then return 0.1 end
		if not self.__owner:IsAlive() then self:Stop() return nil end
		self:Update()
		return FrameTime()
	end, 0)

	if self.__on_start ~= nil then
		self.__on_start()
	end
	return self
end

--[[
=========================================================================
停止运动器
=========================================================================
@return CMotion
]]
function public:Stop()
	self.__is_running = false
	self:GetOwner():SetContextThink(self.__unique, function() return nil end, 0)
	FindClearSpaceForUnit(self:GetOwner(), self:GetOwner():GetOrigin(), false)

	if self.__delay_to_delete_stun == 0 then
		self.__owner:RemoveModifierByName(self.__stun_modifier)
	end

	if self.__on_end ~= nil then
		self.__on_end()
	end
	return self
end

--[[
=========================================================================
判断运动器是否在运行中
=========================================================================
@return boolean
]]
function public:IsRunning()
	return self.__is_running
end

--[[
=========================================================================
设置起始位置
=========================================================================
@param {Vector} vec
@return CMotion
]]
function public:SetStartPosition(vec)
	self.__start_position = Vector(vec.x,vec.y,vec.z)
	return self
end

--[[
=========================================================================
返回起始位置
=========================================================================
@return Vector
]]
function public:GetStartPosition()
	return self.__origin
end

--[[
=========================================================================
返回当前位置
=========================================================================
@return Vector
]]
function public:GetOrigin()
	return self.__origin
end

--[[
=========================================================================
设置终点位置
=========================================================================
@param {Vector} vec
@return CMotion
]]
function public:SetEndPosition(vec)
	self.__end_position = Vector(vec.x,vec.y,vec.z)
	return self
end

--[[
=========================================================================
返回终点位置
=========================================================================
@return Vector
]]
function public:GetEndPosition()
	return self.__end_position
end

--[[
=========================================================================
返回运动器运行所的持续时间
=========================================================================
@return float
]]
function public:GetDuration()
	return self.__duration
end

--[[
=========================================================================
设置速度
=========================================================================
@param {Vector} vec
@return CMotion
]]
function public:SetVelocity(vec)
	self.__velocity = Vector(vec.x,vec.y,vec.z)
	return self
end

--[[
=========================================================================
返回速度
=========================================================================
@return Vector
]]
function public:GetVelocity()
	return self.__velocity
end

--[[
=========================================================================
返回运动的方向
=========================================================================
@return Vector
]]
function public:GetForwardVector()
	return self.__velocity:Normalized()
end

--[[
=========================================================================
设置加速度
=========================================================================
@param {float} vec
@return CMotion
]]
function public:SetAcceleration(num)
	self.__acceleration = num
	return self
end

--[[
=========================================================================
返回加速度
=========================================================================
@return float
]]
function public:GetAcceleration()
	return self.__acceleration
end

--[[
=========================================================================
设置垂直方向的速度
=========================================================================
@param {Vector} vec
@return CMotion
]]
function public:SetVerticalVelocity(vec)
	self.__vertical_velocity = Vector(0,0,vec.z)
	return self
end

--[[
=========================================================================
返回垂直方向的速度
=========================================================================
@return Vector
]]
function public:GetVerticalVelocity()
	return self.__vertical_velocity
end

--[[
=========================================================================
事件，当运动器启动
=========================================================================
@param {function} func
@return CMotion
]]
function public:OnStart(func)
	self.__on_start = func
	return self
end

--[[
=========================================================================
事件，当运动器更新， 默认一个参数是time，time是运动器的运行时间
=========================================================================
@param {function} func
@return CMotion
]]
function public:OnUpdate(func)
	self.__on_update = func
	return self
end

--[[
=========================================================================
事件，当运动器结束
=========================================================================
@param {function} func
@return CMotion
]]
function public:OnEnd(func)
	self.__on_end = func
	return self
end

--[[
=========================================================================
设置是否将拥有者处于不可动弹状态（击晕效果）
=========================================================================
@param {boolean} b
@return CMotion
]]
function public:SetStun(b)
	self.__stun_owner = b
	if not b then
		self:GetOwner():RemoveModifierByName(self.__stun_modifier)
	end
	return self
end

--[[
=========================================================================
返回是否将拥有者处于不可动弹状态（击晕效果）
=========================================================================
@return boolean
]]
function public:IsStun()
	return self.__stun_owner
end

--[[
=========================================================================
设置不可动弹状态的modifier名称
=========================================================================
@param {string} name
@return CMotion
]]
function public:SetStunModifier(name)
	self.__stun_modifier = name
	return self
end

--[[
=========================================================================
返回不可动弹状态的modifier名称
=========================================================================
@return boolean
]]
function public:GetStunModifier()
	return self.__stun_modifier
end

--[[
=========================================================================
设置是否在遇到障碍时停止运动器
=========================================================================
@param {boolean} b
@return CMotion
]]
function public:SetStopIfBlocked(b)
	self.__stop_if_blocked = b
	return self
end

--[[
=========================================================================
返回是否在遇到障碍时停止运动器
=========================================================================
@return boolean
]]
function public:IsStopIfBlocked()
	return self.__stop_if_blocked
end

--[[
=========================================================================
设置延迟移除不可动弹状态的BUFF时间
=========================================================================
@return boolean
]]
function public:SetDelayToDeleteStun(delay)
	self.__delay_to_delete_stun = delay
	return self
end

--[[
=========================================================================
跳跃运动
=========================================================================
@param {Vector} start_pos
@param {Vector} end_pos
@param {float}  vertical_speed
@param {float}  duration
@param {string} stun_modifier
@return CMotion
]]
function public:Jump(start_pos, end_pos, vertical_speed, duration, stun_modifier)
	if stun_modifier then
		self:SetStun(true)
		self:SetStunModifier(stun_modifier)
	else
		self:SetStun(false)
	end

	local forward = (end_pos - start_pos):Normalized()

	return 	self:SetStartPosition(start_pos)
				:SetEndPosition(end_pos)
				:SetAcceleration(0)
				:SetVelocity(forward*((end_pos - start_pos):Length2D()/duration))
				:SetVerticalVelocity(Vector(0,0,vertical_speed))
				:Start()
end

--[[
=========================================================================
线性运动
=========================================================================
@param {Vector} start_pos
@param {Vector} end_pos
@param {float}  acceleration
@param {float}  duration
@param {string} stun_modifier
@return CMotion
]]
function public:Linear(start_pos, end_pos, acceleration, duration, stun_modifier)
	if stun_modifier then
		self:SetStun(true)
		self:SetStunModifier(stun_modifier)
	else
		self:SetStun(false)
	end

	local forward = (end_pos - start_pos):Normalized()

	return 	self:SetStartPosition(start_pos)
				:SetEndPosition(end_pos)
				:SetAcceleration(acceleration)
				:SetVelocity(forward*((end_pos - start_pos):Length2D()/duration))
				:SetVerticalVelocity(Vector(0,0,0))
				:Start()
end