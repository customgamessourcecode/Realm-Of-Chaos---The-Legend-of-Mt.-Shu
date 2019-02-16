
if ItemToBeCollected == nil then
	ItemToBeCollected = RegisterController('item_to_be_collected')
	ItemToBeCollected.__players_itemlist = {}
	setmetatable(ItemToBeCollected,ItemToBeCollected)
end

local public = ItemToBeCollected

function public:OnEnter(hero, id)
	local t = item_compose_table[id]
	if not t then return end
	
	local list = self.__players_itemlist[hero:GetEntityIndex()]

	if list == nil then
		list = {}
		self.__players_itemlist[hero:GetEntityIndex()] = list
	end

	for k,v in pairs(t.requestItem) do
		list[v.itemname] = (list[v.itemname] or 0) + v.count
	end

	CustomNetTables:SetTableValue("Common", "ItemToBeCollected", self.__players_itemlist)
end