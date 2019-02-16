modifier_item_suit_liudao = class({})

local public = modifier_item_suit_liudao

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
	return 'item_0429'
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
		if target == self:GetCaster() and attacker ~= self:GetCaster() and RandomFloat(0, 100) <= 5 then
			local duration = 3
			if GameRules:GetCustomGameDifficulty() >= 4 then
				duration = duration/2
			end
			attacker:AddNewModifier(target, nil, "modifier_item_suit_liudao_effect", {duration=duration})
		end

		-- 攻击敌人
		if target ~= self:GetCaster() and attacker == self:GetCaster() then
			local damage_table = {
				victim = target,
				attacker = attacker,
				damage_increase = 0.4,
			}
			UnitDamageTarget(damage_table)
		end
	end
end

--------------------------------------------------------------------------------