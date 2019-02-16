local ShushanHeroList = {
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_centaur",
}

local SpecialsShuShanHero = {
	["npc_dota_hero_legion_commander"] = "ShuShanHeroMoLuo",
	["npc_dota_hero_slark"] = "ShuShanHeroYunLian",
	["npc_dota_hero_spectre"] = "ShuShanHeroMengYan",
	["npc_dota_hero_lina"] = "ShuShanHeroHuMei",
	["npc_dota_hero_templar_assassin"] = "ShuShanHeroMuYue",
}

-- 自定义选择英雄
CustomEvents('avalon_select_hero', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end
	if ShushanPlayerSelectHero[data.PlayerID] ~= nil then return end

	local heroname = data.heroname or ""
	if heroname == "" then return end

	-- if IsInToolsMode() then
	-- 	SpecialsShuShanHero[heroname] = nil
	-- 	CreateHeroForPlayer(heroname, player):RemoveSelf()
	-- 	ShushanPlayerSelectHero[data.PlayerID] = heroname
	-- 	CustomNetTables:SetTableValue("Common", "ShushanPlayerSelectHero", ShushanPlayerSelectHero )
	-- 	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_has_select_hero_response", {has=true,heroname=heroname})
	-- 	return
	-- end

	if SpecialsShuShanHero[heroname] ~= nil then
		local steamid = tostring(PlayerResource:GetSteamID(data.PlayerID))
		if ShushanPlayerSelectHero[data.PlayerID] == nil and HasShuShanStoreItem(steamid, SpecialsShuShanHero[heroname]) then
			SpecialsShuShanHero[heroname] = nil
			CreateHeroForPlayer(heroname, player):RemoveSelf()
			ShushanPlayerSelectHero[data.PlayerID] = heroname
			CustomNetTables:SetTableValue("Common", "ShushanPlayerSelectHero", ShushanPlayerSelectHero )
			CustomGameEventManager:Send_ServerToPlayer(player, "avalon_has_select_hero_response", {has=true,heroname=heroname})
			return
		end
	end

	for i,v in ipairs(ShushanHeroList) do
		if v == heroname then
			table.remove(ShushanHeroList,i)

			CreateHeroForPlayer(heroname, player):RemoveSelf()
			ShushanPlayerSelectHero[data.PlayerID] = heroname
			CustomNetTables:SetTableValue("Common", "ShushanPlayerSelectHero", ShushanPlayerSelectHero )
			CustomGameEventManager:Send_ServerToPlayer(player, "avalon_has_select_hero_response", {has=true,heroname=heroname})

			return
		end
	end
end)

CustomEvents('avalon_has_select_hero', function(e, data)
	if data.PlayerID == nil then return end
	
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_has_select_hero_response", {has=ShushanPlayerSelectHero[data.PlayerID]~=nil,heroname=ShushanPlayerSelectHero[data.PlayerID]})
end)

CustomEvents('avalon_can_select_hero', function(e, data)
	if data.PlayerID == nil then return end
	
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local heroname = data.heroname or ""
	if heroname == "" then return end

	-- if IsInToolsMode() then
	-- 	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_can_select_hero_response", {can=true})
	-- 	return
	-- end

	if SpecialsShuShanHero[heroname] ~= nil then
		local steamid = tostring(PlayerResource:GetSteamID(data.PlayerID))
		if HasShuShanStoreItem(steamid, SpecialsShuShanHero[heroname]) then

			for k,v in pairs(ShushanPlayerSelectHero) do
				if v == heroname then
					CustomGameEventManager:Send_ServerToPlayer(player, "avalon_can_select_hero_response", {can=false})
					return
				end
			end

			CustomGameEventManager:Send_ServerToPlayer(player, "avalon_can_select_hero_response", {can=true})
			return
		end
	end

	for i,v in ipairs(ShushanHeroList) do
		if v == heroname then
			CustomGameEventManager:Send_ServerToPlayer(player, "avalon_can_select_hero_response", {can=true})
			return
		end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_can_select_hero_response", {can=false})
end)

CustomEvents('avalon_random_select_hero', function(e, data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end
	if ShushanPlayerSelectHero[data.PlayerID] ~= nil then return end

	local i = RandomInt(1, #ShushanHeroList)
	local heroname = table.remove(ShushanHeroList,i)

	CreateHeroForPlayer(heroname, player):RemoveSelf()
	ShushanPlayerSelectHero[data.PlayerID] = heroname
	CustomNetTables:SetTableValue("Common", "ShushanPlayerSelectHero", ShushanPlayerSelectHero )
	CustomGameEventManager:Send_ServerToPlayer(player, "avalon_has_select_hero_response", {has=true,heroname=heroname})
end)