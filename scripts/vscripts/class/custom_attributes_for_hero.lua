
--@class CDOTA_BaseNPC_Hero

local public = CDOTA_BaseNPC_Hero

-- 设置子属性
function public:SetCustomAttribute(name, childKey, value)
	local children = self:GetCustomAttributeChildren(name)
	children[childKey] = value
end

-- 修改子属性
function public:ModifyCustomAttribute(name, childKey, value)
	local oldValue = self:GetCustomAttributeChild(name, childKey)
	local children = self:GetCustomAttributeChildren(name)
	self:SetCustomAttribute(name, childKey, oldValue + value)
end

-- 获取子属性
function public:GetCustomAttributeChild(name, childKey, defaultValue)
	local children = self:GetCustomAttributeChildren(name)
	return children[childKey] or defaultValue or 0
end

-- 获取子属性合集
function public:GetCustomAttributeChildren(name)
	local children = self.__CustomAttributesChildren[name]

	if children == nil then
		children = {}
		self.__CustomAttributesChildren[name] = children
	end

	return children
end

-- 获取属性
function public:GetCustomAttribute(name,defaultValue)
	local value = 0
	defaultValue = defaultValue or 0

	for i=0,5 do
		local item = self:GetItemInSlot(i)
		if item then
			value = value + item:GetCustomAttribute(name,defaultValue)
		end
	end

	local children = self:GetCustomAttributeChildren(name)
	for k,v in pairs(children) do
		value = value + v
	end

	return value
end

-- 获取所有属性
function public:GetAllCustomAttribute()
	local t = self.__CustomAttributes

	for k,v in pairs(CustomAttributesConfig) do
		if v == 'magic_armor' then
			local fixed = 0
			if self:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
				fixed = (self:GetStrength()) * 0.1
			else
				fixed = (self:GetStrength()) * 0.08
			end
			t[v] = 0
			local attr = (self:GetStrength() + self:GetAgility() + self:GetIntellect()) / 3
			local base = 32 + self:GetCustomAttribute(v) + attr*0.008
			local result = base/100
			local y = 1 - fixed/100
			local x = (result-1)/y + 1
			self:SetBaseMagicalResistanceValue(x*100)
		else
			t[v] = self:GetCustomAttribute(v)
		end
	end

	return t
end

-- 
function public:StatisticalAttributes()
	local t = self.__All_Attributes
	for k,v in pairs(CustomAttributesConfig) do
		if v == "str" then
			t[v] = self:GetStrength()
		elseif v == "agi" then
			t[v] = self:GetAgility()
		elseif v == "int" then
			t[v] = self:GetIntellect()
		elseif v == "hp" then
			t[v] = self:GetMaxHealth()
		elseif v == "mana" then
			t[v] = self:GetMaxMana()
		elseif v == "armor" then
			t[v] = self:GetPhysicalArmorValue()
		elseif v == "magic_armor" then
			t[v] = 25 + self:GetCustomAttribute(v)
		elseif v == "health_regen" then
			t[v] = self:GetHealthRegen()
		elseif v == "mana_regen" then
			t[v] = self:GetManaRegen()
		elseif v == "attack_speed" then
			t[v] = self:GetIncreasedAttackSpeed() * 100
		elseif v == "move_speed" then
			t[v] = self:GetMoveSpeedModifier(self:GetBaseMoveSpeed())
		else
			t[v] = self:GetCustomAttribute(v)
		end
	end
	return t
end
