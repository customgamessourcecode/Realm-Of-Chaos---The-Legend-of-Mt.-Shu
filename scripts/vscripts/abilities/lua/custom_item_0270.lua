custom_item_0270 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0270

function public:OnCustomSpellStart(item)
	CollectOreSystem:AddExp(self:GetCaster(), item:GetSpecialValueFor("collect_ore_exp"))
end