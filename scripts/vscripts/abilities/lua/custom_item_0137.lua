custom_item_0137 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0137
local trigger = nil

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local p = ParticleManager:CreateParticle("particles/avalon/quests/fishing/fishing_fx.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(p, 1, point)
	ParticleManager:SetParticleControl(p, 2, Vector(700,0,0))

	local dummy = CreateUnitByName("avalon_dummy", point, false, nil, nil, caster:GetTeam())
	dummy:AddNoDraw()
	dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", nil)

	if trigger == nil then
		trigger = Entities:FindByName(nil, "trigger_shihepan")
	end

	Wait(0.6, function ()
		ParticleManager:DestroyParticle(p, false)

		if trigger:IsTouching(dummy) then
			local p = ParticleManager:CreateParticle("particles/avalon/quests/fishing/fishing_water.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(p, 0, point)
			ParticleManager:SetParticleControl(p, 2, point)
			ParticleManager:DestroyParticleSystem(p)

			local charges = 10

			if RandomFloat(0, 100) <= 50 then
				charges = charges + RandomInt(0, 5)
			end

			if not caster:GetBag():CreateItem("item_0105",charges) then
				local item = CreateItem("item_0105", nil, nil)
				item:SetCurrentCharges(charges)
				CreateItemOnPositionSync(point, item)
			end

			if caster:IsFate("buyudaren") then
				if RandomFloat(0, 100) <= 5 then
					caster:AddItemByName("item_0520")
				end
				if RandomFloat(0, 100) <= 5 then
					if caster.__item_0521_get_count == nil or caster.__item_0521_get_count < 3 then
						caster.__item_0521_get_count = (caster.__item_0521_get_count or 0) + 1
						caster:AddItemByName("item_0521")
					end
				end
			end
		end

		dummy:RemoveSelf()
			
	end)
end