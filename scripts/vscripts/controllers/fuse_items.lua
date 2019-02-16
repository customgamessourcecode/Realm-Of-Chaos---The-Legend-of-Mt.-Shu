
if FuseItemsSystem == nil then
	FuseItemsSystem = RegisterController('fuse_items_system')
	FuseItemsSystem.__player_binding_material = {}
	setmetatable(FuseItemsSystem,FuseItemsSystem)
end

local public = FuseItemsSystem

function public:fusing(hero, itemname)
	local data = FuseItemsConfig[itemname]
	if not data then return false end

	local bag = hero:GetBag()
	if not bag then return false end

	local RequireItems = data["RequireItems"]
	local conform = {}
	local composeItem = {}

	for i,t in pairs(RequireItems) do
		local items = {}
		bag:Look(function(bagSlot,itemIndex,item)
			if item:GetAbilityName() == t.itemname then

				if item:IsStackable() then
					local list = items['list']
					if list == nil then
						list = {}
						items['list'] = list
						items['count'] = 0
						items['afterRemove'] = t.afterRemove == true
					end

					if conform[t.itemname] == nil then
						conform[t.itemname] = bag:GetNumItemInBag(t.itemname)
					end

					local num = conform[t.itemname]
					if num <= 0 then return true end

					local charges = item:GetCurrentCharges()
					local remaining_require = t.count - items.count

					if charges >= remaining_require then
						items.count = items.count + remaining_require
						conform[t.itemname] = num - remaining_require
					else
						items.count = items.count + charges
						conform[t.itemname] = num - charges
					end
					table.insert(list,bagSlot)

					if items.count >= t.count then
						return true
					end

				elseif conform[bagSlot] == nil then
					conform[bagSlot] = true
					items['IsStackable'] = false
					items['afterRemove'] = t.afterRemove == true

					local list = items['list']
					if list == nil then
						list = {}
						items['list'] = list
						items['count'] = 0
					end

					table.insert(list,bagSlot)
					items.count = items.count + 1

					if items.count >= t.count then
						return true
					end
				end
			end
		end)
		composeItem[i] = items
	end

	-- 验证物品是否满足
	for i,t in pairs(RequireItems) do
		local items = composeItem[i]
		if (items.count or 0) < t.count then
			return Avalon:Throw(hero,"avalon_msg_materials_not_enough",false)
		end
	end

	-- 消耗元会
	local yuanhui = data.YuanHui
	if hero:IsFate("lianhuazhe") then
		yuanhui = math.floor(yuanhui/2)
	end
	if not hero:SpendYuanHui(yuanhui) then
		return
	end

	-- 删除物品
	for k,items in pairs(composeItem) do
		if not items.afterRemove then
			if items.IsStackable == false then
				for _,bagSlot in pairs(items.list) do
					bag:RemoveItemInSlot(bagSlot)
				end
				
			else
				for _,bagSlot in pairs(items.list) do
					bag:CostItemInSlot(bagSlot,items.count)
				end
			end
		end
	end

	-- 成功概率
	local chance = data.Chance + self:GetAddChance(hero)

	if hero:IsFate("lianhuazhe") then
		chance = 111
	end

	self:RemoveBindingItem(hero)
	if RandomFloat(0, 100) <= chance then
		-- 删除物品
		for k,items in pairs(composeItem) do
			if items.afterRemove then
				if items.IsStackable == false then
					for _,bagSlot in pairs(items.list) do
						bag:RemoveItemInSlot(bagSlot)
					end
					
				else
					for _,bagSlot in pairs(items.list) do
						bag:CostItemInSlot(bagSlot,items.count)
					end
				end
			end
		end

		bag:CreateItem(itemname)
		GameStats:Increment("ItemsSpawnCount", itemname)
		hero:ShowCustomMessage({type="left",msg="#fuse_items_succeeded", class="", log=true})
		
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_new_item_tips", {itemname=itemname})
		return
	end

	-- 失败
	self:Failed(hero, itemname, chance)
	hero:ShowCustomMessage({type="left",msg="#fuse_items_failed", class="", log=true})
end

function public:Failed(hero, itemname, chance)
	local data = FuseItemsConfig[itemname]
	if not data then return false end

	local bag = hero:GetBag()
	if not bag then return false end

	local config = ItemConfig[itemname]
	local item = nil

	if config.quality == ITEM_QUALITY_B then
		item = CreateItem("item_0161", nil, nil)
		GameStats:Increment("ItemsSpawnCount", "item_0161")
	elseif config.quality == ITEM_QUALITY_A then
		item = CreateItem("item_0162", nil, nil)
		GameStats:Increment("ItemsSpawnCount", "item_0162")
	elseif config.quality == ITEM_QUALITY_S then
		item = CreateItem("item_0163", nil, nil)
		GameStats:Increment("ItemsSpawnCount", "item_0163")
	elseif config.quality == ITEM_QUALITY_Z then
		item = CreateItem("item_0164", nil, nil)
		GameStats:Increment("ItemsSpawnCount", "item_0164")
	end

	if item == nil then return end

	item:Attribute_SetFloatValue("fuse_items_system_chance",chance/2)

	if not bag:AddItem(item) then
		CreateItemOnPositionSync(hero:GetOrigin() + RandomVector(150), item)
	end
end

function public:Binding(hero, slot, itemname)
	local bag = hero:GetBag()
	if not bag then return false end

	local item = bag:GetItem(slot)
	if item == nil then return end

	local chance = item:Attribute_GetFloatValue("fuse_items_system_chance",-1.0)
	if chance <= 0 then
		return Avalon:Throw(hero,"fuse_items_this_is_not_material")
	end

	local config_a = ItemConfig[itemname]
	local config_b = ItemConfig[item:GetAbilityName()]
	if config_a.quality ~= config_b.quality then
		return Avalon:Throw(hero,"fuse_items_can_not_use_material")
	end

	local data = self.__player_binding_material[hero:GetEntityIndex()]
	if not data then
		data = {}
		self.__player_binding_material[hero:GetEntityIndex()] = data
	end

	data.binding_item_index = item:GetEntityIndex()
	data.add_chance = chance
	CustomNetTables:SetTableValue("Common", "fuse_items_system_player_binding_material", self.__player_binding_material)
end

function public:GetAddChance(hero)
	local bag = hero:GetBag()
	if not bag then return 0 end

	local data = self.__player_binding_material[hero:GetEntityIndex()]
	if not data then return 0 end

	local item = EntIndexToHScript(data.binding_item_index)
	if item == nil then return 0 end
	if bag:HasItem(item) then
		return item:Attribute_GetFloatValue("fuse_items_system_chance",0.0)
	end

	return 0
end

function public:RemoveBindingItem(hero)
	local bag = hero:GetBag()
	if not bag then return end

	local data = self.__player_binding_material[hero:GetEntityIndex()]
	if not data then return end

	local item = EntIndexToHScript(data.binding_item_index)
	if item == nil then return end

	bag:RemoveItem(item)
	self:Clear(hero)
end

function public:Clear( hero )
	local data = self.__player_binding_material[hero:GetEntityIndex()]
	if not data then return end

	data.binding_item_index = -1
	data.add_chance = 0

	CustomNetTables:SetTableValue("Common", "fuse_items_system_player_binding_material", self.__player_binding_material)
end