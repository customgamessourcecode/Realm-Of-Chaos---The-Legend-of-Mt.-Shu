custom_item_0050 = CustomItemSpellSystem:GetBaseClass()
LinkLuaModifier( "modifier_custom_item_0050", "modifiers/abilities/modifier_custom_item_0050", LUA_MODIFIER_MOTION_NONE )

local public = custom_item_0050

function public:OnCustomSpellStart(item)
	self:GetCaster():AddNewModifier(self:GetCaster(), item, "modifier_custom_item_0050", {duration=item:GetSpecialValueFor("duration")})
end