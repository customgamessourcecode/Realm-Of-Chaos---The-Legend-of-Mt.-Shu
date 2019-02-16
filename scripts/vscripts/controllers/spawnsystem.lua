
if SpawnSystemCtrl == nil then
	SpawnSystemCtrl = RegisterController('spawnsystem')
	SpawnSystemCtrl.__spawners = {}
	SpawnSystemCtrl.__plant_list = {}
end

local public = SpawnSystemCtrl
local FOWViewerUnit = {}

g_bosses_particle_table = 
{
	["LV4_fb_07_boss_bingyanshou"] = "particles/bosses/yanshuangshou_fire.vpcf",
	["LV4_fb_08_boss_yanshuangshou"] = "particles/bosses/yanshuangshou_fire.vpcf"
}

-- 当单位被创建
function public:OnSpawnUnit(spawner, spawnEntity, unit, isForce)
	local unitName = unit:GetUnitName()
	local findNum = string.find(unitName, 'BOSS')
			
	if spawner:GetType() == SPAWN_SYSTEM_TYPE_DUNGEON then

		local spawnerTable = spawner:GetSpawnerTable()
		local difficulty = GameRules:GetCustomGameDifficulty()

		--if difficulty > 0 and findNum ~= nil then
			
			--unit:SetModelScale( difficulty*0.2 + unit:GetModelScale())
		--end

		-- for k,v in pairs(g_bosses_particle_table) do
		-- 	if k == unitName then
		-- 		print("g_bosses_particle_table")
		-- 		local effectIndex = ParticleManager:CreateParticle(v, PATTACH_CUSTOMORIGIN, unit)
		-- 		ParticleManager:SetParticleControlEnt(effectIndex , 0, unit, 5, "attach_hitloc", Vector(0,0,0), true)
		-- 	end
		-- end


		unit:SetForwardVector(RandomVector(1))
		local isBoss = string.find(unitName,"boss") ~= nil

		if isBoss == false and #spawnEntity:GetChildren() > 0 then
			AICtrl:CreateAI(unit, "dungeon_unit", {SpawnEntity=spawnEntity, GoBackDistance=1000})
		else
			-- AICtrl:CreateAI(unit, "fbcreaturebaseai", {SpawnEntity=spawnEntity})
			
			if isBoss then
				AICtrl:CreateAI(unit, "dungeon_boss", {SpawnEntity=spawnEntity})
			else
				AICtrl:CreateAI(unit, "dungeon_unit_easy", {SpawnEntity=spawnEntity})
			end
		end

		if isBoss == false and isForce == false then
			unit:AddNewModifier(unit, nil, "modifier_dungeon_unit_recycling", nil)
		end

		if isBoss then
			unit:AddAbility("shushan_fb_boss_common"):SetLevel(1)
			self:ChangeUnitData(unit)
			unit:AddNewModifier(unit, nil, "modifier_shushan_boss", nil)

			local radius = SpawnerKV["FixedUnitHullRadius"][unitName]
			if radius then unit:SetHullRadius(radius) end

			if GameRules:GetGameModeEntity():GetFogOfWarDisabled() == false and not FOWViewerUnit[spawnEntity:GetName()] then
				FOWViewerUnit[spawnEntity:GetName()] = true
				AddFOWViewer(DOTA_TEAM_GOODGUYS, unit:GetOrigin(), 256, 9999, false)
			end

		end

		-- 模型动画
		if 
			unit:GetModelName() == "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl"
		then
			unit:StartGesture(ACT_DOTA_CONSTANT_LAYER)
		end

		-- unit:SetAngles(0, 270, 0)
		-- if string.find(unit:GetUnitName(),"boss") == nil then
		-- 	unit:AddNoDraw()
		-- 	unit:AddNewModifier(unit, nil, "modifier_invulnerable", nil)
		-- end

	else
		-- unit:SetMustReachEachGoalEntity(true)
		-- unit:SetInitialGoalEntity(spawnEntity)
		local isBoss = false
		if string.find(unitName,"boss") ~= nil then
			self:ChangeUnitData(unit, true)
			isBoss = true
		end
		AICtrl:CreateAI(unit, "attacking", {SpawnEntity=spawnEntity, CurrentEntity=spawnEntity, GoBackDistance=2000, IsBoss=isBoss})

		if isBoss then
			CustomNetTables:SetTableValue("Common", "ShuShanAttackingBoss", {
				unit=unit:GetEntityIndex()
			})
		end
	end
end

local m_IsTeamBoss = {
	["LV11_fb_19_boss_fengshi"] = true,
	["LV11_fb_19_boss_baji"] = true,
	["LV11_fb_19_boss_cangyin"] = true,
	["LV11_fb_19_boss_jiuxiao"] = true,
	["LV12_fb_19_boss_dihen"] = true,
	["LV12_fb_13_boss_dizangwang"] = true,
	["LV12_fb_14_boss_nvwahuanying"] = true,
	["LV13_fb_20_boss_fushuizhifeng"] = true,
}

function public:ChangeUnitData(unit, isAttacking, defaultLevel)
	local Level = tonumber(GetUnitNameStringLevel(unit:GetUnitName())) or defaultLevel
	if Level~=nil then
		local difficulty = GameRules:GetCustomGameDifficulty()

		-- 攻击力调整
		local baseAttackMax = unit:GetBaseDamageMax()*5*(1+Level*0.2)
		local baseAttackMin = baseAttackMax

		if difficulty == 1 then
			baseAttackMax = baseAttackMax - baseAttackMax*0.2
			baseAttackMin = baseAttackMin - baseAttackMin*0.2
		elseif difficulty == 2 then
			baseAttackMax = baseAttackMax - baseAttackMax*0.1
			baseAttackMin = baseAttackMin - baseAttackMin*0.1
		elseif difficulty == 3 then
		elseif difficulty == 4 then
			baseAttackMax = baseAttackMax + baseAttackMax*0.1
			baseAttackMin = baseAttackMin + baseAttackMin*0.1
		elseif difficulty == 5 then
			baseAttackMax = baseAttackMax + baseAttackMax*0.2
			baseAttackMin = baseAttackMin + baseAttackMin*0.2
		elseif difficulty == 6 then
			baseAttackMax = baseAttackMax + baseAttackMax*0.3
			baseAttackMin = baseAttackMin + baseAttackMin*0.3
		elseif difficulty == 7 then
			baseAttackMax = baseAttackMax + baseAttackMax*0.3
			baseAttackMin = baseAttackMin + baseAttackMin*0.3
		end

		unit:SetBaseDamageMax(baseAttackMax)
		unit:SetBaseDamageMin(baseAttackMin)

		-- 生命值调整
		local health = unit:GetBaseMaxHealth()*(1+Level*0.3)

		if difficulty == 1 then
			health = health - health*0.2
		elseif difficulty == 2 then
			health = health - health*0.1
		elseif difficulty == 3 then
		elseif difficulty == 4 then
			health = health + health*0.1
		elseif difficulty == 5 then
			health = health + health*0.2
		elseif difficulty == 6 then
			health = health + health*0.3
		elseif difficulty == 7 then
			health = health + health*1.6
		end

		if m_IsTeamBoss[unit:GetUnitName()] == true or isAttacking then
			health = health*GetRealPlayerCount()
		end

		unit:SetBaseMaxHealth(health)
		unit:SetMaxHealth(health)
		unit:SetHealth(unit:GetMaxHealth())
	end
end

-- 初始化
function public:init()
	_G['SpawnerKV'] = LoadKeyValues("scripts/npc/spawner.kv")

	local dungeonNameList = {}

	-- 初始化刷怪器
	for SpawnerName, SpawnerData in pairs(SpawnerKV) do
		
		if SpawnerName == "Dungeon" then

			for DungeonName,DungeonData in pairs(SpawnerData) do
				self.__spawners[DungeonName] = CSpawnSystem({
					Type = SPAWN_SYSTEM_TYPE_DUNGEON,
					SpawnerName = "Dungeon", 
					DungeonName = DungeonName,
				})
				table.insert(dungeonNameList,DungeonName)
			end

		elseif SpawnerName == "Attacking" then
			self.__spawners[SpawnerName] = CSpawnSystem({
				Type = SPAWN_SYSTEM_TYPE_WAVE,
				SpawnerName = "Attacking", 
			})
		end

	end


	table.sort(dungeonNameList, function ( a,b )
		local aa = string.match(a,"(%d+)") or 99
		local bb = string.match(b,"(%d+)") or 99
		return tonumber(aa) < tonumber(bb)
	end)
	CustomNetTables:SetTableValue("Common", "DungeonNameList", dungeonNameList)

	-- 注册事件
	ListenToGameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), self)
	Avalon:Listen("spawnsystem_spawn_unit", Dynamic_Wrap(self,"OnSpawnUnit"), self)
	Avalon:Listen("on_attacking_next_wave", Dynamic_Wrap(self,"OnAttackingNextWave"), self)
	Avalon:Listen("attacking_update", Dynamic_Wrap(self,"OnAttackingUpdate"), self)
	Avalon:Listen("attacking_finished", Dynamic_Wrap(self,"OnAttackingFinished"), self)
	Avalon:Listen("attacking_spawn_finished", Dynamic_Wrap(self,"OnAttackingSpawnFinished"), self)
	Avalon:Listen("attacking_spawn_times", Dynamic_Wrap(self,"OnAttackingSpawnTimes"), self)
	Avalon:BindConform("spawnsystem_get_wave", Dynamic_Wrap(self,"GetWave"), self)
	Avalon:BindConform("spawnsystem_get_interval", Dynamic_Wrap(self,"GetInterval"), self)
	Avalon:BindConform("spawnsystem_get_break_time", Dynamic_Wrap(self,"GetBreakTime"), self)
	Avalon:BindConform("spawnsystem_get_max_wave", Dynamic_Wrap(self,"GetMaxWave"), self)
	Avalon:BindConform("spawnsystem_get_fixed_dungeon_spawn_time", Dynamic_Wrap(self,"GetFixedDungeonSpawnTime"), self)
end

function public:StartAll()
	local delay = 1
	local difficulty = GameRules:GetCustomGameDifficulty()

	local spawnerNameList = {}
	for k,v in pairs(self.__spawners) do
		while true do
			if ShuShanLanguageIsSchinese then
				if (difficulty == 1) and (k == "FB18BOSS" or k == "FB18" 
					or k == "FB12BOSS" or k == "FB12" or k == "FB14BOSS" or k == "FB14BOSS3" or k == "FB14" 
					or k == "FB19BOSS" or k == "FB19") then
					break
				elseif (difficulty == 2) and (k == "FB18BOSS" or k == "FB18" or k == "FB12BOSS" or k == "FB12" or k == "FB19BOSS" or k == "FB19") then
					break
				elseif (difficulty == 3) and (k == "FB18BOSS" or k == "FB18" or k == "FB19BOSS" or k == "FB19") then
					break
				elseif (difficulty == 4) and (k == "FB19BOSS" or k == "FB19") then
					break
				end
			end
			table.insert(spawnerNameList,k)
			break
		end
	end
	table.sort(spawnerNameList, function ( a,b )
		local aa = string.match(a,"(%d+)") or 99
		local bb = string.match(b,"(%d+)") or 99
		return tonumber(aa) < tonumber(bb)
	end)

	for i,k in ipairs(spawnerNameList) do
		local v = self.__spawners[k]
		if v:GetName() == "Attacking" then
			v:Start()
			if GameRules:GetCustomGameDifficulty() <= 1 then
				v:Stop(99999)
				CustomNetTables:SetTableValue("Common", "StartAttackingInfo", {start=0} )
			end
		else
			Wait(delay, function ()
				v:Start()
			end)
			delay = delay + 3
		end
	end

	for i,v in ipairs(self.__plant_list) do
		self:Plant(v)
	end

	-- self:CreateSpawnFlowerThink("item_0005", 10, {"FB1"}, {"huayao","linghuayao"})
	-- self:CreateSpawnFlowerThink("item_0007", 10, {"FB4"}, {"shanyao"})
	self.StartAll = nil
end

function public:GetDungeonSpawner(name)
	return self.__spawners[name]
end

function public:GetAttackingSpawner()
	return self.__spawners["Attacking"]
end

-- 当下一波开始
function public:OnAttackingNextWave(spawner)
	CustomGameEventManager:Send_ServerToAllClients("attacking_start", {wave=spawner:GetWave()})
end

-- 单位被击杀
function public:OnEntityKilled(keys)
	local victim = EntIndexToHScript(keys.entindex_killed or -1)
	if victim:GetTeam() ~= DOTA_TEAM_BADGUYS then return end
	
	local attacker = EntIndexToHScript(keys.entindex_attacker or -1)

	for k,spawner in pairs(self.__spawners) do
		spawner:OnKilledUnit(attacker,victim)
	end

	if victim.SpawnEnt ~= nil and string.find(victim:GetUnitName(),"boss") ~= nil then
		local children = victim.SpawnEnt:GetChildren()
		if #children > 0 then
			local child = children[#children]
			if child.Enable then
				child:Enable()
				local p = ParticleManager:CreateParticle("particles/avalon/teleport_trigger_enabled_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(p, 0, child:GetOrigin())
				victim.SpawnEnt.__trigger_effect = p
			end
		end
	end
end

-- 进攻怪更新
function public:OnAttackingUpdate(spawner)
	local BreakTime = spawner:GetBreakTime()
	if BreakTime < 0 then return end

	if self.__attacking_info == nil then
		self.__attacking_info = {}
	end
	
	local info = self.__attacking_info

	if spawner:IsRunning() then
		info.is_stop = 0
		info.wave = spawner:GetWave()
		info.next_wave_remaining_time = spawner:GetNextWaveRemainingTime()
		info.break_time = BreakTime
	else
		info.is_stop = 1
		info.stop_start_time = spawner:GetStopStartTime()
		info.stop_duration = spawner:GetStopDuration()
	end
		
	CustomNetTables:SetTableValue("Common", "attacking_info", info )
end

-- 进攻怪被击杀完毕
local isWaitWinner = false
function public:OnAttackingFinished(spawner)
	if spawner:GetWave() >= spawner:GetMaxWave() then
		if isWaitWinner == false then
			isWaitWinner = true
		else
			_G["IsShuShanPlayerWin"] = true
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end
	else
		if self.__is_quick_game_over == true then
			spawner:Start()
			spawner.__break_start_time = GameRules:GetGameTime() + 1
		end
	end
end

-- 进攻怪全部创建完毕
function public:OnAttackingSpawnFinished(spawner)
	if self.__is_quick_game_over == true then
		spawner:Stop(120)
	end
	-- if GameRules:GetCustomGameDifficulty() >= 4 and spawner:GetWave()%4 ~= 0 then
	-- 	local spawnerTable = spawner:GetSpawnerTable()
	-- 	local waveData = spawnerTable["Wave"..spawner.__wave]
	-- 	if waveData == nil then return end

	-- 	local unitName = waveData["Unit"]

	-- 	local SpawnEnt = spawner.__spawn_entities[1]
	-- 	local spawnUnit = CreateUnitByName(unitName, SpawnEnt:GetOrigin(), true, nil, nil, spawner:GetTeam())
	-- 	if spawnUnit then
	-- 		spawnUnit:SetModelScale(spawnUnit:GetModelScale()*2)
	-- 		spawnUnit:SetRenderColor(255, 128, 128)
	-- 		spawnUnit.__is_elite = true
	-- 		spawnUnit.__this_wave = spawner:GetWave()
	-- 		self:ChangeUnitData(spawnUnit, true, spawnUnit:GetLevel())
	-- 		spawnUnit:AddAbility("creature_elite_ability01"):SetLevel(1)
	-- 		spawnUnit:AddAbility("creature_elite_ability02"):SetLevel(1)
	-- 		spawnUnit:AddAbility("creature_elite_ability03"):SetLevel(1)
	-- 		spawnUnit:AddAbility("creature_elite_ability04"):SetLevel(1)

	-- 		table.insert(spawner.__created_units,spawnUnit)
	-- 		spawnUnit:SetSpawnOrigin(SpawnEnt:GetOrigin())
	-- 		Avalon:Fire("spawnsystem_spawn_unit", spawner, SpawnEnt, spawnUnit)
	-- 	end
	-- end
end

function public:GetInterval(baseInterval)
	return baseInterval - baseInterval * (GameRules:GetCustomGameRate()/10)
end

function public:GetBreakTime(baseBreakTime)
	if self.__is_quick_game_over == true then
		return 10
	end
	local rate = GameRules:GetCustomGameRate()
	local fixed = 0
	if rate == 1 then
		fixed = 60
	elseif rate == 2 then
		fixed = 30
	elseif rate == 3 then
		fixed = 0
	elseif rate == 4 then
		fixed = -30
	elseif rate == 5 then
		fixed = -60
	elseif rate == 6 then
		fixed = -90
	end
	return baseBreakTime + fixed
end

function public:GetMaxWave()
	local difficulty = GameRules:GetCustomGameDifficulty()
	if difficulty == 1 then
		return 20
	elseif difficulty == 2 then
		return 24
	elseif difficulty == 3 then
		return 28
	elseif difficulty == 4 then
		return 32
	elseif difficulty == 5 then
		return 32
	elseif difficulty == 6 then
		return 32
	end
	return 32
end

function public:GetWave(spawner, wave)
	if self.__is_quick_game_over == true then
		for i=wave+1,32 do
			if i % 4 == 0 then
				return i
			end
		end
	end
	return wave + 1
end

function public:GetFixedDungeonSpawnTime(time)
	return time / (1+(GetRealPlayerCount()-1)*0.25)
end

function public:OnAttackingSpawnTimes(spawner, times)
	if times == 20 then
		if GameRules:GetCustomGameDifficulty() >= 4 and spawner:GetWave()%4 ~= 0 then
			local spawnerTable = spawner:GetSpawnerTable()
			local waveData = spawnerTable["Wave"..spawner.__wave]
			if waveData == nil then return end

			local unitName = waveData["Unit"]

			local SpawnEnt = spawner.__spawn_entities[1]
			local spawnUnit = CreateUnitByName(unitName, SpawnEnt:GetOrigin(), true, nil, nil, spawner:GetTeam())
			if spawnUnit then
				spawnUnit:SetModelScale(spawnUnit:GetModelScale()*2)
				spawnUnit:SetRenderColor(255, 128, 128)
				spawnUnit.__is_elite = true
				spawnUnit.__this_wave = spawner:GetWave()
				self:ChangeUnitData(spawnUnit, true, spawnUnit:GetLevel())
				spawnUnit:AddAbility("creature_elite_ability01"):SetLevel(1)
				spawnUnit:AddAbility("creature_elite_ability02"):SetLevel(1)
				spawnUnit:AddAbility("creature_elite_ability03"):SetLevel(1)
				spawnUnit:AddAbility("creature_elite_ability04"):SetLevel(1)

				table.insert(spawner.__created_units,spawnUnit)
				spawnUnit:SetSpawnOrigin(SpawnEnt:GetOrigin())
				Avalon:Fire("spawnsystem_spawn_unit", spawner, SpawnEnt, spawnUnit)
			end
		end
	end
end

--[[
快速通关
]]
function public:SetQuickGameOver()
	if self.__is_quick_game_over ~= true then
		self.__is_quick_game_over = true
	end
end

function public:StartAttacking()
	if GameRules:GetCustomGameDifficulty() > 1 then return end
	SpawnSystemCtrl:GetAttackingSpawner().__break_start_time = GameRules:GetGameTime()
	SpawnSystemCtrl:GetAttackingSpawner():Start()
	CustomNetTables:SetTableValue("Common", "StartAttackingInfo", {start=1} )
end

function public:StopAttacking()
	if GameRules:GetCustomGameDifficulty() > 1 then return end
	SpawnSystemCtrl:GetAttackingSpawner():Stop(99999)
	CustomNetTables:SetTableValue("Common", "StartAttackingInfo", {start=0} )
end

local DungeonTurnData = {}
function public:StopDungeon(name, checked)
	local spawner = self.__spawners[name]
	if not spawner then return end

	local c = DungeonTurnData[name] or 0
	if c == checked then return end
	DungeonTurnData[name] = checked

	CustomNetTables:SetTableValue("Common", "DungeonTurnData", DungeonTurnData )

	if checked == 1 then
		spawner:StopAndRemoveAllUnit()
	else
		spawner:Recover()
	end
end

--[[
=============================================================================================================
植物
=============================================================================================================
]]

local Plant_CanSpawn = function ( self, index )
	if self.__spawn_list[index] == nil then
		return true
	end

	local ent = self.__spawn_list[index]

	if ent:IsNull() then
		ParticleManager:DestroyParticle(ent.__effect, false)
		ParticleManager:ReleaseParticleIndex(ent.__effect)

		local count = math.floor(self:count()/2)
		local validCount = 0
		for i,v in ipairs(self.__spawn_list) do
			if not v:IsNull() then
				validCount = validCount + 1
			end
		end

		if validCount <= count then
			return true
		end

		local time = self.__spawn_time[index]

		if time == -1 then
			self.__spawn_time[index] = GameRules:GetGameTime()

		elseif GameRules:GetGameTime() - time >= self:interval() then
			return true
		end
	end

	return false
end

function public:CreatePlantEffect(box)
	local p = ParticleManager:CreateParticle("particles/avalon/item_tip.vpcf", PATTACH_CUSTOMORIGIN, box)
	ParticleManager:SetParticleControl(p, 0, box:GetOrigin())
	box.__effect = p
end


function public:Plant(model)
	model.__spawn_list = {}
	model.__spawn_time = {}

	if model.can_spawn == nil then
		model.can_spawn = Plant_CanSpawn
	end

	model:init()

	Timer(DoUniqueString("Plant"), 10, function ()
		
		for i=1, model:count() do
			if model:can_spawn(i) then
				local pos = model:pos(i)
				if pos then
					local item = CreateItem(model:itemname(),nil,nil)
					if item then
						model.__spawn_list[i] = CreateItemOnPositionSync(pos, item)
						model.__spawn_time[i] = -1
						self:CreatePlantEffect(model.__spawn_list[i])
					end
				end
			end
		end

		return 2
	end)
end

function public:AddPlant(model)
	table.insert(self.__plant_list,model)
end

-- 灵草
public:AddPlant({

	init = function ( self )
		local refer_spawn_points = {}
		local Dungeon = SpawnerKV["Dungeon"]["FB1"]["Units"]
		for k,v in pairs(Dungeon) do
			if v.UnitName == "LV1_fb_01_huayao" then
				local ent = Entities:FindByName(nil, v.EntName)
				if ent then
					table.insert(refer_spawn_points,ent:GetOrigin())
				end
			end
		end

		self.__refer_spawn_points = refer_spawn_points
	end,

	pos = function ( self, index )
		return self.__refer_spawn_points[RandomInt(1, #self.__refer_spawn_points)] + RandomVector(RandomFloat(50, 150))
	end,

	interval = function ( self )
		return 60
	end,

	itemname = function ( self )
		return "item_0005"
	end,

	count = function ( self )
		return 10
	end,

})

-- 九瓣天龙散
public:AddPlant({

	init = function ( self )
		local refer_spawn_points = {}
		local Dungeon = SpawnerKV["Dungeon"]["FB1"]["Units"]
		for k,v in pairs(Dungeon) do
			if v.UnitName == "LV1_fb_01_huayao" then
				local ent = Entities:FindByName(nil, v.EntName)
				if ent then
					table.insert(refer_spawn_points,ent:GetOrigin())
				end
			end
		end

		self.__refer_spawn_points = refer_spawn_points
	end,

	pos = function ( self, index )
		return self.__refer_spawn_points[RandomInt(1, #self.__refer_spawn_points)] + RandomVector(RandomFloat(50, 150))
	end,

	interval = function ( self )
		return 60
	end,

	itemname = function ( self )
		return "item_0004"
	end,

	count = function ( self )
		return 1
	end,

})

-- 木材
public:AddPlant({

	init = function ( self )
		local refer_spawn_points = {}
		local entities = Entities:FindAllByName("item_0007")
		for k,v in pairs(entities) do
			table.insert(refer_spawn_points,v:GetOrigin())
		end

		self.__refer_spawn_points = refer_spawn_points
	end,

	pos = function ( self, index )
		return self.__refer_spawn_points[index]
	end,

	interval = function ( self )
		return 60
	end,

	itemname = function ( self )
		return "item_0007"
	end,

	count = function ( self )
		return #self.__refer_spawn_points
	end,

})

-- 兰叶
public:AddPlant({

	init = function ( self )
		local refer_spawn_points = {}
		local Dungeon = SpawnerKV["Dungeon"]["FB2"]["Units"]
		for k,v in pairs(Dungeon) do
			if v.UnitName == "LV1_fb_02_shuiyao" then
				local ent = Entities:FindByName(nil, v.EntName)
				if ent then
					table.insert(refer_spawn_points,ent:GetOrigin())
				end
			end
		end

		self.__refer_spawn_points = refer_spawn_points
	end,

	pos = function ( self, index )
		return self.__refer_spawn_points[RandomInt(1, #self.__refer_spawn_points)] + RandomVector(RandomFloat(50, 150))
	end,

	interval = function ( self )
		return 60
	end,

	itemname = function ( self )
		return "item_0008"
	end,

	count = function ( self )
		return 10
	end,

})

-- 九火冰莲
public:AddPlant({

	init = function ( self )
		local refer_spawn_points = {}
		local Dungeon = SpawnerKV["Dungeon"]["FB7"]["Units"]
		for k,v in pairs(Dungeon) do
			if v.UnitName == "LV4_fb_07_bingguai" then
				local ent = Entities:FindByName(nil, v.EntName)
				if ent then
					table.insert(refer_spawn_points,ent:GetOrigin())
				end
			end
		end

		self.__refer_spawn_points = refer_spawn_points
	end,

	pos = function ( self, index )
		return self.__refer_spawn_points[RandomInt(1, #self.__refer_spawn_points)] + RandomVector(RandomFloat(50, 150))
	end,

	interval = function ( self )
		return 60
	end,

	itemname = function ( self )
		return "item_0212"
	end,

	count = function ( self )
		return 1
	end,

})