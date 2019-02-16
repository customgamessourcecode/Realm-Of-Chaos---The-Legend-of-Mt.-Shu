custom_item_0453 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0453

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end