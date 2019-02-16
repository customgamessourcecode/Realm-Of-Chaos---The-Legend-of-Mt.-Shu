
if EquipCtrl == nil then
	EquipCtrl = RegisterController('equip')
	setmetatable(EquipCtrl,EquipCtrl)
end

local public = EquipCtrl

-- 装备位置
ITEM_KIND_GROUP_WEAPON_SLOT 	= 5
ITEM_KIND_GROUP_SHOES_SLOT		= 2
ITEM_KIND_GROUP_CLOTHES_SLOT	= 1
ITEM_KIND_GROUP_HAT_SLOT		= 0
ITEM_KIND_GROUP_TRINKET_SLOT	= 3

-- 初始化
function public:init()
	Avalon:BindConform("bag_swap_item_from_inventory",  Dynamic_Wrap(self,"WhenSwapItem"), self)
end

-- 装备
function public:__call(hero, item)
	if not hero:IsHero() then return false end

	local slot = self:GetSlotForHero(hero, item)
	if slot >= 0 then
		local oldItem = hero:GetItemInSlot(slot)

		if oldItem == nil then
			return true,slot
		else
			return false
		end
	end

	return false
end

-- 获取装备的位置
function public:GetSlot(item)
	return self:GetSlotForItemName(item:GetAbilityName())
end

function public:GetSlotForItemName(itemname)
	local config = ItemConfig[itemname]
	if not config then return -1 end

	local group = ItemKindGroup[config["kind"]]

	if group == ITEM_KIND_GROUP_WEAPON then
		return ITEM_KIND_GROUP_WEAPON_SLOT
	elseif group == ITEM_KIND_GROUP_SHOES then
		return ITEM_KIND_GROUP_SHOES_SLOT
	elseif group == ITEM_KIND_GROUP_CLOTHES then
		return ITEM_KIND_GROUP_CLOTHES_SLOT
	elseif group == ITEM_KIND_GROUP_HAT then
		return ITEM_KIND_GROUP_HAT_SLOT
	elseif group == ITEM_KIND_GROUP_TRINKET then
		return ITEM_KIND_GROUP_TRINKET_SLOT
	end

	return -1
end

function public:GetSlotForHero(hero,item)
	local itemname = item:GetAbilityName()
	local config = ItemConfig[itemname]
	if not config then return -1 end

	local group = ItemKindGroup[config["kind"]]

	if group == ITEM_KIND_GROUP_WEAPON then
		return ITEM_KIND_GROUP_WEAPON_SLOT
	elseif group == ITEM_KIND_GROUP_SHOES then
		return ITEM_KIND_GROUP_SHOES_SLOT
	elseif group == ITEM_KIND_GROUP_CLOTHES then
		return ITEM_KIND_GROUP_CLOTHES_SLOT
	elseif group == ITEM_KIND_GROUP_HAT then
		return ITEM_KIND_GROUP_HAT_SLOT
	elseif group == ITEM_KIND_GROUP_TRINKET then

		if hero:GetItemInSlot(ITEM_KIND_GROUP_TRINKET_SLOT) ~= nil and hero:GetItemInSlot(ITEM_KIND_GROUP_TRINKET_SLOT+1) == nil then
			return ITEM_KIND_GROUP_TRINKET_SLOT+1
		end

		return ITEM_KIND_GROUP_TRINKET_SLOT
	end

	return -1
end

function public:CanEquipItemToSlot(hero,item,slot)
	local itemname = item:GetAbilityName()
	local config = ItemConfig[itemname]
	if not config then return false end

	local group = ItemKindGroup[config["kind"]]
	if group == ITEM_KIND_GROUP_WEAPON then
		return slot == ITEM_KIND_GROUP_WEAPON_SLOT
	elseif group == ITEM_KIND_GROUP_SHOES then
		return slot == ITEM_KIND_GROUP_SHOES_SLOT
	elseif group == ITEM_KIND_GROUP_CLOTHES then
		return slot == ITEM_KIND_GROUP_CLOTHES_SLOT
	elseif group == ITEM_KIND_GROUP_HAT then
		return slot == ITEM_KIND_GROUP_HAT_SLOT
	elseif group == ITEM_KIND_GROUP_TRINKET then
		return (slot == ITEM_KIND_GROUP_TRINKET_SLOT) or (slot == ITEM_KIND_GROUP_TRINKET_SLOT+1)
	end

	return false
end

function public:WhenSwapItem(bagItem, inventorySlot)
	if not self:CanEquipItemToSlot(owner,bagItem,inventorySlot) then
		local preSlot = self:GetSlotForHero(owner,bagItem)

		if preSlot < 0 then
			return -1
		end

		if inventorySlot ~= preSlot then
			return preSlot
		end
	end

	return inventorySlot
end