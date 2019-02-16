custom_item_0182 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0182

function public:OnCustomSpellStart(item)
	local target = self:GetCursorTarget()
	local p = ParticleManager:CreateParticle("particles/avalon/units/hunmotower/hunmotower_0182.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(p, 0, target:GetOrigin() + Vector(0,0,140))
	target.__fire_particle = p
	target.__is_fire = true
	CustomNetTables:SetTableValue("Abilities", "custom_item_0182",  {can_not_cast=1})
	target:EmitSound("Item0182.Fire")
	SummonHunMoBingYanZhenJun()
end

function public:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "item_0182_tower" then
		local t = CustomNetTables:GetTableValue("Abilities", "custom_item_0182")
		if t and t["can_not_cast"] == 1 then
			return UF_FAIL_OTHER
		end
		return UF_SUCCESS
	end
	return UF_FAIL_OTHER
end