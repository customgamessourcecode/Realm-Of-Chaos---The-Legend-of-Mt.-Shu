modifier_custom_attributes = class({})

local public = modifier_custom_attributes

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	--MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	-- MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetAttrValue(name)
	return self.__CustomAttributes[name] or 0
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	self:StartIntervalThink(0.2)
	self.__entity_index_str = tostring(self:GetParent():GetEntityIndex())
	self.__CustomAttributes = {}
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsIllusion() and not parent:IsAlive() then return self:Destroy() end
		self.__CustomAttributes = parent:GetAllCustomAttribute()
		CustomNetTables:SetTableValue("CustomAttributes", self.__entity_index_str, self.__CustomAttributes)
	else
		self.__CustomAttributes = CustomNetTables:GetTableValue("CustomAttributes", self.__entity_index_str)
	end
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return m_modifier_funcs
end

--------------------------------------------------------------------------------

-- 生命值加成
function public:GetModifierHealthBonus()
	return self:GetAttrValue("hp")
end

--------------------------------------------------------------------------------

-- 生命回复速度
function public:GetModifierConstantHealthRegen()
	return self:GetAttrValue("health_regen")
end

--------------------------------------------------------------------------------

-- 力量
function public:GetModifierBonusStats_Strength()
	return self:GetAttrValue("str")
end

--------------------------------------------------------------------------------

-- 敏捷
function public:GetModifierBonusStats_Agility()
	return self:GetAttrValue("agi")
end

--------------------------------------------------------------------------------

-- 智力
function public:GetModifierBonusStats_Intellect()
	return self:GetAttrValue("int")
end

--------------------------------------------------------------------------------

-- 魔法加成
function public:GetModifierManaBonus()
	return self:GetAttrValue("mana")
end

--------------------------------------------------------------------------------

-- 护甲加成
function public:GetModifierPhysicalArmorBonus()
	return self:GetAttrValue("armor")
end

--------------------------------------------------------------------------------

-- 魔抗加成
function public:GetModifierMagicalResistanceBonus()
	return self:GetAttrValue("magic_armor")
end

--------------------------------------------------------------------------------

-- 魔法回复速度
function public:GetModifierConstantManaRegen()
	return self:GetAttrValue("mana_regen")
end

--------------------------------------------------------------------------------

-- 攻击速度加成
function public:GetModifierAttackSpeedBonus_Constant()
	return self:GetAttrValue("attack_speed")
end

--------------------------------------------------------------------------------

-- 移速加成
function public:GetModifierMoveSpeedBonus_Constant()
	return self:GetAttrValue("move_speed")
end

--------------------------------------------------------------------------------

-- 最大移动速度
function public:GetModifierMoveSpeed_AbsoluteMax()
	return 10000
end

function public:GetModifierMoveSpeed_Absolute()
	local caster = self:GetCaster()
	local moveSpeed = 0
	local moveSpeedPercent = 0
	for i=0,5 do
		local item = caster:GetItemInSlot( i )
		if item then
			local speed = item:GetSpecialValueFor( "bonus_movement_speed" )
			if speed > moveSpeed then
				moveSpeed = speed
			end
			local speedPercent = item:GetSpecialValueFor( "bonus_movement_speed_pct" )
			if speedPercent > moveSpeedPercent then
				moveSpeedPercent = speedPercent
			end
		end
	end

	if caster:HasModifier("modifier_ability_shushan_evade") then
		moveSpeedPercent = moveSpeedPercent + 50
	end

	moveSpeedPercent = 1 + moveSpeedPercent / 100
	moveSpeedPercent = moveSpeedPercent + caster:GetAgility() * 0.0008
	return (400 + moveSpeed + self:GetAttrValue("move_speed")) * moveSpeedPercent
end

--------------------------------------------------------------------------------

-- 伤害输出增强
function public:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAttrValue("damage_outgoing")
end

--------------------------------------------------------------------------------

-- 伤害吸收
function public:GetModifierIncomingDamage_Percentage()
	return self:GetAttrValue("incoming_damage")
end

--------------------------------------------------------------------------------

-- 生命恢复速度%
function public:GetModifierHealthRegenPercentage()
	return self:GetAttrValue("health_regen_pct")
end

--------------------------------------------------------------------------------