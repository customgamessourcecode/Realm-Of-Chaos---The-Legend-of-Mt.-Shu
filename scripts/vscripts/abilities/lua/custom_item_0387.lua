custom_item_0387 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0387

function public:OnCustomSpellStart(item)
	self:GetCaster():CastAbilityNoTarget(item, self:GetCaster():GetPlayerOwnerID())
end