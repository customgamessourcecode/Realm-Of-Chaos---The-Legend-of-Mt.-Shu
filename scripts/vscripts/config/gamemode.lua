
--[[

GameModeEntity相关的配置，使用默认配置注释掉相关的函数即可

]]

local GameMode = GameRules:GetGameModeEntity()

-- 是否禁用天气特效
GameMode:SetWeatherEffectsDisabled(true)

-- 总是显示玩家名字
GameMode:SetAlwaysShowPlayerNames(true)

-- 总是显示玩家的仓库，无论选择任何单位
GameMode:SetAlwaysShowPlayerInventory(false)

-- 是否禁用播音员
GameMode:SetAnnouncerDisabled(true)

-- 是否开启买活
GameMode:SetBuybackEnabled(false)

-- 是否开启买活CD
GameMode:SetCustomBuybackCooldownEnabled(false)

-- 是否开启买活需要消耗金币
GameMode:SetCustomBuybackCostEnabled(true)

-- 设置默认镜头高度，不建议在这里设置，在Javascript中使用GameUI.SetCameraDistance()设置
-- GameMode:SetCameraDistanceOverride(1135)

-- 强制玩家选择英雄
-- GameMode:SetCustomGameForceHero('npc_dota_hero_juggernaut')

-- 是否使用自定义英雄等级
GameMode:SetUseCustomHeroLevels(true)

-- 是否使用自定义经验值，开启之后调用SetCustomXPRequiredToReachNextLevel设置每级经验差，否者可能引起崩溃
GameRules:SetUseCustomHeroXPValues(true)

-- 设置英雄最高等级
CUSTOM_HERO_MAX_LEVEL = 101
GameMode:SetCustomHeroMaxLevel(CUSTOM_HERO_MAX_LEVEL)

-- 设置每级经验差
local HERO_EXP_TABLE={0}
local exp={80,160,240,320,400,480,560,640,720,800,
   880,960,1040,1120,1200,1280,1360,1440,1520,1600,
   1680,1760,1840,1920,2000,2080,2160,2240,2320,2400,
   2480,2560,2640,2720,2800,2880,2960,3040,3120,3200,
   3280,3340,3420,3500,3580,3660,3740,3820,3900,3980,
   4060,4140,4220,4300,4380,4460,4540,4620,4700,4780,
   4860,4940,5020,5100,5180,5260,5340,5420,5500,5580,
   5660,5740,5820,5900,5980,6060,6140,6220,6300,6380,
   6460,6540,6620,6700,6780,6860,6940,7020,7100,7180,
   7260,7340,7420,7500,7580,7660,7740,7820,7900,7980,
   8060,8140,8220,8300
  }
local xp=0

for i=2,CUSTOM_HERO_MAX_LEVEL-1 do
  HERO_EXP_TABLE[i]=HERO_EXP_TABLE[i-1]+exp[i-1]
end

GameMode:SetCustomXPRequiredToReachNextLevel(HERO_EXP_TABLE)

-- 设置固定的复活时间
-- GameMode:SetFixedRespawnTime(5)

-- 是否禁用战争迷雾
-- GameMode:SetFogOfWarDisabled(false)

-- 是否开启黑色迷雾，开启后地图一开始是全黑的，需要探索后才会显示
GameMode:SetUnseenFogOfWarEnabled(false)

-- 设置泉水回复魔法值的速率
-- GameMode:SetFountainConstantManaRegen(1)

-- 设置泉水回复生命值的速率
-- GameMode:SetFountainPercentageHealthRegen(1)

-- 设置泉水回复魔法值百分比
-- GameMode:SetFountainPercentageManaRegen(1)

-- 是否禁用金币掉落的音效
GameMode:SetGoldSoundDisabled(true)

-- 是否英雄死亡损失金币
GameMode:SetLoseGoldOnDeath(false)

-- 设置最大攻击速度
-- GameMode:SetMaximumAttackSpeed(1000)

-- 设置最小攻击速度
-- GameMode:SetMinimumAttackSpeed(100)

-- 是否禁用物品推荐
GameMode:SetRecommendedItemsDisabled(true)

-- 当幻象死亡后是否删除
GameMode:SetRemoveIllusionsOnDeath(true)

-- 是否开启双倍神符
GameMode:SetRuneEnabled(DOTA_RUNE_DOUBLEDAMAGE,false)

-- 是否开启加速神符
GameMode:SetRuneEnabled(DOTA_RUNE_HASTE,false)

-- 是否开启幻象神符
GameMode:SetRuneEnabled(DOTA_RUNE_ILLUSION,false)

-- 是否开启隐身神符
GameMode:SetRuneEnabled(DOTA_RUNE_INVISIBILITY,false)

-- 是否开启恢复神符
GameMode:SetRuneEnabled(DOTA_RUNE_REGENERATION,false)

-- 是否开启赏金神符
GameMode:SetRuneEnabled(DOTA_RUNE_BOUNTY,false)

-- 是否禁用神秘商店
GameMode:SetStashPurchasingDisabled(true)

-- 隐藏置顶物品在快速购买
GameMode:SetStickyItemDisabled(true)

-- 修改DOTA2默认的三围属性加成
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 1 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP, 20 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP_REGEN_PERCENT, 0.008 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT, 0.0008 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_DAMAGE, 1 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.17 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 1 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT, 0.0008 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 1 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 11 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN_PERCENT, 0.008 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT, 0.0008 )
-- GameMode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT, 0.0008 )