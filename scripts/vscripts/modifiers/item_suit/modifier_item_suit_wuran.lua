modifier_item_suit_wuran = class({})

local public = modifier_item_suit_wuran

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
	return 'item_0374'
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
		if target == self:GetCaster() and keys.attacker ~= self:GetCaster() and RandomFloat(0, 100) <= 20 then
			target:AddNewModifier(target, nil, "modifier_item_suit_wuran_effect", {duration=3})
		end
	end
end

--------------------------------------------------------------------------------