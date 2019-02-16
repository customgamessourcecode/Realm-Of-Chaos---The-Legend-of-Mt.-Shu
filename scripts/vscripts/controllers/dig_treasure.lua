
if DigTreasure == nil then
	DigTreasure = RegisterController('dis_treasure')
	DigTreasure.__player_this_pos = {}
	DigTreasure.__refer_entities = {}
	setmetatable(DigTreasure,DigTreasure)
end

local public = DigTreasure

function public:__call(hero)
	self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
end

-- 初始化
function public:init()
	local refer_entities = DigTreasure.__refer_entities
	local SpawnerKV = LoadKeyValues("scripts/npc/spawner.kv")

	for k,v in pairs(SpawnerKV["Dungeon"]["FB5"]["Units"]) do
		local ent = Entities:FindByName(nil, v.EntName)
		if ent then
			table.insert(refer_entities,ent)
		end
	end
end

-- 获取当前宝物的点
function public:GetThisPos(hero)
	return self.__player_this_pos[hero:GetEntityIndex()]
end

-- 获取一个随机的宝物点
function public:GetRandomVector()
	local refer_entities = self:GetReferEntities()
	local max = #refer_entities
	if max == 0 then return RandomVector(200) end

	local ent = refer_entities[RandomInt(1, max)]
	return ent:GetOrigin() + RandomVector(200)
end

-- 获取参考的实体
function public:GetReferEntities()
	return self.__refer_entities
end

-- 获取箭头颜色
function public:GetColor(len)
	if len <= 800 then
		return Vector(0,255,0)
	elseif len <= 1200 then
		return Vector(255,255,0)
	end

	return Vector(255,0,0)
end

-- 探索
function public:Explore(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_hint.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, target_pos)
		ParticleManager:DestroyParticleSystem(p)
		return 
	end

	local p = ParticleManager:CreateParticle("particles/avalon/items/item_0135/item_0135.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(p, 0, origin)
	ParticleManager:DestroyParticleSystem(p)

	Wait(1, function ()
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, origin)
		ParticleManager:SetParticleControl(p, 1, target_pos)
		ParticleManager:SetParticleControl(p, 2, self:GetColor(len))
		ParticleManager:DestroyParticleSystem(p)
	end)
end

-- 获取要创建的物品
function public:GetItemList()
	return TreasureConfig
end

-- 找到宝物
function public:FindHit(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local itemlist = self:GetItemList()

		local itemname = itemlist[RandomInt(1, #itemlist)]
		local item = CreateItem(itemname, nil, nil)
		local container = CreateItemOnPositionSync(target_pos, item)

		item:LaunchLoot(false,500,1,target_pos+RandomVector(150))

		self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
	end
end



-------------------------------------------------------------------------------------------------------------

if DigTreasureItem0591 == nil then
	DigTreasureItem0591 = RegisterController('dis_treasure_item_0591')
	DigTreasureItem0591.__player_this_pos = {}
	DigTreasureItem0591.__refer_entities = {}
	setmetatable(DigTreasureItem0591,DigTreasureItem0591)
end

function DigTreasureItem0591:__call(hero)
	self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
end

-- 初始化
function DigTreasureItem0591:init()
	local refer_entities = DigTreasureItem0591.__refer_entities
	local SpawnerKV = LoadKeyValues("scripts/npc/spawner.kv")

	for k,v in pairs(SpawnerKV["Dungeon"]["FB8"]["Units"]) do
		local ent = Entities:FindByName(nil, v.EntName)
		if ent then
			table.insert(refer_entities,ent)
		end
	end
end

-- 获取当前宝物的点
function DigTreasureItem0591:GetThisPos(hero)
	return self.__player_this_pos[hero:GetEntityIndex()]
end

-- 获取一个随机的宝物点
function DigTreasureItem0591:GetRandomVector()
	local refer_entities = self:GetReferEntities()
	local max = #refer_entities
	if max == 0 then return RandomVector(200) end

	local ent = refer_entities[RandomInt(1, max)]
	return ent:GetOrigin() + RandomVector(200)
end

-- 获取参考的实体
function DigTreasureItem0591:GetReferEntities()
	return self.__refer_entities
end

-- 获取箭头颜色
function DigTreasureItem0591:GetColor(len)
	if len <= 800 then
		return Vector(0,255,0)
	elseif len <= 1200 then
		return Vector(255,255,0)
	end

	return Vector(255,0,0)
end

-- 探索
function DigTreasureItem0591:Explore(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_hint.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, target_pos)
		ParticleManager:DestroyParticleSystem(p)
		return 
	end

	local p = ParticleManager:CreateParticle("particles/avalon/items/item_0135/item_0135.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(p, 0, origin)
	ParticleManager:DestroyParticleSystem(p)

	Wait(1, function ()
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, origin)
		ParticleManager:SetParticleControl(p, 1, target_pos)
		ParticleManager:SetParticleControl(p, 2, self:GetColor(len))
		ParticleManager:DestroyParticleSystem(p)
	end)
end

-- 获取要创建的物品
function DigTreasureItem0591:GetItemList()
	return TreasureConfigItem0591
end

-- 找到宝物
function DigTreasureItem0591:FindHit(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local itemlist = self:GetItemList()

		local itemname = itemlist[RandomInt(1, #itemlist)]
		local item = CreateItem(itemname, nil, nil)
		local container = CreateItemOnPositionSync(target_pos, item)

		item:LaunchLoot(false,500,1,target_pos+RandomVector(150))

		self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
	end
end


-------------------------------------------------------------------------------------------------------------

if DigTreasureItem0592 == nil then
	DigTreasureItem0592 = RegisterController('dis_treasure_item_0592')
	DigTreasureItem0592.__player_this_pos = {}
	DigTreasureItem0592.__refer_entities = {}
	setmetatable(DigTreasureItem0592,DigTreasureItem0592)
end

function DigTreasureItem0592:__call(hero)
	self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
end

-- 初始化
function DigTreasureItem0592:init()
	local refer_entities = DigTreasureItem0592.__refer_entities
	local SpawnerKV = LoadKeyValues("scripts/npc/spawner.kv")

	for k,v in pairs(SpawnerKV["Dungeon"]["FB7"]["Units"]) do
		local ent = Entities:FindByName(nil, v.EntName)
		if ent then
			table.insert(refer_entities,ent)
		end
	end
end

-- 获取当前宝物的点
function DigTreasureItem0592:GetThisPos(hero)
	return self.__player_this_pos[hero:GetEntityIndex()]
end

-- 获取一个随机的宝物点
function DigTreasureItem0592:GetRandomVector()
	local refer_entities = self:GetReferEntities()
	local max = #refer_entities
	if max == 0 then return RandomVector(200) end

	local ent = refer_entities[RandomInt(1, max)]
	return ent:GetOrigin() + RandomVector(200)
end

-- 获取参考的实体
function DigTreasureItem0592:GetReferEntities()
	return self.__refer_entities
end

-- 获取箭头颜色
function DigTreasureItem0592:GetColor(len)
	if len <= 800 then
		return Vector(0,255,0)
	elseif len <= 1200 then
		return Vector(255,255,0)
	end

	return Vector(255,0,0)
end

-- 探索
function DigTreasureItem0592:Explore(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_hint.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, target_pos)
		ParticleManager:DestroyParticleSystem(p)
		return 
	end

	local p = ParticleManager:CreateParticle("particles/avalon/items/item_0135/item_0135.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(p, 0, origin)
	ParticleManager:DestroyParticleSystem(p)

	Wait(1, function ()
		local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, origin)
		ParticleManager:SetParticleControl(p, 1, target_pos)
		ParticleManager:SetParticleControl(p, 2, self:GetColor(len))
		ParticleManager:DestroyParticleSystem(p)
	end)
end

-- 获取要创建的物品
function DigTreasureItem0592:GetItemList()
	return TreasureConfigItem0592
end

-- 找到宝物
function DigTreasureItem0592:FindHit(hero)
	local origin = hero:GetOrigin()
	local target_pos = self:GetThisPos(hero)
	local len = (origin - target_pos):Length2D()

	if len <= 400 then
		local itemlist = self:GetItemList()

		local itemname = itemlist[RandomInt(1, #itemlist)]
		local item = CreateItem(itemname, nil, nil)
		local container = CreateItemOnPositionSync(target_pos, item)

		item:LaunchLoot(false,500,1,target_pos+RandomVector(150))

		self.__player_this_pos[hero:GetEntityIndex()] = self:GetRandomVector()
	end
end