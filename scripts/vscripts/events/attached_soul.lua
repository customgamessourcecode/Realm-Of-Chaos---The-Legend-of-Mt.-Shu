
CustomEvents('shushan_attached_soul_drap', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local item = EntIndexToHScript(data.item or -1)
	if item == nil then return end

	AttachedSoul:BindItem(hero,item)
end)

CustomEvents('shushan_attached_soul', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	AttachedSoul:Attached(hero)
end)