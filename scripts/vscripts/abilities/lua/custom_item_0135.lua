custom_item_0135 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0135

function public:OnCustomSpellStart(item)
	DigTreasure:Explore(self:GetCaster())
end