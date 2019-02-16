
modifier_quests_reward_kaiyi = class({})

local public = modifier_quests_reward_kaiyi

local modifier_funcs = {
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}

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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'batrider_firefly'
end

--------------------------------------------------------------------------------

function public:OnCreated()
	if IsServer() then
		self.__kill_count = 0
		self:SetStackCount(1)
	end
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return modifier_funcs
end

--------------------------------------------------------------------------------

-- 力量
function public:GetModifierBonusStats_Strength()
	return 1*self:GetStackCount()
end

--------------------------------------------------------------------------------

-- 敏捷
function public:GetModifierBonusStats_Agility()
	return 1*self:GetStackCount()
end

--------------------------------------------------------------------------------

-- 智力
function public:GetModifierBonusStats_Intellect()
	return 1*self:GetStackCount()
end

--------------------------------------------------------------------------------

function public:OnKill(attacker, victim)
	if IsServer() then
		if self:GetCaster() == attacker and self:GetCaster() ~= victim and (attacker:GetTeam() ~= victim:GetTeam()) then
			self.__kill_count = self.__kill_count + 1
			if self.__kill_count >= 10 then
				self.__kill_count = 0
				self:SetStackCount(self:GetStackCount()+1)
			end
		end
	end
end

--------------------------------------------------------------------------------