
CustomEvents('shushan_decompose_drap', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local slot = data.slot or -1
	local bag = hero:GetBag()
	local item = bag:GetItem(slot)
	if item == nil then return end

	DecomposeSystem:Bind(hero, item)
end)

CustomEvents('shushan_decompose_clear', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end
	
	DecomposeSystem:Clear(hero, item)
end)

CustomEvents('shushan_decompose', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	if data.slot == nil then
		DecomposeSystem:Decompose(hero)
	else
		local bag = hero:GetBag()
		local item = bag:GetItem(data.slot or -1)
		DecomposeSystem:Decompose(hero, item)
	end
end)