
--[[

GameRules相关的配置，使用默认配置注释掉相关的函数即可

]]

-- 是否开启第一滴血
GameRules:SetFirstBloodActive(false)

-- 设置根据时间的金钱奖励
GameRules:SetGoldPerTick(0)
GameRules:SetGoldTickTime(100.0)

-- 设置起始金钱
GameRules:SetStartingGold(0)

-- 设置一天的时间
GameRules:SetTimeOfDay(240)

-- 是否开启英雄重生
GameRules:SetHeroRespawnEnabled(true)

-- 是否允许选择相同英雄
GameRules:SetSameHeroSelectionEnabled(true)

-- 设置选择英雄时间
GameRules:SetHeroSelectionTime(1)

-- 设置决策时间
GameRules:SetStrategyTime(0)

-- 设置展示时间
GameRules:SetShowcaseTime(0)

-- 是否隐藏击杀提示
GameRules:SetHideKillMessageHeaders(true)

-- 设置游戏结束后停留的时间
GameRules:SetPostGameTime(300)

-- 设置游戏开始前准备的时间
GameRules:SetPreGameTime(15)

-- 设置树木再生时间
GameRules:SetTreeRegrowTime(300)

-- 是否使用默认的击杀奖励
GameRules:SetUseBaseGoldBountyOnHeroes(true)

-- 是否没有在神秘商店也可以买到神秘商店的物品
GameRules:SetUseUniversalShopMode(false)

-- 设置队伍人数
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_FIRST,     0)  -- 观战队伍
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS,  5)  -- 天辉
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS,   0)  -- 夜魇
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_NEUTRALS,  0)  -- 野怪
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1,  0)  -- 自定义队伍1
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2,  0)  -- 自定义队伍2
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3,  0)  -- 自定义队伍3
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4,  0)  -- 自定义队伍4
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5,  0)  -- 自定义队伍5
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6,  0)  -- 自定义队伍6
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7,  0)  -- 自定义队伍7
GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8,  0)  -- 自定义队伍8