custom_item_0383 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0383

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end