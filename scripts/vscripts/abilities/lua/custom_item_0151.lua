custom_item_0151 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0151

function public:OnCustomSpellStart(item)
	local target = self:GetCursorTarget()
	local p = ParticleManager:CreateParticle("particles/avalon/units/dihen/dihen_effect_01.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(p, 2, Vector(200,200,200))
	target.__fire_particle = p
	target.__is_fire = true
	CustomNetTables:SetTableValue("Abilities", "custom_item_0151",  {can_not_cast=1})
	target:EmitSound("Item0182.Fire")
	SummonShuShanDiHen()
end

function public:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "dihen_tower_06" then
		local t = CustomNetTables:GetTableValue("Abilities", "custom_item_0151")
		if t and t["can_not_cast"] == 1 then
			return UF_FAIL_OTHER
		end
		return UF_SUCCESS
	end
	return UF_FAIL_OTHER
end