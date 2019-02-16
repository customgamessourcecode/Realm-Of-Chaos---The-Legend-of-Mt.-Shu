modifier_item_suit_yinze = class({})

local public = modifier_item_suit_yinze

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
	return 'item_0378'
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
		if attacker == self:GetCaster() and keys.target ~= self:GetCaster() and RandomFloat(0, 100) <= 5 then
			keys.target:AddNewModifier(attacker, nil, "modifier_stunned", {duration=1})
		end
	end
end

--------------------------------------------------------------------------------