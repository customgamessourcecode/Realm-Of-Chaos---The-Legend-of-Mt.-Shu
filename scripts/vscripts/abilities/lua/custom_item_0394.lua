custom_item_0394 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0394

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local multiple = 1
	if caster:IsFate("shennonghouyi") then
		multiple = 2
	end
	caster:ModifyCustomAttribute('str','custom_item_0394',item:GetSpecialValueFor("bonus_strength")*multiple);
	caster:ModifyCustomAttribute('agi','custom_item_0394',item:GetSpecialValueFor("bonus_agility")*multiple);
	caster:ModifyCustomAttribute('int','custom_item_0394',item:GetSpecialValueFor("bonus_intellect")*multiple);
	caster:ModifyCustomAttribute('sword_coefficient','custom_item_0394',item:GetSpecialValueFor("weapon_mult_sword")*multiple);
	caster:ModifyCustomAttribute('knife_coefficient','custom_item_0394',item:GetSpecialValueFor("weapon_mult_knife")*multiple);
	caster:ModifyCustomAttribute('blade_coefficient','custom_item_0394',item:GetSpecialValueFor("weapon_mult_blade")*multiple);
	caster:ModifyCustomAttribute('caster_coefficient','custom_item_0394',item:GetSpecialValueFor("weapon_mult_caster")*multiple);
	caster:ModifyCustomAttribute('lancer_coefficient','custom_item_0394',item:GetSpecialValueFor("weapon_mult_lancer")*multiple);
end