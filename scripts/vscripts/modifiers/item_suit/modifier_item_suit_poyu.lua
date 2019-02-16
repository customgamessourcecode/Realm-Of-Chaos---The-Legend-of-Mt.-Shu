modifier_item_suit_poyu = class({})

local public = modifier_item_suit_poyu

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
	return 'item_0522'
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
			target:AddNewModifier(attacker, nil, "modifier_item_suit_poyu_effect", {duration=5})
		end
	end
end

--------------------------------------------------------------------------------