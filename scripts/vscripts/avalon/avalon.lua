
--[[

Avalon库说明:

* abilities    存放技能RunScript所需要的文件以及AbilityLua相关的文件
* items        存放物品RunScript所需要的文件以及ItemLua相关的文件
* modifiers    存放ModifierLua相关的文件
* triggers     存放trigger实体参数Entity Script所需要的文件
* ai           存放AI文件

* avalon       Avalon库主要目录
* extends      对V社提供的类进行扩展
* utils        如果你不知道把文件放哪就扔这吧

* config
  存放配置的目录，默认两个文件：gamemode.lua(GameModeEntity),gamerules.lua(GameRules)
  配置一般是常量的定义或者是一个table，取名尽量保持唯一性，毕竟是全局的

* class
  class目录下存放的是模块或者模型的实现，比如背包、任务，这个目录下的文件应当保持独立性，就是只负责实现功能，不负责实际该怎么去调用
  更多详细情况请看class/class.lua

* controllers
  控制器存在的意义就是控制class目录下的模块或者模型，比如是将背包给予单位还是英雄，控制UI与任务类的交互，以及对一些事件的响应处理等
  更多详细情况请看controllers/controllers.lua

* events
  存放事件相关的文件，主要是与UI交互的自定义事件(CustomGameEventManager)
  默认包涵三个基础文件, game.lua(游戏事件),filter.lua(过滤器),custom.lua(自定义事件)

* Avalon自定义事件
  Avalon库提供了两个方法Avalon:Fire()和Avalon:Listen()
  V社本身也提供了两种自定义事件的实现，1.通过custom_events.txt实现的自定义事件。2.通过CustomGameEventManager实现的自定义事件
  但是两种自定义事件的方式很蛋疼，都不利于直接复制模块

  1.使用V社提供的FireGameEvent()和ListenToGameEvent()，需要在custom_events.txt中定义好事件，
    如果很多模块，每个模块都有各自事件，那么复制一些模块到其它项目也需要把相关的事件复制过去，有些麻烦
    理论上FireGameEvent()触发的事件是同时发送到server端和client端，但是上传到创意工坊后就只有server端接收到，这也许是BUG

  2.CustomGameEventManager就不用说了，这是与UI交互的事件，在Lua监听不到
  
  综上所述，才会有了Avalon自定义事件

  使用方法, 以背包为例：
  function public:OnBagChanged(owner, bag)
  end
	
  -- 监听事件的写法跟V社提供的API相似
  Avalon:Listen("bag_changed", Dynamic_Wrap(public,"OnBagChanged"), public)
  
  -- 此时在class中发送事件
  function CBag:Update()
	  Avalon:Fire('bag_changed', self:GetOwner(), self)
  end

  如上面的例子所示，事件监听的写法是跟ListenToGameEvent()差不多，唯一有区别的就是Avalon:Fire()
  Avalon:Fire()，第一个参数就是事件名，后面的参数就是要传递到监听的函数的参数
  例如上面(self:GetOwner(),self)就是对应OnBagChanged的(owner, bag)
  这样一来就可以保持class的独立，在controllers按游戏需要监听事件

* 抛出错误
  这并不是抛出代码执行过程的错误，而是在代码执行过程中，判断到不符合往下执行的情况时发送一个错误信息给UI
  然后由UI提示错误信息文本给玩家，调用之后是发送"avalon_throw_error"到js，只有一个text参数
  两个API：Avalon:Throw(unit, text, returnValue)和Avalon:ThrowAll(text, returnValue)
  
  例如,背包创建物品，当背包满格时抛出"背包已满，无法创建物品"的消息
  function CBag:CreateItem(itemname)
	if self:IsFull() then return Avalon:Throw(self:GetOwner(), "error_msg_bag_is_full_does_not_create_item", nil) end
  end

  此时在js的GameEvents.Subscribe("avalon_throw_error",OnThrowError)就会受到错误信息

* 单一绑定确认事件
  有时候写一个模块也会发生一些不确定的事件，比如我在写背包的时候，实现一个出售背包中物品的功能
  由于我不确定这个游戏是什么样的规则，物品的售价是原来50%还是75%，还是这个游戏就是不能出售物品的，又或者有自定义的货币系统
  所以就诞生了Avalon:Conform()和Avalon:BindConform()，这两个API写法跟Avalon:Fire()和Avalon:Listen()一模一样
  不同的是，BindConform()是一对一的，绑定一个函数之后就是这个函数了，如果再绑定其它函数就会覆盖掉前面的函数
  在模块中调用Conform()之后可以获得返回值，然后根据这个返回值来做出相应的处理

  例：
  function public:WhenSellItem(owner, item)
    owner:SpendGold(item:GetCost())
    return true
  end
  Avalon:BindConform("bag_sell_item", Dynamic_Wrap(public,"WhenSellItem"), public)
  
  -- 出售物品
  function CBag:SellItem(item)
    if Avalon:Conform("bag_sell_item",item) == true then
      self:RemoveItem(item)
    end
  end

* 永久变量
  Avalon:Forever(key,value)提供了永久变量的定义，这种做法只是为了在编辑器模式下防止script_reload导致一些变量的数据丢失
]]

if Avalon == nil then
  local __forever = nil
  if IsInToolsMode() then
    __forever = {}
  end
  AvalonEmptyTable = {}

	Avalon = {
    Forever = function (self,key,value)
      if IsInToolsMode() then
        if __forever[key] then
          return __forever[key]
        else
          __forever[key] = value
        end
      end
      return value
    end
  }
end

autoload({
	'globals',
	'events',
},'avalon')