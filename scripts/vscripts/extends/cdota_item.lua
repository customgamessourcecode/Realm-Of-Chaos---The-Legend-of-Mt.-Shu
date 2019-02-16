
--@Class CDOTA_Item

function CDOTA_Item:GetQuality()
	local conf = ItemConfig[self:GetAbilityName()]
	if not conf then return -1 end
	return conf["quality"]
end

function CDOTA_Item:GetCustomData()
	local data = {

		-- 炼化物品成功率
		fuse_items_system_chance = self:Attribute_GetFloatValue("fuse_items_system_chance",-1.0),
	}

	return data
end
