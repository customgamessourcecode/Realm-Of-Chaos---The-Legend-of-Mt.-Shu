

--[[
*********************** Avalon Studio ***********************

Member: RobinCode

*************************************************************
]]

-- 是否开启Debug相关的功能
-- 正式上线的时候将此值设置为false
_G['TurnCustomGameDebug'] = IsInToolsMode()

-- Reload
local state = GameRules:State_Get()
if state > DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
	print("reload script")
	require("autoload")
end

_G['ShushanPlayerSelectHero'] = {}

--[[
Auto load lua files, exmple: autoload({'abc','exp.abc'}), if prefix='utils', {'utils.abc','utils.exp.abc'}

@params t table
@params [prefix] string
@return void
]]
_G['autoload'] = function (t,prefix)
	prefix = prefix or ""
	if prefix == "" then
		for i,v in ipairs(t) do
			require(v)
		end
	else
		prefix = prefix..'.'
		for i,v in ipairs(t) do
			require(prefix..v)
		end
	end
end

if CShuShanGameMode == nil then
	CShuShanGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

	PrecacheResource( "soundfile", "soundevents/custom_game/shushan_abilities.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/override_dota_sound.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/abilities.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/abilities_fb_units.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/ui/common.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/unit_death/fb_01.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/unit_death/fb_03.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/unit_death/fb_04.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/unit_death/fb_05.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/unit_death/fb_06.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/collect_ores.vsndevts", context )

	-- heroes
	PrecacheResource( "soundfile", "soundevents/custom_game/heroes/yunlian.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/heroes/moluo.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/heroes/mengyan.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/heroes/humei.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/heroes/muyue.vsndevts", context )

	PrecacheResource( "particle_folder", "particles/avalon", context )
	PrecacheResource( "particle_folder", "particles/avalon/wings", context )
	PrecacheResource( "particle_folder", "particles/avalon/quests", context )
	PrecacheResource( "particle_folder", "particles/avalon/quests/quests_accepted", context )
	PrecacheResource( "particle_folder", "particles/avalon/quests/quests_finished", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_lycan", context )
	PrecacheResource( "particle_folder", "particles/bosses", context )
	PrecacheResource( "particle_folder", "particles/heroes", context )

	
	
	PrecacheResource( "particle", "particles/avalon/evade_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_front.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf", context )
	

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )

	local units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	local finished = function() end
	for name in pairs(units) do
		PrecacheUnitByNameAsync(name, finished, -1)
	end

	require('config.courier_list')
	for i,v in ipairs(ShuShanCourierList) do
		PrecacheResource( "model", v, context )
	end
end

function Activate()
	GameRules.ShuShan = CShuShanGameMode()
	GameRules.ShuShan:InitGameMode()
end


function CShuShanGameMode:InitGameMode()
	if TurnCustomGameDebug then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
			local m = collectgarbage('count')
			print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m/1024))
			return 20
		end, 0)
	end
	
	require('autoload')

	-- 定时清理垃圾
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
		collectgarbage('collect')
		return 600
	end, 600)

	CustomNetTables:SetTableValue("Common", "GameSetupInfoTable", {GameRateLevel=1,Difficulty=1} )
end