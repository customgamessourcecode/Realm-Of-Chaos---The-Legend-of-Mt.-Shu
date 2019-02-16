
if BagCtrl == nil then
	BagCtrl = RegisterController('bag')
	BagCtrl.player_bag={}
	setmetatable(BagCtrl,BagCtrl)
end

BAG_SLOT_COUNT = 54 
BAG_SIGIL_SLOT_COUNT = 5
BAG_NAME_COMMON = 1 --普通背包
BAG_NAME_SIGIL = 2 --符印背包

local public = BagCtrl

-- 获取英雄背包
function CDOTA_BaseNPC_Hero:GetBag()
	return public(self,BAG_NAME_COMMON)
end

-- 获取符印背包
function CDOTA_BaseNPC_Hero:GetSigilBag()
	return public(self,BAG_NAME_SIGIL)
end

-- 获取英雄的背包
function public:__call(hero, bagName)
	assert(hero and hero:IsHero(), 'Invalid hero')

	local playerBag = self.player_bag[hero:GetSteamID()]

	if playerBag == nil then
		playerBag = {}
		self.player_bag[hero:GetSteamID()] = playerBag
	end

	if playerBag[bagName] == nil then
		if bagName == BAG_NAME_COMMON then
			playerBag[bagName] = CBag(BAG_NAME_COMMON, hero, BAG_SLOT_COUNT, 1, 36)
		elseif bagName == BAG_NAME_SIGIL then
			playerBag[bagName] = CBag(BAG_NAME_SIGIL, hero, BAG_SIGIL_SLOT_COUNT)
		end
	end

	return playerBag[bagName]
end

-- 初始化
function public:init()
	Avalon:Listen("bag_changed", Dynamic_Wrap(self,"OnBagChanged"), self)
	Avalon:Listen("bag_sell_item", Dynamic_Wrap(self,"OnSellItem"), self)
	Avalon:Listen("bag_new_item", Dynamic_Wrap(self,"OnNewItem"), self)
	Avalon:BindConform("bag_sell_item", Dynamic_Wrap(self,"WhenSellItem"), self)
end

-- 背包发生改变
function public:OnBagChanged(hero, bag)
	self:Update(hero, bag:GetBagName())
end

-- 当前添加新的物品
function public:OnNewItem(hero, bag, item)
	for i=Custom_Item_Spell_System_Slot_Min,Custom_Item_Spell_System_Slot_Max do
		local ability = hero:GetAbilityByIndex(i)
		if ability == nil or string.find(ability:GetAbilityName(),"custom_item_spell_system") == 1 then
			CustomItemSpellSystem:SetSlot(hero, i, item)
			break
		end
	end
end

function public:OnSellItem(hero, itemname, charges)
	EmitSoundOnClient("General.Sell",PlayerResource:GetPlayer(hero:GetPlayerID()))

	QuestsCtrl:TouchCustomType(hero, 'sell_items', function (subquest, data)
		if data["Target"] ~= itemname then return false end

		data["Count"] = data["Count"] + 1
		if data["Count"] >= data["MaxCount"] then
			return true
		end
	end)
end

-- 当出售物品
function public:WhenSellItem(hero, item)
	local data = ItemConfig[item:GetAbilityName()]
	if not data then return false end

	local amount = item:GetCost()
	local charges = item:GetCurrentCharges()

	if not item:IsStackable() then
		charges = 1
	end

	-- if amount <= 0 then
	-- 	if data["quality"] == 1 then
	-- 		amount = 100
	-- 	elseif data["quality"] == 2 then
	-- 		amount = 900
	-- 	elseif data["quality"] == 3 then
	-- 		amount = 1800
	-- 	elseif data["quality"] == 4 then
	-- 		amount = 2600
	-- 	elseif data["quality"] == 5 then
	-- 		amount = 4800
	-- 	elseif data["quality"] == 6 then
	-- 		amount = 5600
	-- 	elseif data["quality"] == 7 then
	-- 		amount = 6200
	-- 	elseif data["quality"] == 8 then
	-- 		amount = 6800
	-- 	end
	-- end

	if amount <= 0 then
		if data["quality"] <= 3 then
			amount = 100
		elseif data["quality"] <= 5 then
			amount = 300
		elseif data["quality"] <= 8 then
			amount = 900
		end
	end

	if data["kind"] == ITEM_KIND_MATERIAL then
		amount = math.floor(amount / 10)
	end

	hero:GiveGold(amount*charges)
	return true
end

-- 判断信使能否拾取物品
function public:CourierCanPickup(parent, hItem, supportAutoPickUp)
	local itemname = hItem:GetAbilityName()

	if
		itemname == "item_0004" 
	or
		itemname == "item_0005"
	or
		itemname == "item_0008"
	then
		if supportAutoPickUp then
			return false
		end
		hItem:RemoveSelf()
		return Avalon:Throw(parent:GetOwner(), "error_msg_courier_can_not_pickup_this_item", false)
	end

	return true
end

-- DOTA物品过滤
function public:InventoryFilter(keys)
	local hInventoryParent = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local hItem = EntIndexToHScript(keys.item_entindex_const)
	local container = hItem:GetContainer()

	local itemName = hItem:GetAbilityName()

	if itemName == "item_tpscroll" or itemName == "item_enchanted_mango" then
		return false
	end

	-- 马甲单位直接跳过
	if hInventoryParent:GetUnitName() == "avalon_dummy" then
		return true
	end

	-- 信使
	if hInventoryParent:GetUnitName() == "unit_courier" then
		if self:CourierCanPickup(hInventoryParent,hItem) then
			hInventoryParent:GetOwner():AddItem(hItem)
		end
		return false
	end

	local bag = hInventoryParent:GetBag()

	-- 如果可以直接装备
	local canEquip,slot = EquipCtrl(hInventoryParent,hItem)
	if canEquip and slot >= 0 then
		AttributesCtrl(hItem)
		keys.suggested_slot = slot
		return true
	end

	-- 否则尝试放入背包
	if not bag:AddItem(hItem) then
		if container and not container:IsNull() then
			CreateItemOnPositionSync(container:GetOrigin(), hItem)
		else
			CreateItemOnPositionSync(hInventoryParent:GetOrigin() + RandomVector(100), hItem)
		end
	end

	return false
end

function public:UpdateBag(hero, bagName)
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "bag_event_update", AvalonEmptyTable)
end

function public:Update(hero, bagName)
	DelayDispatch(0.15, hero:GetEntityIndex(), self.UpdateBag, self, hero, bagName)
end