
CustomEvents('avalon_public_stash_add_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	PublicStash:Add(hero, data.slot or -1)
end)

CustomEvents('avalon_public_stash_take_item', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	PublicStash:Take(hero, data.index or -1)
end)