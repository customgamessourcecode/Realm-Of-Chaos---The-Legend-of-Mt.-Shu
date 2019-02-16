
CustomEvents('avalon_custom_spell_item_drop', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local item = EntIndexToHScript(data.item or -1)
	if not item then return end

	local slot = _G['Custom_Item_Spell_System_Slot_'..tostring((data.slot or -1) + 1)]
	CustomItemSpellSystem:SetSlot(hero, slot, item)
end)

CustomEvents('avalon_custom_spell_item_swap', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local slot1 = _G['Custom_Item_Spell_System_Slot_'..tostring((data.slot1 or -1) + 1)]
	local slot2 = _G['Custom_Item_Spell_System_Slot_'..tostring((data.slot2 or -1) + 1)]
	CustomItemSpellSystem:SwapAbilities(hero, slot1, slot2)
end)

CustomEvents('avalon_custom_spell_item_release', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local slot = _G['Custom_Item_Spell_System_Slot_'..tostring((data.slot or -1) + 1)]
	CustomItemSpellSystem:Release(hero, slot)
end)