
if PublicStash == nil then
	PublicStash = RegisterController('public_stash')
	PublicStash.__item_list = {}
	setmetatable(PublicStash,PublicStash)
end

PUBLIC_STASH_MIN_INDEX = 1
PUBLIC_STASH_MAX_INDEX = 100

function PublicStash:init()
	for i=PUBLIC_STASH_MIN_INDEX,PUBLIC_STASH_MAX_INDEX do
		self.__item_list[i] = -1
	end
end

function PublicStash:Add(hero, slot)
	local bag = hero:GetBag()
	if not bag then return false end

	local item = bag:GetItem(slot)
	if item == nil then return end

	local index = -1

	for i=PUBLIC_STASH_MIN_INDEX, PUBLIC_STASH_MAX_INDEX do
		if self.__item_list[i] == -1 or self.__item_list[i] == nil then
			index = i
			break
		end
	end

	if index == -1 then return end

	self.__item_list[index] = item:GetEntityIndex()
	bag:ReleaseItem(slot)
	CustomNetTables:SetTableValue("Bag", "PublicStash", self.__item_list )
end

function PublicStash:Take(hero, index)
	if index < PUBLIC_STASH_MIN_INDEX or index > PUBLIC_STASH_MAX_INDEX then return false end

	local bag = hero:GetBag()
	if not bag then return false end

	local itemIndex = self.__item_list[index] or -1
	if itemIndex == -1 then return false end

	local item = EntIndexToHScript(itemIndex)
	if item then
		if bag:AddItem(item) then
			self.__item_list[index] = -1
			CustomNetTables:SetTableValue("Bag", "PublicStash", self.__item_list )
			EmitSoundOnClient("CustomGameUI.PublicStashItemDropToBag",PlayerResource:GetPlayer(hero:GetPlayerID()))
		end
	end
end

function PublicStash:sort()
	table.sort( self.__item_list, function ( itemIndex1, itemIndex2 )
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
	end )

	CustomNetTables:SetTableValue("Bag", "PublicStash", self.__item_list )
end