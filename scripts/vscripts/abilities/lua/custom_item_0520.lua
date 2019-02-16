custom_item_0520 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0520

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	
	if caster.__custom_item_0520_eat_count == nil then
		caster.__custom_item_0520_eat_count = 0
	end

	if caster.__custom_item_0520_eat_count >= 3 then
		return
	end

	caster.__custom_item_0520_eat_count = caster.__custom_item_0520_eat_count + 1

	caster:ModifyCustomAttribute('str','custom_item_0520',item:GetSpecialValueFor("bonus_strength"));
	caster:ModifyCustomAttribute('agi','custom_item_0520',item:GetSpecialValueFor("bonus_agility"));
	caster:ModifyCustomAttribute('int','custom_item_0520',item:GetSpecialValueFor("bonus_intellect"));
	caster:ModifyCustomAttribute('sword_coefficient','custom_item_0520',item:GetSpecialValueFor("weapon_mult_sword"));
	caster:ModifyCustomAttribute('knife_coefficient','custom_item_0520',item:GetSpecialValueFor("weapon_mult_knife"));
	caster:ModifyCustomAttribute('blade_coefficient','custom_item_0520',item:GetSpecialValueFor("weapon_mult_blade"));
	caster:ModifyCustomAttribute('caster_coefficient','custom_item_0520',item:GetSpecialValueFor("weapon_mult_caster"));
	caster:ModifyCustomAttribute('lancer_coefficient','custom_item_0520',item:GetSpecialValueFor("weapon_mult_lancer"));
end