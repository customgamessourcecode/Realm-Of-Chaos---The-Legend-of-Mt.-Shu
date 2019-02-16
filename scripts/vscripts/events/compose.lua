

CustomEvents('avalon_compose_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	ComposeSystem:ComposeForUI(hero, data.index or -1, data.itemname or "")
end)

CustomEvents('avalon_mixing_weapon', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	MixingWeapon:ComposeForUI(hero, data.recipe or -1, data.stage or -1, data.index or -1)
end)