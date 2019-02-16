custom_item_0584 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0584

function public:OnCustomSpellStart(item)
	local itemlist = {"item_0581","item_0582","item_0583"}
	self:GetCaster():AddItemByName(itemlist[RandomInt(1, #itemlist)])
end