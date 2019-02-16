custom_item_0592 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0592

function public:OnCustomSpellStart(item)
	DigTreasureItem0592:Explore(self:GetCaster())
end