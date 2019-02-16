custom_item_0384 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0384

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end