custom_item_0382 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0382

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end