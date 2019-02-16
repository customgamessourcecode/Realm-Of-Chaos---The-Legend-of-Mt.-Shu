
-- NPC商店
NPCShops = {
	["npc_task_yufu"] = {
		["item_0009"]={},["item_0137"]={},
	},
	["npc_task_zahuopulaoban"] = {
		["item_0135"]={},["item_0136"]={},["item_0001"]={},["item_0002"]={},["item_0003"]={},
		["item_0010"]={},["item_0016"]={},["item_0020"]={},["item_0037"]={},["item_0044"]={},
		["item_0047"]={},["item_0062"]={},["item_0066"]={},["item_0067"]={},["item_0071"]={},
		["item_0074"]={},["item_0075"]={},["item_0097"]={},

		-- 天命 - 左右逢源
		["item_0523"]={fate="zuoyoufengyuan",cost=15000},["item_0524"]={fate="zuoyoufengyuan",cost=15000},
		["item_0522"]={fate="zuoyoufengyuan",cost=15000},
	},
	["npc_task_chuansongshi"] = {
		["item_teleport_fushucun"]={tooltip="minimap", action="teleport"},["item_teleport_shushan"]={tooltip="minimap", action="teleport"},
		["item_teleport_qiannianxueshan"]={tooltip="minimap", action="teleport"},
		["item_teleport_chiyouzhong"]={tooltip="minimap", action="teleport"},
		["item_teleport_kunlun"]={tooltip="minimap", action="teleport"},
	},
	["npc_task_heishishangren"] = {
		["item_0152"]={},["item_0153"]={},["item_0154"]={},["item_0155"]={},["item_0156"]={},["item_0211"]={},
		["item_0591"]={cost=10000},["item_0592"]={cost=10000},

		-- 天命 - 左右逢源
		["item_0182"]={fate="zuoyoufengyuan",cost=10000},["item_0185"]={fate="zuoyoufengyuan",cost=10000},
		["item_0525"]={fate="zuoyoufengyuan",cost=50000},["item_0526"]={fate="zuoyoufengyuan",cost=50000},
	},
}

-- 积分商店
PointsShops = {
	["ProtectFortPoints"] = {
		["item_0035"]={cost=10}, ["item_0061"]={cost=30}, ["item_0070"]={cost=90}, ["item_0078"]={cost=270},
		["item_0084"]={cost=810},["item_0081"]={cost=300},["item_0080"]={cost=300},["item_0082"]={cost=300},
		["item_0079"]={cost=300},
	},
	["HuntingPoints"] = {
		["item_0081"]={cost=30}, ["item_0080"]={cost=30}, ["item_0082"]={cost=30}, ["item_0079"]={cost=30},
		["item_0152"]={cost=5},  ["item_0153"]={cost=10}, ["item_0154"]={cost=15}, ["item_0155"]={cost=25},
		["item_0156"]={cost=50},
	},
}

-- 物品出售价格按照品质进行调整
for k,v in pairs(NPCShops) do
	for itemname, t in pairs(v) do
		if t.cost == nil then
			local cost = GetItemCost(itemname)
			if cost > 0 then
				t.cost = cost
			else
				if ItemConfig[itemname] ~= nil then
					local quality = ItemConfig[itemname]["quality"]
					if quality == 1 then
						t.cost = 100
					elseif quality == 2 then
						t.cost = 900
					elseif quality == 3 then
						t.cost = 1800
					elseif quality == 4 then
						t.cost = 2600
					elseif quality == 5 then
						t.cost = 4800
					elseif quality == 6 then
						t.cost = 5600
					elseif quality == 7 then
						t.cost = 6200
					elseif quality == 8 then
						t.cost = 6800
					end
				else
					t.cost = 100
				end
			end
		end
	end
		
end

CustomNetTables:SetTableValue("Common", "PointsShops", PointsShops)