
--@class CDOTA_Item

local public = CDOTA_Item

-- 设置属性
function public:SetCustomAttribute(name, value)
	if self.__CustomAttributes == nil then
		self.__CustomAttributes = {}
	end
	self.__CustomAttributes[name] = value

	DelayDispatch(0.06, self:GetEntityIndex(), self.UpdateCustomAttribute, self)
end

function public:HasCustomAttributes()
	return self.__CustomAttributes ~= nil
end

-- 设置属性
function public:SetCustomAttributeFromTable(t)
	if not t then return end
	for k,v in pairs(t) do
		self:SetCustomAttribute(k, v)
	end
end

-- 获取属性
function public:GetCustomAttribute(name,defaultValue)
	local value = self.__CustomAttributes[name] or (defaultValue or 0)
	
	if name == "sword_coefficient" then
		value = value + self:GetSpecialValueFor("weapon_mult_sword")
	elseif name == "knife_coefficient" then
		value = value + self:GetSpecialValueFor("weapon_mult_knife")
	elseif name == "blade_coefficient" then
		value = value + self:GetSpecialValueFor("weapon_mult_blade")
	elseif name == "caster_coefficient" then
		value = value + self:GetSpecialValueFor("weapon_mult_caster")
	elseif name == "lancer_coefficient" then
		value = value + self:GetSpecialValueFor("weapon_mult_lancer")
	elseif name == "sword_damage" then
		value = value + self:GetSpecialValueFor("bonus_sword_damage")
	elseif name == "knife_damage" then
		value = value + self:GetSpecialValueFor("bonus_knife_damage")
	elseif name == "blade_damage" then
		value = value + self:GetSpecialValueFor("bonus_blade_damage")
	elseif name == "caster_damage" then
		value = value + self:GetSpecialValueFor("bonus_caster_damage")
	elseif name == "lancer_damage" then
		value = value + self:GetSpecialValueFor("bonus_lancer_damage")
	end

	return value 
end

-- 修改属性
function public:ModifyCustomAttribute(name, value)
	local oldValue = self:GetCustomAttribute(name)

	oldValue = oldValue + value

	self:SetCustomAttribute(name, oldValue)
end

-- 获取所有属性
function public:GetAllCustomAttribute()
	return self.__CustomAttributes
end

-- 更新
function public:UpdateCustomAttribute()
	CustomNetTables:SetTableValue("CustomAttributes", tostring(self:GetEntityIndex()),self:GetAllCustomAttribute())
end

