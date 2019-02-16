
if CustomUICtrl == nil then
	CustomUICtrl = RegisterController('custom_ui')
end

local public = CustomUICtrl

ShuShanTips_MinCount = 1
ShuShanTips_MaxCount = 31

function public:Create(PlayerID)
	-- 创建任务追踪
	-- CustomUI:DynamicHud_Create(PlayerID,"overhead_label","file://{resources}/layout/custom_game/frames/overhead_label/overhead_label.xml",nil);
	-- CustomUI:DynamicHud_Create(PlayerID,"bubble","file://{resources}/layout/custom_game/frames/bubble/bubble.xml",nil);
	-- CustomUI:DynamicHud_Create(PlayerID,"mini_quests","file://{resources}/layout/custom_game/frames/mini_quests/mini_quests.xml",nil);
	-- CustomUI:DynamicHud_Create(PlayerID,"topbar","file://{resources}/layout/custom_game/frames/topbar/topbar.xml",
	-- 	{Gold=0,YuanHui=0,difficulty_text=tostring(GameRules:GetCustomGameDifficulty())..tostring(GameRules:GetCustomGameRate())  });
end

function public:init()
	Timer(function ()
		local n = RandomInt(ShuShanTips_MinCount, ShuShanTips_MaxCount)

		EachHero(function ( hero )
			hero:ShowCustomMessage({
				type="message-box",
				role="Avalon",
				list={
					{
						text="shushan_tips_"..tostring(n),
						args={}
					}
				},
				duration=10,
			})
		end)

		return RandomFloat(60, 120)
	end)
end
