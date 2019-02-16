
--[[
控制器主要作用是控制类的生成和类的事件管理，比如控制任务管理器给予每个玩家，控制背包给予每个玩家的英雄

以QuestsCtrl（任务控制器）为例

if QuestsCtrl == nil then

	-- 注册控制器
	QuestsCtrl = RegisterController('quests')

	-- 定义控制器相关的变量
	QuestsCtrl.player_quests_manager={}
end

local public = QuestsCtrl

-- 当所有玩家加载游戏完毕，就会调用所有控制器的init的函数进行初始化
function public:init()
	-- 加载任务数据
	_G['QuestsKV'] = LoadKeyValues("scripts/quests/quests.kv")
end

此时可以通过QuestsCtrl来获取控制器，当然如果不确定是不是QuestsCtrl这个变量名，可以通过GetController('quests')来获取，建议在类中都是使用GetController()来获取
]]


if __controller == nil then
	__controller = {}
	
	function RegisterController(name)
		if __controller[name] == nil then
			__controller[name] = {}
		end
		return __controller[name]
	end

	function GetController(name)
		return __controller[name]
	end

	function ControllersInit()
		for k,v in pairs(__controller) do
			if v.init then v:init() end
		end
	end
end

autoload({
	'quests',
	'bag',
	'damage_system',
	'custom_ui',
	'currencies',
	'equip',
	'custom_attributes',
	'message',
	'spawnsystem',
	'ai',
	'dropped',
	'suit_system',
	'compose_system',
	'unit_states',
	'custom_item_spell_system',
	'player_setting',
	'dig_treasure',
	'novice_guide',
	'modal_dialog',
	'wings_system',
	'fuse_items',
	'fate_system',
	'collect_ore_system',
	'mixing_weapon',
	'attached_soul',
	'public_stash',
	'decompose',
	'game_stats',
	'learn_extra_abilities',
	'vote_system',
	'item_to_be_collected',
	'test',
},'controllers')