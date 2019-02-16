custom_item_0576 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0576

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	caster:GiveYuanHui(item:GetSpecialValueFor("yuanhui"))
end