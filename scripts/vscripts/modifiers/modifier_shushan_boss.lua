modifier_shushan_boss = class({})

local public = modifier_shushan_boss

local m_modifier_funcs = {
	MODIFIER_EVENT_ON_ATTACKED,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return m_modifier_funcs
end

--------------------------------------------------------------------------------

function public:OnAttacked(keys)
	if IsServer() then
		local target = keys.target
		if target == self:GetCaster() and keys.attacker ~= self:GetCaster() then
			self.__disable_end_time = GameRules:GetGameTime() + 13
		end
	end
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	if IsServer() then
		self.__disable_end_time = 0

		if GameRules:GetCustomGameDifficulty() > 1 then
			self:StartIntervalThink(1)
		end
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() >= self.__disable_end_time then
			self:GetCaster():Heal(self:GetCaster():GetMaxHealth()*0.05, nil)
		end
	end
end

--------------------------------------------------------------------------------

-- 最大移动速度
function public:GetModifierMoveSpeed_Max()
	return 10000
end

--------------------------------------------------------------------------------

function public:GetModifierAttackSpeedBonus_Constant()
	if GameRules:GetCustomGameDifficulty() >= 6 then
		return 50
	end

	return 0
end

--------------------------------------------------------------------------------