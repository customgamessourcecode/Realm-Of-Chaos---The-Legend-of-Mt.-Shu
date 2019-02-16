
if AttributesCtrl == nil then
	AttributesCtrl = RegisterController('custom_attributes')
	AttributesCtrl.__player_hero_attributes = {}
	AttributesCtrl.__items = {}
	setmetatable(AttributesCtrl,AttributesCtrl)
end

local public = AttributesCtrl

-- 获取实体的属性类
function public:__call(entity)

	if entity:IsBaseNPC() and entity:IsHero()  then

		if not entity:HasModifier("modifier_custom_attributes") then
			entity:AddNewModifier(entity, nil, "modifier_custom_attributes", nil)
		end

	end

	if entity.__CustomAttributes == nil then
		entity.__CustomAttributes = {}
		CustomNetTables:SetTableValue("CustomAttributes", tostring(entity:GetEntityIndex()),{})

		if entity:IsBaseNPC() and entity:IsHero()  then
			entity.__CustomAttributesChildren = {}
			entity.__All_Attributes = {}
		else
			entity:SetCustomAttributeFromTable(ItemCustomAttributes[entity:GetAbilityName()])
		end
	end

end

function public:MultiWeaponDamage(caster,weaponType,multi)
	local unique = DoUniqueString("MultiWeaponDamage")
	local weaponDamge = caster:GetCustomAttribute(weaponType.."_coefficient",0)
	caster:SetCustomAttribute(weaponType.."_coefficient",unique,multi)
	return unique
end

function public:ClearMultiWeaponDamage(caster,weaponType,unique)
	caster:SetCustomAttribute(weaponType.."_coefficient",unique,0)
end

function public:AddWeaponDamage(caster,weaponType,amount)
	local weaponDamge = caster:GetCustomAttribute(weaponType.."_coefficient",0)
	caster:SetCustomAttribute(weaponType.."_coefficient",DoUniqueString("MultiWeaponDamage"),weaponDamge+amount)
	return amount
end