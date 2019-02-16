modifier_whosyourdaddy = class({})

local public = modifier_whosyourdaddy

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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

-- 生命值加成
function public:GetModifierHealthBonus()
	return 100000
end

--------------------------------------------------------------------------------

-- 生命回复速度
function public:GetModifierConstantHealthRegen()
	return 10000
end

--------------------------------------------------------------------------------

-- 力量
function public:GetModifierBonusStats_Strength()
	return 10000
end

--------------------------------------------------------------------------------

-- 敏捷
function public:GetModifierBonusStats_Agility()
	return 10000
end

--------------------------------------------------------------------------------

-- 智力
function public:GetModifierBonusStats_Intellect()
	return 10000
end

--------------------------------------------------------------------------------

-- 魔法加成
function public:GetModifierManaBonus()
	return 10000
end

--------------------------------------------------------------------------------

-- 护甲加成
function public:GetModifierPhysicalArmorBonus()
	return 60000
end

--------------------------------------------------------------------------------

-- 魔抗加成
function public:GetModifierMagicalResistanceBonus()
	return 90
end

--------------------------------------------------------------------------------

-- 魔法回复速度
function public:GetModifierConstantManaRegen()
	return 100
end

--------------------------------------------------------------------------------

-- 攻击速度加成
function public:GetModifierAttackSpeedBonus_Constant()
	return 500
end

--------------------------------------------------------------------------------

-- 移速加成
function public:GetModifierMoveSpeedBonus_Constant()
	return 1000
end

--------------------------------------------------------------------------------

-- 伤害输出增强
function public:GetModifierTotalDamageOutgoing_Percentage()
	return 0
end

--------------------------------------------------------------------------------

-- 伤害吸收
function public:GetModifierIncomingDamage_Percentage()
	return 0
end

--------------------------------------------------------------------------------

-- 生命恢复速度%
function public:GetModifierHealthRegenPercentage()
	return 10000
end

--------------------------------------------------------------------------------