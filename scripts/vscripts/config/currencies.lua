
--[[
货币相关的配置
]]

-- 货币类型
CURRENCY_TYPE_GOLD = 1		--金币
CURRENCY_TYPE_WOOD = 2		--木材
CURRENCY_TYPE_YUANHUI = 3	--元会
CURRENCY_TYPE_PROTECT_FORT_POINTS = 4	--守家积分
CURRENCY_TYPE_HUNTING_POINTS = 5	--狩猎积分
CURRENCY_TYPE_ASSIGN_ATTRIBUTE_POINTS = 6	--可分配属性点
CURRENCY_TYPE_DAO_HENG = 7	--道行

-- 货币配置
CurrenciesConfig = {
	[CURRENCY_TYPE_GOLD] = {name="gold", min=0, max=-1, default=625, msg="#avalon_msg_not_enough_gold"},
	[CURRENCY_TYPE_WOOD] = {name="wood", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_wood"},
	[CURRENCY_TYPE_YUANHUI] = {name="yuanhui", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_yuanhui"},
	[CURRENCY_TYPE_PROTECT_FORT_POINTS] = {name="protect_fort_points", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_protect_fort_points"},
	[CURRENCY_TYPE_HUNTING_POINTS] = {name="hunting_points", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_hunting_points"},
	[CURRENCY_TYPE_ASSIGN_ATTRIBUTE_POINTS] = {name="assign_attribute_points", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_assign_attribute_points"},
}

CurrenciesConfig[CURRENCY_TYPE_DAO_HENG] = {name="daoheng", min=0, max=-1, default=0, msg="#avalon_msg_not_enough_daoheng", 
	OnUpdate=function (owner, amount)
		if amount >= 100 and owner:SpendDaoHeng(100) then
			owner:GiveYuanHui(1)
		end
	end}