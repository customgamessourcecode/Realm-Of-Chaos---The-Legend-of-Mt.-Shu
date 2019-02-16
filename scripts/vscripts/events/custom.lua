
--[[
Exmple:

CustomEvents('event_name', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end
end)

]]

-------------------------------------------------------------------------

CustomEvents('touch_update_event', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local event = data.event or ''

	if event == "quests_event_update" then
		QuestsCtrl:UpdateQuests(hero)
	end
end)


-------------------------------------------------------------------------
CustomEvents('update_magic_armor', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	hero:SetContextNum( "FixedMagicArmor", data.armor * 100, 0 )
end)

-------------------------------------------------------------------------

CustomEvents('avalon_get_item_tooltip_data', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	-- 获取物品属性
	local item = EntIndexToHScript(data.item)
	if not item then return end

	local custom_attributes
	if item:HasCustomAttributes() then
		custom_attributes = item:GetAllCustomAttribute()
	end

	local compare = true
	for i=0,5 do
		local _item = hero:GetItemInSlot(i)
		if _item == item then
			compare = false
			break
		end
	end

	local compareItem1
	local compareItem1_Config
	local compareItem1_Specials
	local compareItem1_CustomAttributes
	local compareItem1_CustomData
	local compareItem2
	local compareItem2_Config
	local compareItem2_Specials
	local compareItem2_CustomAttributes
	local compareItem2_CustomData
	
	if compare then
		-- 获取比较的装备
		local inventorySlot = EquipCtrl:GetSlot(item)
		if inventorySlot >= 0 then
			local inventoryItem = hero:GetItemInSlot(inventorySlot)
			if inventoryItem and inventoryItem ~= item then

				compareItem1 = inventoryItem:GetEntityIndex()
				compareItem1_Config = ItemConfig[inventoryItem:GetAbilityName()]
				compareItem1_Specials = inventoryItem:GetAbilityKeyValues()["AbilitySpecial"]
				compareItem1_CustomData = inventoryItem:GetCustomData()
				if inventoryItem:HasCustomAttributes() then
					compareItem1_CustomAttributes = inventoryItem:GetAllCustomAttribute()
				end

			end

			-- 如果是饰品湖区另外一个格子的饰品
			if inventorySlot == ITEM_KIND_GROUP_TRINKET_SLOT then
				local inventoryItem2 = hero:GetItemInSlot(inventorySlot+1)
				if inventoryItem2 and inventoryItem2 ~= item then
					compareItem2 = inventoryItem2:GetEntityIndex()
					compareItem2_Config = ItemConfig[inventoryItem2:GetAbilityName()]
					compareItem2_Specials = inventoryItem2:GetAbilityKeyValues()["AbilitySpecial"]
					compareItem2_CustomData = inventoryItem2:GetCustomData()
					if inventoryItem2:HasCustomAttributes() then
						compareItem2_CustomAttributes = inventoryItem2:GetAllCustomAttribute()
					end
				end
			end
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_get_item_tooltip_data_response", {
		item=data.item, specials=item:GetAbilityKeyValues()["AbilitySpecial"], custom_attributes=custom_attributes, config=ItemConfig[item:GetAbilityName()],
		custom_data = item:GetCustomData(),

		compareItem1=compareItem1, compareItem1_Specials=compareItem1_Specials,compareItem1_CustomAttributes=compareItem1_CustomAttributes, 
		compareItem1_Config=compareItem1_Config, compareItem1_CustomData=compareItem1_CustomData,

		compareItem2=compareItem2, compareItem2_Specials=compareItem2_Specials,compareItem2_CustomAttributes=compareItem2_CustomAttributes,
		compareItem2_Config=compareItem2_Config, compareItem2_CustomData=compareItem2_CustomData,
		})
end)

-------------------------------------------------------------------------

CustomEvents('shops_event_buy_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) and (npc:GetOrigin() - hero.__shushan_courier:GetOrigin()):Length2D() > 250 then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	local npcname = npc:GetUnitName()
	local itemname = data.itemname
	local shopItems = NPCShops[npcname]
	if not shopItems then return end

	local itemdata = shopItems[itemname]
	if not itemdata then return end

	local cost = itemdata.cost or GetItemCost(itemname)
	if hero:SpendGold(cost) then
		if itemdata.action == nil then
			local bag = hero:GetBag()
			local item = bag:CreateItem(itemname)
			if item then
				AttributesCtrl(item)
				item.__get_source = "shop"
				EmitSoundOnClient("General.Buy",PlayerResource:GetPlayer(hero:GetPlayerID()))

				QuestsCtrl:TouchCustomType(hero, 'buy_items', function (subquest, data)
					if data["Target"] ~= itemname then return false end
					if data["NPC"] ~= npcname then return false end

					data["Count"] = data["Count"] + 1
					if data["Count"] >= data["MaxCount"] then
						return true
					end
				end)
			else
				hero:ModifyCurrency(CURRENCY_TYPE_GOLD,cost)
				hero:ShowCustomMessage({type="bottom",msg="#avalon_msg_shops_can_not_buy_item",class="error"})
			end

		elseif itemdata.action == "teleport" then
			local ent = Entities:FindByName(nil, itemname)
			if ent then
				FindClearSpaceForUnit(hero, ent:GetOrigin(), true)
				PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
				Wait(0.1,function ()
					PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
				end)
			end
		end
	end
end)

-------------------------------------------------------------------------

CustomEvents('avalon_get_item_tooltip_data_for_kv', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local itemname = data.itemname or ""
	local kv = ItemsKV[itemname]
	if not kv then return end

	local compareItem1
	local compareItem1_Config
	local compareItem1_Specials
	local compareItem1_CustomAttributes
	local compareItem1_CustomData
	local compareItem2
	local compareItem2_Config
	local compareItem2_Specials
	local compareItem2_CustomAttributes
	local compareItem2_CustomData
	
	-- 获取比较的装备
	local inventorySlot = EquipCtrl:GetSlotForItemName(itemname)
	if inventorySlot >= 0 then
		local inventoryItem = hero:GetItemInSlot(inventorySlot)
		if inventoryItem then

			compareItem1 = inventoryItem:GetEntityIndex()
			compareItem1_Config = ItemConfig[inventoryItem:GetAbilityName()]
			compareItem1_Specials = inventoryItem:GetAbilityKeyValues()["AbilitySpecial"]
			compareItem1_CustomData = inventoryItem:GetCustomData()
			if inventoryItem:HasCustomAttributes() then
				compareItem1_CustomAttributes = inventoryItem:GetAllCustomAttribute()
			end

		end

		-- 如果是饰品湖区另外一个格子的饰品
		if inventorySlot == ITEM_KIND_GROUP_TRINKET_SLOT then
			local inventoryItem2 = hero:GetItemInSlot(inventorySlot+1)
			if inventoryItem2 then
				compareItem2 = inventoryItem2:GetEntityIndex()
				compareItem2_Config = ItemConfig[inventoryItem2:GetAbilityName()]
				compareItem2_Specials = inventoryItem2:GetAbilityKeyValues()["AbilitySpecial"]
				compareItem2_CustomData = inventoryItem2:GetCustomData()
				if inventoryItem2:HasCustomAttributes() then
					compareItem2_CustomAttributes = inventoryItem2:GetAllCustomAttribute()
				end
			end
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_get_item_tooltip_data_for_kv_response", {
		itemname = data.itemname, kv=kv, config=ItemConfig[itemname],

		compareItem1=compareItem1, compareItem1_Specials=compareItem1_Specials,compareItem1_CustomAttributes=compareItem1_CustomAttributes, 
		compareItem1_Config=compareItem1_Config, compareItem1_CustomData=compareItem1_CustomData,

		compareItem2=compareItem2, compareItem2_Specials=compareItem2_Specials,compareItem2_CustomAttributes=compareItem2_CustomAttributes,
		compareItem2_Config=compareItem2_Config, compareItem2_CustomData=compareItem2_CustomData,
	})
end)

-------------------------------------------------------------------------

CustomEvents('avalon_fort_upgrade', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	if hero:GetGold() >= 2000 then
		local ability = ShushanFort:FindAbilityByName("avalon_fort_upgrade")
		if ability:IsCooldownReady() then

			local wave = SpawnSystemCtrl:GetAttackingSpawner():GetWave()
			local stackCount = ShushanFort:GetModifierStackCount("modifier_avalon_fort_upgrade",ShushanFort)

			if stackCount >= wave then
				return Avalon:ThrowAll("error_msg_can_not_upgrade_fort_because_level")
			end

			if stackCount >= 20 then
				return Avalon:ThrowAll("error_msg_can_not_upgrade_fort_because_maxlevel")
			else
				hero:SpendGold(2000)

				if hero:HasVIP() then
					hero:GiveProtectFortPoints(20)
				else
					hero:GiveProtectFortPoints(10)
				end
				
				ability:CastAbility()
			end
		else
			Avalon:Throw(hero,"dota_hud_error_ability_in_cooldown")
		end
	else
		hero:ShowCustomMessage({type="bottom",msg="#avalon_msg_not_enough_gold",class="error"})
	end
	
end)

CustomEvents('avalon_stop_attacking', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local ability = ShushanFort:FindAbilityByName("avalon_fort_stop_attacking")
	if not ability:IsCooldownReady() then
		hero:ShowCustomMessage({type="bottom",msg="#dota_hud_error_ability_in_cooldown",class="error"})
		return
	end

	if hero:GetGold() >= 10000 then
		hero:SpendGold(10000)
		ability.__last_click_hero = hero
		ability:CastAbility()
	else
		hero:ShowCustomMessage({type="bottom",msg="#avalon_msg_not_enough_gold",class="error"})
	end
	
end)

-------------------------------------------------------------------------

CustomEvents('avalon_points_shop_buy_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) and (npc:GetOrigin() - hero.__shushan_courier:GetOrigin()):Length2D() > 250 then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	local type_t = data.type or ""
	local t = PointsShops[type_t]
	if not t then return end

	local itemname = data.itemname or ""
	local itemdata = t[itemname]
	if not itemdata then return end

	local cost = itemdata.cost
	if not cost then return end

	local hasSpend = false
	if type_t == "ProtectFortPoints" then
		hasSpend = hero:SpendProtectFortPoints(cost)
	elseif type_t == "HuntingPoints" then
		hasSpend = hero:SpendHuntingPoints(cost)
	end

	if hasSpend then
		local bag = hero:GetBag()
		local item = bag:CreateItem(itemname)
		if item then
			AttributesCtrl(item)
		else
			hero:GiveProtectFortPoints(cost)
			hero:ShowCustomMessage({type="bottom",msg="#avalon_msg_shops_can_not_buy_item",class="error"})
		end
	end
end)

-------------------------------------------------------------------------

-- 玩家设置
CustomEvents('avalon_player_setting', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	PlayerSetting:set(hero:GetSteamID(), data.key or "", data.value or "")
end)

-------------------------------------------------------------------------

-- 境界提升
CustomEvents('shushan_state_upgrade', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local state = hero:GetCustomAttribute("state",0)
	if state >= 12 then
		return Avalon:Throw(hero,"shushan_state_you_has_reached_the_highest_state")
	end

	local require_table = StateUpgradeRequireTable[state]

	if ShuShanCanUpgradeState(hero) then
		-- 提升成功
		hero:ModifyCustomAttribute("state", "state_upgrade", 1);
		hero:ShowCustomMessage({type="left",msg="#shushan_state_upgrade_success", args={text="shushan_attribute_state_"..state+1} ,class="", log=true})
		QuestsCtrl:OnStateUpgrade(hero)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(p, 0, hero:GetOrigin())
		ParticleManager:SetParticleControl(p, 1, Vector(50,50,50))
		ParticleManager:SetParticleControl(p, 2, hero:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)
	else
		-- 提升失败
		return Avalon:Throw(hero,"shushan_state_can_not_upgrade")
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_can_upgrade_state", {can=ShuShanCanUpgradeState(hero)})
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_state_upgrade_response", {state=hero:GetCustomAttribute("state",0)})
end)

-------------------------------------------------------------------------

-- 分配属性点
CustomEvents('assign_attribute_points', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local name = data.name or ""
	if name ~= "str" and name ~= "agi" and name ~= "int" then
		return
	end

	if hero:SpendAssignAttributePoints(1) then
		hero:ModifyCustomAttribute(name,"assign_attribute_points",1)
	end
end)

-- 分配属性点
CustomEvents('assign_attribute_points_random', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local points = hero:GetAssignAttributePoints()
	if points > 0 and hero:SpendAssignAttributePoints(points) then
		local a = 1
		for i=1,points do
			if a == 1 then
				hero:ModifyCustomAttribute("str","assign_attribute_points",1)
			elseif a == 2 then
				hero:ModifyCustomAttribute("agi","assign_attribute_points",1)
			elseif a == 3 then
				hero:ModifyCustomAttribute("int","assign_attribute_points",1)
			end
			a = (a%3) + 1
		end
	end
end)

-------------------------------------------------------------------------

-- 选择翅膀
CustomEvents('shushan_select_wing', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	if not WingsSystem:HasWing(hero) then
		WingsSystem:Binding(hero,data.wing)
	end
end)

-- 升级翅膀
CustomEvents('shushan_upgrade_wing', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	WingsSystem:Upgrade(hero)
end)

-------------------------------------------------------------------------

-- 学习技能
CustomEvents('shushan_learn_ability', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end
	
	LearnExtraAbilities:LearnAbility(hero, npc, data.abilityname or "")
end)

CustomEvents('shushan_upgrade_learn_ability', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end
	
	LearnExtraAbilities:UpgradeAbility(hero, npc, data.abilityname or "")
end)

-------------------------------------------------------------------------

-- 炼化物品
CustomEvents('shushan_fuse_items', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	FuseItemsSystem:fusing(hero, data.itemname or "")
end)

-------------------------------------------------------------------------

-- 炼化物品 - 放置材料
CustomEvents('shushan_fuse_items_drop_material', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	FuseItemsSystem:Binding(hero, data.slot or -1, data.itemname or "")
end)

-- 炼化物品 - 清空材料
CustomEvents('shushan_fuse_items_clear', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	FuseItemsSystem:Clear(hero)
end)

-------------------------------------------------------------------------

-- 算命
CustomEvents('shushan_fortune_teller', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local npc = EntIndexToHScript(data.unit or -1)
	if npc == nil then return end

	if not QuestsCtrl:HasTouchingHero(npc, hero) then
		return Avalon:Throw(hero,"error_msg_not_near_npc")
	end

	-- hero.__shushan_fate_name = nil
	FateSystem:Random(hero)
end)

CustomEvents('shushan_fate_system_done', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	FateSystem:Done(hero)
end)

CustomEvents('shushan_fate_system_again', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	FateSystem:Again(hero)
end)

-- CustomEvents('shushan_fate_force', function(e, data)
-- 	local player = PlayerResource:GetPlayer(data.PlayerID)
-- 	if player ==nil then return end

-- 	local hero = player:GetAssignedHero()
-- 	if hero == nil then return end

-- 	hero.__shushan_pre_fate_name = data.name
-- 	FateSystem:Done(hero)
-- end)

-------------------------------------------------------------------------

-- 禁用音乐
CustomEvents('shushan_disable_music', function(e, data)
	local ents = Entities:FindAllByClassname("env_soundscape")
	for i,v in ipairs(ents) do
		v:RemoveSelf()
	end
end)

-------------------------------------------------------------------------

CustomEvents('shushan_item_to_be_collect_drap', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	ItemToBeCollected:OnEnter(hero, data.id or -1)
end)

-------------------------------------------------------------------------

CustomEvents('shushan_gambling', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local conf = GamblingConfig[data.itemname or ""]
	if conf == nil then
		conf = GamblingConfigForFate[data.itemname or ""]
		if conf == nil then
			return
		end
	end

	if hero:SpendGold(conf["gold"]) then
		local chance = conf["chance"]
		if hero:IsFate("dushen") and conf.isFate ~= true then
			chance = 111
		end
		if RandomFloat(0, 100) <= chance then
			hero:AddItemByName(data.itemname)
		else
			Avalon:Throw(hero,"shushan_gambling_fail")
		end
	end
end)

-------------------------------------------------------------------------

CustomEvents('shushan_heishishangren_321', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local itemname = data.itemname or ""
	if itemname == "" then return end

	local list = json.decode(data.list or "")
	if list == nil then return end

	ShuShanHeiShiShangRenThreeToOneDone(hero, list, itemname)

	data.unit = QuestsCtrl:GetAllNPC()["npc_task_heishishangren"]:GetEntityIndex()
	CustomEvents['avalon_event_select_npc'](e, data)
end)

-------------------------------------------------------------------------

CustomEvents('shushan_quick_game_over', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	ModalDialog(hero, {
		type = "CommonForLua",
		title = "dialog_title_warning",
		text = "shushan_do_you_want_to_quick_game_over",
		style = "warning",
		options = {
			{
				key = "YES",
				func = function ()
					CustomVoteSystem:Select(data.PlayerID, "rush_boss_mode")

					if CustomVoteSystem:Result("rush_boss_mode") == true then
						SpawnSystemCtrl:SetQuickGameOver()
						hero:ShowCustomMessage({
							type="message-box",
							role="BOSS",
							list={
								{
									text="shushan_quick_game_over_vote_format_enable",
									args={}
								}
							},
							duration=16,
						})
					else
						hero:ShowCustomMessage({
							type="message-box",
							role="BOSS", 
							list={
								{
									text="shushan_quick_game_over_vote_format_disable",
									args={Count=CustomVoteSystem:GetVoteCount("rush_boss_mode"), MaxCount=PlayerResource:GetPlayerCount()}
								}
							},
							duration=16,
						})
					end
					
				end,
			},
			{
				key = "NO",
			},
		},
	})
end)

-------------------------------------------------------------------------

CustomEvents('shushan_attacking_start', function(e, data)
	SpawnSystemCtrl:StartAttacking()
end)

CustomEvents('shushan_attacking_stop', function(e, data)
	SpawnSystemCtrl:StopAttacking()
end)

-------------------------------------------------------------------------

ShuShanLanguageIsSchinese = true
CustomEvents('shushan_set_language', function(e, data)

	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	if not GameRules:PlayerHasCustomGameHostPrivileges(player) then return end

	ShuShanLanguageIsSchinese = (data.lang == "schinese")
end)

-------------------------------------------------------------------------

CustomEvents('shushan_dungeon_manager', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end
	
	SpawnSystemCtrl:StopDungeon(data.name or "", data.checked or 0)
end)

-------------------------------------------------------------------------

CustomEvents('simulate_multiplayer_mode', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	_G["ShuShanSimulateMultiplayerMode"] = data.count or 1
end)


CustomEvents('shushan_sort_publish_stash', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end
	PublicStash:sort()
end)

-------------------------------------------------------------------------

CustomEvents('shushan_suicide', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end
	
	if hero:IsAlive() then
		hero:ForceKill(true)
	end
end)