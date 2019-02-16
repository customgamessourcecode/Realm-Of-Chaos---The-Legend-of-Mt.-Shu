
if AttachedSoul == nil then
	AttachedSoul = RegisterController('attached_soul')
	AttachedSoul.__player_bind_items = {}
	AttachedSoul.__player_attached_soul_items = {}
	setmetatable(AttachedSoul,AttachedSoul)
end

local public = AttachedSoul

function public:Attached(hero)
	local data = self.__player_bind_items[hero:GetEntityIndex()]
	if data == nil then return end

	local equipmentIndex = data["Equipment"] or -1
	local soulItemIndex = data["SoulItem"] or -1
	if equipmentIndex == -1 or soulItemIndex == -1 then return end

	local bag = hero:GetBag()
	if not bag:HasItemIndex(soulItemIndex) then return end

	local hasEquipment = false
	local equipment = EntIndexToHScript(equipmentIndex)
	local soulItem = EntIndexToHScript(soulItemIndex)
	if equipment == nil or soulItem == nil then return end

	for i=0,5 do
		local _item = hero:GetItemInSlot(i)
		if _item == equipment then
			hasEquipment = true
			break
		end
	end

	if not hasEquipment then
		local bag = hero:GetBag()
		hasEquipment = bag:HasItem(equipment)
	end

	if not hasEquipment then return end

	local soulItemName = soulItem:GetAbilityName()

	if bag:CostItem(soulItem,1) == 1 then
		if soulItem:IsNull() then
			data["SoulItem"] = -1
		end

		local attachedData = self.__player_attached_soul_items[hero:GetEntityIndex()]
		if not attachedData then
			attachedData = {}
			self.__player_attached_soul_items[hero:GetEntityIndex()] = attachedData
		end

		attachedData[equipmentIndex] = {
			itemname = soulItemName
		}

		CustomNetTables:SetTableValue("Common", "AttachedSoulPlayerItems"..tostring(hero:GetEntityIndex()), attachedData )
	end

	CustomNetTables:SetTableValue("Common", "AttachedSoulPlayerBindItems", self.__player_bind_items )
end

function public:BindItem(hero, item)
	local hasItem = false

	for i=0,5 do
		local _item = hero:GetItemInSlot(i)
		if _item == item then
			hasItem = true
			break
		end
	end

	if not hasItem then
		local bag = hero:GetBag()
		hasItem = bag:HasItem(item)
	end

	if not hasItem then return end

	local data = self.__player_bind_items[hero:GetEntityIndex()]
	if not data then
		data = {}
		self.__player_bind_items[hero:GetEntityIndex()] = data
	end

	if AttachedSoulConfig[item:GetAbilityName()] ~= nil then
		data["SoulItem"] = item:GetEntityIndex()
	else
		local config = ItemConfig[item:GetAbilityName()]
		if not config then return end
		local group = ItemKindGroup[config.kind]
		if group == ITEM_KIND_GROUP_MATERIAL then return end

		data["Equipment"] = item:GetEntityIndex()
	end

	CustomNetTables:SetTableValue("Common", "AttachedSoulPlayerBindItems", self.__player_bind_items )
end