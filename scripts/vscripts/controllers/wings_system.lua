
if WingsSystem == nil then
	WingsSystem = RegisterController('wings_system')
	WingsSystem.__player_binding_wing = {}
	WingsSystem.__player_binding_wing_level = {}
	WingsSystem.__player_binding_wing_particles = {}
	setmetatable(WingsSystem,WingsSystem)
end

local public = WingsSystem

--[[
绑定翅膀
]]
function public:Binding(hero, _t)
	local wing = self.__player_binding_wing[hero:GetEntityIndex()]
	if wing == _t then return end

	local data = ShuShanWingsConfig[_t]['Levels'][1]["Cost"]
	if not hero:SpendCurrency(data.type, data.amount) then
		return
	end

	self:Release(hero)
	self.__player_binding_wing[hero:GetEntityIndex()] = _t
	self:SetLevel(hero, 1)
end

--[[
是否有翅膀
]]
function public:HasWing(hero)
	return self.__player_binding_wing[hero:GetEntityIndex()] ~= nil
end

--[[
升级翅膀
]]
function public:Upgrade(hero)
	local wing = self.__player_binding_wing[hero:GetEntityIndex()]
	if wing == nil then return end

	local newdata = ShuShanWingsConfig[wing]['Levels'][self:GetLevel(hero)+1]
	if not newdata then return end
	if not hero:SpendCurrency(newdata["Cost"].type, newdata["Cost"].amount) then
		return
	end

	local data = ShuShanWingsConfig[wing]['Levels'][self:GetLevel(hero)]

	for k,v in pairs(data["Attributes"]) do
		hero:SetCustomAttribute(k,'wings_system',0)
	end

	for k,v in pairs(data["Modifiers"]) do
		hero:RemoveModifierByName(v)
	end

	local particles = self.__player_binding_wing_particles[hero:GetEntityIndex()]
	for k,v in pairs(particles) do
		ParticleManager:DestroyParticle(v, true)
	end

	self:SetLevel(hero, self:GetLevel(hero) + 1)

	hero:ShowCustomMessage({type="left",msg="#shushan_wing_upgrade_succeeded", class="", log=true})
end

--[[
获取翅膀等级
]]
function public:GetLevel(hero)
	return self.__player_binding_wing_level[hero:GetEntityIndex()]
end

--[[
设置翅膀等级
]]
function public:SetLevel(hero, level)
	local wing = self.__player_binding_wing[hero:GetEntityIndex()]
	if wing == nil then return end
	if level == nil then return end

	local data = ShuShanWingsConfig[wing]['Levels'][level]
	if data == nil then return end

	self.__player_binding_wing_level[hero:GetEntityIndex()] = level

	for k,v in pairs(data["Attributes"]) do
		hero:SetCustomAttribute(k,'wings_system',v)
	end

	for k,v in pairs(data["Modifiers"]) do
		hero:AddNewModifier(hero, nil, v, nil)
	end

	local particles = self.__player_binding_wing_particles[hero:GetEntityIndex()]

	if particles == nil then
		particles = {}
		self.__player_binding_wing_particles[hero:GetEntityIndex()] = particles
	end

	for k,v in pairs(data["Particles"]) do
		particles[k] = create_particle(v, hero)
	end

	CustomNetTables:SetTableValue("Common", "shushan_player_binding_wing", self.__player_binding_wing )
	CustomNetTables:SetTableValue("Common", "shushan_player_binding_wing_level", self.__player_binding_wing_level )
end

--[[
删除翅膀
]]
function public:Release(hero)
	local wing = self.__player_binding_wing[hero:GetEntityIndex()]
	if wing == nil then return end

	self.__player_binding_wing[hero:GetEntityIndex()] = nil

	local data = ShuShanWingsConfig[wing]['Levels'][self:GetLevel(hero)]

	for k,v in pairs(data["Attributes"]) do
		hero:SetCustomAttribute(k,'wings_system',0)
	end

	for k,v in pairs(data["Modifiers"]) do
		hero:RemoveModifierByName(v)
	end

	local particles = self.__player_binding_wing_particles[hero:GetEntityIndex()]
	for k,v in pairs(particles) do
		ParticleManager:DestroyParticle(v, true)
	end
end

--[[
刷新翅膀
]]
function public:Refresh(hero)
	local wing = self.__player_binding_wing[hero:GetEntityIndex()]
	if wing == nil then return end

	local particles = self.__player_binding_wing_particles[hero:GetEntityIndex()]
	if particles == nil then return end
	
	local data = ShuShanWingsConfig[wing]['Levels'][self:GetLevel(hero)]
	if data == nil then return end

	for k,v in pairs(data["Particles"]) do
		ParticleManager:DestroyParticle(particles[k], true)
	end

	self:SetLevel(hero, self:GetLevel(hero))
end