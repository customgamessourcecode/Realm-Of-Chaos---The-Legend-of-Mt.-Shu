modifier_attacking_boss = class({})

local public = modifier_attacking_boss

local m_modifier_funcs = {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
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

function public:OnTakeDamage(keys)
	if IsServer() then
		self.__take_damage_time = GameRules:GetGameTime() + 60
	end
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	if IsServer() then
		self.__is_game_paused = false
		self.__take_damage_time = GameRules:GetGameTime() + 60
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() >= self.__take_damage_time then
			self.__take_damage_time = GameRules:GetGameTime() + 60
			FindClearSpaceForUnit(self:GetCaster(), ShushanFort:GetOrigin() - Vector(220,220,0), true)
		end
	end
end

--------------------------------------------------------------------------------

-- 最大移动速度
function public:GetModifierMoveSpeed_Max()
	return 800
end

--------------------------------------------------------------------------------