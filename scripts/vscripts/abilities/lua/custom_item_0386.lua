custom_item_0386 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0386

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end