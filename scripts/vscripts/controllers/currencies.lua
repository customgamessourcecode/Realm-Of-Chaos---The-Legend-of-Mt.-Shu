
if CurrenciesCtrl == nil then
	CurrenciesCtrl = RegisterController('currencies')
	CurrenciesCtrl.__player_currencies = {}
	setmetatable(CurrenciesCtrl,CurrenciesCtrl)
end

local public = CurrenciesCtrl

-- 初始化
function public:__call(hero)

	local t = {}

	for k,v in pairs(CurrenciesConfig) do
		t[k] = v.default or 0
	end

	self.__player_currencies[hero:GetEntityIndex()] = t
	self:Update(hero)
end

-- 更新
function public:Update(hero)
	local currencies = public.__player_currencies[hero:GetEntityIndex()]
	CustomNetTables:SetTableValue("Common", "currencies_"..hero:GetEntityIndex(),  currencies)
end

-- 获取货币数量
function CDOTA_BaseNPC_Hero:GetCurrency(_type)
	local currencies = public.__player_currencies[self:GetEntityIndex()]
	if not currencies then return 0 end
	return currencies[_type] or 0
end

-- 修改货币数量
function CDOTA_BaseNPC_Hero:ModifyCurrency(_type, _amount)
	local amount = self:GetCurrency(_type) + _amount
	self:SetCurrency(_type, amount)
end

-- 设置货币数量
function CDOTA_BaseNPC_Hero:SetCurrency(_type, amount)
	local conf = CurrenciesConfig[_type]
	if not conf then return end

	if conf.min ~= -1 and amount < conf.min then
		amount = conf.min
	end

	if conf.max ~= -1 and amount > conf.max then
		amount = conf.max
	end

	local currencies = public.__player_currencies[self:GetEntityIndex()]
	if currencies == nil then return end
	currencies[_type] = amount

	if conf.OnUpdate then conf.OnUpdate(self, amount) end

	public:Update(self)
end

-- 花费货币
function CDOTA_BaseNPC_Hero:SpendCurrency(_type, amount)
	if amount < 0 then return false end
	if amount == 0 then return true end

	local _amount = self:GetCurrency(_type)
	if _amount >= amount then
		self:ModifyCurrency(_type, -amount)
		return true
	else
		local conf = CurrenciesConfig[_type]
		if conf then
			self:ShowCustomMessage({type="bottom",msg=conf.msg,class="error"})
		end
	end

	return false
end

-- 花费金币
function CDOTA_BaseNPC_Hero:SpendGold(amount)
	return self:SpendCurrency(CURRENCY_TYPE_GOLD, amount)
end

-- 给予金币
function CDOTA_BaseNPC_Hero:GiveGold(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_GOLD, amount)
end

-- 获取金币
function CDOTA_BaseNPC_Hero:GetGold()
	return self:GetCurrency(CURRENCY_TYPE_GOLD)
end

-- 花费木材
function CDOTA_BaseNPC_Hero:SpendWood(amount)
	return self:SpendCurrency(CURRENCY_TYPE_WOOD, amount)
end

-- 给予木材
function CDOTA_BaseNPC_Hero:GiveWood(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_WOOD, amount)
end

-- 花费元会
function CDOTA_BaseNPC_Hero:SpendYuanHui(amount)
	return self:SpendCurrency(CURRENCY_TYPE_YUANHUI, amount)
end

-- 给予元会
function CDOTA_BaseNPC_Hero:GiveYuanHui(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_YUANHUI, amount)
end

-- 获取元会
function CDOTA_BaseNPC_Hero:GetYuanHui()
	return self:GetCurrency(CURRENCY_TYPE_YUANHUI)
end

-- 花费守家积分
function CDOTA_BaseNPC_Hero:SpendProtectFortPoints(amount)
	return self:SpendCurrency(CURRENCY_TYPE_PROTECT_FORT_POINTS, amount)
end

-- 给予守家积分
function CDOTA_BaseNPC_Hero:GiveProtectFortPoints(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_PROTECT_FORT_POINTS, amount)
end

-- 花费狩猎积分
function CDOTA_BaseNPC_Hero:SpendHuntingPoints(amount)
	return self:SpendCurrency(CURRENCY_TYPE_HUNTING_POINTS, amount)
end

-- 给予狩猎积分
function CDOTA_BaseNPC_Hero:GiveHuntingPoints(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_HUNTING_POINTS, amount)
end

-- 花费属性点
function CDOTA_BaseNPC_Hero:SpendAssignAttributePoints(amount)
	return self:SpendCurrency(CURRENCY_TYPE_ASSIGN_ATTRIBUTE_POINTS, amount)
end

-- 给予属性点
function CDOTA_BaseNPC_Hero:GiveAssignAttributePoints(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_ASSIGN_ATTRIBUTE_POINTS, amount)
end

-- 获取属性点
function CDOTA_BaseNPC_Hero:GetAssignAttributePoints()
	return self:GetCurrency(CURRENCY_TYPE_ASSIGN_ATTRIBUTE_POINTS)
end

-- 花费道行
function CDOTA_BaseNPC_Hero:SpendDaoHeng(amount)
	return self:SpendCurrency(CURRENCY_TYPE_DAO_HENG, amount)
end

-- 给予道行
function CDOTA_BaseNPC_Hero:GiveDaoHeng(amount)
	if amount <= 0 then return end
	self:ModifyCurrency(CURRENCY_TYPE_DAO_HENG, amount)
end