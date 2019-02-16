
if CollectOreSystem == nil then
	CollectOreSystem = RegisterController('collect_ore_system')
	CollectOreSystem.hUnitsLevel = {}
	CollectOreSystem.hUpdateMethods = {}
	CollectOreSystem.__fake_ore_units = {}
end

local public = CollectOreSystem

function public:init()
	local allOres = Entities:FindAllByName('npc_fake_ores')

	local sortFunc = function (a,b)
		return a.chance <= b.chance
	end

	for i,v in ipairs(allOres) do
		local unitname = v:GetUnitName()

		v:AddNewModifier(v, nil, "modifier_invulnerable", nil)

		local data = CollectOreFakeUnitConfig[unitname]

		local list = self.__fake_ore_units[unitname]
		if list == nil then
			list = {}
			self.__fake_ore_units[unitname] = list
		end
		table.insert(list,v)
		table.sort(data["DropItems"],sortFunc)
	end
	self.__all_ores = allOres

	local OresWeight = {
		["npc_fake_ore_tongtiekuang"]=1,
		["npc_fake_ore_jingtiekuang"]=2,
		["npc_fake_ore_longshikuang"]=3,
		["npc_fake_ore_shenmaikuang"]=4,
		["npc_fake_ore_shenglingkuang"]=5,
	}

	table.sort(self.__all_ores, function ( a,b )
		return OresWeight[a:GetUnitName()] > OresWeight[b:GetUnitName()]
	end)
end

function public:Start( hUnit )
	if not IsValidEntity(hUnit) then return end

	self.hUnitsLevel[hUnit:GetEntityIndex()] = 1

	local oreUnit = self:GetUniqueOreUnit( hUnit )
	assert(oreUnit ~= nil)

	FindClearSpaceForUnit(hUnit, oreUnit:GetOrigin(), true)
	Wait("CollectOreSystemWait", hUnit, 0.1, function ()
		hUnit:FaceTowards(oreUnit:GetOrigin())
		self:CollectOre( hUnit )
	end)
end

-- 开始挖矿
function public:CollectOre( hUnit )
	local hOwner = hUnit:GetOwner()
	local unitActionType = ACT_DOTA_ATTACK
	local maxPoints = nil
	local points = 0

	local methods = {}
	self.hUpdateMethods[hUnit:GetEntityIndex()] = methods

	if hOwner:IsFate("wakuangzongshi") then
		function methods:ChannelTime()
			return 0.5
		end
	else
		function methods:ChannelTime()
			return 1.0
		end
	end

	function methods:SetOreUnit( hOreUnit )
		if self.currentOreUnit ~= nil then
			self.currentOreUnit:Attribute_SetIntValue("OreMaster", -1)
		end

		self.currentOreUnit = hOreUnit
		self.maxPoints = public:GetMaxPoints( hOreUnit:GetUnitName() )
		hOreUnit:Attribute_SetIntValue("OreMaster", hUnit:GetEntityIndex())
		points = 0

		FindClearSpaceForUnit(hUnit, hOreUnit:GetOrigin(), true)
		hUnit:FaceTowards(hOreUnit:GetOrigin())
	end

	function methods:Update()
		hUnit:RemoveGesture(unitActionType)
		hUnit:StartGestureWithPlaybackRate(unitActionType, 1.5)
		hUnit:EmitSound("CollectOreSystem.CollectOres")

		local oreUnit = self.currentOreUnit
		local maxPoints = self.maxPoints
		local level = public:GetLevel(hUnit)
		local speed = public:GetCollectSpeed(level)
		public:AddExp(hUnit, speed)

		-- 消耗矿石点数
		points = points + speed
		if points >= maxPoints then
			points = 0
			public:DropItems( hUnit )
		end

		-- 升级
		if public:LevelUp( hUnit ) then
			oreUnit = public:GetUniqueOreUnit( hUnit )
			assert(oreUnit ~= nil)
			self:SetOreUnit(oreUnit)
			return 0.1
		end

		return self:ChannelTime()
	end

	methods:SetOreUnit(self:GetOreUnit(hUnit))
	Timer("CollectOreSystemTimer", hUnit, function ()
		return methods:Update()
	end)
end

-- 获取矿石最大点数
function public:GetMaxPoints( szUnitName )
	local config = CollectOreFakeUnitConfig[szUnitName]
	if config == nil then return 0 end
	return config["Points"] or 0
end

-- 获取唯一的矿石
function public:GetUniqueOreUnit( hUnit )
	local oreUnitName = ""
	local level = self:GetLevel(hUnit)
	if level == 1 then
		oreUnitName = "npc_fake_ore_tongtiekuang"
	elseif level == 2 then
		oreUnitName = "npc_fake_ore_jingtiekuang"
	elseif level == 3 then
		oreUnitName = "npc_fake_ore_longshikuang"
	elseif level == 4 then
		oreUnitName = "npc_fake_ore_shenmaikuang"
	elseif level == 5 then
		oreUnitName = "npc_fake_ore_shenglingkuang"
	end

	if oreUnitName == "" then return end

	local oreEntity = nil

	for _,ent in pairs(self.__fake_ore_units[oreUnitName] or {}) do
		if ent:GetUnitName() == oreUnitName and ent:Attribute_GetIntValue("OreMaster", -1) == -1 then
			ent:Attribute_SetIntValue("OreMaster", hUnit:GetEntityIndex())
			return ent
		end
	end

	return nil
end

-- 矿石单位
function public:GetOreUnit( hUnit )
	local entIndex = hUnit:GetEntityIndex()
	for _,ent in pairs(self.__all_ores) do
		local unit = EntIndexToHScript(ent:Attribute_GetIntValue("OreMaster", -1))
		if IsValidEntity(unit) and unit:GetEntityIndex() == entIndex then
			return ent
		end
	end
	return nil
end

-- 获取挖矿等级
function public:GetLevel( hUnit )
	return self.hUnitsLevel[hUnit:GetEntityIndex()]
end

-- 设置挖矿等级
function public:SetLevel( hUnit, iLevel )
	self.hUnitsLevel[hUnit:GetEntityIndex()] = iLevel
end

-- 增加采矿经验
function public:AddExp( hUnit, fExp )
	if fExp < 0 then return false end
	local old = self:GetExp( hUnit )
	hUnit:Attribute_SetFloatValue("OreExp", old + fExp)
	return true
end

-- 消耗采矿经验
function public:SubExp( hUnit, fExp )
	if fExp < 0 then return false end

	local nowExp = self:GetExp( hUnit )
	if nowExp >= fExp then
		hUnit:Attribute_SetFloatValue("OreExp", nowExp - fExp)
		return true
	end

	return false
end

-- 获取经验值
function public:GetExp( hUnit )
	return hUnit:Attribute_GetFloatValue("OreExp", 0.0)
end

-- 升级技能
function public:LevelUp( hUnit )
	local level = self:GetLevel( hUnit )
	local maxExp = self:GetNextLevelExp(level)
	if maxExp <= 0 then return false end

	if self:GetExp(hUnit) < maxExp then
		return false
	end

	if not self:SubExp(hUnit, self:GetNextLevelExp(level)) then
		return false
	end

	self:SetLevel( hUnit, level + 1 )

	for i=0,5 do
		local ability = hUnit:GetAbilityByIndex(i)
		if ability then
			hUnit:RemoveAbility(ability:GetAbilityName())
		end
	end

	local ability = hUnit:AddAbility("ability_ore_spirit_collect_lv"..tostring(level + 1))
	if ability then
		ability:SetLevel(1)
	end

	return true
end

-- 掉落物品
function public:DropItems( hUnit )
	local fakeUnit = self:GetOreUnit( hUnit )
	local hOwner = hUnit:GetOwner()

	local config = CollectOreFakeUnitConfig[fakeUnit:GetUnitName()]
	if config == nil then return end

	local DropItems = config["DropItems"]
	local chance = RandomFloat(0, 100)
	for i,v in ipairs(DropItems) do
		if chance <= v.chance then
			local bag = hOwner:GetBag()
			local item = bag:CreateItem(v.itemname, v.count)
			if item == nil then
				local item = CreateItem(v.itemname, nil, nil)
				CreateItemOnPositionSync(fakeUnit:GetOrigin(), item)
				item:LaunchLoot(false,150,1,fakeUnit:GetOrigin() + RandomVector(100))
			else
				CustomGameEventManager:Send_ServerToPlayer(hOwner:GetPlayerOwner(), "shushan_new_item_tips", {itemname=v.itemname})
			end
			break
		end
	end
end

-- 获取升级所需经验最大值，返回-1表示无法升级
function public:GetNextLevelExp( iCurrentLevel )
	if iCurrentLevel == 1 then
		return 20000
	elseif iCurrentLevel == 2 then
		return 80000
	elseif iCurrentLevel == 3 then
		return 320000
	elseif iCurrentLevel == 4 then
		return 1240000
	end
	return -1
end

-- 采集速度
function public:GetCollectSpeed( iCurrentLevel )
	if iCurrentLevel == 1 then
		return 50
	elseif iCurrentLevel == 2 then
		return 100
	elseif iCurrentLevel == 3 then
		return 200
	elseif iCurrentLevel == 4 then
		return 500
	elseif iCurrentLevel == 5 then
		return 1000
	end
	return 0
end

function public:SetOreUnit( hUnit, hOreUnit )
	local methods = self.hUpdateMethods[hUnit:GetEntityIndex()]
	if not methods then return end
	if hOreUnit:Attribute_GetIntValue("OreMaster", -1) ~= -1 then return end

	local config = CollectOreFakeUnitConfig[hOreUnit:GetUnitName()]
	if config == nil then return end

	if self:GetLevel(hUnit) < config["Level"] then
		return
	end

	methods:SetOreUnit(hOreUnit)
end

function public:OnFateSelected( hOwner )
	local hUnit = hOwner.__shushan_ore_spirit
	if not hUnit then return end

	local methods = self.hUpdateMethods[hUnit:GetEntityIndex()]
	if not methods then return end

	if methods:ChannelTime() > 0.5 then
		function methods:ChannelTime()
			return 0.5
		end
	end
end

-- -- 获取矿精
-- function public:GetOreSpirit(hero)
-- 	return hero.__shushan_ore_spirit
-- end

-- -- 更新经验值
-- function public:UpdateExp(hero)
-- 	local spirit = self:GetOreSpirit(hero)
-- 	self.__ore_spirits_exp[spirit:GetEntityIndex()] = spirit.__ShuShan_CollectOreExp
-- 	CustomNetTables:SetTableValue("Common", "CollectOreSystem_OreSpiritsEXP", self.__ore_spirits_exp )
-- end

-- -- 刷新矿石
-- function public:RespawnFakeOreUnit(fakeUnit)
-- 	local list = self.__fake_ore_units[fakeUnit:GetUnitName()]
-- 	local endTime = GameRules:GetGameTime() + 60

-- 	fakeUnit:AddNewModifier(fakeUnit, nil, "modifier_no_draw", nil)

-- 	Timer("RespawnFakeOreUnit", fakeUnit, function ()

-- 		if GameRules:GetGameTime() >= endTime then
-- 			fakeUnit.__collect_ore_system_points = fakeUnit.__collect_ore_system_max_points
-- 			fakeUnit:RemoveModifierByName("modifier_no_draw")

-- 			self.__all_ores_points[fakeUnit:GetEntityIndex()] = fakeUnit.__collect_ore_system_points
-- 			CustomNetTables:SetTableValue("Common", "CollectOreSystem_AllOresPoints", self.__all_ores_points )
-- 			return nil
-- 		end

-- 		local validCount = 0
-- 		for i,v in ipairs(list) do
-- 			if v.__collect_ore_system_points > 0 then
-- 				validCount = validCount + 1
-- 			end
-- 		end

-- 		if validCount <= math.floor(#list / 2) then
-- 			fakeUnit.__collect_ore_system_points = fakeUnit.__collect_ore_system_max_points
-- 			fakeUnit:RemoveModifierByName("modifier_no_draw")

-- 			self.__all_ores_points[fakeUnit:GetEntityIndex()] = fakeUnit.__collect_ore_system_points
-- 			CustomNetTables:SetTableValue("Common", "CollectOreSystem_AllOresPoints", self.__all_ores_points )
-- 			return nil
-- 		end

-- 		return 1
-- 	end)
-- end

