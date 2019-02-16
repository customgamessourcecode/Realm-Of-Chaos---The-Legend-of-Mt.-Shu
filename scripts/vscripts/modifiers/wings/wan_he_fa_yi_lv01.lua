
wan_he_fa_yi_lv01 = class({})

local public = wan_he_fa_yi_lv01

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_OnTakeDamage
end

--------------------------------------------------------------------------------

function public:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() and keys.unit ~= keys.attacker then
			if RandomFloat(0, 100) <= 15 then
				keys.unit:AddNewModifier(keys.attacker, nil, "wan_he_fa_yi_enemy_effect", {duration=10, max_count=2})
			end
		end
	end
end