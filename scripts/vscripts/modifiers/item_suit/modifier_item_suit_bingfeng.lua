modifier_item_suit_bingfeng = class({})

local public = modifier_item_suit_bingfeng

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
	return 'item_0192'
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
		if keys.target == self:GetCaster() and keys.attacker ~= self:GetCaster() and RandomFloat(0, 100) <= 5 then
			local duration = 0.5
			if GameRules:GetCustomGameDifficulty() >= 4 then
				duration = duration/2
			end
			keys.attacker:AddNewModifier(keys.target, nil, "modifier_item_suit_bingfeng_effect", {duration=duration})
		end
	end
end

--------------------------------------------------------------------------------