custom_item_0423 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0423

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local multiple = 1
	if caster:IsFate("shennonghouyi") then
		multiple = 2
	end
	local stats = self:GetCaster():StatisticalAttributes()
	caster:ModifyCustomAttribute('str','custom_item_0423',stats["str"]*(item:GetSpecialValueFor("bonus_strength")/100)*multiple);
	caster:ModifyCustomAttribute('agi','custom_item_0423',stats["agi"]*(item:GetSpecialValueFor("bonus_agility")/100)*multiple);
	caster:ModifyCustomAttribute('int','custom_item_0423',stats["int"]*(item:GetSpecialValueFor("bonus_intellect")/100)*multiple);
end