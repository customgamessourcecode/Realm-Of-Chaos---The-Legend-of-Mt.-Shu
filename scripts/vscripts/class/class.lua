
--[[
各个系统写成类，类里面只提供方法不做其它事情，诸如事件响应通过类的控制器来通知

Exmple:

--@class CQuests
if CQuests == nil then
	CQuests = class({})
end

local public = CQuests

-- 构造函数
function public:constructor()
end

]]

autoload({
	"bag",
	"quests",
	"quests_subquest",
	"quests_manager",
	'custom_attributes_for_hero',
	'custom_attributes_for_item',
	'spawnsystem',
	'motion',
},'class')