
--@class CSpawnSystem

--[[
-- 波数刷怪
CSpawnSystem({
	Type = SPAWN_SYSTEM_TYPE_WAVE,
	SpawnerName = "Attacking",	--在spawner.kv中所使用的表名称
	StartWave = 1,  --默认 1
	EndWave = -1,   --默认 -1，代表整个表的怪都要刷
})

-- 副本刷怪
CSpawnSystem({
	Type = SPAWN_SYSTEM_TYPE_DUNGEON,
	SpawnerName = "Dungeon",  --在spawner.kv中所使用的表名称
	DungeonName = "FB1",	--副本名称
	StageName = "FB1_STAGE1", --阶段,可通过SetStageName()来切换阶段
})
]]

if CSpawnSystem == nil then
	CSpawnSystem = class({})
end

local public = CSpawnSystem
local GameMode = GameRules:GetGameModeEntity()

SPAWN_SYSTEM_TYPE_WAVE = 1;
SPAWN_SYSTEM_TYPE_DUNGEON = 2;

function public:constructor(t)
	
	self.__is_running = false;
	self.__spawner_name = t["SpawnerName"]
	self.__type = t["Type"]
	self.__team = t["Team"] or DOTA_TEAM_BADGUYS
	self.__created_units = {}
	self.__stop_start_time = 0
	self.__stop_duration = -1

	-- 波数刷怪
	if self.__type == SPAWN_SYSTEM_TYPE_WAVE then
		self.__spawner_table = SpawnerKV[self.__spawner_name]
		self.__wave = t["StartWave"] or 1
		self.__current_times = 0
		self.__interval_time = 0
		self.__break_start_time = -1
		self.__is_first_start = true
		self.__is_next_wave_start = false

		local SpawnEntities = self.__spawner_table["SpawnEntities"]
		local SpawnEntList = {}
		for k,v in pairs(SpawnEntities) do
			local ent = Entities:FindByName(nil, v)
			if ent then
				table.insert(SpawnEntList,ent)
			end
		end

		self.__spawn_entities = SpawnEntList

	-- 副本刷怪
	elseif self.__type == SPAWN_SYSTEM_TYPE_DUNGEON then
		self.__dungeon_name = t["DungeonName"]
		self.__spawner_table = SpawnerKV[self.__spawner_name][self.__dungeon_name]
	end
end

function public:GetTeam()
	return self.__team
end

function public:GetName()
	return self.__spawner_name
end

function public:GetWave()
	return self.__wave
end

function public:GetMaxWave()
	return Avalon:Conform("spawnsystem_get_max_wave")
end

function public:GetSpawnerTable()
	return self.__spawner_table
end

function public:GetInterval()
	local spawnerTable = self:GetSpawnerTable()
	local waveData = spawnerTable["Wave"..self.__wave]
	if waveData == nil then return -1 end
	return Avalon:Conform("spawnsystem_get_interval", waveData["Interval"]) or 1
end

function public:GetBreakTime()
	local spawnerTable = self:GetSpawnerTable()
	local waveData = spawnerTable["Wave"..self.__wave]
	if waveData == nil then return -1 end
	return Avalon:Conform("spawnsystem_get_break_time", waveData["BreakTime"]) or 1
end

function public:IsRunning()
	return self.__is_running
end

function public:GetType()
	return self.__type
end

function public:Start()
	self.__is_running = true
	if self.__is_first_start then
		self.__is_first_start = false
		self.__break_start_time = GameRules:GetGameTime()
	end
	self:Run()
end

function public:GetCreatedUnits()
	return self.__created_units
end

function public:Run()
	if not self.__has_created_think then
		self.__has_created_think = true

		GameMode:SetContextThink("CSpawnSystem_"..self.__spawner_name..tostring(self.__dungeon_name), function()

			if GameRules:IsGamePaused() then
				return 0.2
			end

			if not self.__has_created_think then
				return nil
			end

			if not self:IsRunning() then
				if self:GetType() == SPAWN_SYSTEM_TYPE_WAVE then
					Avalon:Fire("attacking_update", self)
				end
				if self.__stop_duration > 0 and GameRules:GetGameTime() - self.__stop_start_time >= self.__stop_duration then
					if self.__break_start_time then
						self.__break_start_time = GameRules:GetGameTime() - self.__stop_break_time_fixed_duration
					end
					self:Start()
					return 0.1
				end
				return 0.5
			end

			if self:GetType() == SPAWN_SYSTEM_TYPE_WAVE then
				self:Execute_Wave()
				Avalon:Fire("attacking_update", self)
			elseif self:GetType() == SPAWN_SYSTEM_TYPE_DUNGEON then
				self:Execute_Dungeon()
			end

			return 0.5
		end, 0)
	end
end

function public:Stop(duration)
	self.__is_running = false
	self.__stop_start_time = GameRules:GetGameTime()
	self.__stop_duration = duration or -1

	if self.__break_start_time then
		self.__stop_break_time_fixed_duration = self:GetBreakTime() - self:GetNextWaveRemainingTime()
	end
end

function public:GetStopStartTime()
	return self.__stop_start_time or 0
end

function public:IsFinished()
	local spawnerTable = self:GetSpawnerTable()
	local waveData = spawnerTable["Wave"..self.__wave]
	local times = waveData["Times"]
	return self.__current_times >= times
end

function public:GetStopDuration()
	return self.__stop_duration or -1
end

function public:Destroy()
	self.__has_created_think = false
end

function public:GetDungeonName()
	return self.__dungeon_name
end

function public:GetStageName()
	return self.__stage_name
end

function public:SetStageName(name)
	self.__stage_name = name
end

function public:GetNextWaveRemainingTime()
	local BreakTime = self:GetBreakTime()
	if BreakTime < 0 then return -1 end

	return BreakTime - (GameRules:GetGameTime() - self.__break_start_time)
end

function public:test()
	self.__break_start_time = GameRules:GetGameTime() - 300
end

function public:Execute_Wave()
	if self:GetNextWaveRemainingTime() > 0 then
		return
	end

	local spawnerTable = self:GetSpawnerTable()
	local waveData = spawnerTable["Wave"..self.__wave]
	if waveData == nil then
		self:Stop()
		self:Destroy()
		return
	end
	local times = waveData["Times"]

	if self.__current_times >= times then
		-- if self.__break_start_time == -1 then
		-- 	self.__break_start_time = GameRules:GetGameTime()
		-- end

		-- local BreakTime = self:GetBreakTime()
		-- if BreakTime < 0 then return end
		-- if GameRules:GetGameTime() - self.__break_start_time >= BreakTime then
		-- 	self.__current_times = 0
		-- 	self.__break_start_time = -1
		-- 	self.__wave = self.__wave + 1
		-- end

		return
	end

	local interval = self:GetInterval()
	if interval < 0 then return end

	if GameRules:GetGameTime() - self.__interval_time >= interval then
		self.__interval_time = GameRules:GetGameTime()
		self.__current_times = self.__current_times + 1
		Avalon:Fire("attacking_spawn_times", self, self.__current_times)

		local count = waveData["Count"]
		local unitName = waveData["Unit"]

		for i=1,count do
			for i,SpawnEnt in ipairs(self.__spawn_entities) do
				local spawnUnit = CreateUnitByName(unitName, SpawnEnt:GetOrigin(), true, nil, nil, self:GetTeam() )
				if spawnUnit then
					table.insert(self.__created_units,spawnUnit)
					spawnUnit:SetSpawnOrigin(SpawnEnt:GetOrigin())
					Avalon:Fire("spawnsystem_spawn_unit", self, SpawnEnt, spawnUnit)
				end
				if string.find(unitName,"boss") ~= nil then
					break
				end
			end
		end
	end

	if self.__is_next_wave_start == false then
		self.__is_next_wave_start = true
		Avalon:Fire("on_attacking_next_wave", self)
	end

	if self.__current_times >= times then
		Avalon:Fire("attacking_spawn_finished", self)

		self.__current_times = 0
		self.__break_start_time = GameRules:GetGameTime()
		self.__wave = Avalon:Conform("spawnsystem_get_wave", self, self:GetWave())
		self.__is_next_wave_start = false

		if self.__wave > self:GetMaxWave() then
			return self:Stop(9999)
		end
		return
	end
end

function public:Execute_Dungeon()
	if self:GetType() ~= SPAWN_SYSTEM_TYPE_DUNGEON then return end
	if self.__checked_stop_dungeon == true then return end

	local spawnerTable = self:GetSpawnerTable()

	local Units = spawnerTable["Units"]

	for k,v in pairs(Units) do
		self:CreateDungeonUnits(k)
	end
end

function public:CreateDungeonUnits(index, isForce)
	if self:GetType() ~= SPAWN_SYSTEM_TYPE_DUNGEON then return end
	if self.__checked_stop_dungeon == true then return end

	local spawnerTable = self:GetSpawnerTable()
	local Units = spawnerTable["Units"]
	local data = Units[index]
	if not data then return end

	local canCreate = isForce or (spawnerTable["IsBoss"] == 1) or (data["Force"] == 1)
	if not canCreate then return end

	local entityName = data["EntName"]
	local SpawnEnt = data["__SpawnEnt"]
	if SpawnEnt == nil then SpawnEnt = Entities:FindByName(nil, entityName); data["__SpawnEnt"]=SpawnEnt end
	if SpawnEnt == nil then return end

	local createdUnits = self:GetCreatedUnits()

	if createdUnits[index] == nil then
		createdUnits[index] = {list={}}
	end

	local units = createdUnits[index]
	local list = units.list
	local count = data["Count"] or 1
	local unitName = data["UnitName"]
	local SpawnTime = (data["SpawnTime"] or spawnerTable["SpawnTime"] or 10)

	SpawnTime = Avalon:Conform("spawnsystem_get_fixed_dungeon_spawn_time",SpawnTime)

	for i=1,count do
		local unit = list[i]
		if (unit == nil) or ( unit and (unit:IsNull() or not unit:IsAlive()) ) then

			local KillTime
			if unit == nil then
				KillTime = -120
			else
				KillTime = unit.__CSpawnSystem_KillTime or -120
			end

			if GameRules:GetGameTime() - KillTime >= SpawnTime then

				local spawnUnit = CreateUnitByName(unitName, SpawnEnt:GetOrigin(), true, nil, nil, self:GetTeam() )
				if spawnUnit then
					list[i] = spawnUnit
					spawnUnit:SetSpawnOrigin(SpawnEnt:GetOrigin())
					Avalon:Fire("spawnsystem_spawn_unit", self, SpawnEnt, spawnUnit, data["Force"] == 1)
				end

			end
		end
	end

end

function public:RefreshDungeon()
	if self:GetType() ~= SPAWN_SYSTEM_TYPE_DUNGEON then return end
	if self.__checked_stop_dungeon == true then return end
	
	local spawnerTable = self:GetSpawnerTable()
	local Units = spawnerTable["Units"]

	for k,v in pairs(Units) do
		self:CreateDungeonUnits(k,true)
	end
end

function public:StopAndRemoveAllUnit()
	if self:GetType() ~= SPAWN_SYSTEM_TYPE_DUNGEON then return end
	self.__checked_stop_dungeon = true
	self:Stop()

	local createdUnits = self:GetCreatedUnits()

	local spawnerTable = self:GetSpawnerTable()
	local Units = spawnerTable["Units"]

	for k,v in pairs(Units) do
		local units = createdUnits[k]
		if units then
			local list = units.list

			if list then
				for _,unit in pairs(list) do
					if not unit:IsNull() then
						unit:RemoveSelf()
					end
				end
			end
		end
			
	end
		
end

function public:Recover()
	if self:GetType() ~= SPAWN_SYSTEM_TYPE_DUNGEON then return end
	self.__checked_stop_dungeon = false
	self:Start()
end

function public:OnKilledUnit(attacker, victim)
	victim.__CSpawnSystem_KillTime = GameRules:GetGameTime()

	if self:GetType() == SPAWN_SYSTEM_TYPE_WAVE then
		local createdUnits = self:GetCreatedUnits()
		if #createdUnits == 0 then return end
		
		for i,unit in ipairs(createdUnits) do
			if unit == victim then
				table.remove(createdUnits,i)
				break
			end
		end
		if #createdUnits == 0 then
			Avalon:Fire("attacking_finished", self)
		end
	end
end