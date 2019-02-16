------------------------------------------------------------------------------------------------------------

---------- 游戏状态 - 设置队伍阶段 ----------
function GameEvents:GameStateCustomGameSetup()
	ControllersInit()
end

---------- 游戏状态 - 选择英雄阶段 ----------
function GameEvents:GameStateHeroSelection()

	-- 节奏与难度
	GameRules:SetCustomGameRate(CustomVoteSystem:Result("game_rate"))
	GameRules:SetCustomGameDifficulty(CustomVoteSystem:Result("difficulty"))
	print("[Game Rate]: "..GameRules:GetCustomGameRate())
	print("[Difficulty]: "..GameRules:GetCustomGameDifficulty())

	-- 初始化基地
	local fort = Entities:FindByName(nil, "dota_goodguys_fort")
	for i=0,fort:GetAbilityCount()-1 do
		local ability = fort:GetAbilityByIndex(i)
		if ability then fort:RemoveAbility(ability:GetAbilityName()) end
	end
	fort:AddAbility("avalon_fort_upgrade"):SetLevel(1)
	fort:AddNewModifier(fort, nil, "modifier_yunlian_defense", nil)
	fort:AddNewModifier(fort, nil, "modifier_shushan_fort", nil)
	local avalon_fort_stop_attacking = fort:AddAbility("avalon_fort_stop_attacking")
	avalon_fort_stop_attacking:SetLevel(1)
	avalon_fort_stop_attacking:StartCooldown(420)
	_G["ShushanFort"] = fort

	-- 稻草人
	-- local DaoCaoRen = Entities:FindByName(nil, "dao_cao_ren")
	-- if DaoCaoRen then
	-- 	DaoCaoRen:AddNewModifier(DaoCaoRen, nil, "modifier_daocaoren", nil)
	-- end

	-- 混魔冰焰真君的召唤塔
	local hunmobingyan_tower = Entities:FindAllByName("hunmobingyan_tower")
	for i,v in ipairs(hunmobingyan_tower) do
		v:AddNewModifier(v, nil, "modifier_invulnerable", nil)	
	end

	-- 玄冰宝藏
	local baozang = Entities:FindAllByName("shushan_baozang")
	for i,v in ipairs(baozang) do
		v:AddNewModifier(v, nil, "modifier_invulnerable", nil)	
	end

	-- 帝恨召唤塔
	local dihen = Entities:FindAllByName("dihen_towers")
	for i,v in ipairs(dihen) do
		v:AddNewModifier(v, nil, "modifier_invulnerable", nil)	
	end

	local ShushanHeroList = {
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_centaur",
	}

	EachPlayerID(function (id)
		GameStats:Set("Players",id,tostring(PlayerResource:GetSteamID(id)))
		
		-- 没有选择英雄的玩家给予默认英雄
		if ShushanPlayerSelectHero[id] == nil then
			local heroname = ShushanHeroList[RandomInt(1, #ShushanHeroList)]
			ShushanPlayerSelectHero[id] = heroname
			CreateHeroForPlayer(heroname, PlayerResource:GetPlayer(id)):RemoveSelf()
		end
	end)

	-- 是否开启战争迷雾
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(CustomVoteSystem:Result("open_fog_of_war") == false)

	-- 统计
	local stats = GameStats:Data()
	stats["PlayerCount"] = PlayerResource:GetPlayerCount()
	stats["GameRate"] = GameRules:GetCustomGameRate()
	stats["Difficulty"] = GameRules:GetCustomGameDifficulty()

	local difficulty = GameRules:GetCustomGameDifficulty()
	if difficulty == 1 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
	elseif difficulty == 2 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
	elseif difficulty == 3 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(15)
	elseif difficulty == 4 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(20)
	elseif difficulty == 5 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(20)
	elseif difficulty == 6 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(20)
	elseif difficulty == 7 then
		GameRules:GetGameModeEntity():SetFixedRespawnTime(20)
	end

	StartDestroyParticlesQueue()
end

----------------- 决策阶段 -----------------
function GameEvents:GameStateStrategyTime()
end

--------------- 队伍展示阶段 ---------------
function GameEvents:GameStateTeamShowcase()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GameStateTeamShowcase"), function ()
		EachHero(function (hero)
			if hero and not hero:IsNull()
				and hero.__HasCustomSelectHero ~= true then
				hero.__HasCustomSelectHero = true
				self:OnCustomSelectHero(hero)
			end
		end)
		return nil
	end, 10)
end

------------- 等待地图加载阶段 -------------
function GameEvents:GameStateWaitForMapToLoad()
end

------------ 游戏状态 - 预备阶段 ------------
function GameEvents:GameStatePreGame()
	GameStats:Timeline()
end

------------ 游戏状态 - 游戏开始 ------------
function GameEvents:GameStateInProgress()
	SpawnSystemCtrl:StartAll()
	TouDanYaoGuaiSpawnThink()
	CreateFuShuiZhiFengSpawn()
end

------------ 游戏状态 - 游戏结束 ------------
function GameEvents:GameStatePostGame()
end

------------------------------------------------------------------------------------------------------------

---当玩家选择英雄
StoreHasCreateVIP = {}
function GameEvents:OnCustomSelectHero(hero)
	-- 初始化
	BagCtrl(hero, BAG_NAME_COMMON)
	QuestsCtrl(hero)
	CurrenciesCtrl(hero)
	SuitSystem(hero)
	PlayerSetting(hero)
	DigTreasure(hero)
	NoviceGuide:start(hero)
	DigTreasureItem0591(hero)
	DigTreasureItem0592(hero)

	hero:RemoveNoDraw()
	hero:RemoveModifierByName("modifier_invulnerable")
	hero:RemoveModifierByName("modifier_custom_stun2")
	hero:SetAbilityPoints(0)

	-- 初始化技能等级
	local abilityCount = hero:GetAbilityCount()-1
	for i=0,abilityCount do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			if (i > 5 and i < 16) or i == 0 then
				ability:SetLevel(1)
			elseif i >= 16 then
				-- 删除多余技能
				hero:RemoveAbility(ability:GetAbilityName())
			end
		end
	end
	hero:FindAbilityByName("ability_shushan_teleport"):SetLevel(0)

	-- 创建信使
	local courier = CreateUnitByName("unit_courier", hero:GetOrigin(), true, nil, nil, hero:GetTeam())
	courier:SetOwner(hero)
	courier:SetControllableByPlayer(hero:GetPlayerID(), true)
	courier:AddNewModifier(courier, nil, "modifier_invulnerable", nil)
	hero.__shushan_courier = courier

	local courierModelName = table.remove(ShuShanCourierList,RandomInt(1, #ShuShanCourierList))
	courier:SetModel(courierModelName)
	courier:SetOriginalModel(courierModelName)

	-- 创建矿精
	local oreSpirit = CreateUnitByName("unit_ore_spirit", hero:GetOrigin(), true, nil, nil, hero:GetTeam())
	oreSpirit:SetOwner(hero)
	oreSpirit:SetControllableByPlayer(hero:GetPlayerID(), true)
	oreSpirit:AddNewModifier(oreSpirit, nil, "modifier_invulnerable", nil)
	hero.__shushan_ore_spirit = oreSpirit

	Wait(2, function ()
		CollectOreSystem:Start(oreSpirit)
	end)

	-- 创建UI
	CustomUICtrl:Create(hero:GetPlayerID())
	QuestsCtrl:UpdateUnitStates(hero)

	-- 刷新
	Timer(DoUniqueString("RefreshCustomAttributes"), hero, function ()
		CustomNetTables:SetTableValue("CustomAttributes", "StatisticalAttributes_"..tostring(hero:GetEntityIndex()),hero:StatisticalAttributes())
		return 0.3
	end)
	Timer(DoUniqueString("RefreshCustomAttributes"), hero, 1, function ()
		ShuShanCanUpgradeStateNotify(hero)
		return 5
	end)

	Wait(1, function ()
		oreSpirit:GetAbilityByIndex(0):CastAbility()

		-- VIP效果
		-- if hero:HasVIP() then
		-- 	hero:AddItemByName("item_0077")
		-- 	hero:AddItemByName("item_0061")
		-- 	hero:AddItemByName("item_0265")
		-- 	hero:GiveGold(3000)
		-- 	StoreHasCreateVIP[hero:GetEntityIndex()] = true
		-- end
	end)
end

------------------------------------------------------------------------------------------------------------

---第一次被创建
---function OnHeroFirstSpawn
-- @param {handle} hero
-- @param {int}    entindex
function GameEvents:OnUnitFirstSpawn( unit, entindex )
	if unit:IsHero() then
		print("Init "..unit:GetUnitName())
		if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GameRules:State_Get() >= DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
			local time = GameRules:GetGameTime() + 120
			Timer("GameEvents:OnUnitFirstSpawn", unit, 1, function ()
				if not unit:IsNull() and unit:IsIllusion() then
					return nil
				end
				if time <= GameRules:GetGameTime() then
					return nil
				end
				if not unit:IsNull() and unit:GetPlayerOwner() and unit:GetPlayerOwner():GetAssignedHero() == unit and unit.__HasCustomSelectHero ~= true then
					unit.__HasCustomSelectHero = true
					self:OnCustomSelectHero(unit)
					return nil
				end
				print("Try init "..unit:GetUnitName())
				return 1
			end)
		end
		-- unit:AddNoDraw()
		-- unit:AddNewModifier(hero, nil, "modifier_invulnerable", nil)
		-- unit:AddNewModifier(hero, nil, "modifier_custom_stun2", nil)
	end
end

------------------------------------------------------------------------------------------------------------

---单位创建， 英雄重生
---function OnNpcSpawned
-- @param {handle} unit
-- @param {int}    entindex
function GameEvents:OnNPCSpawned( unit, entindex )
	if unit:IsHero() then
		AttributesCtrl(unit)
		WingsSystem:Refresh(unit)
		FateSystem:OnRespawn(unit)
		unit:AddNewModifier( unit, nil, "modifier_fixed_armor_for_hero", nil )
	else
		local armor = unit:GetPhysicalArmorValue()
		local oldArmor = (0.06 * armor) / (1 + 0.06 * armor)
		local fixedArmor = (0.9 * oldArmor) / (0.052 - 0.048 * oldArmor)
		unit:SetPhysicalArmorBaseValue( fixedArmor )
	end
end

------------------------------------------------------------------------------------------------------------

---玩家英雄升级
---function OnPlayerLevelUp
-- @param player handle 玩家
-- @param hero handle 英雄
-- @param level number 等级
function GameEvents:OnPlayerLevelUp( player, hero, level )
	hero:GiveAssignAttributePoints(3)
	hero:SetAbilityPoints(0)

	local ability = hero:GetAbilityByIndex(1)
	if level >= 15 and ability and ability:GetLevel() == 0 then
		ability:SetLevel(1)
	end

	ability = hero:GetAbilityByIndex(2)
	if level >= 25 and ability and ability:GetLevel() == 0 then
		ability:SetLevel(1)
	end

	ability = hero:GetAbilityByIndex(3)
	if level >= 50 and ability and ability:GetLevel() == 0 then
		ability:SetLevel(1)
	end

	FateSystem:OnLevelUp(hero)
	ShuShanCanUpgradeStateNotify(hero)

	QuestsCtrl:TouchCustomType(hero, 'hero_levelup', function (subquest, data)
		data["Level"] = hero:GetLevel()
		if data["Level"] >= data["MaxLevel"] then
			return true
		end
	end)
end

------------------------------------------------------------------------------------------------------------

---单位被击杀
---function OnEntityKilled
-- @param attacker handle 伤害来源
-- @param victim handle 受害者
-- @param ability handle 技能
-- @param damagebits number 未知

function GameEvents:OnEntityKilled( attacker, victim, ability, damagebits )
	DropItemsCtrl(attacker, victim)
	FateSystem:OnKilledUnit(attacker, victim)

	if not attacker:IsRealHero() then
		local owner = attacker:GetOwner()
		if owner and owner.IsRealHero and owner:IsRealHero() then
			attacker = owner
		end
	end

	local victim_unitname = victim:GetUnitName()
	local isBoss = string.find(victim_unitname,"boss") ~= nil
	local isAttackingUnit = string.find(victim_unitname,"creature_") ~= nil

	if victim:IsRealHero() then HeroRespawnManager(victim, "EntityKilledEvent") end

	if attacker:IsRealHero() then
		
		attacker:Heal(attacker:GetMaxHealth()*0.05, attacker)
		attacker:GiveMana(attacker:GetMaxMana()*0.05)

		local modifier = attacker:FindModifierByName("modifier_quests_reward_kaiyi")
		if modifier then modifier:OnKill(attacker, victim) end

		if attacker:HasVIP() then
			attacker:GiveGold(victim:GetGoldBounty()*1.5)
		else
			attacker:GiveGold(victim:GetGoldBounty())
		end

		if victim:IsCreature() then
			if isAttackingUnit then
				attacker:GiveProtectFortPoints(1)
			end

			-- 给予道行
			local Level = tonumber(GetUnitNameStringLevel(victim_unitname))
			if Level ~= nil then
				local daoheng = 0
				if isBoss then
					daoheng = Level*5
				else
					daoheng = Level
				end

				if attacker:IsFate("xiulianzhe") then
					daoheng = daoheng * 2
				end

				if attacker:HasItemInInventory("item_0573") then
					daoheng = daoheng * 1.25
				end

				if attacker:HasVIP() then
					attacker:GiveDaoHeng(daoheng*1.5)
				else
					attacker:GiveDaoHeng(daoheng)
				end
			end
				
		end
	end

	if isBoss and isAttackingUnit then
		CustomNetTables:SetTableValue("Common", "ShuShanAttackingBoss", nil)
	end

	-- 播放单位死亡音效
	if victim:IsCreature() and victim:IsOpposingTeam(attacker:GetTeam()) then
		EmitSoundOn("UnitDeath."..victim:GetUnitName(),victim)
	end

	-- 显示DPS
	-- local stats = StatsShuShanAttackingBossDPS(victim:GetUnitName())
	-- if stats then
	-- 	EachPlayer(function (player)
	-- 		CustomGameEventManager:Send_ServerToPlayer(player, "shushan_attacking_boss_dps", stats)
	-- 	end)
	-- end
	-- ClearShuShanAttackingBossDPS(victim:GetUnitName())
	
	if victim:GetUnitName() == "LV7_fb_07_boss_hunmobingyanzhenjun" then
		ClearHunMoBingYanZhenJunTowerFire()
	elseif victim:GetUnitName() == "LV12_fb_19_boss_dihen" then
		ClearShuShanDiHenTowerFire()

		-- 实现武器觉醒
		EachHero(function ( hero )
			for i=0,5 do
				local item = hero:GetItemInSlot(i)
				if (item and not item:IsNull()) then
					local str = string.match(item:GetAbilityName(),"item_0(%d+)")
					local num = tonumber(str)
					if num >= 474 and num <= 478 then  
						hero:RemoveItem(item)
						num = num + 5
						hero:AddItemByName("item_0"..num)
					end
				else
					hero:ShowCustomMessage({
						type="message-box",role="npc_yunlian", list={{text="shushan_shengling_error_msg_yifu",args={}}},
						duration=10,
					})
				end
			end
				
		end)

	elseif victim:GetUnitName() == "LV13_fb_20_boss_fushuizhifeng" then
		HasKillShuShanFuShuiZhiFeng = true
		EachHero(function ( hero )
			if hero:IsAlive() then
				hero:AddNewModifier(hero, nil, "modifier_fushuizhifeng_kill_reward", nil)
			else
				Timer(1, function ()
					if hero:IsAlive() then
						hero:AddNewModifier(hero, nil, "modifier_fushuizhifeng_kill_reward", nil)
						return nil
					end

					return 1
				end)
			end
		end)
	end
end

------------------------------------------------------------------------------------------------------------

---玩家重连
---function OnPlayerReconnected
-- @param playerID number 玩家ID
-- @param player handle 玩家

function GameEvents:OnPlayerReconnected( playerID, player )
	CustomUICtrl:Create(playerID)
end

------------------------------------------------------------------------------------------------------------

---物品被捡起
---function OnItemPickedUp
-- @param player handle 玩家
-- @param hero handle 英雄
-- @param item handle 物品
-- @param itemName string 物品名称

function GameEvents:OnItemPickedUp( player, hero, item, itemName )
	
end

------------------------------------------------------------------------------------------------------------

---玩家聊天
---function OnPlayerSay
-- @param isTeamOnly bool 是否只有同队可见
-- @param playerID number 玩家ID
-- @param player handle 玩家
-- @param text string 文本
function GameEvents:OnPlayerChat( isTeamOnly, playerID, player, text )
	if text == "-kill" then
		local hero = player:GetAssignedHero()
		hero:ForceKill(true)
	end

	if GameRules:IsCheatMode() and not TurnCustomGameDebug then
		if text == "-nb" then
			local hero = player:GetAssignedHero()
			hero:AddItemByName("item_0510")
			hero:AddItemByName("item_0511")
			hero:AddItemByName("item_0512")
			hero:AddItemByName("item_0513")
			hero:AddItemByName("item_0514")
			hero:AddItemByName("item_0515")
			hero:AddItemByName("item_0516")
			hero:AddItemByName("item_0517")
			hero:AddItemByName("item_0518")

			hero:AddItemByName("item_0479")
			hero:AddItemByName("item_0480")
			hero:AddItemByName("item_0481")
			hero:AddItemByName("item_0482")
			hero:AddItemByName("item_0483")
			hero:AddItemByName("item_0484")
			hero:AddItemByName("item_0546")
			hero:AddItemByName("item_0551")

			hero:AddItemByName("item_0088")
			hero:AddItemByName("item_0089")
			hero:AddItemByName("item_0090")
			hero:AddItemByName("item_0091")

			hero:SetCustomAttribute('merits','nb', 500)
			hero:SetCustomAttribute('state','nb', 10)
			hero:GiveHuntingPoints(500)
			hero:GiveGold(500000)
		end

		if text == "-wd" then
			ShushanFort:AddNewModifier(ShushanFort,nil, "modifier_invulnerable_fake", nil)
		end
		
	end
end

------------------------------------------------------------------------------------------------------------

function GameEvents:OnPlayerTeamChange(team, oldteam, isDisconnect)
end