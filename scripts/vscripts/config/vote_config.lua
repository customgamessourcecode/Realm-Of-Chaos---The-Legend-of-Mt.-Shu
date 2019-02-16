
AVALON_VOTE_COUNT = 0	-- 计数
AVALON_VOTE_RADIO = 1	-- 单项选择
AVALON_VOTE_CHECK = 2	-- 多项选择

if AvalonVoteConfig == nil then
AvalonVoteConfig = 
{
	["difficulty"] =
	{
		type = AVALON_VOTE_RADIO,
		default = 1,
		options = 
		{
			0,0,0,0,0,0,0
		},
	},
	["game_rate"] =
	{
		type = AVALON_VOTE_RADIO,
		default = 1,
		options = 
		{
			0,0,0,0,0,0
		},
	},
	["open_fog_of_war"] =
	{
		type = AVALON_VOTE_COUNT,
		percent = 0.5,
	},
	["rush_boss_mode"] =
	{
		type = AVALON_VOTE_COUNT,
		percent = 0.5,
	},
}
end