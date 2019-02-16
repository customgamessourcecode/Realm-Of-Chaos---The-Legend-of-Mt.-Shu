custom_item_0385 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0385

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end