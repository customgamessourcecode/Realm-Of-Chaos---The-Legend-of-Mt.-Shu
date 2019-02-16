
shi_hun_mo_yi_lv02 = class({})

local public = shi_hun_mo_yi_lv02

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
	return ShuShan_Modifier_Funcs_OnAttackLanded
end

--------------------------------------------------------------------------------

function public:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() then
			if RandomFloat(0, 100) <= 15 then
				keys.attacker:AddNewModifier(keys.attacker, nil, "shi_hun_mo_yi_enemy_effect", {duration=10, max_count=2})
			end
		end
	end
end