
--@class CBag

--[[
Requirement:

NetTable:
["Bag"] = 
{
	["Entity Index" + "bagName"] = {[1]=-1,[2]=-1,...}
}

Events:
* bag_changed
  @owner handle
  @bag   CBag

Conform:
* bag_sell_item  --出售物品
  @item handle
  @return boolean

* bag_swap_item_from_inventory  --与物品栏交换位置，返回物品栏槽位
  @bagItem        handle
  @inventorySlot  int
  @return int

Error Msg:
error_msg_bag_can_not_add_item
error_msg_bag_can_not_create_item
error_msg_bag_can_not_cost_item
error_msg_bag_can_not_sell_item
error_msg_bag_can_not_swap_item
error_msg_bag_can_not_split_item_is_not_stackable
error_msg_bag_can_not_split_item_number_invalid
error_msg_bag_can_not_merge_item_itemname_is_not_equal
]]

if CBag == nil then
	CBag = class({})
end

if ItemsKV == nil then
	ItemsKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
end

local public = CBag
local tinsert = table.insert

function public:constructor(bagName, owner, slot_count, min_index, max_index)
	self.__owner = owner
	self.__bag_name = bagName
	self.__slot_count = slot_count
	self.__valid_slot_min_index = min_index or 1
	self.__valid_slot_max_index = max_index or slot_count
	self.__write_lock = false

	local itemlist = {}
	for i=1,slot_count do
		itemlist[i] = -1
	end

	self.__itemlist = itemlist
	self.__nettable_name = tostring(owner:GetEntityIndex())..tostring(bagName)
end

function public:GetOwner()
	return self.__owner
end

function public:GetBagName()
	return self.__bag_name
end

function public:GetMin()
	return self.__valid_slot_min_index
end

function public:GetMax()
	return self.__valid_slot_max_index
end

function public:SetMin(min)
	if min > self.__slot_count or min <= 0 or min >= self:GetMax() then
		return
	end
	self.__valid_slot_min_index = min
end

function public:SetMax(max)
	if max > self.__slot_count or max <= 0 or max <= self:GetMin() then
		return false
	end
	self.__valid_slot_max_index = max
end

function public:Update()
	local owner = self:GetOwner()
	CustomNetTables:SetTableValue("Bag", self.__nettable_name, self.__itemlist )
	Avalon:Fire('bag_changed', owner, self)
end

--[[
=========================================================================
判断格子是否属于此背包
=========================================================================
@param {int} bagSlot
@return boolean
]]
function public:IsValidSlot(bagSlot)
	return bagSlot >= self:GetMin() and bagSlot <= self:GetMax()
end

--[[
=========================================================================
获取此背包已被使用的格子数量
=========================================================================
@return int
]]
function public:GetCount()
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local count = 0

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			count = count + 1
		end
	end

	return count
end

--[[
=========================================================================
获取此背包的最大格子数量
=========================================================================
@return int
]]
function public:GetMaxCount()
	return self.__slot_count
end

--[[
=========================================================================
获取物品在此背包的数量
=========================================================================
@param {string} itemName 物品
@return int
]]
function public:GetNumItemInBag(itemName)
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local num = 0

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() and item:GetAbilityName() == itemName then
				if item:IsStackable() then
					num = num + item:GetCurrentCharges()
				else
					num = num + 1
				end
			end
		end
	end

	return num
end

--[[
=========================================================================
判断背包是否已满
=========================================================================
@param {int} bagSlot
@return boolean
]]
function public:IsFull()
	local valid_max_count = self:GetMax() - self:GetMin() + 1
	return self:GetCount() == valid_max_count
end

--[[
=========================================================================
获取指定格子上的物品
=========================================================================
@param {int} bagSlot
@return table
]]
function public:GetItem(bagSlot)
	if self:IsValidSlot(bagSlot) then
		local itemlist = self.__itemlist
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			return EntIndexToHScript(itemIndex)
		end
	end

	return nil
end

--[[
=========================================================================
获取指定格子上的物品的名称
=========================================================================
@param {int} bagSlot
@return table
]]
function public:GetItemName(bagSlot)
	if self:IsValidSlot(bagSlot) then
		local itemlist = self.__itemlist
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item == nil then return "" end
			return item:GetAbilityName()
		end
	end

	return ""
end

--[[
=========================================================================
获取物品在此背包的位置
=========================================================================
@param {handle} item 物品
@return int
]]
function public:GetSlot(item)
	if item:IsNull() then return -1 end

	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local itemIndex = item:GetEntityIndex()

	for bagSlot=min,max do
		local bagItemIndex = itemlist[bagSlot]
		if bagItemIndex == itemIndex then
			return bagSlot
		end
	end

	return -1
end

--[[
=========================================================================
根据物品名称查找物品，查到第一个立即返回
=========================================================================
@param {string} itemname 物品
@return table
]]
function public:FindItemByName(itemname)
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() and item:GetAbilityName() == itemname then
				return item,bagSlot
			end
		end
	end

	return nil
end

--[[
=========================================================================
根据物品名称查找所有此类物品
=========================================================================
@param {string} itemname 物品
@return table
]]
function public:FindAllItemByName(itemname)
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local list = {}

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() and item:GetAbilityName() == itemname then
				table.insert(list,item)
			end
		end
	end

	return list
end

--[[
=========================================================================
判断是否能创建物品
=========================================================================
@param {string} itemname 物品
@param {int}    count    数量
@return boolean
]]
function public:CanCreateItem(itemname, count)
	local itemdata = ItemsKV[itemname]
	if itemdata == nil then return false end

	-- 如果是可叠加的，且已有物品则可以直接叠加故返回true，无物品则需要创建物品，依据背包是否已满
	if itemdata.ItemStackable == 1 or itemdata.ItemStackable == "true" then
		local item = self:FindItemByName( itemname )
		if item ~= nil and not item:IsNull() then
			return true
		end

		return not self:IsFull()

	-- 如果是不可叠加物品直接判断是否有足够的格子创建
	else
		return self:IsFull()
	end

	return false
end

--[[
=========================================================================
判断是否有物品
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:HasItem(item)
	if item:IsNull() then return false end

	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local itemIndex = item:GetEntityIndex()

	return self:HasItemIndex(itemIndex)
end

--[[
=========================================================================
判断是否有物品，根据物品的index
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:HasItemIndex(itemIndex)
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		local bagItemIndex = itemlist[bagSlot]
		if bagItemIndex == itemIndex then
			return true
		end
	end

	return false
end

--[[
=========================================================================
释放物品，只把物品从背包中移除，不删除物品，返回被释放的物品的entity index，返回-1代表没有物品可以释放
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:ReleaseItem(bagSlot)
	if self.__write_lock then return -1 end

	if self:IsValidSlot(bagSlot) then
		local itemlist = self.__itemlist
		local itemIndex = itemlist[bagSlot]
		if itemIndex > 0 then
			itemlist[bagSlot] = -1;
			self:Update()
			return itemIndex
		end
	end

	return -1
end

--[[
=========================================================================
删除物品
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:RemoveItem(item)
	if self.__write_lock then return false end

	local bagSlot = self:GetSlot(item)
	if bagSlot > 0 then
		local itemlist = self.__itemlist
		item:RemoveSelf()
		itemlist[bagSlot] = -1
		self:Update()
		return true
	end

	return false
end

--[[
=========================================================================
删除指定格子的物品
=========================================================================
@param {int} bagSlot 格子
@return boolean
]]
function public:RemoveItemInSlot(bagSlot)
	if self.__write_lock then return false end

	if self:IsValidSlot(bagSlot) then
		local itemlist = self.__itemlist
		local itemIndex = itemlist[bagSlot]
		if itemIndex then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() then
				item:RemoveSelf()
				itemlist[bagSlot] = -1
				self:Update()
				return true
			end
		end
	end

	return false
end

--[[
=========================================================================
删除物品，按指定的物品名称和指定的数量，返回尚未删除的数量
=========================================================================
@param {string} itemname 物品名称
@param {int}    count    删除数量
@return int
]]
function public:RemoveItemByName(itemname, count)
	if self.__write_lock then return count end

	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		if count <= 0 then break end

		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() and item:GetAbilityName() == itemname then
				if item:IsStackable() then
					local charges = item:GetCurrentCharges()
					if charges >= count then
						local num = charges-count
						if num > 0 then
							item:SetCurrentCharges(num)
						else
							item:RemoveSelf()
							itemlist[bagSlot] = -1
						end
						count = 0
					else
						item:RemoveSelf()
						itemlist[bagSlot] = -1
						count = count - charges
					end
				else
					item:RemoveSelf()
					itemlist[bagSlot] = -1
					count = count - 1
				end
			end
		end
	end

	self:Update()
	return count
end

--[[
=========================================================================
删除背包内的所有物品
=========================================================================
]]
function public:RemoveAllItem()
	if self.__write_lock then return nil end

	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex and itemIndex > 0 then
			local item = EntIndexToHScript(itemIndex)
			if item and not item:IsNull() then
				item:RemoveSelf()
				itemlist[bagSlot] = -1
			end
		end
	end

	self:Update()
end

--[[
=========================================================================
获取未使用的格子，如果返回-1则表示没有可用格子
=========================================================================
@return int
]]
function public:GetNoUseSlot()
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex == -1 then
			return bagSlot
		end
	end

	return -1
end

--[[
=========================================================================
添加物品
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:AddItem(item)
	if self.__write_lock then return false end

	if self:HasItem(item) then return false end

	-- 如果为可叠加物品，则叠加后删除
	if item:IsStackable() then
		local sameItem,bagSlot = self:FindItemByName(item:GetAbilityName())
		if sameItem and sameItem:IsStackable() then
			sameItem:SetCurrentCharges(sameItem:GetCurrentCharges()+item:GetCurrentCharges())
			item:RemoveSelf()
			self:Update()
			return true
		end
	end

	local bagSlot = self:GetNoUseSlot()

	if bagSlot > 0 then
		local itemlist = self.__itemlist
		itemlist[bagSlot] = item:GetEntityIndex()
		Avalon:Fire("bag_new_item", self:GetOwner(), self, item)
		self:Update()
		return true
	end
		
	return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_add_item", false)
end

--[[
=========================================================================
创建物品
=========================================================================
@param {string} itemName 物品名称
@param {int}    charges  初始数量，只对可叠加物品数量
@return table
]]
function public:CreateItem(itemName, charges)
	if self.__write_lock then return nil end

	local itemdata = ItemsKV[itemName]
	if not itemdata then return nil end

	if itemdata.ItemStackable == 1 or itemdata.ItemStackable == "true" then
		local item,bagSlot = self:FindItemByName(itemName)
		if item ~= nil and not item:IsNull() and item:IsStackable() then
			item:SetCurrentCharges(item:GetCurrentCharges() + (charges or 1))
			self:Update()
			return item
		end
	end

	local bagSlot = self:GetNoUseSlot()

	if bagSlot > 0 then
		return self:CreateItemInSlot(itemName, bagSlot, charges)
	end

	return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_create_item", nil)
end

--[[
=========================================================================
创建物品到指定格子，如果指定的格子已有物品则先删除后添加
=========================================================================
@param {string} itemName 物品名称
@param {int}    bagSlot  格子
@param {int}    charges  初始数量，只对可叠加物品数量
@return table
]]
function public:CreateItemInSlot(itemName, bagSlot, charges)
	if self.__write_lock then return nil end
	if not self:IsValidSlot(bagSlot) then return nil end

	local itemlist = self.__itemlist
	local oldItemIndex = itemlist[bagSlot]

	if oldItemIndex ~= -1 then
		local oldItem = EntIndexToHScript(oldItemIndex)
		if oldItem and not oldItem:IsNull() then oldItem:RemoveSelf() end
	end

	local newItem = CreateItem(itemName, nil, nil)
	itemlist[bagSlot] = newItem:GetEntityIndex()

	if charges and charges>0 and newItem:IsStackable() then
		newItem:SetCurrentCharges(charges)
	end

	Avalon:Fire("bag_new_item", self:GetOwner(), self, newItem)

	self:Update()
	return newItem
end

--[[
=========================================================================
消耗物品
=========================================================================
@param {handle} item 物品
@return int
]]
function public:CostItem(item, charges)
	if self.__write_lock then return 0 end

	if not item:IsStackable() then return 0 end

	local bagSlot = self:GetSlot(item)
	return self:CostItemInSlot(bagSlot, charges)
end

--[[
=========================================================================
消耗物品从指定的格子
=========================================================================
@param {handle} item 物品
@return int
]]
function public:CostItemInSlot(bagSlot, charges)
	if self.__write_lock then return 0 end

	local item = self:GetItem(bagSlot)
	if not item then return 0 end
	if not item:IsStackable() then return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_cost_item", 0) end

	local used = 0
	
	if item:GetCurrentCharges() <= charges then
		used = item:GetCurrentCharges()
		item:SetCurrentCharges(0)
		if not item:IsPermanent() then
			local itemlist = self.__itemlist
			item:RemoveSelf()
			itemlist[bagSlot] = -1
		end
	else
		item:SetCurrentCharges(item:GetCurrentCharges() - charges)
		used = charges
	end

	self:Update()
	return used
end

--[[
=========================================================================
出售物品
=========================================================================
@param {handle} item 物品
@return boolean
]]
function public:SellItem(item)
	if self.__write_lock then return false end

	if not self:HasItem(item) then return false end
	
	if Avalon:Conform("bag_sell_item",self:GetOwner(),item) == true then
		Avalon:Fire("bag_sell_item",self:GetOwner(),item:GetAbilityName(),item:GetCurrentCharges())
		self:RemoveItem(item)
		return true
	end

	return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_sell_item", false)
end

--[[
=========================================================================
循环遍历背包，返回true中止循环
=========================================================================
@param {function} func 物品
@return boolean
]]
function public:Look(func)
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()

	for bagSlot=min,max do
		local itemIndex = itemlist[bagSlot]
		if itemIndex > 0 then
			if func(bagSlot,itemIndex,EntIndexToHScript(itemIndex)) == true then return true end
		end
	end

	return false
end

--[[
=========================================================================
切换物品位置
=========================================================================
@param {int} slot1 格子
@param {int} slot2 格子
@return boolean
]]
function public:SwapItem(slot1,slot2)
	if self.__write_lock then return false end

	if not self:IsValidSlot(slot1) or not self:IsValidSlot(slot2) then
		return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_swap_item", false)
	end

	local itemlist = self.__itemlist

	itemlist[slot1],itemlist[slot2] = itemlist[slot2],itemlist[slot1]

	self:Update()

	return true
end

--[[
=========================================================================
与其他背包的物品切换位置
=========================================================================
@param {int} slot1 格子
@param {int} slot2 格子
@return boolean
]]
function public:SwapItemForOtherBag(slot1, bag, slot2)
	if self.__write_lock then return false end

	if not self:IsValidSlot(slot1) or not bag:IsValidSlot(slot2) then
		return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_swap_item", false)
	end

	self.__itemlist[slot1],bag.__itemlist[slot2] = bag.__itemlist[slot2],self.__itemlist[slot1]

	bag:Update()
	self:Update()
	return true
end

--[[
=========================================================================
把物品放到末尾
=========================================================================
@param {int} slot 格子
@return boolean
]]
function public:MoveItemToEndPos(slot)
	if self.__write_lock then return false end

	if not self:IsValidSlot(slot) then return false end
	local itemlist = self.__itemlist
	local min,max = self:GetMin(),self:GetMax()
	local itemIndex = itemlist[slot]

	if itemIndex and itemIndex > 0 then
		for i=max,min,-1 do
			if itemlist[i] == -1 then
				self:SwapItem(slot,i)
				return true
			end
		end
	end
end

--[[
=========================================================================
与装备栏交换物品
=========================================================================
@param {int} bagSlot 格子
@param {int} inventorySlot 装备栏格子
@return boolean
]]
function public:SwapItemFromInventory(bagSlot, inventorySlot)
	if self.__write_lock then return false end

	if not self:IsValidSlot(bagSlot) then return false end
	if inventorySlot < 0 or inventorySlot > 5 then return false end

	local itemlist = self.__itemlist
	local owner = self:GetOwner()
	local bagItem = self:GetItem(bagSlot)

	if bagItem then
		inventorySlot = Avalon:Conform("bag_swap_item_from_inventory", bagItem, inventorySlot)
	end

	local inventoryItem = owner:GetItemInSlot(inventorySlot)

	if inventoryItem and not inventoryItem:IsNull() then
		owner:TakeItem(inventoryItem)
		itemlist[bagSlot] = inventoryItem:GetEntityIndex()
	else
		itemlist[bagSlot] = -1
	end

	if bagItem and not bagItem:IsNull() then
		owner:AddItem(bagItem)
	end

	self:Update()
	return true
end

--[[
=========================================================================
丢弃物品
=========================================================================
@param {int} bagSlot 格子
@return void
]]
function public:Discard(bagSlot)
	if self.__write_lock then return end

	local itemIndex = self:ReleaseItem(bagSlot)

	if itemIndex > 0 then
		local origin = self:GetOwner():GetOrigin()+RandomVector(150)
		local container = CreateItemOnPositionSync(origin, EntIndexToHScript(itemIndex))
	end
end

--[[
=========================================================================
分离可叠加物品
=========================================================================
@param {int} bagSlot 格子
@param {int} num 数量
@return boolean
]]
function public:Split(bagSlot, num)
	if self.__write_lock then return false end

	local item = self:GetItem(bagSlot)
	if not item then return false end
	if not item:IsStackable() then return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_split_item_is_not_stackable", false) end
	if num < 0 or num >= item:GetCurrentCharges() then return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_split_item_number_invalid", false) end

	local newSlot = self:GetNoUseSlot()
	if newSlot > 0 then
		self:CreateItemInSlot(item:GetAbilityName(), newSlot, num)
		item:SetCurrentCharges(item:GetCurrentCharges() - num)

		return true
	end

	return false
end

--[[
=========================================================================
合并可叠加物品,bagSlot2的物品合并到bagSlot1里面
=========================================================================
@param {int} bagSlot1 格子
@param {int} bagSlot2 格子
@return boolean
]]
function public:Merge(bagSlot1, bagSlot2)
	if self.__write_lock then return false end

	local item1 = self:GetItem(bagSlot1)
	local item2 = self:GetItem(bagSlot2)
	if not item1 or not item2 then return false end
	if not item1:IsStackable() then return false end
	if not item2:IsStackable() then return false end
	if item1:GetAbilityName() ~= item2:GetAbilityName() then return Avalon:Throw(self:GetOwner(), "error_msg_bag_can_not_merge_item_itemname_is_not_equal", false) end

	item1:SetCurrentCharges(item1:GetCurrentCharges() + item2:GetCurrentCharges())

	local itemlist = self.__itemlist
	itemlist[bagSlot2] = -1
	item2:RemoveSelf()

	self:Update()
	return true
end

--[[
=========================================================================
丢弃物品到指定位置
=========================================================================
]]
function public:DropItemToPosition( item, pos )
	if self.__write_lock then return end

	if item:IsNull() then return end
	if not self:HasItem(item) then return end

	ExecuteOrderFromTable
	{
		UnitIndex = self:GetOwner():GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = pos,
		Queue = 0
	}

	unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()
		if (unit:GetOrigin() - pos):Length2D() <= 150 then

			local drop = CreateItemOnPositionSync( pos , item)
			unit:Stop()
			return nil
		end

		return 0.2
	end, 0)
end

--[[
=========================================================================
整理背包
=========================================================================
Exmple:

hero:GetBag():Sort(
	function ( itemIndex1, itemIndex2 )
		return itemIndex1>itemIndex2
	end)
]]
function public:Sort(func1, func2, func3)
	self.__write_lock = true

	local itemlist = self.__itemlist

	if func1 ~= nil then
		table.sort(itemlist,func1)
	end
	if func2 ~= nil then
		table.sort(itemlist,func2)
	end
	if func3 ~= nil then
		table.sort(itemlist,func3)
	end

	if self:GetMax() <= 36 then
		for i=19,self.__slot_count do
			local temp = itemlist[i]
			if temp > 0 then
				itemlist[i-18] = temp
				itemlist[i] = -1
			end
		end
	end
	
	self.__write_lock = false
	self:Update()
end
