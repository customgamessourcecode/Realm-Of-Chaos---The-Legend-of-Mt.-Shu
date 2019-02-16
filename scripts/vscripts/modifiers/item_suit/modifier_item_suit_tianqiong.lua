modifier_item_suit_tianqiong = class({})

local public = modifier_item_suit_tianqiong

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
	return 'item_0581'
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

		-- 受到攻击
		if target == self:GetCaster() and attacker ~= self:GetCaster() then
			target:Heal(10000, nil)
			return
		end

		-- 攻击敌人
		if target ~= self:GetCaster() and attacker == self:GetCaster() then
			DamageSystem:TakeInRadius({
				attacker = attacker,
				pos = target:GetOrigin(),
				radius = 300,
				damage_increase = 0.2,
			})
		end
	end
end

--------------------------------------------------------------------------------