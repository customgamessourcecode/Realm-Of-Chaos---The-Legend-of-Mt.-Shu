

function GetRealPlayerCount()
	if ShuShanSimulateMultiplayerMode ~= nil then
		return ShuShanSimulateMultiplayerMode
	end

	return PlayerResource:GetPlayerCount()
end

--[[
-----------------------------------------------------------------
统一重生管理
EntityKilledEvent
]]
local FoJiaoXinTuCooldown = {}
local HeroRespawnManagerLockTime = {}
function HeroRespawnManager(hero, source, ability)
	if not hero:IsRealHero() then return end

	local lockTime = HeroRespawnManagerLockTime[hero:GetEntityIndex()] or 0
	if GameRules:GetGameTime() < lockTime then return end

	if source == "EntityKilledEvent" then
		local hasSuit = hero:HasModifier("modifier_item_suit_buluominghe")
		local hasItem = hero:HasItemInInventory("item_0551")

		if hero:IsFate("fojiaoxintu") then

			local cd = FoJiaoXinTuCooldown[hero:GetEntityIndex()] or 0
			if GameRules:GetGameTime() >= cd then
				FoJiaoXinTuCooldown[hero:GetEntityIndex()] = GameRules:GetGameTime() + 360
				HeroRespawnManagerLockTime[hero:GetEntityIndex()] = GameRules:GetGameTime() + 0.1

				hero:SetRespawnsDisabled(true)
				hero:SetRespawnPosition(hero:GetOrigin())
				hero:SetTimeUntilRespawn(0)
				hero:SetRespawnsDisabled(false)
			end

		elseif hero:IsFate("zhuanshizhe") or hasSuit or hasItem then

			local percent = 1

			if hasSuit then
				percent = percent * 0.5
			end

			if hero:IsFate("zhuanshizhe") then
				percent = percent * 0.5
			end

			if hasItem then
				percent = percent * 0.5
			end

			hero:SetTimeUntilRespawn(GameRules:GetGameModeEntity():GetFixedRespawnTime()*percent)
		end

	elseif source == "Fomenxinfa" then
		HeroRespawnManagerLockTime[hero:GetEntityIndex()] = GameRules:GetGameTime() + 0.1
		hero:SetRespawnsDisabled(true)
		hero:SetRespawnPosition(hero:GetOrigin())
		hero:SetTimeUntilRespawn(0)
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		hero:SetRespawnsDisabled(false)

	end
end


--[[
-----------------------------------------------------------------
召唤混魔冰焰真君
]]
local HunMoBingYanZhenJun = nil
function SummonHunMoBingYanZhenJun()
	local hunmobingyan_tower = Entities:FindAllByName("hunmobingyan_tower")
	for i,v in ipairs(hunmobingyan_tower) do
		if not v.__is_fire then
			return
		end
	end

	local ent = Entities:FindByName(nil, "hunmobingyanzhenjun")
	local p = ParticleManager:CreateParticle("particles/avalon/units/hunmotower/hunmotower_boss_spawn.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, ent:GetOrigin())
	ent:EmitSound("HunMoBingYanZhenJun.SpawnLoop")
	
	Wait(3, function ( )
		ent:StopSound("HunMoBingYanZhenJun.SpawnLoop")
		ent:EmitSound("HunMoBingYanZhenJun.Spawn")
		ParticleManager:DestroyParticle(p, false)

		local boss = CreateUnitByName("LV7_fb_07_boss_hunmobingyanzhenjun", ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		if boss then
			boss.SpawnEnt = ent
			HunMoBingYanZhenJun = boss
			AICtrl:CreateAI(boss, "fbcreaturebaseai", {SpawnEntity=ent})
			SpawnSystemCtrl:ChangeUnitData(boss)
			boss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
			boss:AddNewModifier(boss, nil, "modifier_shushan_boss", nil)
		end
	end)
end

function ClearHunMoBingYanZhenJunTowerFire()
	if HunMoBingYanZhenJun then
		if HunMoBingYanZhenJun:IsNull() or not HunMoBingYanZhenJun:IsAlive() then
			local hunmobingyan_tower = Entities:FindAllByName("hunmobingyan_tower")
			for i,v in ipairs(hunmobingyan_tower) do
				v.__is_fire = false
				ParticleManager:DestroyParticle(v.__fire_particle, false)
			end
			CustomNetTables:SetTableValue("Abilities", "custom_item_0182",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0185",  {can_not_cast=0})
		end
	end
end

--[[
-----------------------------------------------------------------
打开玄冰宝藏
]]
function OpenXuanBingBaoZang( target )
	if target:GetUnitName() ~= "shushan_xuanbingbaozang" then
		return
	end

	if target.__right_key_ok and target.__left_key_ok then
		target.__right_key_ok = false
		target.__left_key_ok = false

		local itemlist = {
			"item_0070",
			"item_0061",
			"item_0035",
			"item_0079",
			"item_0080",
			"item_0081",
			"item_0082",
			"item_0186",
			"item_0198",
		}

		local len = #itemlist
		for i=1,len do
			local itemname = table.remove(itemlist,1)
			Wait(0.1*(i-1), function ()
				local item = CreateItem(itemname, nil, nil)
				local container = CreateItemOnPositionSync(target:GetOrigin(), item)
				item:LaunchLoot(false, 256, 1, target:GetOrigin()+RandomVector(150))
			end)
		end

		CustomNetTables:SetTableValue("Abilities", "custom_item_0208",  {can_not_cast=0})
		CustomNetTables:SetTableValue("Abilities", "custom_item_0209",  {can_not_cast=0})
	end
end

--[[
-----------------------------------------------------------------
稻草人
]]
function DaoCaoRenOnDamage(attacker, victim, damage)
	if attacker.__dao_cao_ren_damage_time == nil then
		attacker.__dao_cao_ren_damage_time = 0
	end
	if GameRules:GetGameTime() >= attacker.__dao_cao_ren_damage_time then
		attacker.__dao_cao_ren_damage_time = GameRules:GetGameTime() + 1
		Say(attacker:GetPlayerOwner(), "秒伤"..tostring(attacker.__dao_cao_ren_damage), false)
		attacker.__dao_cao_ren_damage = 0
	end
	attacker.__dao_cao_ren_damage = attacker.__dao_cao_ren_damage + damage
end


--[[
-----------------------------------------------------------------
境界提升
]]
function ShuShanCanUpgradeState(hero)
	local state = hero:GetCustomAttribute("state",0)
	if state >= 12 then return false end

	local require_table = StateUpgradeRequireTable[state]

	return 	hero:GetStrength() >= require_table.three_attrs
		and 
			hero:GetAgility() >= require_table.three_attrs
		and 
			hero:GetIntellect() >= require_table.three_attrs
		and
			hero:GetCustomAttribute("merits",0) >= require_table.merits
		and
			hero:GetLevel() >= require_table.level
end

function ShuShanCanUpgradeStateNotify(hero)
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_can_upgrade_state", {can=ShuShanCanUpgradeState(hero)})
end

--[[
-----------------------------------------------------------------
DPS统计
]]
local ShuShanAttackingBossDPS_Filter = {
	["npc_dao_cao_ren"] = true,
	["LV4_creature_04_boss"] = true,
	["LV6_creature_08_boss"] = true,
	["LV12_creature_12_boss"] = true,
	["LV9_creature_16_boss"] = true,
	["LV10_creature_20_boss"] = true,
	["LV11_creature_24_boss"] = true,
	["LV12_creature_28_boss"] = true,
	["LV11_fb_19_boss_fengshi"] = true,
	["LV11_fb_19_boss_baji"] = true,
	["LV11_fb_19_boss_cangyin"] = true,
	["LV11_fb_19_boss_jiuxiao"] = true,
	["LV12_fb_19_boss_dihen"] = true,
}
local ShuShanAttackingBossDPS_Data = {}

for k in pairs(ShuShanAttackingBossDPS_Filter) do
	ShuShanAttackingBossDPS_Data[k] = {}
end

function ShuShanAttackingBossDPS(unitname, attacker, damage)
	-- if not ShuShanAttackingBossDPS_Filter[unitname] then return end

	-- local data = ShuShanAttackingBossDPS_Data[unitname]
	-- if not data then return end

	-- if not attacker:IsRealHero() then
	-- 	attacker = attacker:GetOwner()
	-- 	if not attacker or not attacker.IsRealHero or not attacker:IsRealHero() then
	-- 		return
	-- 	end
	-- end

	-- local entindex = attacker:GetEntityIndex()
	
	-- if data[entindex] == nil then data[entindex] = {} end

	-- local time = math.floor(GameRules:GetGameTime())
	-- data[entindex][time] = (data[entindex][time] or 0) + damage
end

function GetShuShanAttackingBossDPS()
	return ShuShanAttackingBossDPS_Data
end

function StatsShuShanAttackingBossDPS(unitname)
	-- if not ShuShanAttackingBossDPS_Filter[unitname] then return end

	-- local data = ShuShanAttackingBossDPS_Data[unitname]
	-- if not data then return end

	-- local t = {}
	-- for entindex,line in pairs(data) do
	-- 	local total = 0
	-- 	local count = 0
	-- 	local first = nil
	-- 	table.sort(line)
	-- 	for k,v in pairs(line) do
	-- 		if first == nil then
	-- 			first = k
	-- 			local max = math.floor(GameRules:GetGameTime())
	-- 			for i=first,max do
	-- 				if line[i] == nil then line[i]=0 end
	-- 			end
	-- 		end
	-- 		count = count + 1
	-- 		total = total + v
	-- 	end
	-- 	t[entindex] = total/count
	-- end

	-- return t
end

function ClearShuShanAttackingBossDPS(unitname)
	-- ShuShanAttackingBossDPS_Data[unitname] = nil
end

--[[
-----------------------------------------------------------------
召唤帝恨
]]
local ShuShanDiHen = nil
function SummonShuShanDiHen()
	if ShuShanLanguageIsSchinese and GameRules:GetCustomGameDifficulty() < 5 then return end

	local dihen_towers = Entities:FindAllByName("dihen_towers")
	for i,v in ipairs(dihen_towers) do
		if not v.__is_fire then
			return
		end
	end

	local ent = Entities:FindByName(nil, "dihen_spawner")
	local index = 1

	Timer(function ()

		local tower = dihen_towers[index]
		tower:AddNoDraw()

		if index >= 6 then
			local boss = CreateUnitByName("LV12_fb_19_boss_dihen", ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			if boss then
				boss:SetOrigin(ent:GetOrigin()+Vector(0,0,1500))
				boss.SpawnEnt = ent
				ShuShanDiHen = boss
				AICtrl:CreateAI(boss, "dihen", {SpawnEntity=ent})
				SpawnSystemCtrl:ChangeUnitData(boss)
				boss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
				boss:AddNewModifier(boss, nil, "modifier_shushan_boss", nil)
				boss:SetAngles(0, 270, 0)
				boss:SetHullRadius(500)
			end

			return nil
		end

		index = index + 1
		return 0.5
	end)
end

function ClearShuShanDiHenTowerFire()
	if ShuShanDiHen then
		if ShuShanDiHen:IsNull() or not ShuShanDiHen:IsAlive() then
			local dihen_towers = Entities:FindAllByName("dihen_towers")
			for i,v in ipairs(dihen_towers) do
				v.__is_fire = false
				v:RemoveNoDraw()
				ParticleManager:DestroyParticle(v.__fire_particle, false)
			end
			CustomNetTables:SetTableValue("Abilities", "custom_item_0401",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0402",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0403",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0404",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0405",  {can_not_cast=0})
			CustomNetTables:SetTableValue("Abilities", "custom_item_0151",  {can_not_cast=0})
		end
	end
end

--[[
-----------------------------------------------------------------
黑市商人 - 三换一功能
]]
HeiShiShangRenThreeToOneConfig = {
	["item_0240"] = {List={"item_0241","item_0239"},Count=2},
	["item_0118"] = {List={"item_0042"},Count=3},
	["item_0042"] = {List={"item_0118"},Count=3},
	["item_0120"] = {List={"item_0039"},Count=3},
	["item_0039"] = {List={"item_0120"},Count=3},
	["item_0120"] = {List={"item_0039"},Count=3},
	["item_0045"] = {List={"item_0038","item_0122"},Count=3},
	["item_0038"] = {List={"item_0045","item_0122"},Count=3},
	["item_0122"] = {List={"item_0045","item_0038"},Count=3},
	["item_0242"] = {List={"item_0243","item_0270"},Count=2},
	["item_0243"] = {List={"item_0242","item_0270"},Count=2},
	["item_0270"] = {List={"item_0242","item_0243"},Count=2},
	["item_0182"] = {List={"item_0185"},Count=1},
	["item_0185"] = {List={"item_0182"},Count=1},
	["item_0021"] = {List={"item_0017","item_0015"},Count=3},
	["item_0017"] = {List={"item_0021","item_0015"},Count=3},
	["item_0015"] = {List={"item_0017","item_0021"},Count=3},
	["item_0052"] = {List={"item_0051","item_0048"},Count=3},
	["item_0051"] = {List={"item_0052","item_0048"},Count=3},
	["item_0048"] = {List={"item_0051","item_0052"},Count=3},
	["item_0407"] = {List={"item_0411","item_0412","item_0408"},Count=3},
	["item_0408"] = {List={"item_0411","item_0412","item_0407"},Count=3},
	["item_0409"] = {List={"item_0410"},Count=1},
}
function ShuShanHeiShiShangRenThreeToOne(hero)
	local bag = hero:GetBag()
	if not bag then return nil end

	local list = nil

	for itemname,data in pairs(HeiShiShangRenThreeToOneConfig) do
		for i,name in ipairs(data.List) do
			bag:Look(function (bagSlot,itemIndex,item)
				if item and item:GetAbilityName() == name then
					if list == nil then list = {} end
					if list[itemname] == nil then
						list[itemname] = {}
					end
					table.insert(list[itemname],itemIndex)
				end
			end)
		end
	end

	return list
end

function ShuShanHeiShiShangRenThreeToOneDone(hero, list, itemname)
	local bag = hero:GetBag()
	if not bag then return end

	local conf = HeiShiShangRenThreeToOneConfig[itemname]

	local sameLog = {}
	local count = 0

	for i,itemIndex in ipairs(list) do
		if sameLog[itemIndex] == true then return end

		if not bag:HasItemIndex(itemIndex) then
			return
		end

		local item = EntIndexToHScript(itemIndex)
		local hasInConf = false
		for j,name in ipairs(conf.List) do
			if item:GetAbilityName() == name then
				hasInConf = true
				break
			end
		end

		if not hasInConf then return end

		sameLog[itemIndex] = true

		if item:IsStackable() then
			count = count + item:GetCurrentCharges()
		else
			count = count + 1
		end
	end

	if count == conf.Count then
		for i,itemIndex in ipairs(list) do
			local item = EntIndexToHScript(itemIndex)
			if item then
				bag:RemoveItem(item)
			end
		end

		hero:AddItemByName(itemname)
	end


end



--[[
-----------------------------------------------------------------
偷蛋妖怪刷新
]]
function TouDanYaoGuaiSpawnThink()
	local spawnEnt = Entities:FindByName(nil, "shushan_toudanyaoguai")
	local yaoguai
	Timer(DoUniqueString("TouDanYaoGuaiSpawnThink"), function()

		if (yaoguai ~= nil) and (yaoguai:IsNull() or not yaoguai:IsAlive()) then
			return nil
		end

		if GameRules:IsDaytime() then
			if yaoguai ~= nil and not yaoguai:IsNull() and yaoguai:IsAlive() then
				yaoguai:RemoveSelf()
				yaoguai = nil
			end
		else
			if yaoguai == nil or yaoguai:IsNull() then
				yaoguai = CreateUnitByName("LV5_fb_06_boss_toudanyaoguai", spawnEnt:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
				yaoguai.SpawnEnt = spawnEnt
				AICtrl:CreateAI(yaoguai, "dungeon_boss", {SpawnEntity=spawnEnt})
				SpawnSystemCtrl:ChangeUnitData(yaoguai)
				yaoguai:AddAbility("shushan_fb_boss_common"):SetLevel(1)
				yaoguai:AddNewModifier(yaoguai, nil, "modifier_shushan_boss", nil)
			end
		end

		return 1
	end)
end


--[[
-----------------------------------------------------------------
覆水之凤刷新
]]
function CreateFuShuiZhiFengSpawn()
	if GameRules:GetCustomGameDifficulty() < 5 then return end
	
	local spawnEnt = Entities:FindByName(nil, "shushan_fushuizhifeng")
	local yaoguai = CreateUnitByName("LV13_fb_20_boss_fushuizhifeng", spawnEnt:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	yaoguai.SpawnEnt = spawnEnt
	AICtrl:CreateAI(yaoguai, "fushuizhifeng", {SpawnEntity=spawnEnt})
	SpawnSystemCtrl:ChangeUnitData(yaoguai)
	yaoguai:AddAbility("shushan_fb_boss_common"):SetLevel(1)
	yaoguai:AddNewModifier(yaoguai, nil, "modifier_shushan_boss", nil)
end
