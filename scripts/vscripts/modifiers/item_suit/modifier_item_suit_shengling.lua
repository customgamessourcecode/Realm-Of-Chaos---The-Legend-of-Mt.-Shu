modifier_item_suit_shengling = class({})

local public = modifier_item_suit_shengling

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'item_0440'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnAttacked(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker

		-- 攻击敌人
		if target ~= self:GetCaster() and attacker == self:GetCaster() then
			local damage_table = {
				attacker = attacker,
				radius = 400,
				pos = target:GetOrigin(),
				damage_increase = 0.4,
			}
			DamageSystem:TakeInRadius(damage_table)
		end
	end
end

--------------------------------------------------------------------------------