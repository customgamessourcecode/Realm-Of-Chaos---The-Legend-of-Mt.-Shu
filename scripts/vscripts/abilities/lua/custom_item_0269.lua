custom_item_0269 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0269

function public:OnCustomSpellStart(item)
	CollectOreSystem:AddExp(self:GetCaster(), item:GetSpecialValueFor("collect_ore_exp"))
end