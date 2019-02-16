modifier_item_suit_duanxie = class({})

local public = modifier_item_suit_duanxie

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
	return 'item_0376'
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
		local attacker = keys.attacker
		if attacker == self:GetCaster() and keys.target ~= self:GetCaster() then
			keys.target:AddNewModifier(attacker, nil, "modifier_item_suit_duanxie_effect", {duration=3})
		end
	end
end

--------------------------------------------------------------------------------