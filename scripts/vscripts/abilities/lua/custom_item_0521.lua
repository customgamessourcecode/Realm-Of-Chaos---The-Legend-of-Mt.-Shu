custom_item_0521 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0521

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	
	local list = {}
	for itemname,conf in pairs(ItemConfig) do
		if conf.quality == ITEM_QUALITY_A then
			table.insert(list,itemname)
		end
	end

	local itemname = list[RandomInt(1, #list)]
	if itemname then
		caster:AddItemByName(itemname)
	end
end