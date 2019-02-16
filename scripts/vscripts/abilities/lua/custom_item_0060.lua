custom_item_0060 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0060

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local multiple = 1
	if caster:IsFate("shennonghouyi") then
		multiple = 2
	end
	caster:ModifyCustomAttribute('str','custom_item_0060',item:GetSpecialValueFor("bonus_strength")*multiple);
	caster:ModifyCustomAttribute('agi','custom_item_0060',item:GetSpecialValueFor("bonus_agility")*multiple);
	caster:ModifyCustomAttribute('int','custom_item_0060',item:GetSpecialValueFor("bonus_intellect")*multiple);
end