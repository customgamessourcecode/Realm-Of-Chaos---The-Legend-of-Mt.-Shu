modifier_item_suit_jihan = class({})

local public = modifier_item_suit_jihan

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
	return 'item_0539'
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
		if target ~= self:GetCaster() and attacker == self:GetCaster() and RandomFloat(0, 100) <= 20 then
			attacker:AddNewModifier(attacker, nil, "modifier_item_suit_jihan_for_self", {duration=5})
			target:AddNewModifier(attacker, nil, "modifier_item_suit_jihan_for_enemy", {duration=5})
		end
	end
end

--------------------------------------------------------------------------------