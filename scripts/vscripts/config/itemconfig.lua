ITEM_QUALITY_E=1
ITEM_QUALITY_D=2
ITEM_QUALITY_C=3
ITEM_QUALITY_B=4
ITEM_QUALITY_A=5
ITEM_QUALITY_S=6
ITEM_QUALITY_Z=7
ITEM_QUALITY_EX=8

ITEM_KIND_MATERIAL=0
ITEM_KIND_SWORD=1
ITEM_KIND_BLADE=2
ITEM_KIND_KNIFE=3
ITEM_KIND_CASTER=4
ITEM_KIND_LANCER=5
ITEM_KIND_SHOES=6
ITEM_KIND_CLOTHES=7
ITEM_KIND_HAT=8
ITEM_KIND_TRINKET=9
ITEM_KIND_TALISMAN=10
ITEM_KIND_CONSUMABLE=11
ITEM_KIND_SIGIL=13

ITEM_KIND_GROUP_MATERIAL = 0
ITEM_KIND_GROUP_WEAPON = 1
ITEM_KIND_GROUP_SHOES = 2
ITEM_KIND_GROUP_CLOTHES = 3
ITEM_KIND_GROUP_HAT = 4
ITEM_KIND_GROUP_TRINKET = 5

ItemKindGroup={
	[ITEM_KIND_CONSUMABLE]	=ITEM_KIND_GROUP_MATERIAL,
	[ITEM_KIND_SIGIL]		=ITEM_KIND_GROUP_MATERIAL,
	[ITEM_KIND_MATERIAL]	=ITEM_KIND_GROUP_MATERIAL,
	[ITEM_KIND_SWORD]		=ITEM_KIND_GROUP_WEAPON,
	[ITEM_KIND_KNIFE]		=ITEM_KIND_GROUP_WEAPON,
	[ITEM_KIND_BLADE]		=ITEM_KIND_GROUP_WEAPON,
	[ITEM_KIND_CASTER]		=ITEM_KIND_GROUP_WEAPON,
	[ITEM_KIND_LANCER]		=ITEM_KIND_GROUP_WEAPON,
	[ITEM_KIND_SHOES]		=ITEM_KIND_GROUP_SHOES,
	[ITEM_KIND_CLOTHES]		=ITEM_KIND_GROUP_CLOTHES,
	[ITEM_KIND_HAT]			=ITEM_KIND_GROUP_HAT,
	[ITEM_KIND_TRINKET]		=ITEM_KIND_GROUP_TRINKET,
	[ITEM_KIND_TALISMAN]	=ITEM_KIND_GROUP_TRINKET,
}

ItemConfig = {
	["item_0001"]={["kind"]= 8,["quality"]=1}, -- 布帽
	["item_0002"]={["kind"]= 6,["quality"]=1}, -- 布鞋
	["item_0003"]={["kind"]= 7,["quality"]=1}, -- 布衣
	["item_0004"]={["kind"]= 0,["quality"]=2}, -- 九瓣天龙散
	["item_0005"]={["kind"]= 0,["quality"]=2}, -- 灵草
	["item_0006"]={["kind"]= 0,["quality"]=2}, -- 狼皮
	["item_0007"]={["kind"]= 0,["quality"]=2}, -- 木材
	["item_0008"]={["kind"]= 0,["quality"]=2}, -- 兰叶
	["item_0009"]={["kind"]= 0,["quality"]=2}, -- 水网
	["item_0010"]={["kind"]= 8,["quality"]=2}, -- 琅琊帽
	["item_0011"]={["kind"]= 9,["quality"]=2}, -- 碧石翠玉戒
	["item_0012"]={["kind"]= 9,["quality"]=2}, -- 灵草挂饰
	["item_0013"]={["kind"]= 9,["quality"]=2}, -- 金鳞挂饰
	["item_0014"]={["kind"]= 9,["quality"]=2}, -- 银鳞戒指
	["item_0015"]={["kind"]= 9,["quality"]=2}, -- 行云戒指
	["item_0016"]={["kind"]= 6,["quality"]=2}, -- 流水鞋
	["item_0017"]={["kind"]= 6,["quality"]=2}, -- 落日靴
	["item_0018"]={["kind"]= 7,["quality"]=2}, -- 狼皮衫
	["item_0019"]={["kind"]= 7,["quality"]=2}, -- 猎户服
	["item_0020"]={["kind"]= 7,["quality"]=2}, -- 天蚕衣
	["item_0021"]={["kind"]= 7,["quality"]=2}, -- 碧河甲
	["item_0022"]={["kind"]=11,["quality"]=2}, -- 壮水散
	["item_0023"]={["kind"]= 0,["quality"]=2}, -- 狼心
	["item_0024"]={["kind"]= 0,["quality"]=2}, -- 露灵白草
	["item_0025"]={["kind"]= 9,["quality"]=2}, -- 狼牙挂饰
	["item_0026"]={["kind"]= 0,["quality"]=2}, -- 狼牙
	["item_0027"]={["kind"]= 0,["quality"]=2}, -- 红花
	["item_0028"]={["kind"]= 8,["quality"]=2}, -- 白草冠
	["item_0029"]={["kind"]= 0,["quality"]=2}, -- 水草
	["item_0030"]={["kind"]= 0,["quality"]=2}, -- 珍珠
	["item_0031"]={["kind"]= 9,["quality"]=2}, -- 山妖铁环
	["item_0032"]={["kind"]= 9,["quality"]=2}, -- 山妖腰带
	["item_0033"]={["kind"]= 0,["quality"]=3}, -- 铜铁
	["item_0034"]={["kind"]=11,["quality"]=3}, -- 小还丹
	["item_0035"]={["kind"]= 0,["quality"]=3}, -- C级晶石
	["item_0036"]={["kind"]= 8,["quality"]=3}, -- 天师道冠
	["item_0037"]={["kind"]= 8,["quality"]=3}, -- 白云冠
	["item_0038"]={["kind"]= 9,["quality"]=3}, -- 九龙戒
	["item_0039"]={["kind"]= 9,["quality"]=3}, -- 九龙腰带
	["item_0040"]={["kind"]= 9,["quality"]=3}, -- 治水法器
	["item_0041"]={["kind"]= 1,["quality"]=3}, -- 铜铁剑
	["item_0042"]={["kind"]= 6,["quality"]=3}, -- 疾行靴
	["item_0043"]={["kind"]= 6,["quality"]=3}, -- 天师鞋
	["item_0044"]={["kind"]= 6,["quality"]=3}, -- 行铁履
	["item_0045"]={["kind"]= 7,["quality"]=3}, -- 九龙甲
	["item_0046"]={["kind"]= 7,["quality"]=3}, -- 天师道服
	["item_0047"]={["kind"]= 7,["quality"]=3}, -- 奇门甲
	["item_0048"]={["kind"]= 8,["quality"]=3}, -- 水妖皮盔
	["item_0049"]={["kind"]= 7,["quality"]=3}, -- 狼王战甲
	["item_0050"]={["kind"]=11,["quality"]=3}, -- 红尘丹
	["item_0051"]={["kind"]= 6,["quality"]=3}, -- 水妖皮靴
	["item_0052"]={["kind"]= 7,["quality"]=3}, -- 水妖皮甲
	["item_0053"]={["kind"]= 9,["quality"]=3}, -- 山妖魔戒
	["item_0054"]={["kind"]= 2,["quality"]=3}, -- 铜铁匕首
	["item_0055"]={["kind"]= 3,["quality"]=3}, -- 铜铁刀
	["item_0056"]={["kind"]= 4,["quality"]=3}, -- 铜铁杖
	["item_0057"]={["kind"]= 5,["quality"]=3}, -- 铜铁枪
	["item_0058"]={["kind"]= 0,["quality"]=4}, -- 千年寒铁
	["item_0059"]={["kind"]= 0,["quality"]=4}, -- 蜀山令牌
	["item_0060"]={["kind"]=11,["quality"]=4}, -- 大还丹
	["item_0061"]={["kind"]= 0,["quality"]=4}, -- B级晶石
	["item_0062"]={["kind"]= 8,["quality"]=4}, -- 凤仙冠
	["item_0063"]={["kind"]= 9,["quality"]=4}, -- 盘龙戒指
	["item_0064"]={["kind"]= 9,["quality"]=4}, -- 铁门刻印
	["item_0065"]={["kind"]= 1,["quality"]=4}, -- 寒铁剑
	["item_0066"]={["kind"]= 6,["quality"]=4}, -- 龙纹履
	["item_0067"]={["kind"]= 7,["quality"]=4}, -- 缠水服
	["item_0068"]={["kind"]= 0,["quality"]=4}, -- 避水珠
	["item_0069"]={["kind"]= 9,["quality"]=4}, -- 水妖护盾
	["item_0070"]={["kind"]= 0,["quality"]=5}, -- A级晶石
	["item_0071"]={["kind"]= 8,["quality"]=5}, -- 神仙百草冠
	["item_0072"]={["kind"]= 9,["quality"]=5}, -- 六合卜玉
	["item_0073"]={["kind"]= 9,["quality"]=5}, -- 妖魂之玉
	["item_0074"]={["kind"]= 6,["quality"]=5}, -- 天云碎靴
	["item_0075"]={["kind"]= 7,["quality"]=5}, -- 万道六环甲
	["item_0076"]={["kind"]= 9,["quality"]=5}, -- 妖王镜
	["item_0077"]={["kind"]=11,["quality"]=6}, -- 狼妖内丹
	["item_0078"]={["kind"]= 0,["quality"]=6}, -- S级晶石
	["item_0079"]={["kind"]= 0,["quality"]=6}, -- 魔炼石
	["item_0080"]={["kind"]= 0,["quality"]=6}, -- 妖化石
	["item_0081"]={["kind"]= 0,["quality"]=6}, -- 仙晋石
	["item_0082"]={["kind"]= 0,["quality"]=6}, -- 佛渡石
	["item_0083"]={["kind"]= 1,["quality"]=6}, -- 铸血魔剑
	["item_0084"]={["kind"]= 0,["quality"]=7}, -- Z级晶石
	["item_0085"]={["kind"]= 7,["quality"]=4}, -- 邪神道服
	["item_0086"]={["kind"]= 0,["quality"]=3}, -- 蝗符
	["item_0087"]={["kind"]= 9,["quality"]=4}, -- 炼妖壶
	["item_0088"]={["kind"]= 0,["quality"]=2}, -- 九龙配饰四
	["item_0089"]={["kind"]= 0,["quality"]=2}, -- 九龙配饰三
	["item_0090"]={["kind"]= 0,["quality"]=2}, -- 九龙配饰二
	["item_0091"]={["kind"]= 0,["quality"]=2}, -- 九龙配饰一
	["item_0092"]={["kind"]= 1,["quality"]=1}, -- 铁剑
	["item_0093"]={["kind"]= 2,["quality"]=1}, -- 匕首
	["item_0094"]={["kind"]= 3,["quality"]=1}, -- 铁刀
	["item_0095"]={["kind"]= 4,["quality"]=1}, -- 木杖
	["item_0096"]={["kind"]= 5,["quality"]=1}, -- 铁枪
	["item_0097"]={["kind"]= 0,["quality"]=1}, -- 木弓
	["item_0098"]={["kind"]= 1,["quality"]=2}, -- 青锋剑
	["item_0099"]={["kind"]= 2,["quality"]=2}, -- 无影刃
	["item_0100"]={["kind"]= 3,["quality"]=2}, -- 古锭刀
	["item_0101"]={["kind"]= 4,["quality"]=2}, -- 十环杖
	["item_0102"]={["kind"]= 5,["quality"]=2}, -- 玄铁枪
	["item_0103"]={["kind"]= 0,["quality"]=2}, -- 定风珠
	["item_0104"]={["kind"]= 0,["quality"]=8}, -- 神秘宝珠
	["item_0105"]={["kind"]= 0,["quality"]=2}, -- 草鱼
	["item_0106"]={["kind"]= 1,["quality"]=3}, -- 太清剑
	["item_0107"]={["kind"]= 2,["quality"]=3}, -- 八方古刃
	["item_0108"]={["kind"]= 3,["quality"]=3}, -- 极影刀
	["item_0109"]={["kind"]= 4,["quality"]=3}, -- 焰泣离魂杖
	["item_0110"]={["kind"]= 5,["quality"]=3}, -- 九转红缨枪
	["item_0111"]={["kind"]= 0,["quality"]=3}, -- 劣质剑模
	["item_0112"]={["kind"]= 0,["quality"]=3}, -- 劣质匕首模
	["item_0113"]={["kind"]= 0,["quality"]=3}, -- 劣质刀模
	["item_0114"]={["kind"]= 0,["quality"]=3}, -- 劣质杖模
	["item_0115"]={["kind"]= 0,["quality"]=3}, -- 劣质枪模
	["item_0116"]={["kind"]= 0,["quality"]=3}, -- 布料
	["item_0117"]={["kind"]= 0,["quality"]=3}, -- 水妖核
	["item_0118"]={["kind"]= 6,["quality"]=3}, -- 九龙鞋
	["item_0119"]={["kind"]= 9,["quality"]=3}, -- 噬心挂坠
	["item_0120"]={["kind"]= 8,["quality"]=3}, -- 九龙盔
	["item_0121"]={["kind"]= 9,["quality"]=3}, -- 囚魔戒
	["item_0122"]={["kind"]= 9,["quality"]=3}, -- 九龙护手
	["item_0123"]={["kind"]= 0,["quality"]=3}, -- 九龙核心
	["item_0124"]={["kind"]= 1,["quality"]=3}, -- 九龙剑
	["item_0125"]={["kind"]= 2,["quality"]=3}, -- 九龙匕首
	["item_0126"]={["kind"]= 5,["quality"]=3}, -- 九龙枪
	["item_0127"]={["kind"]= 3,["quality"]=3}, -- 九龙刀
	["item_0128"]={["kind"]= 0,["quality"]=3}, -- 皮革
	["item_0129"]={["kind"]= 6,["quality"]=4}, -- 九龙战靴
	["item_0130"]={["kind"]= 8,["quality"]=4}, -- 九龙战盔
	["item_0131"]={["kind"]= 7,["quality"]=4}, -- 九龙战甲
	["item_0132"]={["kind"]= 6,["quality"]=5}, -- 行龙靴
	["item_0133"]={["kind"]= 6,["quality"]=2}, -- 水草鞋
	["item_0134"]={["kind"]= 0,["quality"]=2}, -- 山妖精华
	["item_0135"]={["kind"]= 0,["quality"]=1}, -- 罗盘
	["item_0136"]={["kind"]= 0,["quality"]=1}, -- 铁铲
	["item_0137"]={["kind"]= 0,["quality"]=1}, -- 渔网
	["item_0138"]={["kind"]= 7,["quality"]=4}, -- 长河战甲
	["item_0139"]={["kind"]= 7,["quality"]=5}, -- 落日神甲
	["item_0140"]={["kind"]= 8,["quality"]=4}, -- 太极道冠
	["item_0141"]={["kind"]= 7,["quality"]=4}, -- 太极道服
	["item_0142"]={["kind"]= 6,["quality"]=4}, -- 太极道靴
	["item_0143"]={["kind"]= 8,["quality"]=5}, -- 真武太极道冠
	["item_0144"]={["kind"]= 7,["quality"]=5}, -- 真武太极道服
	["item_0145"]={["kind"]= 6,["quality"]=5}, -- 真武太极道靴
	["item_0146"]={["kind"]= 0,["quality"]=3}, -- 山风皮
	["item_0147"]={["kind"]= 0,["quality"]=3}, -- 妖翼
	["item_0148"]={["kind"]=11,["quality"]=6}, -- 风霄内丹
	["item_0149"]={["kind"]= 0,["quality"]=4}, -- 巨兽牙饰
	["item_0150"]={["kind"]= 7,["quality"]=4}, -- 风霄战甲
	["item_0151"]={["kind"]= 0,["quality"]=6}, -- 风神珠
	["item_0152"]={["kind"]= 0,["quality"]=3}, -- 韬光符
	["item_0153"]={["kind"]= 0,["quality"]=4}, -- 定势符
	["item_0154"]={["kind"]= 0,["quality"]=5}, -- 真武符
	["item_0155"]={["kind"]= 0,["quality"]=6}, -- 神机符
	["item_0156"]={["kind"]= 0,["quality"]=7}, -- 太上符
	["item_0157"]={["kind"]= 7,["quality"]=6}, -- 落霄神风甲
	["item_0158"]={["kind"]= 7,["quality"]=7}, -- 真*落霄神风甲
	["item_0159"]={["kind"]= 9,["quality"]=5}, -- 天极挂饰
	["item_0160"]={["kind"]= 9,["quality"]=6}, -- 真武天极挂饰
	["item_0161"]={["kind"]= 0,["quality"]=4}, -- B级无灵石
	["item_0162"]={["kind"]= 0,["quality"]=5}, -- A级无灵石
	["item_0163"]={["kind"]= 0,["quality"]=6}, -- S级无灵石
	["item_0164"]={["kind"]= 0,["quality"]=7}, -- Z级无灵石
	["item_0165"]={["kind"]= 1,["quality"]=3}, -- 韬光青锋剑
	["item_0166"]={["kind"]= 1,["quality"]=4}, -- 定势青锋剑
	["item_0167"]={["kind"]= 2,["quality"]=3}, -- 韬光无影刃
	["item_0168"]={["kind"]= 2,["quality"]=4}, -- 定势无影刃
	["item_0169"]={["kind"]= 3,["quality"]=3}, -- 韬光古锭刀
	["item_0170"]={["kind"]= 3,["quality"]=4}, -- 定势古锭刀
	["item_0171"]={["kind"]= 4,["quality"]=3}, -- 韬光十环杖
	["item_0172"]={["kind"]= 4,["quality"]=4}, -- 定势十环杖
	["item_0173"]={["kind"]= 5,["quality"]=3}, -- 韬光玄铁枪
	["item_0174"]={["kind"]= 5,["quality"]=4}, -- 定势玄铁枪
	["item_0175"]={["kind"]= 1,["quality"]=5}, -- 真武太清剑
	["item_0176"]={["kind"]= 2,["quality"]=5}, -- 真武八方古刃
	["item_0177"]={["kind"]= 3,["quality"]=5}, -- 真武极影刀
	["item_0178"]={["kind"]= 4,["quality"]=5}, -- 真武焰泣离魂杖
	["item_0179"]={["kind"]= 5,["quality"]=5}, -- 真武九转红缨枪
	["item_0180"]={["kind"]= 0,["quality"]=4}, -- 冰刺
	["item_0181"]={["kind"]= 9,["quality"]=4}, -- 冰封挂饰
	["item_0182"]={["kind"]= 0,["quality"]=5}, -- 冰封魔珠
	["item_0183"]={["kind"]= 0,["quality"]=4}, -- 炎刺
	["item_0184"]={["kind"]= 9,["quality"]=4}, -- 火焰挂饰
	["item_0185"]={["kind"]= 0,["quality"]=5}, -- 烈炎魔珠
	["item_0186"]={["kind"]= 7,["quality"]=5}, -- 冰焰神袍
	["item_0187"]={["kind"]= 1,["quality"]=4}, -- 炎霜剑
	["item_0188"]={["kind"]= 2,["quality"]=4}, -- 炎霜匕首
	["item_0189"]={["kind"]= 3,["quality"]=4}, -- 炎霜刀
	["item_0190"]={["kind"]= 4,["quality"]=4}, -- 炎霜杖
	["item_0191"]={["kind"]= 5,["quality"]=4}, -- 炎霜枪
	["item_0192"]={["kind"]= 8,["quality"]=4}, -- 冰封头盔
	["item_0193"]={["kind"]= 6,["quality"]=4}, -- 冰封战靴
	["item_0194"]={["kind"]= 8,["quality"]=4}, -- 烈炎头盔
	["item_0195"]={["kind"]= 6,["quality"]=4}, -- 烈焰战靴
	["item_0196"]={["kind"]= 7,["quality"]=4}, -- 炎霜袍
	["item_0197"]={["kind"]= 9,["quality"]=5}, -- 无护神腕
	["item_0198"]={["kind"]= 0,["quality"]=6}, -- 冰焰魔石
	["item_0199"]={["kind"]= 1,["quality"]=5}, -- 冰烈炎霜剑
	["item_0200"]={["kind"]= 2,["quality"]=5}, -- 冰烈炎霜匕首
	["item_0201"]={["kind"]= 3,["quality"]=5}, -- 冰烈炎霜刀
	["item_0202"]={["kind"]= 4,["quality"]=5}, -- 冰烈炎霜杖
	["item_0203"]={["kind"]= 5,["quality"]=5}, -- 冰烈炎霜枪
	["item_0204"]={["kind"]= 8,["quality"]=5}, -- 冰焰神盔
	["item_0205"]={["kind"]= 6,["quality"]=5}, -- 冰焰神靴
	["item_0206"]={["kind"]=13,["quality"]=5}, -- 道术符印
	["item_0207"]={["kind"]= 9,["quality"]=4}, -- 天玄宝镜
	["item_0208"]={["kind"]= 0,["quality"]=5}, -- 玄冰宫密匙（左）
	["item_0209"]={["kind"]= 0,["quality"]=5}, -- 玄冰宫密匙（右）
	["item_0210"]={["kind"]= 0,["quality"]=5}, -- 破魔符
	["item_0211"]={["kind"]= 0,["quality"]=5}, -- 万灵散
	["item_0212"]={["kind"]= 0,["quality"]=5}, -- 九火冰莲
	["item_0213"]={["kind"]= 9,["quality"]=4}, -- 冰蚀宝坠
	["item_0214"]={["kind"]= 9,["quality"]=5}, -- 冰蚀神坠
	["item_0215"]={["kind"]= 9,["quality"]=6}, -- 破魔冰蚀
	["item_0216"]={["kind"]= 9,["quality"]=7}, -- 太上破魔冰蚀
	["item_0217"]={["kind"]=13,["quality"]=5}, -- 心法符印
	["item_0218"]={["kind"]= 7,["quality"]=4}, -- 风霄神甲
	["item_0219"]={["kind"]=13,["quality"]=3}, -- 移速符印
	["item_0220"]={["kind"]=13,["quality"]=3}, -- 攻速符印
	["item_0221"]={["kind"]=13,["quality"]=3}, -- 吸血符印
	["item_0222"]={["kind"]=13,["quality"]=3}, -- 血量符印
	["item_0223"]={["kind"]=13,["quality"]=3}, -- 攻击符印
	["item_0224"]={["kind"]=13,["quality"]=3}, -- 法力符印
	["item_0225"]={["kind"]=13,["quality"]=3}, -- 增伤符印
	["item_0226"]={["kind"]=13,["quality"]=3}, -- 减速符印
	["item_0227"]={["kind"]=13,["quality"]=3}, -- 减攻符印
	["item_0228"]={["kind"]=13,["quality"]=3}, -- 减伤符印
	["item_0229"]={["kind"]=13,["quality"]=3}, -- 减甲符印
	["item_0230"]={["kind"]=13,["quality"]=3}, -- 回血符印
	["item_0231"]={["kind"]= 1,["quality"]=4}, -- 巫族长剑
	["item_0232"]={["kind"]= 2,["quality"]=4}, -- 巫族匕首
	["item_0233"]={["kind"]= 3,["quality"]=4}, -- 巫族长刀
	["item_0234"]={["kind"]= 4,["quality"]=4}, -- 巫族法杖
	["item_0235"]={["kind"]= 5,["quality"]=4}, -- 巫族长枪
	["item_0236"]={["kind"]= 7,["quality"]=4}, -- 巫族战袍
	["item_0237"]={["kind"]= 6,["quality"]=4}, -- 巫族皮靴
	["item_0238"]={["kind"]= 8,["quality"]=4}, -- 巫族战盔
	["item_0239"]={["kind"]= 9,["quality"]=5}, -- 血神挂坠
	["item_0240"]={["kind"]= 9,["quality"]=5}, -- 龙族项链
	["item_0241"]={["kind"]= 0,["quality"]=6}, -- 噬魔妖魂
	["item_0242"]={["kind"]= 0,["quality"]=6}, -- 刑天战斧 
	["item_0243"]={["kind"]= 9,["quality"]=5}, -- 刑天战盾
	["item_0244"]={["kind"]= 0,["quality"]=4}, -- 精打剑模
	["item_0245"]={["kind"]= 0,["quality"]=4}, -- 精打匕首模
	["item_0246"]={["kind"]= 0,["quality"]=4}, -- 精打刀模
	["item_0247"]={["kind"]= 0,["quality"]=4}, -- 精打杖模
	["item_0248"]={["kind"]= 0,["quality"]=4}, -- 精打枪模
	["item_0249"]={["kind"]= 0,["quality"]=5}, -- 龙炼剑模
	["item_0250"]={["kind"]= 0,["quality"]=5}, -- 龙炼匕首模
	["item_0251"]={["kind"]= 0,["quality"]=5}, -- 龙炼刀模
	["item_0252"]={["kind"]= 0,["quality"]=5}, -- 龙炼杖模
	["item_0253"]={["kind"]= 0,["quality"]=5}, -- 龙炼枪模
	["item_0254"]={["kind"]= 0,["quality"]=6}, -- 神道剑模
	["item_0255"]={["kind"]= 0,["quality"]=6}, -- 神道匕首模
	["item_0256"]={["kind"]= 0,["quality"]=6}, -- 神道刀模
	["item_0257"]={["kind"]= 0,["quality"]=6}, -- 神道杖模
	["item_0258"]={["kind"]= 0,["quality"]=6}, -- 神道枪模
	["item_0259"]={["kind"]= 0,["quality"]=7}, -- 先天剑模
	["item_0260"]={["kind"]= 0,["quality"]=7}, -- 先天匕首模
	["item_0261"]={["kind"]= 0,["quality"]=7}, -- 先天刀模
	["item_0262"]={["kind"]= 0,["quality"]=7}, -- 先天杖模
	["item_0263"]={["kind"]= 0,["quality"]=7}, -- 先天枪模
	["item_0264"]={["kind"]= 0,["quality"]=4}, -- 精铁
	["item_0265"]={["kind"]= 0,["quality"]=5}, -- 龙石
	["item_0266"]={["kind"]= 0,["quality"]=6}, -- 神脉石
	["item_0267"]={["kind"]= 0,["quality"]=7}, -- 圣灵石
	["item_0268"]={["kind"]= 0,["quality"]=3}, -- 矿精元神（C级）
	["item_0269"]={["kind"]= 0,["quality"]=4}, -- 矿精元神（B级）
	["item_0270"]={["kind"]= 0,["quality"]=5}, -- 矿精元神（A级）
	["item_0271"]={["kind"]= 0,["quality"]=6}, -- 矿精元神（S级）
	["item_0272"]={["kind"]= 0,["quality"]=7}, -- 矿精元神（Z级）
	["item_0273"]={["kind"]= 0,["quality"]=5}, -- 融火玄铁
	["item_0274"]={["kind"]= 0,["quality"]=6}, -- 地脉龙石
	["item_0275"]={["kind"]= 0,["quality"]=6}, -- 先天龙石
	["item_0276"]={["kind"]= 0,["quality"]=7}, -- 夜妄神石
	["item_0277"]={["kind"]= 0,["quality"]=7}, -- 轮回幽石
	["item_0278"]={["kind"]= 0,["quality"]=8}, -- 圣龙魂石
	["item_0279"]={["kind"]= 0,["quality"]=8}, -- 圣神天石
	["item_0280"]={["kind"]= 0,["quality"]=8}, -- 荒神石
	["item_0281"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其一
	["item_0282"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其二
	["item_0283"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其三
	["item_0284"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其四
	["item_0285"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其五
	["item_0286"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其六
	["item_0287"]={["kind"]= 0,["quality"]=6}, -- 真书残卷*其七
	["item_0288"]={["kind"]= 0,["quality"]=7}, -- 无真天书
	["item_0289"]={["kind"]= 0,["quality"]=6}, -- 苍狼之魂
	["item_0290"]={["kind"]= 0,["quality"]=6}, -- 绝影之魂
	["item_0291"]={["kind"]= 0,["quality"]=6}, -- 示空之魂
	["item_0292"]={["kind"]= 0,["quality"]=6}, -- 亡罪之魂
	["item_0293"]={["kind"]= 0,["quality"]=6}, -- 雾然之魂
	["item_0294"]={["kind"]= 0,["quality"]=6}, -- 断邪之魂
	["item_0295"]={["kind"]= 0,["quality"]=6}, -- 阴泽之魂
	["item_0296"]={["kind"]= 2,["quality"]=4}, -- 寒铁匕首
	["item_0297"]={["kind"]= 3,["quality"]=4}, -- 寒铁刀
	["item_0298"]={["kind"]= 4,["quality"]=4}, -- 寒铁杖
	["item_0299"]={["kind"]= 5,["quality"]=4}, -- 寒铁枪
	["item_0300"]={["kind"]= 1,["quality"]=4}, -- 玄铁剑
	["item_0301"]={["kind"]= 2,["quality"]=4}, -- 玄铁匕首
	["item_0302"]={["kind"]= 3,["quality"]=4}, -- 玄铁刀
	["item_0303"]={["kind"]= 4,["quality"]=4}, -- 玄铁杖
	["item_0304"]={["kind"]= 5,["quality"]=4}, -- 玄铁枪
	["item_0305"]={["kind"]= 1,["quality"]=5}, -- 融火剑
	["item_0306"]={["kind"]= 2,["quality"]=5}, -- 融火匕首
	["item_0307"]={["kind"]= 3,["quality"]=5}, -- 融火刀
	["item_0308"]={["kind"]= 4,["quality"]=5}, -- 融火杖
	["item_0309"]={["kind"]= 5,["quality"]=5}, -- 融火枪
	["item_0310"]={["kind"]= 1,["quality"]=5}, -- 龙渊剑
	["item_0311"]={["kind"]= 2,["quality"]=5}, -- 龙渊匕首
	["item_0312"]={["kind"]= 3,["quality"]=5}, -- 龙渊刀
	["item_0313"]={["kind"]= 4,["quality"]=5}, -- 龙渊杖
	["item_0314"]={["kind"]= 5,["quality"]=5}, -- 龙渊枪
	["item_0315"]={["kind"]= 1,["quality"]=6}, -- 地葬龙剑
	["item_0316"]={["kind"]= 2,["quality"]=6}, -- 地葬龙匕首
	["item_0317"]={["kind"]= 3,["quality"]=6}, -- 地葬龙刀
	["item_0318"]={["kind"]= 4,["quality"]=6}, -- 地葬龙杖
	["item_0319"]={["kind"]= 5,["quality"]=6}, -- 地葬龙枪
	["item_0320"]={["kind"]= 1,["quality"]=6}, -- 先天龙火剑
	["item_0321"]={["kind"]= 2,["quality"]=6}, -- 先天龙火匕首
	["item_0322"]={["kind"]= 3,["quality"]=6}, -- 先天龙火刀
	["item_0323"]={["kind"]= 4,["quality"]=6}, -- 先天龙火杖
	["item_0324"]={["kind"]= 5,["quality"]=6}, -- 先天龙火枪
	["item_0325"]={["kind"]= 1,["quality"]=6}, -- 神灭剑
	["item_0326"]={["kind"]= 2,["quality"]=6}, -- 神灭匕首
	["item_0327"]={["kind"]= 3,["quality"]=6}, -- 神灭刀
	["item_0328"]={["kind"]= 4,["quality"]=6}, -- 神灭杖
	["item_0329"]={["kind"]= 5,["quality"]=6}, -- 神灭枪
	["item_0330"]={["kind"]= 1,["quality"]=7}, -- 夜妄剑
	["item_0331"]={["kind"]= 2,["quality"]=7}, -- 夜妄匕首
	["item_0332"]={["kind"]= 3,["quality"]=7}, -- 夜妄刀
	["item_0333"]={["kind"]= 4,["quality"]=7}, -- 夜妄杖
	["item_0334"]={["kind"]= 5,["quality"]=7}, -- 夜妄枪
	["item_0335"]={["kind"]= 1,["quality"]=7}, -- 六道剑
	["item_0336"]={["kind"]= 2,["quality"]=7}, -- 六道匕首
	["item_0337"]={["kind"]= 3,["quality"]=7}, -- 六道刀
	["item_0338"]={["kind"]= 4,["quality"]=7}, -- 六道杖
	["item_0339"]={["kind"]= 5,["quality"]=7}, -- 六道枪
	["item_0340"]={["kind"]= 1,["quality"]=7}, -- 圣灵剑
	["item_0341"]={["kind"]= 2,["quality"]=7}, -- 圣灵匕首
	["item_0342"]={["kind"]= 3,["quality"]=7}, -- 圣灵刀
	["item_0343"]={["kind"]= 4,["quality"]=7}, -- 圣灵杖
	["item_0344"]={["kind"]= 5,["quality"]=7}, -- 圣灵枪
	["item_0345"]={["kind"]= 1,["quality"]=8}, -- 圣龙魂剑
	["item_0346"]={["kind"]= 2,["quality"]=8}, -- 圣龙魂匕首
	["item_0347"]={["kind"]= 3,["quality"]=8}, -- 圣龙魂刀
	["item_0348"]={["kind"]= 4,["quality"]=8}, -- 圣龙魂杖
	["item_0349"]={["kind"]= 5,["quality"]=8}, -- 圣龙魂枪
	["item_0350"]={["kind"]= 1,["quality"]=8}, -- 圣神天剑
	["item_0351"]={["kind"]= 2,["quality"]=8}, -- 圣神天匕首
	["item_0352"]={["kind"]= 3,["quality"]=8}, -- 圣神天刀
	["item_0353"]={["kind"]= 4,["quality"]=8}, -- 圣神天杖
	["item_0354"]={["kind"]= 5,["quality"]=8}, -- 圣神天枪
	["item_0355"]={["kind"]= 1,["quality"]=8}, -- 荒天剑
	["item_0356"]={["kind"]= 2,["quality"]=8}, -- 荒天匕首
	["item_0357"]={["kind"]= 3,["quality"]=8}, -- 荒天刀
	["item_0358"]={["kind"]= 4,["quality"]=8}, -- 荒天杖
	["item_0359"]={["kind"]= 5,["quality"]=8}, -- 荒天枪
	["item_0360"]={["kind"]= 1,["quality"]=6}, -- 苍狼剑
	["item_0361"]={["kind"]= 2,["quality"]=6}, -- 苍狼战刃
	["item_0362"]={["kind"]= 3,["quality"]=6}, -- 苍狼刀
	["item_0363"]={["kind"]= 4,["quality"]=6}, -- 苍狼杖
	["item_0364"]={["kind"]= 5,["quality"]=6}, -- 苍狼枪
	["item_0365"]={["kind"]= 6,["quality"]=6}, -- 无相战靴
	["item_0366"]={["kind"]= 8,["quality"]=6}, -- 无相战盔
	["item_0367"]={["kind"]= 7,["quality"]=6}, -- 无相战甲
	["item_0368"]={["kind"]= 6,["quality"]=6}, -- 绝影之尘
	["item_0369"]={["kind"]= 8,["quality"]=6}, -- 绝影头环
	["item_0370"]={["kind"]= 7,["quality"]=6}, -- 绝影衣
	["item_0371"]={["kind"]= 6,["quality"]=6}, -- 弥光鞋
	["item_0372"]={["kind"]= 8,["quality"]=6}, -- 弥光宝盔
	["item_0373"]={["kind"]= 7,["quality"]=6}, -- 弥光法袍
	["item_0374"]={["kind"]= 9,["quality"]=6}, -- 雾然挂饰
	["item_0375"]={["kind"]= 9,["quality"]=6}, -- 雾然戒指
	["item_0376"]={["kind"]= 9,["quality"]=6}, -- 断邪链
	["item_0377"]={["kind"]= 9,["quality"]=6}, -- 断邪指环
	["item_0378"]={["kind"]= 9,["quality"]=6}, -- 阴泽护腕
	["item_0379"]={["kind"]= 9,["quality"]=6}, -- 阴泽魔镜
	["item_0380"]={["kind"]= 9,["quality"]=1}, -- 本命法器（E级）
	["item_0381"]={["kind"]= 9,["quality"]=2}, -- 本命法器（D级）
	["item_0382"]={["kind"]= 9,["quality"]=3}, -- 本命法器（C级）
	["item_0383"]={["kind"]= 9,["quality"]=4}, -- 本命法器（B级）
	["item_0384"]={["kind"]= 9,["quality"]=5}, -- 本命法器（A级）
	["item_0385"]={["kind"]= 9,["quality"]=6}, -- 本命法器（S级）
	["item_0386"]={["kind"]= 9,["quality"]=7}, -- 本命法器（Z级）
	["item_0387"]={["kind"]= 9,["quality"]=8}, -- 本命法器（EX级）
	["item_0388"]={["kind"]= 0,["quality"]=3}, -- 灵石碎片
	["item_0389"]={["kind"]= 9,["quality"]=6}, -- 巫王盾
	["item_0390"]={["kind"]= 9,["quality"]=7}, -- 巫妖神骨
	["item_0391"]={["kind"]= 0,["quality"]=4}, -- 巫族战骨
	["item_0392"]={["kind"]=11,["quality"]=6}, -- 火麟内丹
	["item_0393"]={["kind"]=11,["quality"]=6}, -- 冰蛟内丹
	["item_0394"]={["kind"]=11,["quality"]=6}, -- 水蛟内丹
	["item_0395"]={["kind"]=11,["quality"]=6}, -- 土灵内丹
	["item_0396"]={["kind"]=11,["quality"]=6}, -- 木吞内丹
	["item_0397"]={["kind"]= 7,["quality"]=5}, -- 火麟战甲
	["item_0398"]={["kind"]= 7,["quality"]=5}, -- 冰角战甲
	["item_0399"]={["kind"]= 9,["quality"]=5}, -- 水蛟神饰
	["item_0400"]={["kind"]= 9,["quality"]=5}, -- 土灵神饰
	["item_0401"]={["kind"]= 0,["quality"]=6}, -- 火神珠
	["item_0402"]={["kind"]= 0,["quality"]=6}, -- 冰神珠
	["item_0403"]={["kind"]= 0,["quality"]=6}, -- 水神珠
	["item_0404"]={["kind"]= 0,["quality"]=6}, -- 土神珠
	["item_0405"]={["kind"]= 0,["quality"]=6}, -- 木神珠
	["item_0406"]={["kind"]= 0,["quality"]=5}, -- 石川之灵
	["item_0407"]={["kind"]= 8,["quality"]=5}, -- 石川宝盔
	["item_0408"]={["kind"]= 6,["quality"]=5}, -- 石川宝靴
	["item_0409"]={["kind"]= 7,["quality"]=5}, -- 石川宝甲
	["item_0410"]={["kind"]= 9,["quality"]=5}, -- 无护天戒
	["item_0411"]={["kind"]= 9,["quality"]=5}, -- 天晶挂坠
	["item_0412"]={["kind"]= 9,["quality"]=5}, -- 阐石魔戒
	["item_0413"]={["kind"]= 0,["quality"]=5}, -- 妖族之骨
	["item_0414"]={["kind"]= 0,["quality"]=5}, -- 妖族精髓
	["item_0415"]={["kind"]= 6,["quality"]=5}, -- 娲皇战靴
	["item_0416"]={["kind"]= 8,["quality"]=5}, -- 娲皇战盔
	["item_0417"]={["kind"]= 7,["quality"]=5}, -- 娲皇战甲
	["item_0418"]={["kind"]= 6,["quality"]=5}, -- 娲皇道靴
	["item_0419"]={["kind"]= 8,["quality"]=5}, -- 娲皇道冠
	["item_0420"]={["kind"]= 7,["quality"]=5}, -- 娲皇道袍
	["item_0421"]={["kind"]= 0,["quality"]=6}, -- 圣灵战符
	["item_0422"]={["kind"]= 0,["quality"]=6}, -- 圣灵法印
	["item_0423"]={["kind"]=11,["quality"]=5}, -- 通灵丹
	["item_0424"]={["kind"]= 1,["quality"]=5}, -- 无常剑
	["item_0425"]={["kind"]= 2,["quality"]=5}, -- 无常匕首
	["item_0426"]={["kind"]= 3,["quality"]=5}, -- 无常刀
	["item_0427"]={["kind"]= 4,["quality"]=5}, -- 无常杖
	["item_0428"]={["kind"]= 5,["quality"]=5}, -- 无常枪
	["item_0429"]={["kind"]= 6,["quality"]=6}, -- 六道天靴
	["item_0430"]={["kind"]= 8,["quality"]=6}, -- 六道天冠
	["item_0431"]={["kind"]= 7,["quality"]=6}, -- 六道天衣
	["item_0432"]={["kind"]= 9,["quality"]=7}, -- 六道魔环
	["item_0433"]={["kind"]= 9,["quality"]=8}, -- 六道轮回
	["item_0434"]={["kind"]= 6,["quality"]=6}, -- 娲神魔靴
	["item_0435"]={["kind"]= 8,["quality"]=6}, -- 娲神魔盔
	["item_0436"]={["kind"]= 7,["quality"]=6}, -- 娲神魔甲
	["item_0437"]={["kind"]= 6,["quality"]=6}, -- 娲神仙鞋
	["item_0438"]={["kind"]= 8,["quality"]=6}, -- 娲神仙冠
	["item_0439"]={["kind"]= 7,["quality"]=6}, -- 娲神仙袍
	["item_0440"]={["kind"]= 8,["quality"]=7}, -- 圣灵冠
	["item_0441"]={["kind"]= 6,["quality"]=7}, -- 圣灵靴
	["item_0442"]={["kind"]= 7,["quality"]=7}, -- 圣灵甲
	["item_0443"]={["kind"]= 0,["quality"]=6}, -- 追魂夺命书
	["item_0444"]={["kind"]= 0,["quality"]=6}, -- 紫玉判官笔
	["item_0445"]={["kind"]= 9,["quality"]=6}, -- 镇邪印
	["item_0446"]={["kind"]= 0,["quality"]=6}, -- 七星炼魔剑
	["item_0447"]={["kind"]= 0,["quality"]=6}, -- 拘魂幡
	["item_0448"]={["kind"]= 9,["quality"]=6}, -- 紫金葫芦
	["item_0449"]={["kind"]= 6,["quality"]=6}, -- 阎刹鞋
	["item_0450"]={["kind"]= 8,["quality"]=6}, -- 策魔冠
	["item_0451"]={["kind"]= 7,["quality"]=6}, -- 镇狱铠
	["item_0452"]={["kind"]= 0,["quality"]=6}, -- 阎王鞭
	["item_0453"]={["kind"]= 9,["quality"]=6}, -- 无护魔环
	["item_0454"]={["kind"]= 9,["quality"]=7}, -- 太上紫金葫芦
	["item_0455"]={["kind"]= 9,["quality"]=7}, -- 太上镇邪印
	["item_0456"]={["kind"]= 9,["quality"]=5}, -- 木吞神饰
	["item_0457"]={["kind"]= 4,["quality"]=3}, -- 九龙杖
	["item_0458"]={["kind"]= 0,["quality"]=7}, -- 融合石
	["item_0459"]={["kind"]= 9,["quality"]=7}, -- 伏羲琴
	["item_0460"]={["kind"]= 9,["quality"]=7}, -- 九天息壤
	["item_0461"]={["kind"]= 0,["quality"]=5}, -- 冤魂
	["item_0462"]={["kind"]= 0,["quality"]=5}, -- 鬼斧
	["item_0463"]={["kind"]= 0,["quality"]=5}, -- 判官笔
	["item_0464"]={["kind"]= 1,["quality"]=6}, -- 天罡
	["item_0465"]={["kind"]= 2,["quality"]=6}, -- 涵虚
	["item_0466"]={["kind"]= 3,["quality"]=6}, -- 魑魅
	["item_0467"]={["kind"]= 4,["quality"]=6}, -- 离火
	["item_0468"]={["kind"]= 5,["quality"]=6}, -- 日月
	["item_0469"]={["kind"]= 1,["quality"]=6}, -- 地煞
	["item_0470"]={["kind"]= 2,["quality"]=6}, -- 幽谷
	["item_0471"]={["kind"]= 3,["quality"]=6}, -- 魍魉
	["item_0472"]={["kind"]= 4,["quality"]=6}, -- 凝冰
	["item_0473"]={["kind"]= 5,["quality"]=6}, -- 星辰
	["item_0474"]={["kind"]= 1,["quality"]=7}, -- 天煞神尺（未觉醒）
	["item_0475"]={["kind"]= 2,["quality"]=7}, -- 虹谷幽冥（未觉醒）
	["item_0476"]={["kind"]= 3,["quality"]=7}, -- 魑魅魍魉（未觉醒）
	["item_0477"]={["kind"]= 4,["quality"]=7}, -- 蝉火离冰（未觉醒）
	["item_0478"]={["kind"]= 5,["quality"]=7}, -- 痕转星辰（未觉醒）
	["item_0479"]={["kind"]= 1,["quality"]=8}, -- 天煞神尺（觉醒）
	["item_0480"]={["kind"]= 2,["quality"]=8}, -- 虹谷幽冥（觉醒）
	["item_0481"]={["kind"]= 3,["quality"]=8}, -- 魑魅魍魉（觉醒）
	["item_0482"]={["kind"]= 4,["quality"]=8}, -- 蝉火离冰（觉醒）
	["item_0483"]={["kind"]= 5,["quality"]=8}, -- 痕转星辰（觉醒）
	["item_0484"]={["kind"]= 9,["quality"]=7}, -- 冥府幽蝶
	["item_0485"]={["kind"]= 0,["quality"]=6}, -- 天灵符
	["item_0486"]={["kind"]= 0,["quality"]=6}, -- 天仙符
	["item_0487"]={["kind"]= 0,["quality"]=6}, -- 天穹石
	["item_0488"]={["kind"]= 0,["quality"]=6}, -- 凌空百尺
	["item_0489"]={["kind"]= 0,["quality"]=6}, -- 绝乐轮
	["item_0490"]={["kind"]= 0,["quality"]=6}, -- 天明神录
	["item_0491"]={["kind"]= 0,["quality"]=6}, -- 圣方宝印
	["item_0492"]={["kind"]= 0,["quality"]=7}, -- 真武魔印
	["item_0493"]={["kind"]= 0,["quality"]=7}, -- 真武法印
	["item_0494"]={["kind"]= 0,["quality"]=7}, -- 天庭之钥
	["item_0495"]={["kind"]= 0,["quality"]=7}, -- 地府之钥
	["item_0496"]={["kind"]= 1,["quality"]=6}, -- 苍穹慈航剑
	["item_0497"]={["kind"]= 2,["quality"]=6}, -- 苍穹慈航匕首
	["item_0498"]={["kind"]= 3,["quality"]=6}, -- 苍穹慈航刀
	["item_0499"]={["kind"]= 4,["quality"]=6}, -- 苍穹慈航仗
	["item_0500"]={["kind"]= 5,["quality"]=6}, -- 苍穹慈航枪
	["item_0501"]={["kind"]= 6,["quality"]=7}, -- 涅槃冲霄鞋
	["item_0502"]={["kind"]= 8,["quality"]=7}, -- 焚月苍炎冠
	["item_0503"]={["kind"]= 7,["quality"]=7}, -- 赤凤九霄袍
	["item_0504"]={["kind"]= 6,["quality"]=7}, -- 自在乾天靴
	["item_0505"]={["kind"]= 8,["quality"]=7}, -- 归元天罡盔
	["item_0506"]={["kind"]= 7,["quality"]=7}, -- 极意无上铠
	["item_0507"]={["kind"]= 6,["quality"]=7}, -- 玄陨震天靴
	["item_0508"]={["kind"]= 8,["quality"]=7}, -- 千炼大乘盔
	["item_0509"]={["kind"]= 7,["quality"]=7}, -- 天命八荒甲
	["item_0510"]={["kind"]= 6,["quality"]=8}, -- 圣灵*涅槃冲霄鞋
	["item_0511"]={["kind"]= 8,["quality"]=8}, -- 圣灵*焚月苍炎冠
	["item_0512"]={["kind"]= 7,["quality"]=8}, -- 圣灵*赤凤九霄袍
	["item_0513"]={["kind"]= 6,["quality"]=8}, -- 圣灵*自在乾天靴
	["item_0514"]={["kind"]= 8,["quality"]=8}, -- 圣灵*归元天罡盔
	["item_0515"]={["kind"]= 7,["quality"]=8}, -- 圣灵*极意无上铠
	["item_0516"]={["kind"]= 6,["quality"]=8}, -- 圣灵*玄陨震天靴
	["item_0517"]={["kind"]= 8,["quality"]=8}, -- 圣灵*千炼大乘盔
	["item_0518"]={["kind"]= 7,["quality"]=8}, -- 圣灵*天命八荒甲
	["item_0519"]={["kind"]= 0,["quality"]=7}, -- 圣灵碎片
	["item_0520"]={["kind"]=11,["quality"]=6}, -- 珍奇动物
	["item_0521"]={["kind"]= 0,["quality"]=6}, -- 碧河密藏
	["item_0522"]={["kind"]= 6,["quality"]=5}, -- 破羽迷靴
	["item_0523"]={["kind"]= 8,["quality"]=5}, -- 破羽战盔
	["item_0524"]={["kind"]= 7,["quality"]=5}, -- 破羽霜甲
	["item_0525"]={["kind"]= 9,["quality"]=6}, -- 囚恒
	["item_0526"]={["kind"]= 9,["quality"]=6}, -- 悲玉
	["item_0527"]={["kind"]= 0,["quality"]=7}, -- 伏灭之匣
	["item_0528"]={["kind"]= 0,["quality"]=7}, -- 魍魉之匣
	["item_0529"]={["kind"]= 8,["quality"]=5}, -- 行龙盔
	["item_0530"]={["kind"]= 7,["quality"]=5}, -- 行龙铠
	["item_0531"]={["kind"]= 9,["quality"]=4}, -- 囚魔玉环
	["item_0532"]={["kind"]= 9,["quality"]=4}, -- 噬心魔坠
	["item_0533"]={["kind"]= 9,["quality"]=5}, -- 凝冰神尺
	["item_0534"]={["kind"]= 9,["quality"]=5}, -- 天玄魔环
	["item_0535"]={["kind"]= 7,["quality"]=6}, -- 冰烈炎霜袍
	["item_0536"]={["kind"]= 9,["quality"]=5}, -- 融火玄珠
	["item_0537"]={["kind"]= 9,["quality"]=6}, -- 冰火魔印
	["item_0538"]={["kind"]= 9,["quality"]=6}, -- 神冰玄晶
	["item_0539"]={["kind"]= 8,["quality"]=6}, -- 极寒头环
	["item_0540"]={["kind"]= 9,["quality"]=6}, -- 极寒护手
	["item_0541"]={["kind"]= 9,["quality"]=7}, -- 玄冰魔影
	["item_0542"]={["kind"]= 7,["quality"]=7}, -- 蚩尤战甲
	["item_0543"]={["kind"]= 9,["quality"]=7}, -- 九黎战盾
	["item_0544"]={["kind"]= 9,["quality"]=7}, -- 黎殇战角
	["item_0545"]={["kind"]= 9,["quality"]=7}, -- 黎殇魔旗
	["item_0546"]={["kind"]= 9,["quality"]=8}, -- 都天神旗
	["item_0547"]={["kind"]= 0,["quality"]=4}, -- 山风羽翼
	["item_0548"]={["kind"]= 9,["quality"]=7}, -- 地书
	["item_0549"]={["kind"]= 7,["quality"]=7}, -- 冥炎宝羽
	["item_0550"]={["kind"]= 9,["quality"]=7}, -- 阐石鬼火
	["item_0551"]={["kind"]= 9,["quality"]=8}, -- 不落冥河
	["item_0552"]={["kind"]= 0,["quality"]=5}, -- 邪佛精元
	["item_0553"]={["kind"]= 0,["quality"]=5}, -- 悟阐
	["item_0554"]={["kind"]= 0,["quality"]=5}, -- 悟道
	["item_0555"]={["kind"]= 1,["quality"]=5}, -- 巫邪长剑
	["item_0556"]={["kind"]= 2,["quality"]=5}, -- 巫邪匕首
	["item_0557"]={["kind"]= 3,["quality"]=5}, -- 巫邪长刀
	["item_0558"]={["kind"]= 4,["quality"]=5}, -- 巫邪法杖
	["item_0559"]={["kind"]= 5,["quality"]=5}, -- 巫邪长枪
	["item_0560"]={["kind"]= 7,["quality"]=5}, -- 巫邪甲
	["item_0561"]={["kind"]= 6,["quality"]=5}, -- 巫邪靴
	["item_0562"]={["kind"]= 8,["quality"]=5}, -- 巫邪盔
	["item_0563"]={["kind"]= 7,["quality"]=5}, -- 巫邪袍
	["item_0564"]={["kind"]= 6,["quality"]=5}, -- 巫邪鞋
	["item_0565"]={["kind"]= 8,["quality"]=5}, -- 巫邪帽
	["item_0566"]={["kind"]= 0,["quality"]=5}, -- 九黎之髓
	["item_0567"]={["kind"]= 9,["quality"]=5}, -- 九黎耳环
	["item_0568"]={["kind"]= 8,["quality"]=6}, -- 九黎战盔
	["item_0569"]={["kind"]= 7,["quality"]=6}, -- 九黎战甲
	["item_0570"]={["kind"]= 8,["quality"]=5}, -- 真武太极道冠（淬炼）
	["item_0571"]={["kind"]= 7,["quality"]=5}, -- 真武太极道服（淬炼）
	["item_0572"]={["kind"]= 6,["quality"]=5}, -- 真武太极道靴（淬炼）
	["item_0573"]={["kind"]= 9,["quality"]=6}, -- 混元金斗
	["item_0574"]={["kind"]= 7,["quality"]=3}, -- 寒雪服
	["item_0575"]={["kind"]= 8,["quality"]=3}, -- 寒雪帽
	["item_0576"]={["kind"]=11,["quality"]=3}, -- 凝冰精元
	["item_0577"]={["kind"]= 0,["quality"]=2}, -- 雪妖皮
	["item_0578"]={["kind"]= 7,["quality"]=4}, -- 寒雪妖服
	["item_0579"]={["kind"]= 8,["quality"]=4}, -- 寒雪妖帽
	["item_0580"]={["kind"]= 9,["quality"]=7}, -- 炽芒
	["item_0581"]={["kind"]= 6,["quality"]=7}, -- 天穹神靴
	["item_0582"]={["kind"]= 8,["quality"]=7}, -- 天穹神冠
	["item_0583"]={["kind"]= 7,["quality"]=7}, -- 天穹神衣
	["item_0584"]={["kind"]= 0,["quality"]=7}, -- 天池宝匣
	["item_0585"]={["kind"]= 0,["quality"]=3}, -- 低级强化石
	["item_0586"]={["kind"]= 0,["quality"]=4}, -- 中级强化石
	["item_0587"]={["kind"]= 0,["quality"]=6}, -- 高级强化石
	["item_0588"]={["kind"]= 0,["quality"]=7}, -- 终极强化石
	["item_0589"]={["kind"]= 9,["quality"]=7}, -- 太上真武天极挂饰
	["item_0590"]={["kind"]= 9,["quality"]=7}, -- 娲皇圣造
	["item_0591"]={["kind"]= 0,["quality"]=5}, -- 天地熔炉藏宝图
	["item_0592"]={["kind"]= 0,["quality"]=5}, -- 千年雪山藏宝图
}