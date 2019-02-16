custom_item_0591 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0591

function public:OnCustomSpellStart(item)
	DigTreasureItem0591:Explore(self:GetCaster())
end