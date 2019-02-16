custom_item_0022 = CustomItemSpellSystem:GetBaseClass()
LinkLuaModifier( "modifier_custom_item_0022", "modifiers/abilities/modifier_custom_item_0022", LUA_MODIFIER_MOTION_NONE )

local public = custom_item_0022

function public:OnCustomSpellStart(item)
	self:GetCaster():AddNewModifier(self:GetCaster(), item, "modifier_custom_item_0022", {duration=item:GetSpecialValueFor("duration")})
end