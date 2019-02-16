custom_item_0381 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0381

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end