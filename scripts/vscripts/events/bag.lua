
CustomEvents('avalon_bag_swap_item', function(e, data)
	if not data.from and not data.to then return end

	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag1 = BagCtrl(hero, data.from.bagName)
	local bag2 = BagCtrl(hero, data.to.bagName)
	local slot1 = data.from.slot
	local slot2 = data.to.slot
	if bag1 == nil or bag2 == nil then return end

	if bag1 == bag2 then
		bag1:SwapItem(slot1,slot2)
	else
		-- 符印背包的物品需要进行验证
		if data.to.bagName == BAG_NAME_SIGIL then
			local config = ItemConfig[bag1:GetItemName(slot1)]
			if config and config.kind ~= ITEM_KIND_SIGIL then
				return Avalon:Throw(hero,"shushan_sigil_error_msg_kind")
			end
		end

		bag1:SwapItemForOtherBag(slot1,bag2,slot2)
	end
end)

CustomEvents('avalon_bag_swap_item_from_inventory', function(e, data)
	if not data.from then return end

	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = BagCtrl(hero, data.from.bagName)
	local slot = data.from.slot

	if bag then
		bag:SwapItemFromInventory(slot, data.inventorySlot)
	end
end)

CustomEvents('avalon_bag_equip_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = BagCtrl(hero, data.bagName)
	local slot = data.slot

	if bag then
		local item = bag:GetItem(slot)
		if item then
			local inventorySlot = EquipCtrl:GetSlotForHero(hero,item)
			if inventorySlot >= 0 then
				bag:SwapItemFromInventory(slot, inventorySlot)
			else
				-- 如果不是可装备的物品，则尝试使用
				CustomItemSpellSystem:QuickCastAbility(hero, item)
			end
		end
	end
end)

CustomEvents('avalon_bag_unload_equipment', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = BagCtrl(hero, data.bagName)
	local inventorySlot = data.inventorySlot

	if bag then
		local item = hero:GetItemInSlot(inventorySlot)
		if item then
			local slot = bag:GetNoUseSlot()
			if slot > 0 then
				bag:SwapItemFromInventory(slot, inventorySlot)
			end
		end
	end
end)

CustomEvents('avalon_bag_context_menu', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local item = EntIndexToHScript(data.item or -1)
	if not item then return end

	local config = ItemConfig[item:GetAbilityName()]
	local res = {}

	if config then
		if config["kind"] == ITEM_KIND_CONSUMABLE then
			res.is_consumable = true
		elseif ItemKindGroup[config["kind"]] >= ITEM_KIND_GROUP_WEAPON then
			res.is_equipment = true
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_bag_context_menu_response", res)
end)

CustomEvents('avalon_bag_discard', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = hero:GetBag()
	bag:Discard(data.slot or -1)
end)

CustomEvents('avalon_bag_sell', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local item = EntIndexToHScript(data.item or -1)
	if not item then return end
	
	local bag = hero:GetBag()
	bag:SellItem(item)
end)

CustomEvents('avalon_bag_split_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = hero:GetBag()
	bag:Split(data.slot or -1, data.num or 1)
end)

CustomEvents('avalon_bag_merge_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	local bag = hero:GetBag()
	bag:Merge(data.slot1 or -1, data.slot2 or -1)
end)

CustomEvents('avalon_bag_sort_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero ==nil then return end

	if GameRules:GetGameTime() < (hero.__avalon_bag_sort_item_time or 0) then
		return
	end

	hero.__avalon_bag_sort_item_time = GameRules:GetGameTime() + 1

	hero:GetBag():Sort(
		function ( itemIndex1, itemIndex2 )
			if itemIndex1 == itemIndex2 then return false end

			local item1 = EntIndexToHScript(itemIndex1)
			local item2 = EntIndexToHScript(itemIndex2)
			if item1 == nil then return true end
			if item2 == nil then return false end

			local config1 = ItemConfig[item1:GetAbilityName()]
			local config2 = ItemConfig[item2:GetAbilityName()]
			if config1 == nil then return false end
			if config2 == nil then return true end

			local group1 = ItemKindGroup[config1.kind]
			local group2 = ItemKindGroup[config2.kind]

			if group1 == group2 then
				if config1.quality == config2.quality then
					return false
				end
				return config1.quality > config2.quality
			else
				return group1>group2
			end

			return false
		end)
end)