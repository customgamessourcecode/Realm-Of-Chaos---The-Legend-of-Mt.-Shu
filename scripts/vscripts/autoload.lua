
autoload({
	"config.config",
	"avalon.avalon",
	"extends.extends",
	"class.class",
	"controllers.controllers",
	"events.events",
	"utils.quests",
	"utils.methods",
	"utils.specials",
	"utils.particles_queue",
	"ai.dungeon_boss_model",
	"ai.attacking_model",
	"ai.pylai",
	'abilities.abilityGlobal',
})

-- Modifier Lua
LinkLuaModifier("modifier_invulnerable","modifiers/modifier_invulnerable",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_attributes","modifiers/modifier_custom_attributes",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_refresh","modifiers/modifier_refresh",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_qwd","modifiers/modifier_qwd",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_stun","modifiers/modifier_custom_stun",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_stun2","modifiers/modifier_custom_stun2",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yunlian_defense","modifiers/modifier_yunlian_defense",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_damage","modifiers/modifier_immune_damage",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_no_draw","modifiers/modifier_no_draw",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shushan_fort","modifiers/modifier_shushan_fort",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invisible_level","modifiers/modifier_invisible_level",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shushan_boss","modifiers/modifier_shushan_boss",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shushan_boss_casting","modifiers/modifier_shushan_boss_casting",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_invisible","modifiers/modifier_custom_invisible",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shushan_evade","modifiers/modifier_shushan_evade",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_daocaoren","modifiers/modifier_daocaoren",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attacking_boss","modifiers/modifier_attacking_boss",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dungeon_unit_recycling","modifiers/modifier_dungeon_unit_recycling",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invulnerable_fake","modifiers/modifier_invulnerable_fake",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_quests_reward_kaiyi","modifiers/modifier_quests_reward_kaiyi",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fushuizhifeng_kill_reward","modifiers/modifier_fushuizhifeng_kill_reward",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_stunned","modifiers/modifier_custom_stunned",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fixed_armor","modifiers/modifier_fixed_armor",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fixed_armor_for_hero","modifiers/modifier_fixed_armor_for_hero",LUA_MODIFIER_MOTION_NONE)


--[[
物品Modifiers
]]
LinkLuaModifier("modifier_item_0206","modifiers/items/modifier_item_0206",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_0217","modifiers/items/modifier_item_0217",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_0454_effect","modifiers/items/modifier_item_0454_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_0455_effect","modifiers/items/modifier_item_0455_effect",LUA_MODIFIER_MOTION_NONE)

--[[
套装Modifiers
]]
LinkLuaModifier("modifier_item_suit_biheluori","modifiers/item_suit/modifier_item_suit_biheluori",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_lieyan","modifiers/item_suit/modifier_item_suit_lieyan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_lieyan_damage","modifiers/item_suit/modifier_item_suit_lieyan_damage",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_bingfeng","modifiers/item_suit/modifier_item_suit_bingfeng",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_bingfeng_effect","modifiers/item_suit/modifier_item_suit_bingfeng_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_bingyan","modifiers/item_suit/modifier_item_suit_bingyan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_wuzu","modifiers/item_suit/modifier_item_suit_wuzu",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_wuran","modifiers/item_suit/modifier_item_suit_wuran",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_wuran_effect","modifiers/item_suit/modifier_item_suit_wuran_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_duanxie","modifiers/item_suit/modifier_item_suit_duanxie",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_duanxie_effect","modifiers/item_suit/modifier_item_suit_duanxie_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_yinze","modifiers/item_suit/modifier_item_suit_yinze",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_liudao","modifiers/item_suit/modifier_item_suit_liudao",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_liudao_effect","modifiers/item_suit/modifier_item_suit_liudao_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_shichuan","modifiers/item_suit/modifier_item_suit_shichuan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_washenmo","modifiers/item_suit/modifier_item_suit_washenmo",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_washenxian","modifiers/item_suit/modifier_item_suit_washenxian",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_shengling","modifiers/item_suit/modifier_item_suit_shengling",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_niepan","modifiers/item_suit/modifier_item_suit_niepan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_guiyuan","modifiers/item_suit/modifier_item_suit_guiyuan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_zhanyun","modifiers/item_suit/modifier_item_suit_zhanyun",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_poyu","modifiers/item_suit/modifier_item_suit_poyu",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_poyu_effect","modifiers/item_suit/modifier_item_suit_poyu_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_binglie","modifiers/item_suit/modifier_item_suit_binglie",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_jihan","modifiers/item_suit/modifier_item_suit_jihan",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_jihan_for_self","modifiers/item_suit/modifier_item_suit_jihan_for_self",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_jihan_for_enemy","modifiers/item_suit/modifier_item_suit_jihan_for_enemy",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_lishang","modifiers/item_suit/modifier_item_suit_lishang",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_lishang_effect","modifiers/item_suit/modifier_item_suit_lishang_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_buluominghe","modifiers/item_suit/modifier_item_suit_buluominghe",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_wuxie","modifiers/item_suit/modifier_item_suit_wuxie",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_tianqiong","modifiers/item_suit/modifier_item_suit_tianqiong",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_hanxue","modifiers/item_suit/modifier_item_suit_hanxue",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_jiuli","modifiers/item_suit/modifier_item_suit_jiuli",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_suit_wuxie_two","modifiers/item_suit/modifier_item_suit_wuxie_two",LUA_MODIFIER_MOTION_NONE)


--[[
翅膀Modifiers
]]
LinkLuaModifier("tian_gang_zhan_yi_lv01","modifiers/wings/tian_gang_zhan_yi_lv01",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tian_gang_zhan_yi_lv02","modifiers/wings/tian_gang_zhan_yi_lv02",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tian_gang_zhan_yi_lv03","modifiers/wings/tian_gang_zhan_yi_lv03",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tian_gang_zhan_yi_lv04","modifiers/wings/tian_gang_zhan_yi_lv04",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tian_gang_zhan_yi_lv05","modifiers/wings/tian_gang_zhan_yi_lv05",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("wan_he_fa_yi_enemy_effect","modifiers/wings/wan_he_fa_yi_enemy_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wan_he_fa_yi_lv01","modifiers/wings/wan_he_fa_yi_lv01",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wan_he_fa_yi_lv02","modifiers/wings/wan_he_fa_yi_lv02",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wan_he_fa_yi_lv03","modifiers/wings/wan_he_fa_yi_lv03",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wan_he_fa_yi_lv04","modifiers/wings/wan_he_fa_yi_lv04",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wan_he_fa_yi_lv05","modifiers/wings/wan_he_fa_yi_lv05",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("shi_hun_mo_yi_enemy_effect","modifiers/wings/shi_hun_mo_yi_enemy_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("shi_hun_mo_yi_lv01","modifiers/wings/shi_hun_mo_yi_lv01",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("shi_hun_mo_yi_lv02","modifiers/wings/shi_hun_mo_yi_lv02",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("shi_hun_mo_yi_lv03","modifiers/wings/shi_hun_mo_yi_lv03",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("shi_hun_mo_yi_lv04","modifiers/wings/shi_hun_mo_yi_lv04",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("shi_hun_mo_yi_lv05","modifiers/wings/shi_hun_mo_yi_lv05",LUA_MODIFIER_MOTION_NONE)


--[[
命运Modifiers
]]
LinkLuaModifier("modifier_fate_fuhao","modifiers/fates/modifier_fate_fuhao",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_qingqiushanhouren","modifiers/fates/modifier_fate_qingqiushanhouren",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_tonglingshi","modifiers/fates/modifier_fate_tonglingshi",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_xunshoushi","modifiers/fates/modifier_fate_xunshoushi",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_xunshoushi_ling_lang","modifiers/fates/modifier_fate_xunshoushi_ling_lang",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_canjiren","modifiers/fates/modifier_fate_canjiren",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_shenyi_aura","modifiers/fates/modifier_fate_shenyi_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fate_shenyi_effect","modifiers/fates/modifier_fate_shenyi_effect",LUA_MODIFIER_MOTION_NONE)

if TurnCustomGameDebug or GameRules:IsCheatMode() then LinkLuaModifier("modifier_whosyourdaddy","modifiers/modifier_whosyourdaddy",LUA_MODIFIER_MOTION_NONE) end

--[[
Modifiers常用的table
]]
ShuShan_NPCTask_Modifier_States = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
}

ShuShan_Modifier_Funcs_OnTakeDamage = {
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

ShuShan_Modifier_Funcs_OnAttackLanded = {
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

ShuShan_Modifier_Funcs_TotalDamageOutgoing = {
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

ShuShan_Modifier_Funcs_IncomingDamage = {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

ShuShan_Modifier_Funcs_Tooltip = {
	MODIFIER_PROPERTY_TOOLTIP
}

ShuShan_Modifier_Funcs_MoveSpeedPercentage = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

ShuShan_Modifier_Funcs_AttackSpeedBonus = {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}



if IsInToolsMode() then
	function StartDebug()
		local mem = {}
		local data = {}
		local Hook = function (mask)
			-- local info = debug.getinfo(2)
			-- if info.name == nil then return end

			-- if mem[info.name] == nil then
			-- 	mem[info.name] = {}
			-- end

			-- if data[info.name] == nil then
			-- 	data[info.name] = 0
			-- end

			-- if mask == "call" then
			-- 	table.insert(mem[info.name],collectgarbage("count"))
			-- elseif mask == "return" then
			-- 	local c = #mem[info.name]
			-- 	if c == 0 then return end
			-- 	local last = table.remove(mem[info.name],c)
			-- 	local m = collectgarbage("count") - last
			-- 	data[info.name] = data[info.name] + m
			-- end
		end

		-- Timer(60,function ()
		-- 	print("=======================================================")
		-- 	local a = 0
		-- 	for k,v in pairs(data) do
		-- 		a = a + v
		-- 	end
		-- 	print(a*1024)
		-- 	print("=======================================================")
		-- 	return 60
		-- end)

		debug.sethook(Hook,"cr")
	end

	--StartDebug()
end