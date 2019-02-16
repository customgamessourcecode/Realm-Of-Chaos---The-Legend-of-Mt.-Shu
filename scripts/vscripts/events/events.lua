
if GameEvents == nil then
	GameEvents = {}
end

if CustomEvents == nil then
	CustomEvents = {}
	setmetatable(CustomEvents,CustomEvents)

	function CustomEvents:__call(event,func)
		if CustomEvents[event] == nil then
			if IsInToolsMode() then
				CustomGameEventManager:RegisterListener(event, function(...)
					CustomEvents[event](...)
				end)
			else
				CustomGameEventManager:RegisterListener(event, func)
			end
		end
		CustomEvents[event] = func
	end
end

if Filter == nil then
	Filter = {}
end

autoload({
	'game',
	'custom',
	'filter',
	'quests',
	'bag',
	'compose',
	'custom_item_spell_system',
	'modal_dialog',
	'decompose',
	'attached_soul',
	'public_stash',
	'select_npc',
	'select_hero',
},'events')

------------------------------------------------------------------------------------------------------------

if __AvalonEvents__ == nil then
	__AvalonEvents__ = {}
end

local m_IsFirstSpawnEntity = Avalon:Forever('__AvalonEvents__m_IsFirstSpawnEntity',{})

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnGameRulesStateChange( keys )
	local state = GameRules:State_Get()

	--------------------- 设置队伍阶段 ---------------------
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		print("[Game State]: Custom Game Setup")
		GameEvents:GameStateCustomGameSetup()

	--------------------- 选择英雄阶段 ---------------------
	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print("[Game State]: Hero Selection")
		GameEvents:GameStateHeroSelection()

	----------------------- 决策阶段 -----------------------
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		print("[Game State]: Strategy time")
		GameEvents:GameStateStrategyTime()

	--------------------- 队伍展示阶段 ---------------------
	elseif state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		print("[Game State]: Team showcase")
		GameEvents:GameStateTeamShowcase()

	------------------- 等待地图加载阶段 -------------------
	elseif state == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		print("[Game State]: Wait for map to load")
		GameEvents:GameStateWaitForMapToLoad()

	----------------------- 预备阶段 -----------------------
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		print("[Game State]: PreGame")
		GameEvents:GameStatePreGame()

	----------------------- 开始游戏 -----------------------
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print("[Game State]: Game In Progress")
		GameEvents:GameStateInProgress()

	----------------------- 游戏结束 -----------------------
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		print("[Game State]: Post Game")
		GameEvents:GameStatePostGame()
	end
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnNPCSpawned( keys )
	local index = keys.entindex
	local ent = EntIndexToHScript(index)

	if ent:UnitCanRespawn() and m_IsFirstSpawnEntity[index] == nil then
		if GameRules:State_Get() <= DOTA_GAMERULES_STATE_HERO_SELECTION then return end
		m_IsFirstSpawnEntity[index] = true
		GameEvents:OnUnitFirstSpawn(ent,index)
	end

	GameEvents:OnNPCSpawned(ent,index)
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnPlayerLevelUp( keys )
	local player = EntIndexToHScript(keys.player)

	if player == nil then return end

	local hero = player:GetAssignedHero()

	GameEvents:OnPlayerLevelUp( player, hero, keys.level )
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnPlayerConnectFull( keys )
	
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnEntityKilled( keys )
	local victim = EntIndexToHScript(keys.entindex_killed or -1)
	local attacker = EntIndexToHScript(keys.entindex_attacker or -1)
	local ability = EntIndexToHScript(keys.entindex_inflictor or -1)

	GameEvents:OnEntityKilled( attacker, victim, ability, keys.damagebits )
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnPlayerReconnected( keys )
	GameEvents:OnPlayerReconnected( keys.PlayerID, PlayerResource:GetPlayer(keys.PlayerID) )
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnItemPickedUp( keys )
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = EntIndexToHScript(keys.HeroEntityIndex or -1)
	local item = EntIndexToHScript(keys.ItemEntityIndex or -1)

	GameEvents:OnItemPickedUp( player, hero, item, keys.itemname )
end

------------------------------------------------------------------------------------------------------------

function __AvalonEvents__:__OnPlayerChat( keys )
	local text = keys.text
	if IsInToolsMode() then
		if text == "-reload" then
			SendToServerConsole("script_reload")
			return
		elseif text == "-restart" then
			SendToServerConsole("restart")
			return
		end
	end
	if TurnCustomGameDebug then
		if string.find(text,"-") == 1 then
			local t = vlua.split(text,' ')
			local name = string.sub(t[1],2,#t[1])
			table.remove(t,1)
			CustomTest(name, keys.playerid, PlayerResource:GetPlayer(keys.playerid), t)
		end
	end
	GameEvents:OnPlayerChat( keys.teamonly, keys.playerid, PlayerResource:GetPlayer(keys.playerid), text )
end

function __AvalonEvents__:__OnPlayerTeamChange(keys)
	GameEvents:OnPlayerTeamChange( keys.team, keys.oldteam, keys.disconnect==1 )
end

------------------------------------------------------------------------------------------------------------

if __AvalonEventsInit__ == nil then
	__AvalonEventsInit__ = true
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( __AvalonEvents__, "__OnGameRulesStateChange" ), __AvalonEvents__ )

	ListenToGameEvent("npc_spawned", Dynamic_Wrap( __AvalonEvents__, "__OnNPCSpawned" ), __AvalonEvents__ )

	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap( __AvalonEvents__, "__OnPlayerLevelUp" ), __AvalonEvents__ )

	ListenToGameEvent("player_connect_full", Dynamic_Wrap(__AvalonEvents__, "__OnPlayerConnectFull"), __AvalonEvents__)

	ListenToGameEvent("entity_killed", Dynamic_Wrap(__AvalonEvents__, "__OnEntityKilled"), __AvalonEvents__)

	ListenToGameEvent("player_reconnected", Dynamic_Wrap(__AvalonEvents__, "__OnPlayerReconnected"), __AvalonEvents__)

	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(__AvalonEvents__, "__OnItemPickedUp"), __AvalonEvents__)

	ListenToGameEvent("player_chat", Dynamic_Wrap(__AvalonEvents__, "__OnPlayerChat"), __AvalonEvents__)

	ListenToGameEvent("player_team", Dynamic_Wrap(__AvalonEvents__, "__OnPlayerTeamChange"), __AvalonEvents__)

	-- GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(Filter, "AbilityTuningValueFilter"),Filter)
	-- GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(Filter, "BountyRunePickupFilter"),Filter)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(Filter, "DamageFilter"),Filter)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(Filter, "ExecuteOrderFilter"),Filter)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(Filter, "ModifierGainedFilter"),Filter)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(Filter, "ModifyExperienceFilter"),Filter)
	-- GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(Filter, "RuneSpawnFilter"),Filter)
	-- GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(Filter, "TrackingProjectileFilter"),Filter)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(Filter, "ItemAddedToInventory"),Filter)
end