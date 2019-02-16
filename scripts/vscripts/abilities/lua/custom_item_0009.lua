custom_item_0009 = CustomItemSpellSystem:GetBaseClass()
LinkLuaModifier( "modifier_custom_item_0009", "modifiers/abilities/modifier_custom_item_0009", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custom_item_0009_touch", "modifiers/abilities/modifier_custom_item_0009_touch", LUA_MODIFIER_MOTION_NONE )

local public = custom_item_0009

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = item:GetSpecialValueFor("duration")
	local capture_duration = item:GetSpecialValueFor("capture_duration")

	local p = ParticleManager:CreateParticle("particles/avalon/items/item_0009/item_0009_ren_net_parent.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(p, 0, pos)

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local types = DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE

    local start_time = GameRules:GetGameTime()
    local capture_unit = nil
	caster:SetContextThink(DoUniqueString("modifier_custom_item_0009"), function ()
		if GameRules:IsGamePaused() then
			return 0.2
		end

		if capture_unit then
			local unitname = capture_unit:GetUnitName()
			
			capture_unit:AddNoDraw()
			capture_unit:ForceKill(true)
			ParticleManager:DestroyParticle(p, false)

			QuestsCtrl:TouchCustomType(caster, 'custom_item_0009', function (subquest, data)
				if data["Target"] ~= unitname then return false end

				data["Count"] = data["Count"] + 1
				if data["Count"] >= data["MaxCount"] then
					return true
				end
			end)

			return nil
		end

		if GameRules:GetGameTime() - start_time >= duration then
			ParticleManager:DestroyParticle(p, false)
			return nil
		end

		local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, 100, teams, types, flags, -1, false)

		for i,v in ipairs(units) do
			if v:GetUnitName() == "LV1_fb_02_shuiyao" then
				capture_unit = v
				ParticleManager:DestroyParticle(p, false)
				v:AddNewModifier(caster, nil, "modifier_stunned", nil)

				p = ParticleManager:CreateParticle("particles/avalon/items/item_0009/item_0009_capturenet.vpcf", PATTACH_CUSTOMORIGIN, v)
				ParticleManager:SetParticleControlEnt(p, 0, v, 5, "attach_hitloc", v:GetOrigin(), true)
				ParticleManager:SetParticleControlEnt(p, 1, v, 5, "attach_hitloc", v:GetOrigin(), true)
				return capture_duration
			end
		end

		return 0.3
	end, 1)
end