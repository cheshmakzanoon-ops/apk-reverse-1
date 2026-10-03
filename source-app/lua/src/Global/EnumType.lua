UIWindowNames = require("UI.Config.UIWindowNames")
ProxyList = {
  "lastwar-game-us-aws-ali.lastwargame.com",
  "lastwar-game-us-cf-ali.lastwarapp.com"
}
ProxyName = {"aws", "cf"}
LoginErrorCode = {
  ERROR_CONN_LOST = "error connect lost",
  ERROR_LOGOUT = "error logout",
  ERROR_NO_NET = "error no net",
  ERROR_CONNECT = "error connect error",
  ERROR_BANID = "4",
  ERROR_IPBLACK = "43",
  ERROR_DEVICEBLACK = "44",
  ACCOUNT_DELETE_APPLY = "45",
  ACCOUNT_DELETE = "46",
  ACCOUNT_DELETE_REFUSE = "47",
  ACCOUNT_DELETE_CONFIRMED = "48",
  ERROR_SUCCESS = "E000",
  ERROR_NETWORK = "E101",
  ERROR_HTTP = "E102",
  ERROR_JSON = "E103",
  ERROR_DATA = "E104",
  ERROR_UNREACHABLE = "E105",
  ERROR_INIT = "E106",
  ERROR_INIT_TIMEOUT = "E107",
  ERROR_TIMEOUT = "E108",
  ERROR_MAINTENANCE = "E109",
  ERROR_SERVER_STATE = "E110",
  ERROR_LOAD_DATATABLE = "E111",
  ERROR_LOAD_DATATABLE_TIMEOUT = "E112",
  ERROR_LOGIN_TIMEOUT = "E113",
  ERROR_UPDATE_MANIFEST = "E114",
  ERROR_DOWNLOAD_UPDATE = "E115",
  ERROR_SERVER_LIST = "E116",
  ERROR_LOGIN_ERROR = "E117"
}
ResPointInfoType = {
  Normal = 0,
  Radar = 1,
  BlackDiamond = 3
}
ResourceType = {
  None = -1,
  Oil = 0,
  Metal = 1,
  Wood = 2,
  PVE_STAMINA = 3,
  People = 4,
  OBSIDIAN = 10,
  Water = 11,
  Electricity = 12,
  FLINT = 13,
  Food = 14,
  Gold = 15,
  PvePoint = 17,
  MedalOfWisdom = 18,
  FarmBox = 19,
  DETECT_EVENT = 20,
  FORMATION_STAMINA = 21,
  BattlePass = 22,
  Petroleum = 23,
  GoldBrick = 24,
  BatteryPower = 25,
  Max = 100,
  BlackKnight = 9001,
  MasteryPoint = 9002,
  AllianceDragonPoint = 9003,
  ResourceItem = 10000,
  AlliancePoint = 1004,
  DragonPoint = 1005,
  ResistancePoint = 1006,
  AllianceBattleReward = 1007,
  DragonItem = 11001,
  AllianceStone = 11014,
  AllianceCoal = 11015,
  AllianceFarmerExp = 11016,
  AllianceFarmerExpItem = 11017,
  MeteoriteNucleusOfStar = 11018,
  MeteoriteCrystallization = 11019,
  SkyBattleGold = 12000,
  PAID_GOLD = 9002,
  GoldProgress = 12001
}
PowerWorkerStatus = {
  WAIT = "0",
  CHARGE_SELF = "1",
  MARCH = "2",
  CHARGE_OTHER = "3",
  CHARGE_SUPPLIES = "4",
  CHARGE_GOLD_TREE = "5"
}
LightHouseUpdateType = {
  SERVER_INIT = 0,
  BRIGHTNESS_CHANGE = 1,
  BUILD_LEVEL_CHANGE = 2,
  OTHER_WORKER_ARRIVE = 3,
  OTHER_WORKER_LEAVE = 4,
  SELF_WORKER_UPDATE = 5,
  MOVE_BASE = 6,
  MOVE_ALLIANCE_BUILDING = 7,
  CROSS_MOVE = 8,
  CROSS_MOVE_ROLL_BACK = 9,
  FOLD_UP_BASE = 10,
  AllianceBuildingBuildFinish = 11,
  autoDownGradeOpen = 12,
  AllianceBuildingDestroy = 13,
  AllianceBuildingRepair = 14,
  AllianceBuildingLvChange = 15
}
LightIconByLevel = {
  [0] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png",
  [1] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_04.png",
  [2] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_05.png",
  [3] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_06.png",
  [4] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_07.png"
}
GlobalShaderLod = {
  LOW = 0,
  MIDDLE = 1,
  HIGH = 2
}
HeroBountyRarity = {
  White = 1,
  Green = 2,
  Blue = 3,
  Purple = 4,
  Orange = 5,
  Red = 6
}
HeroBountyRarityColor = {
  [HeroBountyRarity.White] = Color.New(0.996078431372549, 0.9411764705882353, 0.8509803921568627, 1),
  [HeroBountyRarity.Green] = Color.New(0.5803921568627451, 0.8823529411764706, 0.2196078431372549, 1),
  [HeroBountyRarity.Blue] = Color.New(0.37254901960784315, 0.6392156862745098, 0.9294117647058824, 1),
  [HeroBountyRarity.Purple] = Color.New(0.788235294117647, 0.4235294117647059, 0.9411764705882353, 1),
  [HeroBountyRarity.Orange] = Color.New(0.9803921568627451, 0.5333333333333333, 0.2627450980392157, 1),
  [HeroBountyRarity.Red] = Color.New(0.9490196078431372, 0.41568627450980394, 0.403921568627451, 1)
}
RewardType = {
  OIL = 0,
  METAL = 1,
  Wood = 2,
  GOLD = 5,
  EXP = 6,
  GOODS = 7,
  GENERAL = 8,
  POWER = 9,
  HONOR = 10,
  ALLIANCE_POINT = 11,
  HOUSE = 12,
  HOSPITAL = 13,
  EQUIP = 14,
  MATERIAL = 15,
  PART = 16,
  ITEM_EFFECT = 17,
  BATTLE_HONOR = 18,
  WATER = 19,
  FOOD = 20,
  ELECTRICITY = 21,
  PEOPLE = 22,
  ARM = 23,
  MANOR = 24,
  HERO = 25,
  PTGOLD = 26,
  RESOURCE_ITEM = 27,
  PVE_POINT = 28,
  DETECT_EVENT = 29,
  FORMATION_STAMINA = 30,
  WOOD = 31,
  PVE_STAMINA = 32,
  PVE_MONUMENT_TIME = 33,
  PVE_ACT_SCORE = 34,
  MuseumArtifact = 35,
  WORKER = 36,
  VISITOR = 37,
  CommonEquip = 38,
  DecorateBuild = 39,
  DragonWorldPoint = 40,
  Building = 41,
  OBSIDIAN = 42,
  FLINT = 43,
  Resistance_Point = 44,
  AllianceBattleReward = 45,
  TWSkillChip = 46,
  PETROLEUM = 47,
  TACTICAL_CARD = 48,
  EMOTION_SELECT = 49,
  CHAT_EMOTION = 50,
  FAVOR = 999,
  PartyMonster = 888,
  SEVENDAY_SCORE = 1001,
  Golloes = 1002,
  SAPPHIRE = 1003,
  ALLIANCE_DONATE = 1004,
  ALLIANCE_SCIENCE_TECH_POINT = 1005,
  UnlockModule = 1007,
  HERO_EXP = 1008,
  BATTLE_PASS = 1009,
  TALENT = 1010,
  RESOURCE = 1011,
  ALLIANCE_GIFT = 1012,
  MonthCard = 1013,
  DailyTaskPoint = 1014,
  EquipStrengtheningStone = 1015,
  ScrewSpike = 1016,
  FourthFormation = 1017,
  MonthCardBuff = 1018,
  MarchDefReductionBuff = 1019,
  ActGiftBox = 1021,
  Credit = 1022,
  MASTERY_POINT = 1023,
  FISH = 1024,
  AllianceStone = 11014,
  AllianceCoal = 11015,
  AllianceFarmerExp = 11016,
  AllianceFarmerExpItem = 11017,
  MeteoriteNucleusOfStar = 11018,
  MeteoriteCrystallization = 11019,
  ArmsMedal = 9001,
  PAID_GOLD = 9002,
  TacticalWeaponPart = 7038
}
RewardToResType = {
  [RewardType.OIL] = ResourceType.Oil,
  [RewardType.METAL] = ResourceType.Metal,
  [RewardType.Wood] = ResourceType.Wood,
  [RewardType.WATER] = ResourceType.Water,
  [RewardType.ELECTRICITY] = ResourceType.Electricity,
  [RewardType.FOOD] = ResourceType.Food,
  [RewardType.GOLD] = ResourceType.Gold,
  [RewardType.PVE_POINT] = ResourceType.PvePoint,
  [RewardType.OBSIDIAN] = ResourceType.OBSIDIAN,
  [RewardType.FLINT] = ResourceType.FLINT,
  [RewardType.AllianceStone] = ResourceType.AllianceStone,
  [RewardType.AllianceCoal] = ResourceType.AllianceCoal,
  [RewardType.AllianceFarmerExp] = ResourceType.AllianceFarmerExp,
  [RewardType.AllianceFarmerExpItem] = ResourceType.AllianceFarmerExpItem,
  [RewardType.DETECT_EVENT] = ResourceType.DETECT_EVENT,
  [RewardType.FORMATION_STAMINA] = ResourceType.FORMATION_STAMINA,
  [RewardType.WOOD] = ResourceType.Wood,
  [RewardType.PVE_STAMINA] = ResourceType.PVE_STAMINA,
  [RewardType.PEOPLE] = ResourceType.People,
  [RewardType.ALLIANCE_DONATE] = ResourceType.AlliancePoint,
  [RewardType.DragonWorldPoint] = ResourceType.DragonPoint,
  [RewardType.MASTERY_POINT] = ResourceType.MasteryPoint,
  [RewardType.Resistance_Point] = ResourceType.ResistancePoint,
  [RewardType.AllianceBattleReward] = ResourceType.AllianceBattleReward,
  [RewardType.PETROLEUM] = ResourceType.Petroleum,
  [RewardType.MeteoriteNucleusOfStar] = ResourceType.MeteoriteNucleusOfStar,
  [RewardType.MeteoriteCrystallization] = ResourceType.MeteoriteCrystallization
}
ResourceItemId = {
  Supply = 3005,
  EquipStrengtheningStone = 6001,
  ScrewSpike = 7001,
  HeroExp = 8001
}
ResTypeToReward = {
  [ResourceType.Oil] = RewardType.OIL,
  [ResourceType.Metal] = RewardType.METAL,
  [ResourceType.Water] = RewardType.WATER,
  [ResourceType.Electricity] = RewardType.ELECTRICITY,
  [ResourceType.Food] = RewardType.FOOD,
  [ResourceType.Gold] = RewardType.GOLD,
  [ResourceType.PvePoint] = RewardType.PVE_POINT,
  [ResourceType.DETECT_EVENT] = RewardType.DETECT_EVENT,
  [ResourceType.FORMATION_STAMINA] = RewardType.FORMATION_STAMINA,
  [ResourceType.Wood] = RewardType.WOOD,
  [ResourceType.PVE_STAMINA] = RewardType.PVE_STAMINA,
  [ResourceType.People] = RewardType.PEOPLE,
  [ResourceType.AlliancePoint] = RewardType.ALLIANCE_DONATE,
  [ResourceType.DragonPoint] = RewardType.DragonWorldPoint,
  [ResourceType.ResistancePoint] = RewardType.Resistance_Point,
  [ResourceType.AllianceBattleReward] = RewardType.AllianceBattleReward,
  [ResourceType.OBSIDIAN] = RewardType.OBSIDIAN,
  [ResourceType.FLINT] = RewardType.FLINT,
  [ResourceType.MasteryPoint] = RewardType.MASTERY_POINT,
  [ResourceType.ResistancePoint] = RewardType.Resistance_Point,
  [ResourceType.AllianceBattleReward] = RewardType.AllianceBattleReward,
  [ResourceType.Petroleum] = RewardType.PETROLEUM,
  [ResourceItemId.HeroExp] = RewardType.HERO_EXP,
  [ResourceItemId.EquipStrengtheningStone] = RewardType.EquipStrengtheningStone,
  [ResourceItemId.ScrewSpike] = RewardType.ScrewSpike
}
GOODS_TYPE = {
  GOODS_TYPE_0 = 0,
  GOODS_TYPE_1 = 1,
  GOODS_TYPE_2 = 2,
  GOODS_TYPE_3 = 3,
  GOODS_TYPE_4 = 4,
  GOODS_TYPE_5 = 5,
  GOODS_TYPE_6 = 6,
  GOODS_TYPE_7 = 7,
  GOODS_TYPE_8 = 8,
  GOODS_TYPE_9 = 9,
  GOODS_TYPE_13 = 13,
  GOODS_TYPE_15 = 15,
  GOODS_TYPE_16 = 22,
  GOODS_TYPE_23 = 23,
  GOODS_TYPE_35 = 35,
  GOODS_TYPE_39 = 39,
  GOODS_TYPE_41 = 41,
  GOODS_TYPE_45 = 45,
  GOODS_TYPE_46 = 46,
  GOODS_TYPE_50 = 50,
  GOODS_TYPE_57 = 57,
  GOODS_TYPE_59 = 59,
  GOODS_TYPE_62 = 62,
  GOODS_TYPE_63 = 63,
  GOODS_TYPE_66 = 66,
  GOODS_TYPE_70 = 70,
  GOODS_TYPE_79 = 79,
  GOODS_TYPE_80 = 80,
  GOODS_TYPE_90 = 90,
  GOODS_TYPE_93 = 93,
  GOODS_TYPE_98 = 98,
  GOODS_TYPE_99 = 99,
  GOODS_TYPE_101 = 101,
  GOODS_TYPE_102 = 102,
  GOODS_TYPE_106 = 106,
  GOODS_TYPE_107 = 107,
  GOODS_TYPE_108 = 108,
  GOODS_TYPE_109 = 109,
  GOODS_TYPE_110 = 110,
  GOODS_TYPE_111 = 111,
  GOODS_TYPE_113 = 113,
  GOODS_TYPE_133 = 133,
  GOODS_TYPE_134 = 134,
  GOODS_TYPE_135 = 135,
  GOODS_TYPE_136 = 136,
  GOODS_TYPE_137 = 137,
  GOODS_TYPE_138 = 138,
  GOODS_TYPE_139 = 139,
  GOODS_TYPE_140 = 140,
  GOODS_TYPE_141 = 141,
  GOODS_TYPE_142 = 142,
  GOODS_TYPE_144 = 144,
  GOODS_TYPE_146 = 146,
  GOODS_TYPE_147 = 147,
  GOODS_TYPE_148 = 148,
  GOODS_TYPE_149 = 149,
  GOODS_TYPE_DRAW_BOX = 150,
  GOODS_TYPE_151 = 151,
  GOODS_TYPE_154 = 154,
  GOODS_TYPE_160 = 160,
  GOODS_TYPE_161 = 161,
  GOODS_TYPE_162 = 162,
  GOODS_TYPE_158 = 158,
  GOODS_TYPE_165 = 165,
  GOODS_TYPE_166 = 166,
  GOODS_TYPE_170 = 170,
  GOODS_TYPE_172 = 172,
  GOODS_TYPE_174 = 174,
  GOODS_TYPE_175 = 175,
  GOODS_TYPE_173 = 173,
  GOODS_TYPE_176 = 176,
  GOODS_TYPE_178 = 178,
  GOODS_TYPE_179 = 179,
  GOODS_TYPE_181 = 181,
  GOODS_TYPE_182 = 182,
  GOODS_TYPE_183 = 183,
  GOODS_TYPE_184 = 184,
  GOODS_TYPE_185 = 185,
  GOODS_TYPE_186 = 186,
  GOODS_TYPE_187 = 187,
  GOODS_TYPE_190 = 190,
  GOODS_TYPE_191 = 191,
  GOODS_TYPE_192 = 192
}
GOODS_TYPE2 = {
  ResourceItem = 1,
  PVEEnergy = 3,
  HeroExp = 20,
  StaminaItem = 21,
  MarchSpeedItem = 22,
  DecoratorItem = 23
}
GOODS_TIPS_TYPE = {
  Box = 1,
  BoxWithoutProbability = 2,
  BoxTag = 3,
  BoxTacticalCard = 4
}
GOODS_POPUP_TYPE = {
  Decoration = 2,
  Hero = 3,
  TWSkillChip = 4,
  Dominator = 5,
  CommonRewardSelection = 6
}
EffectStateDefine = {
  LORD_SKILL_PROTECTED = 501051,
  PLAYER_PROTECTED_TIME1 = 500000,
  PLAYER_PROTECTED_TIME2 = 500001,
  PLAYER_PROTECTED_TIME3 = 500002,
  PLAYER_PROTECTED_TIME4 = 500003,
  PLAYER_PROTECTED_TIME5 = 500004,
  NEW_PLAYER_PROTECTED = 500009,
  CHINESE_WIND_SKIN = 500526
}
PushType = {
  PUSH_GM = 0,
  PUSH_QUEUE = 1,
  PUSH_WORLD = 2,
  PUSH_MAIL = 3,
  PUSH_STATUS = 4,
  PUSH_ALLIANCE = 5,
  PUSH_ACTIVITY = 6,
  PUSH_RESOURCE = 7,
  PUSH_CHAT = 8,
  PUSH_REWARD = 9,
  PUSH_WEB_ONLINE = 10,
  PUSH_ATTACK = 11,
  PUSH_SCOUT = 12,
  NOT_CHECK = 99
}
AtlasAssets = {
  ItemAtlas = "ItemIcons",
  ItemAtlas1 = "ItemIcons1",
  ResourceAtlas = "Resource",
  SoldierIcons = "SoldierIcons",
  MonsterBodyAtlas = "MonsterBody",
  UIAllianceFlag = "AllianceFlags",
  UIAllianceWar = "AllianceWar",
  UIWorldCity = "Scene_WorldCity",
  CountryFlag = "CountryFlag",
  SceneMiniMap = "Scene_MiniMap",
  UIBuildBtns = "UI_UIBuildBtns",
  SceneRoad = "Scene_road",
  UICommon = "UI_Common",
  UICommonBG = "UI_CommonBG",
  WorldResource = "Scene_WorldResource",
  UIMail = "UI_UIMail",
  UIFormation = "UI_UIFormation",
  UIActivityPreView = "UI_UIActivityPreView",
  EquipAtlas = "Equip",
  SceneWorld = "Scene_World",
  ServerMap = "Scene_ServerMap",
  TalentIcon = "UI_TalentIcon",
  CommonDefault = "UI_CommonDefault",
  UIBattle = "UI_Battle_BattleUI",
  WorldBuild = "WorldBuild",
  UI_DoomsdayBattleGuide = "UI_DoomsdayBattleGuide",
  UI_WelfareCenter = "UI_WelfareCenter",
  UI_KingdomFace = "UI_KingdomFace",
  UI_NoteBook = "UI_UINoteBook",
  UI_BuildMenu = "UI_BuildMenu",
  UI_UIMissile = "UI_UIMissile",
  UI_Decoration = "UI_Decoration",
  DynamicAtlas = "DynamicAtlas0",
  UI_UITilepop = "UI_UITilepop",
  UI_UIResourceProduction = "UI_UIResourceProduction",
  HUP = "HUP",
  UI_UIMain = "UI_UIMain",
  UI_GiftPackage = "UI_GIftPackage_GiftCommon",
  Science = "UI_UIScience",
  ScienceIcons = "ScienceIcons",
  UI_UIHeroInfo = "UI_UIHeroInfo",
  UITask = "UI_UITask",
  UISet = "UI_UISet",
  UI_UIHeroTalent = "UI_UIHeroTalent"
}
UIAssets = {
  BuildUpgradeCompleteEffect = "Assets/Main/Prefabs/BuildEffect/BuildUpgradeCompleteEffect%s.prefab",
  BuildBoxFinishEffect = "Assets/_Art/Effect/prefab/scene/VFX_libao_open_0%s.prefab",
  BuildingDes = "Assets/Main/Prefabs/UI/Build/BuildingDes.prefab",
  LUAUIMain = "Assets/Main/Prefabs/UI/UIMain/UIMain.prefab",
  LUAGiftPackagePagePanel = "Assets/Main/Prefabs/UI/LWGift/GiftPackagePagePanel.prefab",
  LUAGoldExchangeNormalLuaView = "Assets/Main/Prefabs/UI/LWGift/GoldExchangeNormalLuaView.prefab",
  UITradeCenter = "Assets/Main/Prefabs/UI/UITradingCenter/UITradeCenter.prefab",
  UIBookMarkPositionCollect = "Assets/Main/Prefabs/UI/BookMark/UIBookMarkPositionCollect.prefab",
  BuildTimeTip = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip2.prefab",
  BuildTimeTip1 = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip1.prefab",
  BuildTimeTip2 = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip3.prefab",
  BuildTimeTip4 = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip4.prefab",
  BuildTimeTipTrainField = "Assets/Main/Prefabs/UI/Build/BuildTimeTipTrainField.prefab",
  SceneBuildBloodTip = "Assets/Main/Prefabs/UI/Build/SceneBuildBloodTip.prefab",
  SceneBuildBloodTipNew = "Assets/Main/Prefabs/UI/Build/SceneBuildBloodTipNew.prefab",
  WorldNewsTips = "Assets/Main/Prefabs/UI/World/WorldNewsTips.prefab",
  SceneAllianceBuildBloodTip = "Assets/Main/Prefabs/UI/Build/SceneAllianceBuildBloodTip.prefab",
  MummyEffDown = "Assets/Main/SeasonRes/Shared/Prefabs/Soldier/MummyEffDown.prefab",
  MummyEffSand = "Assets/Main/SeasonRes/Shared/Prefabs/Soldier/MummyEffSand.prefab",
  MummyMarchBoss = "Assets/Main/SeasonRes/Shared/Prefabs/Soldier/MummyMarchBoss.prefab",
  MummyMarchGroup = "Assets/Main/SeasonRes/Shared/Prefabs/Soldier/MummyMarchGroup.prefab",
  WarFlagBaseDefault = "Assets/Main/Prefabs/UI/WarFlag/WarFlagBase.prefab",
  AllianceBubble = "Assets/Main/Prefabs/UI/State/AllianceBubble.prefab",
  TrainBubble = "Assets/Main/Prefabs/LWRailway/TrainBubble.prefab",
  BuildStateIcon = "Assets/Main/Prefabs/UI/State/BuildStateIcon.prefab",
  BuildStateIcon2 = "Assets/Main/Prefabs/UI/State/BuildStateIcon2.prefab",
  BuildStateIcon3 = "Assets/Main/Prefabs/UI/State/BuildStateIcon3.prefab",
  BuildStateIcon4 = "Assets/Main/Prefabs/UI/State/BuildStateIcon4.prefab",
  BuildStateIcon5 = "Assets/Main/Prefabs/UI/State/BuildStateIcon5.prefab",
  BuildStateIcon6 = "Assets/Main/Prefabs/UI/State/BuildStateIcon6.prefab",
  BuildStateIcon7 = "Assets/Main/Prefabs/UI/State/BuildStateIcon7.prefab",
  BuildStateIcon8 = "Assets/Main/Prefabs/UI/State/BuildStateIcon8.prefab",
  BuildStateIcon9 = "Assets/Main/Prefabs/UI/State/BuildStateIcon9.prefab",
  BuildStateIcon10 = "Assets/Main/Prefabs/UI/State/BuildStateIcon10.prefab",
  RaceEntranceBubble = "Assets/Main/Prefabs/UI/State/RaceEntranceBubble.prefab",
  RaceEntranceBigBubble = "Assets/Main/Prefabs/UI/State/RaceEntranceBigBubble.prefab",
  BuildStateIcon_Savegirl = "Assets/Main/Prefabs/UI/State/BuildStateIcon_Savegirl.prefab",
  PVPArenaBubble = "Assets/Main/Prefabs/UI/State/PVPArenaBubble.prefab",
  PVPArenaBubbleNew = "Assets/Main/Prefabs/UI/State/PVPArenaBubbleNew.prefab",
  PVPArenaChampionDuelBubble = "Assets/Main/Prefabs/UI/State/PVPArenaChampionDuelBubble.prefab",
  BuildBubbleUpgradeItem = "Assets/Main/Prefabs/UI/State/UpgradeGoods.prefab",
  FirstPayFixing = "Assets/Main/Prefabs/UI/State/FirstPayFixing.prefab",
  BuildHammerIcon = "Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_feixu_chuizi.prefab",
  DecorationPlaySoundBubble = "Assets/Main/Prefabs/UI/State/DecorationPlaySoundBubble.prefab",
  HeroEventFinishBubble = "Assets/Main/Prefabs/UI/State/HeroEventFinishBubble.prefab",
  SmallSandWormCell = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/SmallSandWormCell.prefab",
  BigSandWormCell = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/BigSandWormCell.prefab",
  VirusChange = "Assets/Main/Prefabs/UI/LWSeason1/Component/VirusChange.prefab",
  WormFishingRankItem = "Assets/Main/Prefabs/UI/UIAllyDuelCommon/UIAllyDuelPersonalRankItem.prefab",
  WormFishingRewardItem = "Assets/Main/Prefabs/UI/World/LWUIWorldBossRewardCell.prefab",
  LWSeasonTrendsRankItem = "Assets/Main/Prefabs/UI/Set/RankListItem.prefab",
  CommonRankItem = "Assets/Main/Prefabs/UI/UICommonRank/CommonRankItem.prefab",
  BloodyNightStageCell = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/StageCell.prefab",
  AllianceRewardCelebrationBubble = "Assets/Main/Prefabs/UI/State/AllianceRewardCelebrationBubble.prefab",
  AllianceWelcomeCelebrationBubble = "Assets/Main/Prefabs/UI/State/AllianceWelcomeCelebrationBubble.prefab",
  FirstPayBubble = "Assets/Main/Prefabs/UI/State/FirstChargeBubble.prefab",
  NoAllianceBubble = "Assets/Main/Prefabs/UI/State/NoAllianceBubble.prefab",
  MysteryTreasureBubble = "Assets/Main/Prefabs/UI/State/MysteryTreasureBubble.prefab",
  MoFieBuildIconBubble = "Assets/Main/Prefabs/UI/State/MoFieBuildIcon.prefab",
  UIWorldPointComp_otherPlayer = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewOtherPlayerInfo.prefab",
  UIWorldPointComp_collect = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewCollect.prefab",
  UIWorldPointComp_dispatchTask = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewDispatchTaskObj.prefab",
  UIWorldPointComp_monster = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointViewMonsterObj.prefab",
  UIWorldPointComp_flowerCar = "Assets/Main/SeasonRes/S4/Prefabs/UI/World/UIWorldPointFlowerCarObj.prefab",
  UIWorldPointComp_train = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewTrainObj.prefab",
  UIWorldPointComp_HSR = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIWorldPointHSR.prefab",
  UIWorldPointComp_worldTrigger = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewWorldTriggerObj.prefab",
  UIWorldPointComp_wolfShadow = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/Component/UIWorldPointNewWolfShadowObj.prefab",
  UIWorldPointComp_cow = "Assets/Main/SeasonRes/Shared/Prefabs/UI/MadCow/UIWorldPointViewCowObj.prefab",
  UIWorldPointComp_simpleMonster = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewSimpleMonsterObj.prefab",
  UIWorldPointComp_meteoriteInfo = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewMeteoriteCollectionInfo.prefab",
  UIWorldPointComp_dragonBuild = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewDragonBuild.prefab",
  UIWorldPointComp_drillObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointViewDrillObj.prefab",
  UIWorldPointComp_zombieRushObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointViewZombieRushObj.prefab",
  UIWorldPointComp_BerserkBossObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewBerserkBossObj.prefab",
  UIWorldPointComp_desertObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewDesertObj.prefab",
  UIWorldPointComp_winterEntityNew = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointViewWinterEntityNew.prefab",
  UIWorldPointComp_epidemicBuild = "Assets/Main/Prefabs/UI/BF_Epidemic/Common/UIWorldPointViewEpidemicBuild.prefab",
  UIWorldPointComp_TreasureDetectObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewTreasureDetectObj.prefab",
  UIWorldPointComp_DetectZombieBusTrain = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointDetectZombieBusTrainObj.prefab",
  UIWorldPointComp_AllianceBuildObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewAllianceBuild.prefab",
  UIWorldPointComp_DetectDigGameObj = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewDetectDigGameObj.prefab",
  UIWorldPointComp_PlayerAssistanceComp = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewOtherPlayerInfoAssistanceComp.prefab",
  UIWorldPointComp_PlayerAssistanceCompFat = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewOtherPlayerInfoAssistanceCompFat.prefab",
  UIWorldPointComp_airshipDonate = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/AirshipDonate.prefab",
  UIWorldPointComp_FlowerTrain = "Assets/Main/Prefabs/UI/FlowerTrain/FlowerTrain_WorldPoint.prefab",
  UIWorldPointComp_FlowerTrainReward = "Assets/Main/Prefabs/UI/FlowerTrain/FlowerTrain_CheerReward_WorldPoint.prefab",
  UIWorldPointComp_battlefieldBuilding = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewBattlefieldBuilding.prefab",
  UIWorldPointComp_ScoutDes = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewScoutDes.prefab",
  UIWorldPoint_ValentineStar = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ValentineStar.prefab",
  UILWSeasonCampDestroyZoneMap = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyZoneMap.prefab",
  UILWSeasonCampDestroyCampPreview = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyCampPreview.prefab",
  UILWSeasonCampDestroyIdleDay = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyIdleDay.prefab",
  UILWSeasonCampDestroyBattleWait = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyBattleWait.prefab",
  UILWSeasonCampDestroyBattleDetail = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyBattleDetail.prefab",
  UILWSeasonCampDestroyAchievement = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyAchievement.prefab",
  UILWSquadEquipItem = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipItem.prefab",
  UILWScienceMainItem = "Assets/Main/Prefabs/UI/LWScience/UILWScienceMainItem.prefab",
  MailDecoItem = "Assets/Main/Prefabs/UI/LWMail/DecoItem.prefab",
  SciBarItem = "Assets/Main/Prefabs/UI/LWMail/SciBarItem.prefab",
  MailArmyItem = "Assets/Main/Prefabs/UI/LWMail/ArmyItem.prefab",
  MailArmyItemNew = "Assets/Main/Prefabs/UI/LWMail/ArmyItemNew.prefab",
  MailHonorItem = "Assets/Main/Prefabs/UI/LWMail/HonorItem.prefab",
  MailOtherItem = "Assets/Main/Prefabs/UI/LWMail/OtherItem.prefab",
  KillItem = "Assets/Main/Prefabs/UI/LWMail/KillItem.prefab",
  DecoBarItem = "Assets/Main/Prefabs/UI/LWMail/MailBattle/DecoBarItem.prefab",
  OtherBarItem = "Assets/Main/Prefabs/UI/LWMail/OtherBarItem.prefab",
  UIMainTopResourceCell = "Assets/Main/Prefabs/UI/UIMain/UIMainTopResourceCell.prefab",
  UIMainMarchCell = "Assets/Main/Prefabs/UI/UIMain/UIMainMarchCell.prefab",
  UIChatTimeCell = "Assets/Main/Prefabs/UI/Chat/UIChatTimeCell.prefab",
  UIChatLeftTextCell = "Assets/Main/Prefabs/UI/Chat/UIChatLeftTextCell.prefab",
  UIChatRightTextCell = "Assets/Main/Prefabs/UI/Chat/UIChatRightTextCell.prefab",
  FarmResourceItem = "Assets/Main/Prefabs/UI/UIFarm/FarmResourceItem.prefab",
  FarmResourceItemNew = "Assets/Main/Prefabs/UI/UIFarm/FarmResourceItemNew.prefab",
  AllianceGiftItem = "Assets/Main/Prefabs/UI/Alliance/AllianceGiftItem.prefab",
  FarmGatherItem = "Assets/Main/Prefabs/UI/UIFarm/FarmGatherItem.prefab",
  FactoryNeedResItem = "Assets/Main/Prefabs/UI/UIFactory/FactoryNeedResItem.prefab",
  FactoryItem = "Assets/Main/Prefabs/UI/UIFactory/FactoryItem.prefab",
  FactoryGatherResItem = "Assets/Main/Prefabs/UI/UIFactory/FactoryGatherResItem.prefab",
  UIFactoryBoxModel = "Assets/Main/Prefabs/UI/UIFactory/UIFactoryBoxModel.prefab",
  UIFactoryRobotModel = "Assets/Main/Prefabs/UI/UIFactory/UIFactoryRobotModel.prefab",
  UIFactoryModelLarge = "Assets/Main/Prefabs/UI/UIFactory/UIFactoryModelLarge.prefab",
  UIFactoryModelSmall = "Assets/Main/Prefabs/UI/UIFactory/UIFactoryModelSmall.prefab",
  BuildConnectEffect = "Assets/Main/Prefabs/BuildEffect/BuildConnectEffect.prefab",
  MailCollectItem = "Assets/Main/Prefabs/UI/Mail/NewMail/MailCollectItem.prefab",
  MailResourceItem = "Assets/Main/Prefabs/UI/Mail/NewMail/MailCollectItem.prefab",
  MailScoutResourceItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutResourceItem.prefab",
  MailResSupportItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailResSupportItem.prefab",
  MailScoutTroopWave = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutTroopWave.prefab",
  MailScoutHeroItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutHeroItem.prefab",
  MailScoutTroopItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutTroopItem.prefab",
  MailScoutFortItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutFortItem.prefab",
  MailRewardCommonItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailRewardCommonItem.prefab",
  UICommonResItem = "Assets/Main/Prefabs/UI/Common/UICommonResItem.prefab",
  UICommonResItemFirstPayExp = "Assets/Main/Prefabs/UI/Common/UICommonResItemFirstPayExp.prefab",
  UICommonResItemMouth = "Assets/Main/Prefabs/UI/Common/UICommonResItemMouth.prefab",
  LimitedTimeFeastNoticeCell = "Assets/Main/Prefabs/UI/ActivityCenter/LimitedTimeFeast/LimitedTimeFeastNoticeCell.prefab",
  LeagueMatchAlRankItem = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/LeagueMatchAlRankItem.prefab",
  AllyDuelLeagueRankItem = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelLeagueRankItem.prefab",
  LeagueMatchRewardItem = "Assets/Main/Prefabs/UI/LeagueMatch/UILeagueMatchReward/LeagueMatchRewardItem.prefab",
  LeagueMatchResultVsItem = "Assets/Main/Prefabs/UI/LeagueMatch/UILeagueMatchResult/LeagueMatchResultVsItem.prefab",
  AllyDuelLeagueHistoryItem = "Assets/Main/Prefabs/UI/LWMainUI/AllyDuelLeagueHistoryItem.prefab",
  MailAlElectResultItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlElect/MailAlElectResultItem.prefab",
  AllianceCompeteScheduleItem = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/AllianceCompeteScheduleItem.prefab",
  AllyDuelScheduleItem = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelScheduleItem.prefab",
  AllyDuelScheduleItemNew = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelScheduleItemNew.prefab",
  AllianceCompetePerRewardITem = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompetePerRewardItem.prefab",
  UIResidentOrderCell = "Assets/Main/Prefabs/UI/UIResidentOrder/UIResidentOrderCell.prefab",
  FlyResourceEffect = "Assets/Main/Prefabs/FlyResourceEffect/FlyResourceEffect.prefab",
  FlyFoldUpBuildEffect = "Assets/Main/Prefabs/FlyResourceEffect/FlyFoldUpBuildEffect.prefab",
  DesCell = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DesCell.prefab",
  DesCell_New = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DesCell_New.prefab",
  DesCell4DecoLevelUpPanel = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DesCell4DecoLevelUpPanel.prefab",
  DesCell4DecoStarUnlock = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DesCell4StarStage.prefab",
  DesCell4DecoStarPanel = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DecoStarUnlockDesc.prefab",
  NeedResourceCell = "Assets/Main/Prefabs/UI/UIBuildUpgrade/NeedResourceCell.prefab",
  ResourceLackItem = "Assets/Main/Prefabs/UI/UIResource/ResourceLackItem.prefab",
  UIResourceLackCell = "Assets/Main/Prefabs/UI/UIResource/UIResourceLackCell.prefab",
  NeedBuildCell = "Assets/Main/Prefabs/UI/UIBuildUpgrade/NeedBuildCell.prefab",
  UIResourceBagTab = "Assets/Main/Prefabs/UI/UIResource/UIResourceBagTab.prefab",
  RoadBlockGreen = "Assets/Main/Prefabs/Road/RoadBlockGreen2.prefab",
  BuildBlock = "Assets/Main/Prefabs/Building/BuildBlock.prefab",
  BuildCollect = "Assets/Main/Prefabs/Building/BuildCollect.prefab",
  UIWorldTileTopBtn = "Assets/Main/Prefabs/UI/World/UIWorldTileTopBtn.prefab",
  UIWorldTileBuildBtn = "Assets/Main/Prefabs/UI/World/UIWorldTileBuildBtn.prefab",
  DropResourceEffect = "Assets/Main/Prefabs/UI/UIFarm/DropResourceEffect.prefab",
  DropMultiResourceEffect = "Assets/Main/Prefabs/UI/UIFactory/DropMultiResourceEffect.prefab",
  DecResourceEffect = "Assets/Main/Prefabs/UI/Build/DecResourceEffect.prefab",
  EarthOrderSceneObj = "Assets/Main/Prefabs/UI/UIEarthOrder/EarthOrderSceneObj.prefab",
  UIEarthOrderBoxCanSubmitEffect = "Assets/Main/Prefabs/UI/UIEarthOrder/UIEarthOrderBoxCanSubmitEffect.prefab",
  EarthOrderBox = "Assets/Main/Prefabs/UI/UIEarthOrder/EarthOrderBox.prefab",
  EarthOrderRewardCell = "Assets/Main/Prefabs/UI/UIEarthOrder/EarthOrderRewardCell.prefab",
  EarthOrderRobot = "Assets/Main/Prefabs/UI/UIEarthOrder/EarthOrderRobot.prefab",
  UIRocketCloseDoorEffect = "Assets/Main/Prefabs/RocketEffect/UIRocketCloseDoorEffect.prefab",
  UIRocketFireEffect = "Assets/Main/Prefabs/RocketEffect/UIRocketFireEffect.prefab",
  UIRocketOpenDoorEffect = "Assets/Main/Prefabs/RocketEffect/UIRocketOpenDoorEffect.prefab",
  UIRocketSmokeEffect = "Assets/Main/Prefabs/RocketEffect/UIRocketSmokeEffect.prefab",
  UIMainGatherItem = "Assets/Main/Prefabs/UI/UIMain/UIMainGatherItem.prefab",
  BuildCanUpgradeEffect = "Assets/Main/Prefabs/UI/Build/BuildCanUpgradeEffect.prefab",
  MeteoriteHitPlane = "Assets/Main/Prefabs/Effect/World/Meteorite/MeteoriteHitPlane.prefab",
  MeteoriteHitBaseGlass = "Assets/Main/Prefabs/Effect/World/Meteorite/MeteoriteHitBaseGlass.prefab",
  UIMainWarningGoBtn = "Assets/Main/Prefabs/UI/UIMain/UIMainWarningGoBtn.prefab",
  UIWarningEffect = "Assets/Main/Prefabs/UI/UIWarningEffect/UIWarningEffect.prefab",
  AllianceFunItem = "Assets/Main/Prefabs/UI/Alliance/AllianceFunItem.prefab",
  AllianceManageButton = "Assets/Main/Prefabs/UI/Alliance/AllianceManageButton.prefab",
  AllianceMemberRankSpecial = "Assets/Main/Prefabs/UI/Alliance/AllianceMemberRankSpecial.prefab",
  AllianceMemberBtnItem = "Assets/Main/Prefabs/UI/Alliance/AllianceMemberBtnItem.prefab",
  AllianceLanguageItem = "Assets/Main/Prefabs/UI/Alliance/AllianceLanguageItem.prefab",
  CommonGoodsShopItem = "Assets/Main/Prefabs/UI/UICommonShop/CommonGoodsShopItem.prefab",
  AllianceStorageResItem = "Assets/Main/Prefabs/UI/Alliance/AllianceStorageResItem.prefab",
  GolloesCampItem = "Assets/Main/Prefabs/UI/UIGolloesCamp/GolloesCampItem.prefab",
  UIScienceTopBtnCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceTopBtnCell.prefab",
  UIScienceNeedResCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceNeedResCell.prefab",
  UIScienceCell = "Assets/Main/Prefabs/UI/LWScience/UILWScienceCell.prefab",
  UIBusinessCenterResourceItem = "Assets/Main/Prefabs/UI/BusinessCenter/UIBusinessCenterResourceItem.prefab",
  CapacityTab = "Assets/Main/Prefabs/UI/UICapacity/CapacityTab.prefab",
  UIBuildUpgradeAddDesCell = "Assets/Main/Prefabs/UI/Build/UIBuildUpgradeAddDesCell.prefab",
  UIScienceInfoNeedBuildCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceInfoNeedBuildCell.prefab",
  UIScienceInfoPreConditionItem = "Assets/Main/Prefabs/UI/LWScience/UILWScienceInfoPreConditionItem.prefab",
  UIScienceInfoDesCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceInfoDesCell.prefab",
  DesertBattleRuleBuildCellForHelp = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleBuildCellForHelp.prefab",
  DesertBattleRuleNormalCellForHelp = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleNormalCellForHelp.prefab",
  DesertBattleRuleSkillCellForHelp = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleSkillCellForHelp.prefab",
  UIBagTab = "Assets/Main/Prefabs/UI/UIBag/UIBagTab.prefab",
  UIBuildQueuePanelCell = "Assets/Main/Prefabs/UI/Build/LWUIBuildQueuePanelCell.prefab",
  UIRepairNeedResCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairNeedResCell.prefab",
  UIRepairPanelCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairPanelCell.prefab",
  UIRepairPanelTitleCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairPanelTitleCell.prefab",
  UITrainNeedResCell = "Assets/Main/Prefabs/UI/UITrain/UITrainNeedResCell.prefab",
  UITrainDetailCell = "Assets/Main/Prefabs/UI/UITrain/UITrainDetailCell.prefab",
  BuildCanUpgradeEffect = "Assets/Main/Prefabs/UI/Build/BuildCanUpgradeEffect.prefab",
  BuildTrainCompleteEffect = "Assets/Main/Prefabs/BuildEffect/BuildTrainCompleteEffect.prefab",
  BuildTrainTimeFinishEffect = "Assets/Main/Prefabs/BuildEffect/BuildTrainTimeFinishEffect.prefab",
  RankSimpleItem = "Assets/Main/Prefabs/UI/Set/RankSimpleItem.prefab",
  FormationAddHero = "Assets/Main/Prefabs/UI/UIFormation/FormationAddHero.prefab",
  FormationHero = "Assets/Main/Prefabs/UI/UIFormation/FormationHero.prefab",
  FormationHeroNew = "Assets/Main/Prefabs/UI/UIFormation/FormationHeroNew.prefab",
  FormationHeroSelectList = "Assets/Main/Prefabs/UI/UIFormation/FormationHeroSelectList.prefab",
  FormationHeroSelectCell = "Assets/Main/Prefabs/UI/UIFormation/FormationHeroSelectCell.prefab",
  FormationSoldierSelect = "Assets/Main/Prefabs/UI/UIFormation/FormationSoldierSelect.prefab",
  FormationSoldierItem = "Assets/Main/Prefabs/UI/UIFormation/FormationSoldierItemNew.prefab",
  UIPveBattleSoliderItem = "Assets/Main/Prefabs/Guide/UIPveBattleSoliderItem.prefab",
  FormationSoldierChooseCell = "Assets/Main/Prefabs/UI/UIFormation/FormationSoldierChooseCell.prefab",
  FormationSoldierChooseCellNew = "Assets/Main/Prefabs/UI/UIFormation/FormationSoldierChooseCellNew.prefab",
  FormationCampListCell = "Assets/Main/Prefabs/UI/UIFormation/FormationCampListCell.prefab",
  UISearchMonsterCell = "Assets/Main/Prefabs/UI/UISearch/UISearchMonsterCell.prefab",
  UISearchFov = "Assets/Main/Prefabs/UI/UISearch/UISearchFov.prefab",
  AllianceWarItem = "Assets/Main/Prefabs/UI/Alliance/AllianceWarItem.prefab",
  UIPersonalWarning = "Assets/Main/Prefabs/UI/Alliance/UIPersonalWarning.prefab",
  BuildResourceGetBubble = "Assets/Main/Prefabs/UI/State/BuildResourceGetBubble.prefab",
  AllianceWarPlayerItem = "Assets/Main/Prefabs/UI/UIFormationDefence/AllianceWarPlayerItem.prefab",
  AllianceAlertPlayerItem = "Assets/Main/Prefabs/UI/Alliance/AllianceAlertPlayerItem.prefab",
  UIPersonalWarPlayerItem = "Assets/Main/Prefabs/UI/Alliance/UIPersonalWarPlayerItem.prefab",
  UILWAllianceWarningItem = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceWarningItem.prefab",
  FormationDefenceCell = "Assets/Main/Prefabs/UI/UIFormationDefence/FormationDefenceCell.prefab",
  FormationDefenceUnlock = "Assets/Main/Prefabs/UI/UIFormationDefence/FormationDefenceUnlock.prefab",
  FormationDefenceHeroItem = "Assets/Main/Prefabs/UI/UIFormationDefence/FormationDefenceHeroItem.prefab",
  FormationHeroAdd = "Assets/Main/Prefabs/UI/UIFormationDefence/FormationHeroAdd.prefab",
  Effectpath = "Assets/_Art/Effect/prefab/scene/Common/VFX_ziyuancaiji.prefab",
  FormationHeroItem = "Assets/Main/Prefabs/UI/UIFormation/FormationSelectHeroItem.prefab",
  TeamCell = "Assets/Main/Prefabs/UI/World/TeamCell.prefab",
  FormationSelectHeroAdd = "Assets/Main/Prefabs/UI/UIFormation/FormationSelectHeroAdd.prefab",
  AllianceWarPlayerSoliderItem = "Assets/Main/Prefabs/UI/Alliance/AllianceWarPlayerSoliderItem.prefab",
  AllianceHeroCell = "Assets/Main/Prefabs/UI/Alliance/AllianceHeroCell.prefab",
  UIScienceLine = "Assets/Main/Prefabs/UI/LWScience/UILWScienceLine.prefab",
  BuildCanPutBirthPoint = "Assets/Main/Prefabs/BuildEffect/BuildCanPutBirthPoint.prefab",
  BuildSelfPutBirthPoint = "Assets/Main/Prefabs/BuildEffect/BuildSelfPutBirthPoint.prefab",
  BuildFireEffect = "Assets/Main/Prefabs/World/BuildFireEffect.prefab",
  BuildFireEffectMainBuild = "Assets/Main/Prefabs/World/BuildFireEffectMainBuild.prefab",
  CityDomeProtectEffect = "Assets/Main/Prefabs/World/CityDomeProtectEffect_%s.prefab",
  LWCityDomeProtectEffect = "Assets/_Art/Effect/prefab/scene/Cangqiong_hudun/VFX_cangqiong_hudun_blue_3X3.prefab",
  LWFocusEffect = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_jijie_suoding.prefab",
  LWAllianceWarFlag = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_jijie_qizi.prefab",
  LWKingDomeHudunEffect = "Assets/Main/Prefabs/World/hudun_1.prefab",
  LWCityDomeHudunEffect = "Assets/Main/Prefabs/World/hudun_2.prefab",
  LWCityDomeHudunMigrationEffect = "Assets/Main/Prefabs/ActMigration/Eff_city_hudun_01.prefab",
  BuildLabelTip = "Assets/Main/Prefabs/World/BuildLabelTip.prefab",
  WorldMarchTileUI = "Assets/Main/Prefabs/UI/World/WorldMarchTileUI.prefab",
  WorldTroopHeadUI = "Assets/Main/Prefabs/March/WorldTroopHeadUI.prefab",
  MarchVirus = "Assets/Main/Prefabs/UI/LWSeason1/MarchVirus.prefab",
  WorldTroopMonsterPro = "Assets/Main/Prefabs/March/WorldTroopMonsterPro.prefab",
  AllianceMineBloodTip = "Assets/Main/Prefabs/UI/Build/AllianceMineBloodTip.prefab",
  PveHeroBloodBar = "Assets/Main/Prefabs/PVE/Hero_Blood.prefab",
  WorldTroopName = "Assets/Main/Prefabs/March/WorldTroopName.prefab",
  WorldTruckName = "Assets/Main/Prefabs/March/WorldTruckName.prefab",
  WorldTroopAssemblyName = "Assets/Main/Prefabs/March/WorldTroopAssemblyName.prefab",
  TroopAttackBuildUI = "Assets/Main/Prefabs/March/TroopAttackBuildUI.prefab",
  TroopTransUI = "Assets/Main/Prefabs/March/TroopTransUI.prefab",
  AllianceCityTip = "Assets/Main/Prefabs/UI/AllianceCityTip/AllianceCityTip.prefab",
  SurpriseBuildingTip = "Assets/Main/SeasonRes/Shared/Prefabs/UI/LWUIWorld/SurpriseBuildingTip.prefab",
  WorldBuildHeadUI = "Assets/Main/Prefabs/March/WorldBuildHeadUI.prefab",
  AllianceLogCell = "Assets/Main/Prefabs/UI/Alliance/AllianceLogCell.prefab",
  BattleBuffTip = "Assets/Main/Prefabs/UI/BattleWord/BattleBuffTip.prefab",
  ActBossBloodTip = "Assets/Main/Prefabs/March/ActBossBloodTip.prefab",
  LandLockBoard = "Assets/Main/Prefabs/World/LandLockBoard.prefab",
  UIMasteryOverviewItem = "Assets/Main/Prefabs/UI/UIMastery/UIMasteryOverviewItem.prefab",
  UIMasterySkillItem = "Assets/Main/Prefabs/UI/UIMastery/UIMasterySkillItem.prefab",
  WorldBankScoutTip = "Assets/Main/SeasonRes/S5/Prefabs/World/Bank/WorldBankScoutTip.prefab",
  UIChatRoomCell = "Assets/Main/Prefabs/UI/ChatNew/ChatRoomCell.prefab",
  UIChatSearchPersonItem = "Assets/Main/Prefabs/UI/ChatNew/SearchPerson/UIChatSearchPersonItem.prefab",
  UIChatHead = "Assets/Main/Prefabs/UI/ChatNew/ChatHead.prefab",
  ObjHeroAddExp = "Assets/Main/Prefabs/UI/UIMain/ObjHeroAddExp.prefab",
  BatteryAttackRange = "Assets/_Art/Effect/prefab/scene/Build/V_paota_fanwei.prefab",
  FoodStateIcon = "Assets/Main/Prefabs/UI/State/FoodStateIcon.prefab",
  FoodStateIconCell = "Assets/Main/Prefabs/UI/State/FoodStateIconCell.prefab",
  UIEarthOrderLaunchFx = "Assets/_Art/Effect/prefab/ui/V_huojian_glow.prefab",
  BuildGetItemAfterShowTalk = "Assets/Main/Prefabs/UI/State/BuildGetItemAfterShowTalk.prefab",
  FoodShouqu = "Assets/_Art/Effect/prefab/ui/Common/VFX_food_shouqu.prefab",
  UICommonNeedResourceCell = "Assets/Main/Prefabs/UI/Common/UICommonNeedResourceCell.prefab",
  UITitleShowItem = "Assets/Main/Prefabs/UI/LWTitle/Component/TitleShowItem.prefab",
  UICityManageCell = "Assets/Main/Prefabs/UI/UILWCityBuff/UICityManageCell.prefab",
  UICityManageCellItemCell = "Assets/Main/Prefabs/UI/UILWCityBuff/UICityManageCellItemCell.prefab",
  UICityBuffCell = "Assets/Main/Prefabs/UI/UILWCityBuff/CityBuffCell.prefab",
  BuffIcon = "Assets/Main/Prefabs/UI/LWMainUI/BuffIcon.prefab",
  OfficialPositionBuffEffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Lianhuanduobao/Eff_ui_duobao_jiangli_faguang_officialPositionBuff.prefab",
  BuildGetItemAfterShowTalk = "Assets/Main/Prefabs/UI/State/BuildGetItemAfterShowTalk.prefab",
  DetectEventItem = "Assets/Main/Prefabs/UI/UILWRadarCenter/DetectEventItem.prefab",
  FakeZombieBusTrainDetectEventItem = "Assets/Main/Prefabs/UI/UILWRadarCenter/FakeZombieBusTrainDetectEventItem.prefab",
  VIPRadarEntrance = "Assets/Main/Prefabs/UI/UILWRadarCenter/VIPRadarContent.prefab",
  SceneBuildTimeTipCircle = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTipCircle.prefab",
  DetectEventRewardEffect = "Assets/Main/Prefabs/UI/UILWRadarCenter/DetectEventRewardEffect.prefab",
  HeroDamageItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/HeroDamageItem.prefab",
  BuildTimeHeroCountdownTip = "Assets/Main/Prefabs/UI/State/BuildTimeHeroCountdownTip.prefab",
  LeadingQuest = "Assets/Main/Prefabs/UI/ActivityCenter/LeadingQuest/LeadingQuestMain.prefab",
  JigsawPuzzle = "Assets/Main/Prefabs/UI/ActivityCenter/JigsawPuzzle/JigsawPuzzleMain.prefab",
  BarterShop = "Assets/Main/Prefabs/UI/ActivityCenter/BarterShop/BarterShopMain.prefab",
  MineCave = "Assets/Main/Prefabs/UI/ActivityCenter/MineCave/MineCaveMain.prefab",
  PersonalArms = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms.prefab",
  AllianceArms = "Assets/Main/Prefabs/UI/ActivityCenter/AllianceCompete/AllianceArms.prefab",
  UIActivitySevenDay = "Assets/Main/Prefabs/UI/ActivityCenter/SevenDay/UIActivitySevenDay.prefab",
  UIActSevenDayNew = "Assets/Main/Prefabs/UI/ActivityCenter/SevenDay/UIActSevenDayNew.prefab",
  AllianceOrder = "Assets/Main/Prefabs/UI/ActivityCenter/AllianceOrder/AllianceOrder.prefab",
  IndividualOrder = "Assets/Main/Prefabs/UI/ActivityCenter/IndividualOrder/IndividualOrder.prefab",
  UIActivityPirates = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityPirates.prefab",
  UIActivityPuzzle = "Assets/Main/Prefabs/UI/ActivityCenter/Puzzle/UIActivityPuzzle.prefab",
  ActivityRewardItem = "Assets/Main/Prefabs/UI/GiftPackage/UIGiftPackageCell.prefab",
  RewardPreviewCell = "Assets/Main/Prefabs/UI/UIActivitySummary/UIRewardPreviewCell.prefab",
  UIActivityListItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActivityListItem.prefab",
  AllyDuelTab = "Assets/Main/Prefabs/UI/UIAllyDuelCommon/AllyDuelTab.prefab",
  ActivityTabGroupItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActivityGroupCell.prefab",
  UIActivitySevenDayItem = "Assets/Main/Prefabs/UI/ActivityCenter/SevenDay/UIActivitySevenDayItem.prefab",
  ActivityCurrenReward = "Assets/Main/Prefabs/UI/ActivityCenter/ActivityCurrenRewardItem.prefab",
  UIRadarRally = "Assets/Main/Prefabs/UI/ActivityCenter/RadarRally/UIRadarRally.prefab",
  BarterShopNotice = "Assets/Main/Prefabs/UI/ActivityCenter/BarterShopNotice/BarterShopNotice.prefab",
  ArenaMain = "Assets/Main/Prefabs/UI/ActivityCenter/Arena/ArenaMain.prefab",
  SeasonPassMain = "Assets/Main/Prefabs/UI/ActivityCenter/SeasonPass/SeasonPassMain.prefab",
  SeasonShop = "Assets/Main/Prefabs/UI/ActivityCenter/SeasonShop/SeasonShop.prefab",
  LuckyRoll = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRoll.prefab",
  UIAttackCityMain = "Assets/Main/Prefabs/UI/ActivityCenter/AttackCity/UIAttackCityMain.prefab",
  UIAttackCityS0Main = "Assets/Main/Prefabs/UI/LWCityAttackS0/UIAttackCityS0Main.prefab",
  UIAttackCityS0BattlePass = "Assets/Main/Prefabs/UI/LWCityAttackS0/UIAttackCityS0BattlePass.prefab",
  UIAttackCityS0Clue = "Assets/Main/Prefabs/UI/LWCityAttackS0/UIAttackCityS0Clue.prefab",
  UIRebateMain = "Assets/Main/Prefabs/UI/ActivityCenter/Rebate/UIRebateActivityMain.prefab",
  UITaskActivityMain = "Assets/Main/Prefabs/UI/ActivityCenter/Task/UITaskActivity.prefab",
  UITreasureHuntMain = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHunt/UITreasureHuntMain.prefab",
  UIActivityAdventure = "Assets/Main/Prefabs/UI/ActivityCenter/Adventure/UIActivityAdventure.prefab",
  UIArenaRewardCell = "Assets/Main/Prefabs/UI/ActivityCenter/Arena/UIArenaRewardCell.prefab",
  UIBattlePass = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePass.prefab",
  UIBattlePass_common = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePass_common.prefab",
  UIBattlePassNormalNew = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassNormalNew.prefab",
  UIBattlePassForActSevenDay = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassForActSevenDay.prefab",
  UIBattlePassRewardCell = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassRewardCell.prefab",
  UIBattlePassNormalNewDefaultBanner = "Assets/Main/TextureEx/UIActivityBg/Banner/BattlePass/202408/FX_BP_BG_01.png",
  UIBPTaskRewardCell = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBPTaskRewardCell.prefab",
  BattlePassEffect = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/BattlePassEffect.prefab",
  UIGolloesCards = "Assets/Main/Prefabs/UI/ActivityCenter/GolloesCards/UIGolloesCards.prefab",
  UIGolloesCardsRPCell = "Assets/Main/Prefabs/UI/ActivityCenter/GolloesCards/UIGolloesCardsRPCell.prefab",
  UISevenDayLogin = "Assets/Main/Prefabs/UI/ActivityCenter/SevenDayLogin/UISevenDayLogin.prefab",
  UISeasonWeekCard = "Assets/Main/Prefabs/UI/ActivityCenter/SeasonWeekCard/UISeasonWeekCard.prefab",
  UISeasonRank = "Assets/Main/Prefabs/UI/ActivityCenter/SeasonRank/UISeasonRank.prefab",
  UIAllianceSeasonForce = "Assets/Main/Prefabs/UI/ActivityCenter/AllianceSeasonForce/UIAllianceSeasonForce.prefab",
  UIWorldTrend = "Assets/Main/Prefabs/UI/ActivityCenter/WorldTrend/UIWorldTrend.prefab",
  AllianceSeasonWeekRank = "Assets/Main/Prefabs/UI/ActivityCenter/AllianceSeasonWeekRank/AllianceSeasonWeekRank.prefab",
  UIDoubleSeasonScore = "Assets/Main/Prefabs/UI/ActivityCenter/DoubleSeasonScore/UIDoubleSeasonScore.prefab",
  DoubleActEffectCell = "Assets/Main/Prefabs/UI/ActivityCenter/DoubleSeasonScore/DoubleActEffectCell.prefab",
  UIPersonSeasonRank = "Assets/Main/Prefabs/UI/ActivityCenter/PersonSeasonRank/UIPersonSeasonRank.prefab",
  UICrossDesert = "Assets/Main/Prefabs/UI/ActivityCenter/CrossServerDesert/UICrossDesert.prefab",
  WorldTrendWeekCell = "Assets/Main/Prefabs/UI/ActivityCenter/WorldTrend/WorldTrendWeekCell.prefab",
  PersonalArmsNew = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/PersonalArms.prefab",
  PersonalArmsTargetItem = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/PersonalArmsTargetItem.prefab",
  PersonalArmsRankItem = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/PersonalArmsRankItem.prefab",
  UIScratchGame = "Assets/Main/Prefabs/UI/ActivityCenter/ScratchOffGame/ScratchOffGame.prefab",
  AllyDrillMain = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillMain.prefab",
  UIContinuePay = "Assets/Main/Prefabs/UI/ActivityCenter/ContinuePay/UIContinuePayMain.prefab",
  UIArenaNewbie = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIArenaNewbie.prefab",
  UIActivityCommonGroupTab = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityCommonGroupTab.prefab",
  UIDoomsday = "Assets/Main/Prefabs/UI/ActivityCenter/Doomsday/UIActivityDoomsday.prefab",
  LeadingQuestV2 = "Assets/Main/Prefabs/UI/ActivityCenter/LeadingQuestV2/LeadingQuestMainV2.prefab",
  UIPersonalArmsDailyTip = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsDailyTip.prefab",
  UIActHeroLevelReplacement = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelReplacement/UIActHeroLevelReplacement.prefab",
  UIActHeroLevelAndStarReplace = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelAndStarReplace/UIActHeroLevelAndStarReplace.prefab",
  UIActHeroPromotion = "Assets/Main/Prefabs/UI/ActivityCenter/UIActHeroPromotion/UIActHeroPromotion.prefab",
  UIActWastelandChallengeRank = "Assets/Main/Prefabs/UI/ActivityCenter/WastelandChallengeRank/UIActWastelandChallengeRank.prefab",
  UIActSnowStormComing = "Assets/Main/Prefabs/UI/ActivityCenter/SnowStormComing/UIActSnowStormComing.prefab",
  LWSeasonSuppliesShare = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/LWSeasonSuppliesShare.prefab",
  UISeasonPhotoCanvaShot = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/Component/SeasonPhotoCanvaShot.prefab",
  UISeasonPhotoCanvaShotFull = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/Component/SeasonPhotoCanvaShotFull.prefab",
  UISeasonHunterHistoryDetailItem = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/Component/SeasonHunterHistoryDetailItem.prefab",
  UIGoldTreePrayContent = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/Component/GoldTreePrayContent.prefab",
  UIActMonopolyMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyMain.prefab",
  UIActChristmasTree = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActChristmasTree.prefab",
  UIBanquetAttackMonster = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/BanquetAttackMonster.prefab",
  UIBanquetAttackMonster_Common1 = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/Prefab/BanquetAttackMonsterCommon1.prefab",
  UIActGiftGivingMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActGiftGiving/UIActGiftGivingMain.prefab",
  UIActLotteryMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotteryMain.prefab",
  UIActSlotMachineMain = "Assets/Main/ActivityFestival/ActSlotMachine/Prefab/UIActSlotMachineMain.prefab",
  UIActBingo = "Assets/Main/Prefabs/UI/ActivityCenter/ActBingo/UIActBingo.prefab",
  UIActChristmasTreeSpritePath = "Assets/Main/Sprites/UI/UIActChristmasTree/%s.png",
  UIActDetectTreasureSpritePath = "Assets/Main/Sprites/UI/ActDetectTreasure/%s.png",
  UIActMonopolySpritePath = "Assets/Main/Sprites/UI/UIActMonopoly/%s.png",
  UIActMonopolyTexturePath = "Assets/Main/TextureEx/ActMonopoly/%s.png",
  UIBattlePassChristmas = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassChristmas.prefab",
  UIBattlePassSpringFestival = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassSpringFestival.prefab",
  UIActBanquetAttackMonsterTexturePath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/%s.png",
  UIActSlotMachineSpritePath = "Assets/Main/ActivityFestival/ActSlotMachine/%s.png",
  UIActLWUIActEasterCommonPath = "Assets/Main/Sprites/UI/LWUIActEasterCommon/%s.png",
  UIQuestCellNew = "Assets/Main/Prefabs/UI/UIMainTask/UIQuestCellNew.prefab",
  UIQuestRewardCell = "Assets/Main/Prefabs/UI/UIMainTask/UIQuestRewardCell.prefab",
  UIVipCellEffectItem = "Assets/Main/Prefabs/UI/UIVip/CellEffect.prefab",
  UIVIPEffectLine = "Assets/Main/Prefabs/UI/UILWVIPPanel/VIPBuffLine.prefab",
  UINpcQNCell = "Assets/Main/Prefabs/UI/UINpcQA/UINpcQNCell.prefab",
  UITaskChapterRewardItem = "Assets/Main/Prefabs/UI/UITask/RewardCell.prefab",
  UITaskChapterRewardSmallItem = "Assets/Main/Prefabs/UI/UITask/RewardCellSmall.prefab",
  UIRadarSoliderICell = "Assets/Main/Prefabs/UI/ChatNew/UIRadarSoliderICell.prefab",
  UIHeroCellSmall = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellSmall.prefab",
  UIHeroCellBig = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellBig.prefab",
  UIHeroCellBigPiece = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellBigPiece.prefab",
  UICapacityBoxHeroItem = "Assets/Main/Prefabs/UI/UICapacity/UICapacityBoxHeroItem.prefab",
  UICapacityBoxItem = "Assets/Main/Prefabs/UI/UICapacity/UICapacityBoxItem.prefab",
  UICapacityBoxNewItem = "Assets/Main/Prefabs/UI/UICapacity/UICapacityBoxNewItem.prefab",
  UIHeroSkillItem = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSkillItem.prefab",
  EquipItem = "Assets/Main/Prefabs/UI/UIHero/LWHero/EquipItem.prefab",
  UIHeroCellTiny = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellTiny.prefab",
  InteractionBubble = "Assets/Main/Prefabs/UI/InteractionBubble/InteractionBubble.prefab",
  TotalItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TotalItem.prefab",
  TroopItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TroopItem.prefab",
  TurretItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TurretItem.prefab",
  TurretDetailItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TurretDetailItem.prefab",
  SceneRobotBuildTip = "Assets/Main/Prefabs/UI/Build/RobotBuildTip.prefab",
  UIDetectEventRewardFlyItem = "Assets/Main/Prefabs/UI/UIDetectEventRewardFly/UIDetectEventRewardFlyItem.prefab",
  BuildConnectRoadEffect = "Assets/Main/Prefabs/BuildEffect/BuildConnectRoadEffect.prefab",
  BuildConnectRoadEffectDire = "Assets/Main/Prefabs/BuildEffect/BuildConnectRoadEffectDire.prefab",
  BuildConnectRoadBallEffect = "Assets/Main/Prefabs/BuildEffect/BuildConnectRoadBallEffect.prefab",
  CityDomeShowEffect = "Assets/Main/Prefabs/BuildEffect/CityDomeShowEffect.prefab",
  CityDomeHideEffect = "Assets/Main/Prefabs/BuildEffect/CityDomeHideEffect.prefab",
  GoToMoveBubble = "Assets/Main/Prefabs/CityScene/GoToMoveBubble.prefab",
  UIGuideTalkSelectBtn = "Assets/Main/Prefabs/Guide/UIGuideTalkSelectBtn.prefab",
  BuildCancelEffect = "Assets/Main/Prefabs/BuildEffect/BuildTrainCompleteEffect.prefab",
  BuildZeroUpgradeEffect = "Assets/Main/Prefabs/BuildEffect/BuildTrainCompleteEffect.prefab",
  UIGuideTalkScene = "Assets/Main/Prefabs/Guide/UIGuideTalkScene.prefab",
  FormationSelectListCellNew = "Assets/Main/Prefabs/UI/UIFormation/FormationSelectCellNew.prefab",
  FormationScoutSelectTip = "Assets/Main/Prefabs/UI/UIFormation/ScoutSelectTip.prefab",
  FormationScoutBankDepositTip = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankDepositTip.prefab",
  UIMainFormationSelectListCellNew = "Assets/Main/Prefabs/UI/UIMain/UIMainFormationSelectCellNew.prefab",
  UIMainFormationSelectListCellFreeSpeed = "Assets/Main/Prefabs/Effect/BF_Epidemic/Eff_ui_FormationSelect_lightsweep.prefab",
  UIMainFormationSelectCellMeteoriteNode = "Assets/Main/Prefabs/UI/UIMain/UIMainFormationSelectCellMeteoriteNode.prefab",
  UIGuideJianzhangTimeline = "Assets/_Art/Models/Npc/jianzhang/prefab/GuideJianzhangTimeline.prefab",
  NextGarbagePoint = "Assets/Main/Prefabs/CityScene/NextGarbagePoint.prefab",
  UIGuideMoveEndFlag = "Assets/Main/Prefabs/Guide/UIGuideMoveEndFlag.prefab",
  GuideStartScene = "Assets/PackageRes/Prefabs/GuideStartScene.prefab",
  SavePeopleScene = "Assets/Main/Prefabs/CityScene/SavePeopleScene.prefab",
  BuildMainZeroUpgradeOneScene = "Assets/Main/Prefabs/CityScene/BuildMainZeroUpgradeOneScene.prefab",
  FogCanUnlock = "Assets/Main/Prefabs/FogOfWar/FogCanUnlock.prefab",
  WorldPointRewardItem = "Assets/Main/Prefabs/UI/World/WorldPointRewardItem.prefab",
  WorldPointRewardItemBig = "Assets/Main/Prefabs/UI/World/WorldPointRewardItemBig.prefab",
  WorldPointHeroSmallItem = "Assets/Main/Prefabs/UI/World/WorldPointHeroSmallItem.prefab",
  WorldArrow = "Assets/Main/Prefabs/Guide/WorldArrow.prefab",
  GuideWorldArrow = "Assets/Main/Prefabs/Guide/GuideWorldArrow.prefab",
  WorldYellowArrow = "Assets/Main/Prefabs/Guide/WorldYellowArrow.prefab",
  WorldCanBuildEffect = "Assets/_Art/Effect/prefab/scene/Build/DaBen_GNXQ/VFX_cangqiongkuojian_f.prefab",
  CityCameraSand = "Assets/Main/Prefabs/CityScene/CityCameraSand.prefab",
  UIChatHeroCell = "Assets/Main/Prefabs/UI/ChatNew/UIChatHeroCell.prefab",
  BuildGrid = "Assets/Main/Prefabs/Building/BuildGrid%s.prefab",
  BuildSelect = "Assets/Main/Prefabs/Building/BuildSelect%sx%s.prefab",
  EpidemicSkillRange = "Assets/Main/Prefabs/World/BF_Epidemic/SkillRange.prefab",
  EpidemicSkillRangeBlue = "Assets/Main/Prefabs/World/BF_Epidemic/SkillRange_blue.prefab",
  UIGroceryStoreCell = "Assets/Main/Prefabs/UI/UIUIGroceryStore/UIGroceryStoreCell.prefab",
  WorldSiegeRewardCell = "Assets/Main/Prefabs/UI/World/WorldSiegeRewardCell.prefab",
  WorldSiegeRewardItem = "Assets/Main/Prefabs/UI/World/WorldSiegeRewardItem.prefab",
  GuideGM = "Assets/Main/Prefabs/Guide/GuideGM.prefab",
  RoadFlag = "Assets/Main/Prefabs/MainCity/road_flag.prefab",
  RoadBlockRed = "Assets/Main/Prefabs/Road/RoadBlockRed2.prefab",
  UIShowBlackCell = "Assets/Main/Prefabs/Guide/UIShowBlackCell.prefab",
  RocketLandingScene = "Assets/Main/Prefabs/Guide/RocketLandingScene.prefab",
  UIMainPlayerLevelEffect = "Assets/_Art/Effect/prefab/ui/VFX_playerBox_glow.prefab",
  UIMainStorageMaxEffect = "Assets/_Art/Effect/prefab/ui/VFX_flyBox_glow.prefab",
  UIHeroStationSkill = "Assets/Main/Prefabs/UI/UIHeroStation/UIHeroStationSkill.prefab",
  ShowOstrichEffect = "Assets/Main/Prefabs/Effect/ShowOstrichEffect.prefab",
  RuinBuildSelectEffect = "Assets/_Art/Effect/prefab/scene/Build/XuanQu/VFX_Ruin_Build_Sel.prefab",
  RuinBuildSelectEffectRed = "Assets/_Art/Effect/prefab/scene/Build/XuanQu/VFX_Ruin_Build_Sel_Red.prefab",
  WarningBlue = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_blue.prefab",
  WarningGreen = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_green.prefab",
  WarningRed = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_red.prefab",
  WarningYellow = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_yellow.prefab",
  WarningAllianceColor = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_alliance.prefab",
  AirDropGarbage = "Assets/Main/Prefabs/CityScene/AirDropGarbage.prefab",
  ShowOstrichScene = "Assets/Main/Prefabs/CityScene/ShowOstrichScene.prefab",
  ShowMigrateScene = "Assets/Main/Prefabs/CityScene/ShowMigrateScene.prefab",
  ShowAirDropScene = "Assets/Main/Prefabs/CityScene/ShowAirDropScene.prefab",
  UIHeroStationValUpItem = "Assets/Main/Prefabs/UI/UIHeroStation/UIHeroStationValUpItem.prefab",
  BuildCoverageMainEffect = "Assets/Main/Prefabs/BuildEffect/BuildCoverageMainEffect%s.prefab",
  BuildCoverageSubEffect = "Assets/Main/Prefabs/BuildEffect/BuildCoverageSubEffect_%s_%s.prefab",
  MonsterRewardBoxEffect = "Assets/_Art/Effect/prefab/scene/VFX_xiangzi_open_01.prefab",
  ProductLineFlyText = "Assets/Main/Prefabs/CityScene/ProductLineFlyText.prefab",
  CitySpaceManFlyText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyText.prefab",
  CitySpaceManFlyWithBloodText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyWithBloodText.prefab",
  FlyText = "Assets/Main/Prefabs/CityScene/FlyText.prefab",
  UIComplexTipItem = "Assets/Main/Prefabs/UI/UIComplexTip/UIComplexTipItem.prefab",
  ResChampionBattleItem_signUp = "Assets/Main/Prefabs/UI/UIChampionBattle/ChampionBattleItem_signUp.prefab",
  ResChampionBattleItem_auditions = "Assets/Main/Prefabs/UI/UIChampionBattle/ChampionBattleItem_auditions.prefab",
  ResChampionBattleItem_strongest = "Assets/Main/Prefabs/UI/UIChampionBattle/ChampionBattleItem_strongest.prefab",
  GroupEighthFinalsCell = "Assets/Main/Prefabs/UI/UIChampionBattle/GroupEighthFinalsCell.prefab",
  GroupHonorListCell = "Assets/Main/Prefabs/UI/UIChampionBattle/GroupHonorListCell.prefab",
  UIPiggyBankDropCoin = "Assets/Main/Prefabs/UI/ActivityCenter/PiggyBank/UIPiggyBankDropCoin.prefab",
  UIEnergyBankDropCoin = "Assets/Main/Prefabs/UI/UIEnergyBank/UIEnergyBankDropCoin.prefab",
  UISubWayItem = "Assets/Main/Prefabs/UI/UISubWay/UISubWayItem.prefab",
  SeasonAllianceRewardItem = "Assets/Main/Prefabs/UI/UISeason/seasonAllianceRewardItem.prefab",
  SeasonGroundAttrItem = "Assets/Main/Prefabs/UI/UISeason/seasonGroundAttrItem.prefab",
  CityPrologueNoMovePoint = "Assets/Main/Prefabs/CityScene/CityPrologueNoMovePoint.prefab",
  ShowBusinessPlaneArriveScene = "Assets/Main/Prefabs/CityScene/ShowBusinessPlaneArriveScene.prefab",
  ShowCowScene = "Assets/Main/Prefabs/CityScene/ShowCowScene.prefab",
  UIScrollPackPoint = "Assets/Main/Prefabs/UI/UIScrollPack/UIScrollPackPoint.prefab",
  GuideAllianceMemberEffect = "Assets/Main/Prefabs/Guide/GuideAllianceMemberEffect.prefab",
  MailDestroyRankItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailDestroyRankItem.prefab",
  UIAllianceScienceCell = "Assets/Main/Prefabs/UI/Alliance/UIAllianceScienceCell.prefab",
  UIPoliceStationCell = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIPoliceStationCell.prefab",
  ShowRobotScene = "Assets/Main/Prefabs/CityScene/ShowRobotScene.prefab",
  MailBattleAttrDetailTitle = "Assets/Main/Prefabs/UI/Mail/ObjMail/PlayerReport/MailPlayerReportInfoCell1.prefab",
  MailBattleAttrDetailCell = "Assets/Main/Prefabs/UI/Mail/ObjMail/PlayerReport/MailPlayerReportInfoCell2.prefab",
  UIShowReasonDesCell = "Assets/Main/Prefabs/UI/UIShowReason/UIShowReasonDesCell.prefab",
  UIWorldTrendItem = "Assets/Main/Prefabs/UI/UIWorldTrend/UIWorldTrendItem.prefab",
  UIGarageRefitItemTipLine = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitItemTipLine.prefab",
  UIGarageRefitUpgradeLine = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeLine.prefab",
  UIGarageRefitUpgradeLine2 = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeLine2.prefab",
  UISkillAdvanceSuccessCell = "Assets/Main/Prefabs/UI/UIHero/New/UISkillAdvanceSuccessCell.prefab",
  UICareerEffect = "Assets/Main/Prefabs/UI/UIPlayerLevel/UICareerEffect.prefab",
  UICareerTag = "Assets/Main/Prefabs/UI/UIPlayerLevel/UICareerTag.prefab",
  UILookForCareerItem = "Assets/Main/Prefabs/UI/UILookForCareer/UILookForCareerItem.prefab",
  UIPlayerHead = "Assets/Main/Prefabs/UI/Common/UIPlayerHead.prefab",
  UIPlayerHeadNoAnim = "Assets/Main/Prefabs/UI/Common/UIPlayerHeadNoAnim.prefab",
  UIPassengerHead = "Assets/Main/Prefabs/UI/Common/UIPassengerHead.prefab",
  UIPlaceHolder = "Assets/Main/Prefabs/UI/UILWRailway/UIPlaceHolder.prefab",
  UIWorldPlayerHead = "Assets/Main/Prefabs/UI/Common/UIWorldPlayerHead.prefab",
  UIWorldPointAssistanceHeadItem = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointAssistanceHeadItem.prefab",
  AllianceFlagBgItem = "Assets/Main/Prefabs/UI/Alliance/AllianceFlagBgItem.prefab",
  AllianceFlagFgItem = "Assets/Main/Prefabs/UI/Alliance/AllianceFlagFgItem.prefab",
  JigsawAreaBlockItem = "Assets/Main/Prefabs/UI/UIJigsawArea/JigsawAreaBlockItem.prefab",
  SetAlOfficialPosItem = "Assets/Main/Prefabs/UI/Alliance/AlliancePosition/SetAlOfficialPosItem.prefab",
  UIAllianceCareerRow = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerRow.prefab",
  UIAllianceCareerInfoCell = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerInfoCell.prefab",
  UIAllianceCareerAddCell = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerAddCell.prefab",
  UIAllianceCareerEffectCell = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerEffectCell.prefab",
  UIAllianceCareerChangeCell = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerChangeCell.prefab",
  WorldBattleAbbr = "Assets/Main/Prefabs/UI/World/WorldBattleAbbr.prefab",
  MailPlayerHeroItem = "Assets/Main/Prefabs/UI/Mail/ObjMail/PlayerReport/MailPlayerHeroItem.prefab",
  HeroBountyItem = "Assets/Main/Prefabs/UI/UIHero/New/HeroBountyItem.prefab",
  UITroopSkillItem = "Assets/Main/Prefabs/UI/UIMain/UITroopSkillItem.prefab",
  FromMjBuildMainBuildScene = "Assets/Main/Prefabs/CityScene/FromMjBuildMainBuildScene.prefab",
  MainZeroUpgradeScene = "Assets/Main/Prefabs/CityScene/MainZeroUpgradeScene.prefab",
  UIMainQuestObj = "Assets/Main/Prefabs/UI/UIMain/questObj.prefab",
  UIPveQuestObj = "Assets/Main/Prefabs/UI/UIMain/questPveObj.prefab",
  UIPveBuffCell = "Assets/Main/Prefabs/UI/UIPVE/UIPveBuffCell.prefab",
  UIPVEShopCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVEShopCell.prefab",
  UIPVEShopCostCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVEShopCostCell.prefab",
  UIGuidePioneerBuffCell = "Assets/Main/Prefabs/Guide/UIGuidePioneerBuffCell.prefab",
  UIPveNeedResourceCell = "Assets/Main/Prefabs/UI/UIPVE/UIPveNeedResourceCell.prefab",
  UIPVESelectBuffCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectBuffCell.prefab",
  UIPVESelectBattleBuffCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectBattleBuffCell.prefab",
  UIPVESelectDiffCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectDiffCell.prefab",
  UIPVESelectAdventureSubCell = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectAdventureSubCell.prefab",
  SecondMigrateScene = "Assets/Main/Prefabs/CityScene/SecondMigrateScene.prefab",
  XuanFengZhanEffect = "Assets/Main/Prefabs/Effect/XuanFengZhanEffect.prefab",
  TilePlaneRuin = "Assets/Main/Prefabs/CityScene/TilePlaneRuin.prefab",
  UIPVEBloodLayerItem = "Assets/Main/Prefabs/Guide/pveBloodTipItem.prefab",
  UIPVEBloodItem = "Assets/Main/Prefabs/Guide/UIPveBloodItem.prefab",
  SaveBobScene = "Assets/Main/Prefabs/CityScene/SaveBobScene.prefab",
  UIPVEBattleBuffItem = "Assets/Main/Prefabs/UI/UIPVE/UIPVEBattleBuffItem.prefab",
  MasterySkillItem = "Assets/Main/Prefabs/UI/UIMastery/MasterySkillItem.prefab",
  MasteryLevelItem = "Assets/Main/Prefabs/UI/UIMastery/MasteryLevelItem.prefab",
  UIPVEAdventureBuffItem = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAdventureBuffItem.prefab",
  UIPVEPackItem = "Assets/Main/Prefabs/UI/UIPVE/UIPVEPackItem.prefab",
  LWCommonScoreDetailItem = "Assets/Main/Prefabs/UI/LWCommonScoreDetail/LWCommonScoreDetailItem.prefab",
  MonsterBuffIcon = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/MonsterBuffIcon.prefab",
  PirateFightBobScene = "Assets/Main/Prefabs/CityScene/PirateFightBobScene.prefab",
  PirateComeScene = "Assets/Main/Prefabs/CityScene/PirateComeScene.prefab",
  PirateAwayScene = "Assets/Main/Prefabs/CityScene/PirateAwayScene.prefab",
  UINpcTalkBubbleLeft = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleLeft.prefab",
  UINpcTalkBubbleRight = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleRight.prefab",
  UINpcTalkBubbleHeroEntrust = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleHeroEntrust.prefab",
  UINpcTalkBubbleHeroEntrustCell = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleHeroEntrustCell.prefab",
  UIHeroEntrustCell = "Assets/Main/Prefabs/UI/UIHeroEntrust/UIHeroEntrustCell.prefab",
  PirateShowScene = "Assets/Main/Prefabs/CityScene/PirateShowScene.prefab",
  NpcTalkBubbleHeroEntrust = "Assets/Main/Prefabs/CityScene/HeroEntrustBubble%s.prefab",
  RadarScanScene = "Assets/Main/Prefabs/CityScene/RadarScanScene.prefab",
  UITalentChooseCell = "Assets/Main/Prefabs/UI/UITalent/UITalentChooseCell.prefab",
  UITalentIcon = "Assets/Main/Prefabs/UI/UITalent/UITalentIcon.prefab",
  TalentGroupInfoCell = "Assets/Main/Prefabs/UI/UITalent/TalentGroupInfoCell.prefab",
  ShowFakePlayerFlagScene = "Assets/Main/Prefabs/CityScene/ShowFakePlayerFlagScene.prefab",
  UIKonbiniBoard = "Assets/Main/Prefabs/UI/UIKonbini/UIKonbiniBoard.prefab",
  UIKonbiniItem = "Assets/Main/Prefabs/UI/UIKonbini/UIKonbiniItem.prefab",
  RadarWorldScanScene = "Assets/Main/Prefabs/CityScene/RadarWorldScanScene.prefab",
  PickUpWeaponScene = "Assets/Main/Prefabs/CityScene/PickUpWeaponScene.prefab",
  TankScene = "Assets/Main/Prefabs/CityScene/TankScene.prefab",
  CitySpaceManFlyBloodText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyBloodText.prefab",
  CollectionBlood = "Assets/Main/Prefabs/PVE/CollectionBlood.prefab",
  PveHeroSummon = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_hero_zhaohuan.prefab",
  UIAdventureIntroItem = "Assets/Main/Prefabs/UI/UIAdventureIntro/UIAdventureIntroItem.prefab",
  UIHeroOfferRewardFirstCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroOfferRewardFirstCell.prefab",
  UIHeroOfficialFetterItem = "Assets/Main/Prefabs/UI/UIHeroOfficial/UIHeroOfficialFetterItem.prefab",
  PvePirateBoomScene = "Assets/Main/Prefabs/CityScene/PvePirateBoomScene.prefab",
  PveThreeBombsScene = "Assets/Main/Prefabs/CityScene/PveThreeBombsScene.prefab",
  PveDestroyHdc1Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc1Scene.prefab",
  PveDestroyHdc2Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc2Scene.prefab",
  PveDestroyHdc3Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc3Scene.prefab",
  PveDestroyMountainScene = "Assets/Main/Prefabs/CityScene/PveDestroyMountainScene.prefab",
  PveHdcEscapeScene = "Assets/Main/Prefabs/CityScene/PveHdcEscapeScene.prefab",
  PveTurretMissile = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_dapao_trail.prefab",
  PveSkyMissile = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_liudan_trail.prefab",
  WeaponMuchEffectTrail = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/WeaponMuchEffectTrail.prefab",
  PveTriggerPointBubble = "Assets/Main/Prefabs/CityScene/PveTriggerPointBubble%s.prefab",
  UIPveActStageItem = "Assets/Main/Prefabs/UI/UIPveAct/UIPveActStageItem.prefab",
  UIPveActStageRewardItem = "Assets/Main/Prefabs/UI/UIPveAct/UIPveActStageRewardItem.prefab",
  PingItem = "Assets/Main/Prefabs/UI/Common/PingItem.prefab",
  UIPveMonsterHpBar = "Assets/Main/Prefabs/PVE/PveMonster_HpBar.prefab",
  UIHeroRaritySquare = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_dikuai_blue.prefab",
  GuluOutFromBaseScene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_1.prefab",
  GuideTimeline2Scene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_2.prefab",
  DefendWallScene = "Assets/Main/Prefabs/CityScene/DefendWallScene.prefab",
  PveDropRewardBox = "Assets/Main/Prefabs/PVELevel/PveDropRewardBox.prefab",
  PveDropRewardBubble = "Assets/Main/Prefabs/CityScene/PveDropRewardBubble.prefab",
  GuideTimeline3Scene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_3.prefab",
  GatherEffectStar = "Assets/_Art/Effect/prefab/scene/VFX_shouge_xingxing.prefab",
  ChallengeBossEffect = "Assets/_Art/Effect/prefab/monster/Dashachong/VFX_shachong_zhaohuan.prefab",
  UIShowDetailCell = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIShowDetailCell.prefab",
  CityRoad = "Assets/Main/Prefabs/Road/Road_Self_%s.prefab",
  CityRoadUpdating = "Assets/Main/Prefabs/Road/Road_Self_Updating_%s.prefab",
  CityRoadLight = "Assets/Main/Prefabs/Road/RoadLightSelf%s.prefab",
  CityRoadMainLight = "Assets/Main/Prefabs/Road/RoadLightSelfMain%s.prefab",
  Road_Self_Main_TopDown = "Assets/Main/Prefabs/Road/Road_Self_Main_TopDown_%s.prefab",
  Road_Self_Main_LeftRight = "Assets/Main/Prefabs/Road/Road_Self_Main_LeftRight_%s.prefab",
  RoadBridgeLeftRight = "Assets/Main/Prefabs/Road/RoadBridgeLeftRight.prefab",
  RoadBridgeTopDown = "Assets/Main/Prefabs/Road/RoadBridgeTopDown.prefab",
  SecondExpandDomeScene = "Assets/Main/Prefabs/CityScene/SecondExpandDomeScene.prefab",
  UIBuildUpgradeSuccessCell = "Assets/Main/Prefabs/UI/UIBuildUpgradeSuccess/UIBuildUpgradeSuccessCell.prefab",
  UIMainBuildUpgradeSuccessCell = "Assets/Main/Prefabs/UI/UIBuildUpgradeSuccess/UIMainBuildUpgradeSuccessCell.prefab",
  CityDome = "Assets/Main/Prefabs/Building/building_dome_%s.prefab",
  ConnectElectricityScene = "Assets/Main/Prefabs/CityScene/ConnectElectricityScene.prefab",
  UIScrollPackPoint = "Assets/Main/Prefabs/UI/UIScrollPack/UIScrollPackPoint.prefab",
  Chapter2CameraMoveScene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_5.prefab",
  SeasonEndIntroCell = "Assets/Main/Prefabs/UI/UIGlory/UIGlorySeasonEnd/SeasonEndIntroCell.prefab",
  SeasonEndTxt = "Assets/Main/Prefabs/UI/UIGlory/UIGlorySeasonEnd/SeasonEndTxt.prefab",
  UIMasteryNode = "Assets/Main/Prefabs/UI/UIMastery/UIMasteryNode.prefab",
  UIMasteryLine = "Assets/Main/Prefabs/UI/UIMastery/UIMasteryLine.prefab",
  UIMasteryOverviewLine = "Assets/Main/Prefabs/UI/UIMastery/UIMasteryOverviewLine.prefab",
  UIMasteryPageCell = "Assets/Main/Prefabs/UI/UIMastery/UIMasteryPageCell.prefab",
  UIHeroSpecialItem = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSpecialItem.prefab",
  UIHeroPropLineItem = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPropLineItem.prefab",
  UIHeroTagItem = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroTagItem.prefab",
  FirstExpandDomeScene = "Assets/Main/Prefabs/CityScene/FirstExpandDomeScene.prefab",
  UIHeroWeaponEffectRow = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroWeaponEffectRow.prefab",
  LWLackResourceItem = "Assets/Main/Prefabs/UI/LWResource/LWLackResourceItem.prefab",
  LWLackResourceItemChipFactory = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV3/LWLackResourceItemChipFactory.prefab",
  UISoldierDetails_Item = "Assets/Main/Prefabs/UI/UIBuildDispatching/UISoldierDetails_Item.prefab",
  LWWorldSiegeUserCell = "Assets/Main/Prefabs/UI/LWWorld/WorldSiegeAllianceScoreCell.prefab",
  LWWorldSiegeRewardCell = "Assets/Main/Prefabs/UI/LWWorld/WorldSiegeRewardCell.prefab",
  WorldFingerArrow = "Assets/Main/Prefabs/City/WorldFingerArrow.prefab",
  UIDiamondShopPage = "Assets/Main/Prefabs/UI/LWGift/DiamondShopPage.prefab",
  GoldBrickStorePage = "Assets/Main/Prefabs/UI/LWGift/GoldBrickStorePage.prefab",
  BrickGiftPackPage = "Assets/Main/Prefabs/UI/LWGift/BrickGiftPack/BrickGiftPackPagePanel.prefab",
  UIDailyPackagePage = "Assets/Main/Prefabs/UI/LWGift/DailyPackage/DailyPackage.prefab",
  UIShopPageToggle = "Assets/Main/Prefabs/UI/LWGift/ShopPageToggle.prefab",
  UIWeekCardPage = "Assets/Main/Prefabs/UI/LWGift/WeekCard/WeekCardMain.prefab",
  UIWeekCardItem = "Assets/Main/Prefabs/UI/LWGift/WeekCard/WeekCardItem.prefab",
  UILWMonthCardPage = "Assets/Main/Prefabs/UI/LWGift/UILWMonthCard/UILWMonthCard.prefab",
  UILWHeroMonthCard = "Assets/Main/Prefabs/UI/LWGift/UILWHeroMonthCard/HeroMonthCardMain.prefab",
  UILWHeroMonthCardPop = "Assets/Main/Prefabs/UI/LWGift/UILWHeroMonthCard/HeroMonthCardMainPop.prefab",
  UILWLimitedPack = "Assets/Main/Prefabs/UI/LWGift/LimitedPackage/LimitedPackage.prefab",
  MonopolyObstacle = "Assets/Main/Prefabs/Monopoly/Obstacle/%s.prefab",
  MonopolyTiles = "Assets/Main/Prefabs/Monopoly/Tiles/%s.prefab",
  AllianceWorldRallyMark = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldRallyMark.prefab",
  S5AllianceOtherServerRallyMark = "Assets/Main/SeasonRes/S5/Prefabs/World/AllianceOtherServerRallyMark.prefab",
  OtherAllianceWorldRallyMark = "Assets/Main/Prefabs/UI/AllianceWorldMark/OtherAllianceWorldRallyMark.prefab",
  UIStrongestCommnaderPanel = "Assets/Main/Prefabs/UI/ActivityCenter/StrongestCommander/UIStrComPanel.prefab",
  LockhartActivityPanel = "Assets/Main/Prefabs/UI/ActivityCenter/Lockhart/LockhartMain.prefab",
  KillZombieActivityPanel = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/KillZombieMain.prefab",
  LWEffectOverviewItem = "Assets/Main/Prefabs/UI/LWEffectOverview/LWEffectOverviewItem.prefab",
  LWEffectOverviewCanFoldItem = "Assets/Main/Prefabs/UI/LWEffectOverview/LWEffectOverviewCanFoldItem.prefab",
  UICommonPropertyCanFoldItem = "Assets/Main/Prefabs/UI/Common/UICommonPropertyCanFoldItem.prefab",
  UICampPropertyCanFoldItem = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampPropertyCanFoldItem.prefab",
  UIActivityWorldBoss = "Assets/Main/Prefabs/UI/ActivityCenter/WorldBoss/UIActivityWorldBoss.prefab",
  UIActivityMonsterInvasion = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/UIActivityMonsterInvasion.prefab",
  UIJungleTrial = "Assets/Main/SeasonRes/S6/Prefabs/UI/JungleTrial/UIJungleTrial.prefab",
  UISandWormHunt = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/UISandWormHunt.prefab",
  UISandWormFishing = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormFishing/UISandWormFishing.prefab",
  UIFishingMaster = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishingMaster.prefab",
  LWPowerOverviewItem = "Assets/Main/Prefabs/UI/LWPowerOverview/LWPowerOverviewItem.prefab",
  UIVisitorTipImagePath = "Assets/Main/Sprites/UI/UIBuildBubble/%s.png",
  UIActivityDesertBattle = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/DesertBattleMain.prefab",
  UIDesertBattleResultDataItem = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleResultDataItem.prefab",
  UIActivityWinterStorm = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/WinterStormMain.prefab",
  LWWorldWinterDrop = "Assets/Main/Prefabs/World/BF_Winter/A_build_jiangluosan.prefab",
  UIActivityDispatchTask = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTask/UIActivityDispatchTask.prefab",
  UIAccuRechargeMain = "Assets/Main/Prefabs/UI/ActivityCenter/AccuRecharge/AccuRechargeMain.prefab",
  AccuRechargeChristmas = "Assets/Main/Prefabs/UI/ActivityCenter/AccuRecharge/AccuRechargeChristmas.prefab",
  UIAccuRechargeSpringFestival = "Assets/Main/Prefabs/UI/ActivityCenter/AccuRecharge/UIAccuRechargeSpringFestival.prefab",
  UIMeteoriteNoticeItemRenderer = "Assets/Main/Prefabs/UI/LWMainUI/LWMiniMapMeteoriteNoticeObj.prefab",
  UIMeteoriteNewsItemRenderer = "Assets/Main/Prefabs/UI/LWMainUI/LWMiniMapMeteoriteNewsObj.prefab",
  UIMeteoriteMainUIMoveCity = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteMoveCity.prefab",
  UIActEpidemicRewardSheetPersonalPt = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicRewardSheetPersonalPt.prefab",
  UIActEpidemicRewardSheetWinner = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicRewardSheetWinner.prefab",
  UIActEpidemicRewardSheetRank = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicRewardSheetRank.prefab",
  UIActEpidemicHelpTips = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicHelpTips.prefab",
  UIActDsbDuelRewardSheetPersonalPt = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Reward/UIActDsbDuelRewardSheetPersonalPt.prefab",
  UIActDsbDuelRewardSheetWinner = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Reward/UIActDsbDuelRewardSheetWinner.prefab",
  UIActDsbDuelRewardSheetRank = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Reward/UIActDsbDuelRewardSheetRank.prefab",
  UIActDsbDuelRewardSheetPersonal = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Reward/UIActDsbDuelRewardSheetPersonal.prefab",
  UIGMDisplayModeMenu = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/Items/GMDisplayModeMenu.prefab",
  UIGMNewMarchMenu = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/Items/GMNewMarchMenu.prefab",
  UISubscriptionRewardItem = "Assets/Main/Prefabs/UI/LWGift/SubscriptionListPanel/UISubscriptionRewardItem.prefab",
  UIGrowFoundationPanel = "Assets/Main/Prefabs/UI/LWGift/GrowFoundation/UIGrowFoundationPanel.prefab",
  UISunriseFoundationPanel = "Assets/Main/Prefabs/UI/LWGift/GrowFoundation/UISunriseFoundationPanel.prefab",
  UILWWeeklyPackageMain = "Assets/Main/Prefabs/UI/LWGift/WeeklyPackage/WeeklyPackage.prefab",
  ActivityRewardTipCell = "Assets/Main/Prefabs/UI/ActivityCenter/ActivityRewardTipCell.prefab",
  UIGiftPackChooseResItem = "Assets/Main/Prefabs/UI/LWGift/UIGiftPackChooseResItem.prefab",
  UIDecorationWorldScene = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorationWorldScene.prefab",
  UIDecorationCityZone = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorationCityZone.prefab",
  UIAllyDuelPersonalRewardItem = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelPersonalRewardItem.prefab",
  AllyDuelLeaguePersonalRewardItem = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelLeaguePersonalRewardItem.prefab",
  UIAllyDuelLeagueRewardItem = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelLeagueRewardItem.prefab",
  UILWSquadEquipPageToggle = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipPageToggle.prefab",
  UILWBagItem = "Assets/Main/Prefabs/UI/LWBag/UILWBagItem.prefab",
  UILWDailyMustBuy = "Assets/Main/Prefabs/UI/LWGift/DailyMustBuy/DailyMustBuy.prefab",
  UILWPiggyBank = "Assets/Main/Prefabs/UI/GiftPackage/UIPiggyBankPanel.prefab",
  UIGiftBox = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxMainPanel.prefab",
  GiftBoxCell = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxMainBoxItem.prefab",
  UIGiftBoxMainRewardBoxItem = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIGiftBoxMainRewardBoxItem.prefab",
  GiftBoxRewardCell = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxRewardCell.prefab",
  GiftBoxRewardCellNew = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxRewardCellNew.prefab",
  GiftBoxDetailCell = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxDetailCell.prefab",
  UIActGiftBoxKeyAccessItem = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxKeyAccessItem.prefab",
  UIGiftBoxRank = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIGiftBoxRank.prefab",
  GiftBoxOptionItem = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxOptionItem.prefab",
  UIGiftBoxNew = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxMainPanelNew.prefab",
  UIGiftBoxMainRewardBoxItemNew = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIGiftBoxMainRewardBoxItemNew.prefab",
  UILuckyShop = "Assets/Main/Prefabs/UI/ActivityCenter/UILuckyShop/UILuckyShop.prefab",
  UIHeroTrialHeroItem = "Assets/Main/Prefabs/UI/ActivityCenter/HeroTrial/HeroTrialHeroItem.prefab",
  UIHeroTrial = "Assets/Main/Prefabs/UI/ActivityCenter/HeroTrial/HeroTrialMainPanel.prefab",
  UILWScienceQueuePanelCell = "Assets/Main/Prefabs/UI/LWScience/LWUIScienceQueuePanelCell.prefab",
  UILWScienceQueueInfoCell = "Assets/Main/Prefabs/UI/LWScience/UIScienceQueueItem.prefab",
  UILWInfiniteGiftRewardItem = "Assets/Main/Prefabs/UI/UIInfiniteGift/UILWInfiniteGiftRewardItem.prefab",
  UIEquipPromoteSuccessCell = "Assets/Main/Prefabs/UI/LWUIEquip/UIEquipPromoteSuccessCell.prefab",
  CitySkinGet = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/CitySkinGet_ThanksGiving.prefab",
  CitySkinExchange = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/CitySkinExchange_ThanksGiving.prefab",
  UILimitedTimeFeast = "Assets/Main/Prefabs/UI/ActivityCenter/LimitedTimeFeast/UILimitedTimeFeast.prefab",
  LimitedTimeFeastChristmas = "Assets/Main/Prefabs/UI/ActivityCenter/LimitedTimeFeast/LimitedTimeFeastChristmas.prefab",
  LimitedTimeFeast_Common2 = "Assets/Main/ActivityFestival/ActLimitedTimeFeast/Prefab/LimitedTimeFeast_Common2.prefab",
  UIThanksGivingCooking = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingCooking.prefab",
  UIThanksGivingBanquet = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingBanquet.prefab",
  BanquetScoreBoxItem = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingBanquetScoreBoxItem.prefab",
  UILWTacticalWeaponItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTacticalWeaponItem.prefab",
  UICollectRewardResItem = "Assets/Main/Prefabs/UI/UICollectReward/CollectRewardResItem.prefab",
  LWUITrailTowerSubPanel = "Assets/Main/Prefabs/UI/UILWTrailTower/UILWTrailTowerSubPanel.prefab",
  LWCountBattleMapVIew = "Assets/Main/Prefabs/UI/LWCountBattle/UILWCountBattleMap.prefab",
  LWUIStageFeatureChapter = "Assets/Main/Prefabs/UI/LWUIStageFeatureChapter/LWUIStageFeatureChapter.prefab",
  LWUIEasyStageFeatureChapter = "Assets/Main/Prefabs/UI/LWUIStageFeatureChapter/LWUIEasyStageFeatureChapter.prefab",
  UIStageFeatureIntegrated = "Assets/Main/Prefabs/UI/StageFeatureIntegrated/UIStageFeatureIntegrated.prefab",
  UIChristmasCitySkinExchange = "Assets/Main/Prefabs/UI/ActivityCenter/CitySkin/CitySkinExchange_Christmas.prefab",
  UISpringFestivalCitySkinExchange = "Assets/Main/Prefabs/UI/ActivityCenter/CitySkin/CitySkinExchange_SpringFestival.prefab",
  UIValentineCitySkinExchange = "Assets/Main/Prefabs/UI/ActivityCenter/CitySkin/CitySkinExchange_Valentine.prefab",
  UIChristmasLuckyRoll = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRollChristmas.prefab",
  UISpringFestivalLuckyRoll = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRollSpringFestival.prefab",
  UIEasterLuckyRoll = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRollEaster.prefab",
  UIActSevenDayNewYear = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIActSevenDayNewYear.prefab",
  UIAccuRechargeNewYear = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/AccuRechargeNewYear.prefab",
  UIAccuRechargeValentine = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/AccuRechargeValentine.prefab",
  UIAccuRechargeEaster = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/AccuRechargeEaster.prefab",
  UIAccuRecharge_Common = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/AccuRecharge_Common.prefab",
  UIActSevenDayLoginNewYear = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UISevenDayLoginNewYear.prefab",
  UIActSevenDayLoginValentine = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIActSevenDayLoginValentine.prefab",
  UIActSevenDayLoginTorchRelay = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIActSevenDayTorchRelay.prefab",
  UIBattlePassNewYear = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassNewYear.prefab",
  UISeasonBattlePass = "Assets/Main/SeasonRes/Shared/Prefabs/UI/BattlePass/UISeasonBattlePass.prefab",
  UIBattlePassValentine = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassValentine.prefab",
  UIBattlePassEaster = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassEaster.prefab",
  UIBattlePassRamadan = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassRamadan.prefab",
  UIActivityBargainShop = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/UIActivityBargainShop.prefab",
  UIActivityBargainShopValentine = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/UIActivityBargainShopValentine.prefab",
  UIComicsTextItem = "Assets/Main/Prefabs/UI/Comics/UIComicsTextItem.prefab",
  UIComicsSpineTextItem = "Assets/Main/Prefabs/UI/Comics/UIComicsSpineTextItem.prefab",
  UIActivityBargainShop_Common = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/UIActivityBargainShop_Common.prefab",
  UITitaniumBlueStore = "Assets/Main/Prefabs/UI/UILWTitaniumBlueStore/UILWTitaniumBlueShop.prefab",
  UILWWorldTipTabItem = "Assets/Main/Prefabs/UI/UILWWorldTip/UILWWorldTipTabItem.prefab",
  UIDecorationBookSubItem = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookEffectOverviewSubItem.prefab",
  UIDecorationBookPropertyItem = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookPropertyDetailItem.prefab",
  UIDecorationBookPropertySubItem = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookPropertyDetailSubItem.prefab",
  PropNoticeItem = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitTipDetailItem.prefab",
  PropNoticeItemNew = "Assets/Main/Prefabs/UI/SurfingBattle/ProbabilityDetailItem.prefab",
  UILWOptionalWeekCard = "Assets/Main/Prefabs/UI/UILWOptionalWeekCard/UILWOptionalWeekCard.prefab",
  UILockhartTexturePath = "Assets/Main/TextureEx/UILockhart/%s.png",
  UIHeroSkillStar = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSkillStar.prefab",
  UILWTWSkillChipItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipItem.prefab",
  UILWTWSkillChipSetLine = "Assets/Main/Prefabs/UI/UIHero/LWHero/UILWTWSkillChipSetLine.prefab",
  UILWUniversalItem = "Assets/Main/Prefabs/UI/Common/UILWUniversalItem.prefab",
  UIActivityMultipleParkour = "Assets/Main/Prefabs/UI/ActivityCenter/MultipleParkour/UIActivityMultipleParkour.prefab",
  UIActivityCounterAttack = "Assets/Main/Prefabs/UI/ActivityCenter/CounterAttack/CounterAttackMain.prefab",
  UIActivityBloodyNight = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/UIBloodyNight.prefab",
  UIWestwardExpansion = "Assets/Main/SeasonRes/S5/Prefabs/UI/WestwardExpansion/UIWestwardExpansion.prefab",
  UITWSignInMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignIn/UITacticalWeaponSignIn.prefab",
  UITWSignInDayItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignIn/TWDayItem.prefab",
  UITWSignInFinalDayItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignIn/TWFinalDayItem.prefab",
  UIFestivalCommonSignIn = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignInFestivalCommon/UIFestivalCommonSignIn.prefab",
  UIFestivalCommonFinalDayItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignInFestivalCommon/FestivalCommonFinalDayItem.prefab",
  UIFestivalCommonDayItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActSignInFestivalCommon/FestivalCommonDayItem.prefab",
  CitySkinExchange_Easter = "Assets/Main/Prefabs/UI/ActivityCenter/CitySkin/CitySkinExchange_Easter.prefab",
  LWUIZombieRushMain = "Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRush.prefab",
  CitySkinExchange_Common = "Assets/Main/ActivityFestival/ActCitySkinExchange/Prefab/CitySkinExchange_Common.prefab",
  UIBattlePassNewYear_Common = "Assets/Main/Prefabs/UI/ActivityCenter/Common/UIBattlePassNewYear/UIBattlePassNewYear_Common.prefab",
  DispatchTreasure = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTreasure/UIActivityDispatchTreasure.prefab",
  LWUIZombieRushWorldScene = "Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRushWorldScene.prefab",
  UIActSevenDayDoomVanguard = "Assets/Main/Prefabs/UI/DoomVanguard/SevenDay/UIActSevenDayDoomVanguard.prefab",
  UIBattlePassForDoomVanguard = "Assets/Main/Prefabs/UI/DoomVanguard/BattlePass/UIBattlePassForDoomVanguard.prefab",
  UIActDoomCommander = "Assets/Main/Prefabs/UI/DoomVanguard/DoomCommander/UIActDoomCommander.prefab",
  UIHeroAttrLine = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAttrLine.prefab",
  WeaponCostGroup = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/WeaponCostGroup.prefab",
  UIHeroPVPFormationPanelHeroCell = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPVPFormationPanelHeroCell.prefab",
  MailHeroWeaponCell = "Assets/Main/Prefabs/UI/LWMail/MailHeroWeaponCell.prefab",
  MailHeroWeaponCell_New = "Assets/Main/Prefabs/UI/LWMail/MailHeroWeaponCell_New.prefab",
  WorkerOverviewBuildingGroupDispatchCell = "Assets/Main/Prefabs/UI/UIWorker/WorkerOverviewBuildingGroupDispatchCell.prefab",
  WorkerOverviewBuildingDispatchCell = "Assets/Main/Prefabs/UI/UIWorker/WorkerOverviewBuildingDispatchCell.prefab",
  HeroUniqueWeaponSkillWillUnlockEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/yingxiongzhuanwu/Eff_ui_skill_unlock.prefab",
  HeroUniqueWeaponSkillUnlockEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_jineng_shengji_01.prefab",
  HeroUniqueWeaopnAttrLineFlashEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_qianghua_shuaguang.prefab",
  LWUIQuestionnaire = "Assets/Main/Prefabs/UI/ActivityCenter/UILWQuestionnaire/LWUIQuestionnaire.prefab",
  UITreasureHuntNewMain = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHuntNew/UITreasureHuntNewMain.prefab",
  UIActCommunityLink = "Assets/Main/Prefabs/UI/ActivityCenter/ActCommunityLink/UIActCommunityLink.prefab",
  TacticalWeaponTextureEx = "Assets/Main/TextureEx/LWUITacticalWeapon/%s.png",
  CommunityLinkBtnIcon = "Assets/Main/TextureEx/ActCommunityLink/%s.png",
  UIRebateNewActivityMain = "Assets/Main/Prefabs/UI/ActivityCenter/RebateNew/UIRebateNewActivityMain.prefab",
  UIChampionDuelMain = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelMain.prefab",
  TrailTowerStageVictoryEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/TrailTower/Effect_ui_trailTowerStageVictory.prefab",
  UIBlackMarketMain = "Assets/Main/Prefabs/UI/UILWBlackMarket/UILWBlackMarket.prefab",
  GREY_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_1.png",
  GREEN_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png",
  BLUE_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png",
  YELLOW_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png",
  RED_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png",
  UIChatViewBottomBtnItem = "Assets/Main/Prefabs/UI/ChatNew/LWUIChat_v2_bottom_BtnItem.prefab",
  ActTrendsMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActTrends/ActTrendsMain.prefab",
  LWUIBerserkBossMain = "Assets/Main/Prefabs/UI/ActivityCenter/UILWBerserkBoss/LWUIBerserkBossMain.prefab",
  UICommonTab = "Assets/Main/Prefabs/UI/Common/UICommonTab.prefab",
  UIBoxItemTipsCell = "Assets/Main/Prefabs/UI/Common/UIBoxItemTipsCell.prefab",
  UIDecorationGachaMain = "Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaMain.prefab",
  MailPageHeroInfoItem = "Assets/Main/Prefabs/UI/LWMail/AIHelper/MailPageHeroInfoItem.prefab",
  ACT_NUCLEAR_POWER_PLANT = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/NuclearPowerPlant/UIActNuclearPowerPlant.prefab",
  ActEpidemicMainPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMain.prefab",
  ActEpidemicCompChangeTeam = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMainCompTeamChange.prefab",
  ActEpidemicCompTimer = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMainCompTimer.prefab",
  ActEpidemicCompMvp = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMainCompMVP.prefab",
  ActEpidemicCompFighting = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMainCompFighting.prefab",
  Ghostrecon = "Assets/Main/Prefabs/UI/ActivityCenter/Ghostrecon/UIActivityGhostrecon.prefab",
  UIGhostreconPath = "Assets/Main/Sprites/UI/UIGhostrecon/",
  UIGhostreconCommonPath = "Assets/Main/Sprites/UI/UIGhostreconCommon/",
  GhostreconTexturePath = "Assets/Main/TextureEx/UIActivityBg/ActGhostrecon/",
  ChatItemBg_left = "ChatItems/zyf_fenxiang_liaotian_1.png",
  ChatItemBg_right = "ChatItems/zyf_fenxiang_liaotian_2.png",
  ACT_COOK_FOOD_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/ActCookFood/UIActCookFood.prefab",
  UITorchRelayMain = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UILWTorchRelayMain.prefab",
  UITorchRelayTask = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UITorchRelayTask.prefab",
  UITorchRelayBattleBuffIconItem = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Item/TorchRelayBuffIconItem.prefab",
  UIVipExtend18Design = "Assets/Main/Prefabs/UI/UIVipExtend/VipExtendVip18Design.prefab",
  UIVipExtend18Panel = "Assets/Main/Prefabs/UI/UIVipExtend/VipExtendVip18Panel.prefab",
  TacticalLevelDisplayAirItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/TacticalLevelDisplayAirItem.prefab",
  TacticalLevelDisplayLevelItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/TacticalLevelDisplayLevelItem.prefab",
  TacticalLevelDisplaySkillItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/TacticalLevelDisplaySkillItem.prefab",
  WeaponAttriLine = "Assets/Main/Prefabs/UI/LWMail/MailBattle/WeaponAttriLine.prefab",
  ChatBubbleAllianceHelp = "Assets/Main/Prefabs/UI/ChatNew/ChatBubbleAllianceHelp/BubbleAllianceHelp.prefab",
  ChatBubbleAllianceTrain = "Assets/Main/Prefabs/UI/ChatNew/ChatBubbleAllianceHelp/BubbleAllianceTrain.prefab",
  ChatBubbleCommonTip = "Assets/Main/Prefabs/UI/ChatNew/ChatBubbleAllianceHelp/ChatBubbleCommonTip.prefab",
  ConstellationSpritePath = "Assets/Main/Sprites/UI/ConstellationBirthday/%s",
  UIActLotteLink = "Assets/Main/Prefabs/UI/ActivityCenter/ActLotteLink/UIActLotteLink.prefab",
  TacticalChipSquadItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipSquadItem.prefab",
  TacticalChipPlanTabItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipPlanTabItem.prefab",
  TacticalChipStatsAttriItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipStatsAttriItem.prefab",
  UILWTWSkillChipManageSmallItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipManageSmallItem.prefab",
  TacticalChipItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipItem.prefab",
  TacticalChipBagSortOptionItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/TacticalChipSortOptionItem.prefab",
  TacticalChipOpenPreTipItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipOpenPreTipItem.prefab",
  TacticalChipTierDisplayItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipTierDisplayItem.prefab",
  MarkTranslateLoading = "Assets/Main/Prefabs/UI/AllianceWorldMark/loadingIcon.prefab",
  Truckgoodsgroup_01_01 = "Assets/_Art_LastWar/Models/Characters/Object/A_Vehicle_transportcar_01/prefab/A_Vehicle_truckgoodsgroup_01_01.prefab",
  Truckgoodsgroup_01_02 = "Assets/_Art_LastWar/Models/Characters/Object/A_Vehicle_transportcar_01/prefab/A_Vehicle_truckgoodsgroup_01_02.prefab",
  TruckFullGoods = "Assets/Main/Prefabs/LWGateDefence/Huoche_manzai.prefab",
  FrontBreakSunday = "Assets/Main/Prefabs/UI/ActivityCenter/FrontBreakoutSunday/ActivityFrontBreakOutSunday.prefab",
  LWUIZoneMobilizationDonatedSubPanel = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationDonatedSubPanel.prefab",
  LWUIZoneMobilizationAttackSubPanel = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationAttackSubPanel.prefab",
  LWUIZoneMobilizationDefendSubPanel = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationDefendSubPanel.prefab",
  SevenDayV2Item = "Assets/Main/Prefabs/UI/LWActSevenDayV2/UIActSevenDayV2.prefab",
  SevenDayV2NewItem = "Assets/Main/Prefabs/UI/LWActSevenDayV2NewUI/UIActSevenDayV2_New.prefab",
  UIJeepAdventureMainSpritePath = "Assets/Main/Sprites/UI/UIJeepAdventureNew/%s",
  DominatorTrainingGrade = "Assets/Main/Prefabs/UI/LWMail/MailBattle/dominator/trainingGrading.prefab",
  MultiReward = "Assets/Main/Prefabs/UI/ActivityCenter/MultiReward/UIActMultiReward.prefab",
  UIRevivalPlanPanel = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanPanel.prefab",
  HelpBuildPlayer = "Assets/Main/Prefabs/BuildHelpNpc/A_jianzao_ben.prefab",
  HelpBuildPlayer_worker = "Assets/Main/Prefabs/BuildHelpNpc/A_jianzao_ben_newbies.prefab",
  HelpBuildPlayer_keyan = "Assets/Main/Prefabs/BuildHelpNpc/A_Hero_keyan_01_newbies.prefab",
  RebuildNursePlayers = "Assets/Main/Prefabs/RebuildNurseNpc/A_Hero_nurse.prefab",
  UIActValentineSendGift = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineSendGiftMain.prefab",
  UIActValentineReceiveGift = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineReceiveGift.prefab",
  TacticalEquipAttriItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/TacticalEquipAttriItem.prefab",
  TacticalEquipAttriItemV = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/TacticalEquipAttriItemV.prefab",
  TacticalEquipStaticAttriItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/TacticalEquipStaticAttriItem.prefab",
  TacticalEquipStaticAttriItemV = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/TacticalEquipStaticAttriItemV.prefab",
  MasterySkillPanelView = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasterySkillPanel.prefab",
  UITCCardMainPanel = "Assets/Main/Prefabs/UI/UILWTC/UITCCardMainPanel.prefab",
  UITCQuickEquipType = "Assets/Main/Prefabs/UI/UILWTC/Component/CardDetailItem/QuickEquip/QuickType.prefab",
  UIActEasterEggMainView = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggMainView.prefab",
  TacticalCardSystemIcon = "Assets/Main/Sprites/UI/UILWMail/FX_zhanshukapai_fenxiang3_icon.png",
  OffSeason1RecaptureMain = "Assets/Main/Prefabs/UI/LWOffSeason1/Recapture/OffSeason1RecaptureMain.prefab",
  OffSeason1QueenOfBloodMain = "Assets/Main/Prefabs/UI/LWOffSeason1/QueenOfBlood/OffSeason1QueenOfBloodMain.prefab",
  ActConcertTexturePath = "Assets/Main/TextureEx/ActConcertList/%s.png",
  ActConcertSpritePath = "Assets/Main/Sprites/UI/ActConcertList/%s.png",
  CrazyRockView = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActCrazyRock/UIActCrazyRockMain.prefab",
  UIMigrationPersonMarket = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_MarketPage.prefab",
  UIMigrationAllianceMarket = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_AllyRecruitPage.prefab",
  UIMigrationAllianceTagItem = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_AllyTagItem.prefab",
  LWUIMigrationAllyChooseContent = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_AllyChooseContent.prefab",
  LWUIMigration_StarListItem = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_StarListItem.prefab",
  UIActBountyHunter = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/UIActBountyHunterRoot.prefab",
  LWBuyDiamondDownloadRes = "Assets/Main/Prefabs/UI/LWGift/LWBuyDiamondDownloadResMain.prefab",
  UISurfingBattleActMain = "Assets/Main/Prefabs/UI/SurfingBattle/UISurfingBattleActMain.prefab",
  UISurfingBattleActEffectPath = "Assets/Main/Prefabs/UI/SurfingBattle/Effect/Prefab/Eff_ui_paoku_enviroment.prefab",
  OffSeasonTreasureBoxRewardPath = "Assets/Main/Prefabs/UI/OffSeason3TreasureBoxReward/OffSeasonTreasureBoxReward.prefab",
  WastelandChallengeBoxReward = "Assets/Main/Prefabs/UI/ActivityCenter/WastelandChallengeRank/WastelandChallengeBoxReward.prefab",
  ActCalendarMain = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/ActCalendarMain.prefab",
  ActCalendarEventGroup = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/ActCalendarEventGroup.prefab",
  ActCalendarEventItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/ActCalendarEventItem.prefab",
  ActCalendarTipsRewardItem = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/ActCalendarTipsRewardItem.prefab",
  UIPositionShare_RedPacket = "Assets/Main/Prefabs/UI/World/UIPositionShareDynamicItem/UIPositionShare_RedPacket.prefab",
  UIAllianceInvite = "Assets/Main/Sprites/UI/UIAllianceInvite/",
  UIGhostParkourActMain = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourActMain.prefab",
  AccuRechargeFestivalOverlapRewardLine = "Assets/Main/ActivityFestival/AccuRecharge/Prefab/AccuRechargeFestivalOverlapRewardLine.prefab",
  AccuRechargeTargetTitleLineItem = "Assets/Main/ActivityFestival/AccuRecharge/Prefab/AccuRechargeTargetTitleLineItem.prefab",
  ArmedUpgradeScenePath = "Assets/Main/Prefabs/ArmedUpgrade/DisplayScene_Monica_WZSJ.prefab",
  UIIdleGameTaskEventDetailRequireItem = "Assets/Main/Prefabs/UI/T11IdleGame/TaskEvent/UIIdleGameTaskEventDetailRequireItem.prefab",
  TacticalChipPlanNeedStarItem = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV3/TacticalChipPlanNeedStarItem.prefab",
  UIHeroDrawCardUR = "Assets/Main/Prefabs/UI/UIHero/LWHero/Effect/Eff_ui_heroexhibit_lightsweep_gold.prefab",
  UIHeroDrawCardSSR = "Assets/Main/Prefabs/UI/UIHero/LWHero/Effect/Eff_ui_heroexhibit_lightsweep_purple.prefab",
  ActRecycleMain = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleMain.prefab",
  ActRecycleLotteryAnim_2025christmas = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/2025christmas/Eff_ui_Characters2025_train_deer.prefab",
  ActRecycleExchangeArrowDefaultImage = "Assets/Main/Sprites/UI/LWUIActRecycle/2025christmas/FX_sdhchs_jiantou.png",
  AccuRechargeFestivalOverlap = "Assets/Main/ActivityFestival/AccuRecharge/Prefab/AccuRechargeFestivalOverlap.prefab",
  MailSkinSystemIcon = "Assets/Main/Sprites/UI/UILWMail/lyt_zhanbao_zhuangban_icon.png",
  UILWMailBattleSkinView = "Assets/Main/Prefabs/UI/LWMail/MailBattle/Skin/LWMailBattleSkinView.prefab",
  UILWMailBattleSkinItem = "Assets/Main/Prefabs/UI/LWMail/MailBattle/Skin/LWMailBattleSkinItem.prefab",
  SendGiftListItem = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftListItem.prefab",
  UICivilizationSparkTexturePath = "Assets/Main/TextureEx/LWUICivilizationSpark/%s.png",
  CommonHeroYellowStarFragImagePath = "Assets/Main/Sprites/UI/LWCommon/Sprite2/FX_yingxiong_xingxing_0%s.png",
  CommonHeroRedStarFragImagePath = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_yingxiong_xingxing_hong0%s.png",
  HeroAwakenSkillFrameImagePath = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_yingxionjuexing_biankuang.png",
  HeroAwakenSkillFrameMaskImagePath = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenMain/FX_yingxionjuexing_biankuangzhezhao.png",
  CommonHeroSkillLevelBgImagePath = "Assets/Main/Sprites/UI/UIHeroCommon/FX_yingxionjuexing_dengjikuang.png",
  HeroAwakenSkillLevelBgImagePath = "Assets/Main/Sprites/UI/UIHeroCommon/FX_yingxionjuexing_dengjikuang2.png",
  CommonHeroSkillSelectBgImagePath = "Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_jinengkuang_xuanzhong.png",
  HeroAwakenSkirmishEnergy = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenBattle/SkirmishHeroAwakenEnergy.prefab",
  HeroAwakenParkourSkill = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenBattle/UIParkourHeroAwakenSkill.prefab",
  DailyPackageBgPosterUniqueWeapon = "Assets/Main/Prefabs/UI/LWGift/DailyPackageRemote/DailyPackageUniquePosterAni.prefab",
  DailyPackageSelectAwakenAni = "Assets/Main/Prefabs/UI/LWGift/DailyPackageRemote/DailyPackageSelectAwakenAni.prefab",
  DailyPackageSelectUWAni = "Assets/Main/Prefabs/UI/LWGift/DailyPackageRemote/DailyPackageSelectUWAni.prefab",
  DailyPackageUniquePosterAni_Awake = "Assets/Main/Prefabs/UI/LWGift/DailyPackageRemote/DailyPackageUniquePosterAni_Awake.prefab",
  UIS0AllianceBossMain = "Assets/Main/Prefabs/UI/ActivityCenter/S0AllianceBoss/UIS0AllianceBossMain.prefab",
  UIS0AllianceDrillBuildingDescPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/S0AllianceBoss/S0AllianceBossDesc_build.prefab",
  UIS0AllianceDrillBossDescPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/S0AllianceBoss/S0AllianceBossDesc_boss.prefab",
  LWUIQuickGift = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIQuickGift.prefab",
  LWUIQuickGiftItem = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/QuickGiftItem.prefab"
}
EffectAssets = {
  TorchRelayAddBuffEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_eat_01.prefab",
  TorchRelaySpeedPowerMaxEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/yundongjie/Eff_s_yundongjie2024_nengliangtiao_01.prefab",
  TorchRelayInvincibleHalloweenEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_wsj_paoku_02.prefab",
  TacticalSubLevelUpOneFillEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_shengji_small.prefab",
  TacticalSubLevelUpAllFillEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_shengji_big.prefab",
  TacticalAttributeValueEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_normal_saoguang.prefab",
  TacticalTotalCombatValueEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_zhanli_saoguang.prefab",
  TacticalLevelUpFlyEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_shengji_trail.prefab",
  TacticalLevelUpExpFullEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_shengji_long.prefab",
  TorchRelayBuffIconProgress = "Assets/_Art_LastWar/Effect/Prefab/UI/Lianhuanduobao/Eff_ui_duobao_jiangli_faguang_officialPositionBuff.prefab",
  TorchRelayBoxPropsGet = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_boxItemglow.prefab",
  ItemCanGetEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Lianhuanduobao/Eff_ui_duobao_jiangli_faguang.prefab"
}
VfxAssets = {
  TacticalChipPlanKeJiRing = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_keji_ring.prefab",
  TacticalChipPlanDianLiu_Top = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_dianliu_top.prefab",
  TacticalChipPlanDianLiu_Right = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_dianliu_right.prefab",
  TacticalChipPlanDianLiu_Left = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_dianliu_left.prefab",
  TacticalChipPlanRadarFind = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_radar_find.prefab",
  TacticalChipPlanRadarFindSimple = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_radar_find_simple.prefab",
  TacticalChipPlanKeJiSwitch = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_keji_switch.prefab",
  TacticalChipPlanItemUnlock = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_item_unlock.prefab",
  TacticalChipPlanBG = "Assets/_Art_LastWar/Effect/Prefab/UI/TacticalChip/Eff_UITacticalWeaponChipPlan_Bg.prefab",
  TacticalChipPlanRingBG = "Assets/_Art_LastWar/Effect/Prefab/UI/TacticalChip/Eff_UITacticalWeaponChipPlan_Bg_Ring.prefab",
  CombatUpgradeEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_zhanli_saoguang.prefab",
  CombatUpgradeEffect_Big = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_zhanli_saoguang.prefab",
  TacticalChipTierUp = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_titlebg_gold.prefab",
  TacticalChipItemProductFinish = "Assets/_Art_LastWar/Effect/Prefab/UI/TacticalChip/Eff_ui_peijian_shouqu_tishi.prefab",
  TacticalChipPropsBoxQualityPath = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_chipbox_%s.prefab",
  TacticalChipFactoryCreatePageDianLiu = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_wurenji_dianliu_002.prefab",
  TacticalChipStarUpDianLiu = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_wurenji_dianliu_004.prefab",
  TacticalChipStarUpMainLvBgEffect = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_lvup_saomiao.prefab",
  TacticalChipStarUpNormalLvSelect = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_UITacticalChipStarUp_select_small.prefab",
  TacticalChipStarUpMainLvSelect = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_UITacticalChipStarUp_select_big.prefab",
  TacticalChipStarUpLvUnlock = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_UITacticalChipStarUp_Unlockable_small.prefab",
  ScienceTreeItemSpecialBg1 = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_UILWScienceCell/Eff_ui_UILWScienceCell_blue.prefab",
  ScienceTreeItemSpecialBg2 = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_UILWScienceCell/Eff_ui_UILWScienceCell_gold.prefab",
  DecorationDazzleChange = "Assets/_Art/Effect/prefab/ui/VFX_ui_level.prefab",
  DecorationDazzleBtn = "Assets/_Art_LastWar/Effect/Prefab/2025/UIDecorationMainView/Eff_UIDecorationMainView_Color.prefab",
  WeatherChange = "Assets/Main/Prefabs/UI/LWSeason1/Effect/Eff_ui_S1_weather_icon_change.prefab",
  WeatherObjChange = "Assets/Main/Prefabs/UI/LWSeason1/Effect/Eff_ui_S1_weather_change_01.prefab",
  DiggingBrickOpen = "Assets/Main/SeasonRes/S3/Prefabs/Effect/Eff_ui_S3_block_broken.prefab",
  DiggingBrickHammer = "Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_feixu_chuizi_xiaoshi.prefab",
  DiggingRewardOpen = "Assets/_Art/Effect/prefab/ui/VFX_ui_zhoukabaoxiang_xiaoOpen.prefab",
  DiggingBlockFinished = "Assets/Main/SeasonRes/S3/Prefabs/Effect/Eff_ui_S3_reward_treasure.prefab",
  DiggingRewardGet = "Assets/Main/SeasonRes/S3/Prefabs/Effect/Eff_ui_S3_treasure_rewards_kuang_loop.prefab",
  DigTreasureReward = "Assets/Main/Prefabs/UI/DigTreasure/effect/Eff_ui_dig_treasure_rewards.prefab",
  DiggingBrickOpenS5 = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_S5_block_broken.prefab",
  GreeningFinishedEffect = "Assets/Main/SeasonRes/S3/Prefabs/Effect/Eff_ui_S3_GreenMain_explode.prefab",
  GoldTreeFinalEffect = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/GoldenTree/Eff_ui_s4_GoldenTree_full.prefab",
  GoldTreeFinalPrayEffect = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/GoldenTree/Eff_ui_S4_GoldenTree_saoguang.prefab",
  TacticalWeaponSkinNameGold = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_switch_gold.prefab",
  TacticalWeaponSkinNamePurple = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_switch_purple.prefab",
  DispatchTaskSweepLight = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_yingmi_shaoguang.prefab",
  DispatchTaskSweepLightNormal = "Assets/Main/Prefabs/UI/DispatchTask/Eff_ui_yingmi_shaoguang_nomal.prefab",
  TacticalEquipUpgradeBg = "Assets/_Art_LastWar/Effect/Prefab/VX/Tactical/Eff_ui_TacticalEquip_back.prefab",
  TacticalEquipUpgrade = "Assets/_Art_LastWar/Effect/Prefab/VX/Tactical/Eff_ui_TacticalEquip_upgrade.prefab",
  TacticalEquipAttributeSaoGuang = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_saoguang_new.prefab",
  SaraPopEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Shouchong/Eff_ui_shouchong_mianban_faguang_xia.prefab",
  SaraPopButtonEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Shouchong/Eff_ui_shouchong_shuaguang.prefab",
  HeroUnlockEffectBottom = "Assets/_Art_LastWar/Effect/Prefab/UI/Xinshou_newbies/UIHeroGuide/Eff_UIHeroGuideUnlockNew_loop.prefab",
  HeroUnlockEffectTop = "Assets/_Art_LastWar/Effect/Prefab/UI/Xinshou_newbies/UIHeroGuide/Eff_UIHeroGuideUnlockNew_qian.prefab",
  HeroTipsEffectBottom = "Assets/_Art_LastWar/Effect/Prefab/UI/Xinshou_newbies/UIHeroGuide/Eff_UIHeroGuideTipsNew_hero_shengji_hou.prefab",
  HeroTipsEffectTop = "Assets/_Art_LastWar/Effect/Prefab/UI/Xinshou_newbies/UIHeroGuide/Eff_UIHeroGuideTipsNew_hero_shengji_qian.prefab",
  DigTreasureBlockFinished = "Assets/Main/Prefabs/UI/DigTreasure/effect/Eff_ui_reward_treasure.prefab",
  DigTreasureBrickOpen = "Assets/Main/Prefabs/UI/DigTreasure/effect/Eff_ui_block_broken.prefab",
  DigTreasureRewardFlyFinish = "Assets/Main/Prefabs/UI/DigTreasure/effect/Eff_UIDigTreasure_guang.prefab",
  UIActSlotMachineSelectCard_box = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/Effect/UIActSlotMachineSelectCard_box.prefab",
  TCCardStarUpgradeVfx = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_star_upgrade_single.prefab",
  TCCardAttributeRefreshVfx = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_saoguang_new.prefab",
  TCCardIntactStarUpgradeShowVfx = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_common_item_star_full.prefab",
  TCCardOpenBoxCoreCardBgVfx_Purple = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_glow_purple.prefab",
  TCCardOpenBoxCoreCardBgVfx_Gold = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_glow_gold.prefab",
  TCCardOpenBoxCoreCardBgVfx_Green = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_glow_green.prefab",
  TCCardOpenBoxCoreCardBgVfx_Blue = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_glow_blue.prefab",
  TCCardOpenBoxNormalCardBgVfx_Purple = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_item_purple.prefab",
  TCCardOpenBoxNormalCardBgVfx_Gold = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_item_gold.prefab",
  TCCardOpenBoxNormalCardBgVfx_Green = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_item_green.prefab",
  TCCardOpenBoxNormalCardBgVfx_Blue = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_item_blue.prefab",
  TCCardOpenBoxCardFrontVfx = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_draw_glow_liz.prefab",
  TCCardOpenBoxCardTrailVfx_Blue = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_trail_blue.prefab",
  TCCardOpenBoxCardTrailVfx_Gold = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_trail_gold.prefab",
  TCCardOpenBoxCardTrailVfx_Green = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_trail_green.prefab",
  TCCardOpenBoxCardTrailVfx_Purple = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_trail_purple.prefab",
  SuppliesSuccess = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/UISuppliesSearch/Eff_UI_UISuppliesSearch_Victory.prefab",
  SuppliesFail = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/UISuppliesSearch/Eff_UI_UISuppliesSearch_Failed.prefab",
  BountyHunterSelectMonsterRefreshBossVfx = "Assets/Main/Prefabs/Effect/BountyHunter/Eff_ui_BountyHunter_saoguang.prefab",
  BountyHunterSelectMonsterRefreshEliteVfx = "Assets/Main/Prefabs/Effect/BountyHunter/Eff_ui_BountyHunter_saoguang_gold.prefab",
  EffectCaiDai = "Assets/Main/Prefabs/Season1/Eff_ui_BirthdayWishes_caidai.prefab",
  OffSeasonDiggingBrickOpen = "Assets/Main/Prefabs/UI/OffSeasonDigGame/Effect/Eff_ui_S4_Dig_broke_01.prefab",
  OffSeasonDiggingRewardGet = "Assets/Main/Prefabs/UI/OffSeasonDigGame/Effect/Eff_mat_S4_Dig_kuang_loop.prefab",
  WeekCardItemSaoGuang = "Assets/Main/Prefabs/WeekCard/Eff_ui_WeekCard_Itemsaoguang_01.prefab",
  GiftUnlockShowEffect = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/IconEffect/UIEffect/Eff_Gift_unlock.prefab",
  GiftActEffect = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_gift_Variant.prefab",
  ValentineNpcRewardCompleteBiling = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_specialFlag_1_Variant.prefab",
  ValentineNpcRewardCompleteFly = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_specialFlag_2_Variant.prefab",
  HeroAwakenStarItemSingleEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_star_single.prefab",
  HeroAwakenUnlockHint = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_hint.prefab",
  HeroAwakenUnlockSwitch = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_switch.prefab",
  HeroAwakenStarFull = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_star_full.prefab",
  HeroAwakenLineEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_saoguang.prefab",
  HeroAwakenLineEffectArabic = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_saoguang_arabic.prefab",
  HeroAwakenSpineEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_upgrade.prefab",
  HeroAwakenTitleEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_title1.prefab",
  HeroAwakenHeroCellBigEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_herohead.prefab",
  HeroAwakenSkirmishEnergyEffect = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenBattle/Eff_ui_heroawaken_energy_active.prefab",
  HeroAwakenSkillItemFrameVfx = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/Eff_ui_heroawaken_Skill_glow.prefab"
}
SceneAssets = {
  TacticalChipAir = "Assets/_Art_LastWar/Models/Cars/A_Hero_wurenji_xinpian/prefab/A_Hero_wurenji_xinpian_cam.prefab",
  TacticalWeaponScene = "Assets/_Art_LastWar/Models/Cars/A_Hero_wurenji_xinpian/prefab/A_Hero_wurenji_zhanshi.prefab",
  TCCardBox = "Assets/Main/Prefabs/TacticalCard/A_build_kapai_1_4.prefab"
}
SettingKeys = {
  HSR_DUMP_UNLOCK_PLOT = "Setting.HSR_DUMP_UNLOCK_PLOT",
  HSR_DUMP_HOWTOPLAY_PLOT = "Setting.HSR_DUMP_HOWTOPLAY_PLOT",
  COK_PURCHASE_KEY = "Setting.COK_PURCHASE_KEY",
  CATCH_ITEM_ID = "Setting.CATCH_ITEM_ID",
  COK_PURCHASE_SUCCESSED_KEY = "Setting.COK_PURCHASE_SUCCESSED_KEY",
  COK_PURCHASE_KEY = "Setting.COK_PURCHASE_KEY",
  EFFECT_MUSIC_ON = "isEffectMusicOn",
  BG_MUSIC_ON = "isBGMusicOn",
  ENV_SOUND_ON = "ENV_SOUND_ON",
  VIBRATE = "Setting.Vibrate",
  TOUCH_SP_FUN = "touch_sp_fun",
  TASK_TIPS_ON = "isTaskTipsOn",
  COORDINATE_ON_SHOW = "COORDINATE_ON_SHOW",
  SKAN_LAST_LOGOUT_TIME = "Setting.SKAN_LAST_LOGOUT_TIME",
  UUID = "Setting.UUID",
  GAME_UID = "Setting.GAME_UID",
  GM_FLAG = "Setting.GM_FLAG",
  SERVER_IP = "SERVER_IP",
  SERVER_PORT = "SERVER_PORT",
  SERVER_ZONE = "SERVER_ZONE",
  LOGIN_KEY = "Login.login_key",
  FUN_BUILD_MAIN_LEVEL = "FUN_BUILD_MAIN_LEVEL",
  AZ_ACCOUNTSTATUS = "Setting.AZ_ACCOUNTSTATUS",
  DEVICE_UID = "Setting.DEVICE_UID",
  DEVICE_ID = "DEVICE_ID",
  ACCOUNT_SENDMIL_AGAINTIME = "Setting.ACCOUNT_SENDMIL_AGAINTIME",
  HERO_LIST_SORT_TYPE = "HERO_LIST_SORT_TYPE",
  CHAT_SHOW_ROOM_LIST = "CHAT_SHOW_ROOM_LIST",
  POST_PROCESSING = "POST_PROCESSING",
  HEIGHT_FOG = "HEIGHT_FOG",
  SCENE_PARTICLES = "SCENE_PARTICLES",
  SCENE_SURFACE = "SCENE_SURFACE",
  SCENE_BUILD = "SCENE_BUILD",
  SCENE_DECORATIONS = "SCENE_DECORATIONS",
  SCENE_MONSTER = "SCENE_MONSTER",
  SCIENCE_TAB_UNLOCK = "SCIENCE_TAB_UNLOCK",
  SEARCH_MONSTER_LEVEL = "Setting.SEARCH_MONSTER_LEVEL",
  ACCOUNT_LIST_DEBUG = "ACCOUNT_LIST_DEBUG",
  ALLOW_TRACKING_CLICK = "ALLOW_TRACKING_CLICK",
  LAST_ALLOW_TRACKING = "LAST_ALLOW_TRACKING",
  MAIL_COLLECT_LAST_OPEN = "MAIL_COLLECT_LAST_OPEN",
  MAIL_MONSTER_REWARD_LAST_OPEN = "MAIL_MONSTER_REWARD_LAST_OPEN",
  USER_ALREADY_FARM = "USER_ALREADY_FARM",
  USER_ALREADY_FEED = "USER_ALREADY_FEED",
  SHOW_DEBUG_CHOOSE_SERVER = "SHOW_DEBUG_CHOOSE_SERVER",
  CANCEL_MARCH_ALERT_UUIDS = "CANCEL_MARCH_ALERT_UUIDS",
  MAIL_LAST_OPEN_TIME_BY_GROUP = "MAIL_LAST_OPEN_TIME_BY_GROUP_",
  SHOW_USE_DIAMOND_ALERT = "SHOW_USE_DIAMOND_ALERT",
  CITY_TROOP_POSITION = "CITY_TROOP_POSITION",
  GOTO_POSITION_X = "GOTO_POSITION_X",
  GOTO_POSITION_Y = "GOTO_POSITION_Y",
  ALLIANCE_WAR_OLD_DATA = "ALLIANCE_WAR_OLD_DATA",
  SCENE_GRAPHIC_LEVEL = "SCENE_GRAPHIC_LEVEL",
  SCENE_FPS_LEVEL = "SCENE_FPS_LEVEL",
  BUILD_NO_SHOW_UNLOCK = "BUILD_NO_SHOW_UNLOCK",
  ACTIVITY_VISITED_END_TIME = "ACTIVITY_VISITED_END_TIME",
  WORLDARROW_TYPE_FARM_NUM = "WORLD_ARROW_TYPE_FARM_NUM",
  WORLDARROW_TYPE_BUILD_NUM = "WORLD_ARROW_TYPE_BUILD_NUM",
  FIRST_INCITY_CHAT_SHOW = "FIRST_INCITY_CHAT_SHOW",
  ALLIANCE_ORDER_WELCOME = "ALLIANCE_ORDER_WELCOME",
  WORLDARROW_TYPE_NUM = "WORLDARROW_TYPE_NUM_",
  LOGIN_SECOND_DAYS = "LOGIN_SECOND_DAYS",
  HERO_STATION_VIEWED = "HERO_STATION_VIEWED",
  HERO_STATION_VAL_CACHE = "HERO_STATION_VAL_CACHE",
  REGISTER_TIME_REACH = "REGISTER_TIME_REACH",
  FIRST_PAY_BUY_CLICK = "FIRST_PAY_BUY_CLICK",
  CAMP_RECRUIT_BUBBLE_TIP = "CAMP_RECRUIT_BUBBLE_TIP",
  DigCameraHeightSnap = "DigCameraHeightSnap",
  LOGIN_POP_K = "LOGIN_POP_K",
  LOGIN_POP_LAST_TIME = "LOGIN_POP_LAST_TIME",
  KONBINI_BUY_DONT_SHOW = "KONBINI_BUY_DONT_SHOW",
  NEWBIE_FARM_BTN_CLICK = "NEWBIE_FARM_BTN_CLICK",
  FIRST_PAY_SHOWN = "FIRST_PAY_SHOWN",
  FIRST_ACCOUNTBIND_SHOW = "FIRST_ACCOUNTBIND_SHOW",
  CAREER_CHANGE_CHECK_TIME = "CAREER_CHANGE_CHECK_TIME",
  UNLOCK_FACTORY_PRELEVEL = "UNLOCK_FACTORY_PRELEVEL",
  PVE_EXP_HEROES = "PVE_EXP_HEROES",
  PVE_HEROES = "PVE_HEROES",
  PVE_HEROES_ADVENTURE = "PVE_HEROES_ADVENTURE",
  PVE_SPEED_OFFSET = "PVE_SPEED_OFFSET",
  ActLuckyRollJumpAnim = "Act_LuckyRoll_JumpAnim",
  FREE_SOLDIER_HIDE_WHEN_MAX = "FREE_SOLDIER_HIDE_WHEN_MAX",
  PVE_HERO_POWER_CONFIG_CACHE = "PVE_HERO_POWER_CONFIG_CACHE",
  PVE_HERO_POWER_CACHE = "PVE_HERO_POWER_CACHE",
  PVE_SPEED_SHOW_RED_DOT = "PVE_SPEED_SHOW_RED_DOT",
  CHAPTER_FIRST_SHOW = "CHAPTER_FIRST_SHOW",
  PVE_SPEED_SHOW_EFFECT = "PVE_SPEED_SHOW_EFFECT",
  KONBINI_TIP_TIME = "KONBINI_TIP_TIME",
  PVE_LV_POINT = "PVE_LV_POINT",
  NEWBIE_FARM_SHOW_HEAD = "NEWBIE_FARM_SHOW_HEAD",
  LEVEL_EXPLORE_SWEEP_HEROES = "LEVEL_EXPLORE_SWEEP_HEROES",
  LAST_WORLD_TREDN = "LAST_WORLD_TREDN",
  SEASON_FORCE_REWARD = "SEASON_FORCE_REWARD",
  POWER_SAVING_MODE = "POWER_SAVING_MODE",
  GAME_QUALITY_CONFIG_LEVEL_KEY = "GAME_QUALITY_CONFIG_KEY",
  GAME_QUALITY_CONFIG_POWER_SAVING_KEY = "POWER_SAVING_MODE",
  IS_RENAME_OPEN_IN_CHAT = "IS_RENAME_OPEN_IN_CHAT",
  IS_RENAME_OPEN_IN_PLAYER_INFO = "IS_RENAME_OPEN_IN_PLAYER_INFO",
  NEWEST_STR_COM_STAGE_ID = "NEWEST_STR_COM_STAGE_ID",
  ACT_GIFT_BOX_JUMP_ANIM = "ACT_GIFT_BOX_JUMP_ANIM",
  TOWER_UP_AUTO_NEXT_STAGE = "TOWER_UP_AUTO_NEXT_STAGE",
  DEFAULT_ACTIVITY_TIP_PRE = "DEFAULT_ACTIVITY_TIP_PRE",
  LAST_TIME_SHOW_VIP_SHOP_REFRESH = "LAST_TIME_SHOW_VIP_SHOP_REFRESH",
  VIP_RADAR_DISCOUNT_STATE = "VIP_RADAR_DISCOUNT_STATE",
  LASTTIME_ARENA3V3_OPEN = "LASTTIME_ARENA3V3_OPEN",
  ACT_THANKS_GIVING_JUMP_ANIM = "ACT_THANKS_GIVING_JUMP_ANIM",
  LASTTIME_REFRESH_STORE_NEW = "LASTTIME_REFRESH_STORE_NEW",
  TRAIL_TOWER_TANK_DIFFICULTY_GROUP_CHANGE = "TRAIL_TOWER_TANK_DIFFICULTY_GROUP_CHANGE",
  TRAIL_TOWER_AIRPLANE_DIFFICULTY_GROUP_CHANGE = "TRAIL_TOWER_AIRPLANE_DIFFICULTY_GROUP_CHANGE",
  TRAIL_TOWER_MISSILE_DIFFICULTY_GROUP_CHANGE = "TRAIL_TOWER_MISSILE_DIFFICULTY_GROUP_CHANGE",
  Last_LOGIN_TIME = "Last_LOGIN_TIME",
  LAST_MONOPOLY_FIRSTPAY = "LAST_MONOPOLY_FIRSTPAY",
  GM_ONLY_SHOW_KEY_FLAG = "GM_ONLY_SHOW_KEY_FLAG",
  SpecialMonsterPlot = "special_monster_plot",
  BATTLE_FIELD_SET_SHOW_LOCAL_TIME = "BATTLE_FIELD_SET_SHOW_LOCAL_TIME",
  DESERT_BATTLE_MASK_ALARM_UID = "DESERT_BATTLE_MASK_ALARM_UID",
  DESERT_BATTLE_REPLACE_LOCAL_TIME = "DESERT_BATTLE_REPLACE_LOCAL_TIME",
  TRUCK_WANTED_KEY = "truck_wanted_key",
  TW_SKILLCHIP_UNLOCKTIP_ONCESHOW = "TW_SKILLCHIP_UNLOCKTIP_ONCESHOW",
  ACT_CITYSKIN_EXCHANGE_REDPOINT = "ACT_CITYSKIN_EXCHANGE_REDPOINT",
  MONOPOLY_V2_GUIDE_SHOWN = "MONOPOLY_V2_GUIDE_SHOWN",
  DISPATCH_TREASURE_SKIPANIM = "DISPATCH_TREASURE_SKIPANIM",
  DISPATCH_TREASURE_SHOWTIME = "DISPATCH_TREASURE_SHOWTIME",
  DISPATCH_TREASURE_PLOT = "DISPATCH_TREASURE_PLOT",
  PARKOUR_FIRST_GUIDE_SHOW = "PARKOUR_FIRST_GUIDE_SHOW",
  HERO_UNIQUE_WEAPON_OPEN = "HERO_UNIQUE_WEAPON_OPEN_%s",
  HERO_AWAKEN_OPEN = "HERO_AWAKEN_OPEN_%s",
  SEASON_SYNTHESIS_JUMP_ANIM = "SEASON_SYNTHESIS_JUMP_ANIM",
  QUESTIONNAIRE_RED_DOT = "QUESTIONNAIRE_RED_DOT",
  CHAMPION_DUEL_SIGN_RED = "CHAMPION_DUEL_SIGN_RED",
  CHAMPION_DUEL_SYNC_TEAM = "CHAMPION_DUEL_SYNC_TEAM",
  CHAMPION_DUEL_QUERY_TEAM = "CHAMPION_DUEL_QUERY_TEAM",
  CHAMPION_DUEL_GROUP_CHECK = "CHAMPION_DUEL_GROUP_CHECK",
  CHAMPION_DUEL_LOG_POP_TIME = "CHAMPION_DUEL_LOG_POP_TIME",
  CHAMPION_DUEL_LOG_POP_RED = "CHAMPION_DUEL_LOG_POP_RED",
  CHAMPION_DUEL_GUESS_TIME = "CHAMPION_DUEL_GUESS_RED_TIME",
  CHAMPION_DUEL_STAGE_CHANGE = "CHAMPION_DUEL_STAGE_CHANGE",
  GOVERMENT_OWN_POSITIONID = "GOVERMENT_OWN_POSITIONID",
  CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET = "CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET",
  ARABIC_AUTO_MIRROR_SWITCH = "ARABIC_AUTO_MIRROR_SWITCH",
  GHOSTRECON_BUBBLE_POSINFO = "GHOSTRECON_BUBBLE_POSINFO",
  GHOSTRECON_BUBBLE_RANDOM_INDEX = "GHOSTRECON_BUBBLE_RANDOM_INDEX",
  PVPALERT = "PVPALERT",
  GETDUELSCORE_PERSON = "GETDUELSCORE_PERSON",
  RECRUIT_CARD_REWARD_GET = "RECRUIT_CARD_REWARD_GET",
  GETDUELSCORE_ALLY = "GETDUELSCORE_ALLY",
  HOSPITAL_CURE_SOLDIER_TIME = "HOSPITAL_CURE_SOLDIER_TIME",
  BUILDING_FINISHED_REMIND = "BUILDING_FINISHED_REMIND",
  OFFICIAL_APPLY_TIME_SHOW_MODE = "OFFICIAL_APPLY_TIME_SHOW_MODE",
  HOSPITAL_CURE_RULES_BUBBLE_FIRST_REMIND = "HOSPITAL_CURE_RULES_BUBBLE_FIRST_REMIND",
  TRIGGER_GHOSTRECON_GUIDE = "TRIGGER_GHOSTRECON_GUIDE",
  DEBUG_CHOOSE_URL_GROUP = "DEBUG_CHOOSE_URL_GROUP_NEW",
  IS_CHANGE_DEBUG_CHOOSE_URL_GROUP = "IS_CHANGE_DEBUG_CHOOSE_URL_GROUP",
  BAG_RESOURCE_OVERVIEW_FIRST_REMIND = "BAG_RESOURCE_OVERVIEW_FIRST_REMIND",
  ALLY_DRILL_LEVEL_TIP = "ALLY_DRILL_LEVEL_TIP",
  SHAKE_COLLECT_RES = "SHAKE_COLLECT_RES",
  ONE_KEY_COLLECT_RES = "ONE_KEY_COLLECT_RES",
  SHAKE_COLLECT_TIPS_SHOWN = "SHAKE_COLLECT_TIPS_SHOWN",
  SHOW_OFFICIAL_EFFECT = "SHOW_OFFICIAL_EFFECT",
  DISPATCH_NEW_GUIDE_INDEX = "DISPATCH_NEW_GUIDE_INDEX",
  RejectAllianceGatherMemberPin = "RejectAllianceGatherMemberPin",
  ActivityAlarmClockCloseTips = "ActivityAlarmClockCloseTips",
  PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL = "PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL",
  USER_REG_TIME = "USER_REG_TIME",
  FIRST_GET_WORKER_HOUSE = "FIRST_GET_WORKER_HOUSE",
  FIRST_GET_TRAIL_TOWER = "FIRST_GET_TRAIL_TOWER",
  NUCLEAR_MONSTER_TIP_KEY = "NUCLEAR_MONSTER_TIP_KEY",
  NUCLEAR_NON_FINISH_TIP_KEY = "NUCLEAR_NON_FINISH_TIP_KEY",
  POP_NEWPEAKARENA_DIALOG = "TRIGGER_NEWPEAKARENA_POP",
  POP_NEWGALEARENA_DIALOG = "POP_NEWGALEARENA_DIALOG",
  NEWPEAKARENA_UP_STARTTIME = "NEWPEAKARENA_UP_STARTTIME",
  NEWGALEARENA_UP_STARTTIME = "NEWGALEARENA_UP_STARTTIME",
  STAGE_FEATURE_FAIL_PREFIX = "STAGE_FEATURE_FAIL_PREFIX_",
  STAGE_FEATURE_SHARE_TIME = "STAGE_FEATURE_SHARE_TIME",
  NEW_TRAIN_INFO_SHOW = "NEW_TRAIN_INFO_SHOW",
  ALLY_DRILL_LAST_ATTEND_TIME = "ALLY_DRILL_LAST_ATTEND_TIME",
  LASTTIME_POPUP_GIFTPACK = "LASTTIME_POPUP_GIFTPACK_%s",
  SEASON_UNPACK_RESOURCE_DOWNLOAD = "SEASON_UNPACK_RESOURCE_DOWNLOAD",
  POPUP_GIFTPACK_TIMES = "POPUP_GIFTPACK_TIMES_%s",
  SEASON_UPGRADE_LOG_DATE = "SEASON_UPGRADE_LOG_DATE",
  ZONE_MOBILIZATION_AUTO_FILL_PROGRESS_PLOT = "ZONE_MOBILIZATION_AUTO_FILL_PROGRESS_PLOT",
  TRIGGER_DOMINATORUP_GUIDE = "TRIGGER_DOMINATORUP_GUIDE",
  Show_DecorationShop_NEW = "Show_DecorationShop_NEW",
  DecorationShopDirectPurchase_GIFT_NEW = "DecorationShopDirectPurchase_GIFT_NEW",
  NO_METEORITE_DROP_PROMPT = "NO_METEORITE_DROP_PROMPT",
  NO_METEORITE_DROP_PROMPT2 = "NO_METEORITE_DROP_PROMPT2",
  METEORITE_AWARD_ITEM_GUIDE = "METEORITE_AWARD_ITEM_GUIDE",
  ZONE_MOBILIZATION_BOSS_LEVEL_DESC = "ZONE_MOBILIZATION_BOSS_LEVEL_DESC",
  VALENTINE_RANK_CARD_SHARE_TIME = "VALENTINE_RANK_CARD_SHARE_TIME",
  ALLY_DRILL_NEW_BOSS = "ALLY_DRILL_NEW_BOSS",
  DecorationPreview_ShowSeasonNode = "DecorationPreview_ShowSeasonNode",
  EFFECT_VOLUME = "EFFECT_VOLUME",
  MUSIC_VOLUME = "MUSIC_VOLUME",
  ENV_SOUND_VOLUME = "ENV_SOUND_VOLUME",
  LOADING_DEFAULT_BGM = "LOADING_DEFAULT_BGM",
  AL_STAR_ENTER_CEREMONY = "AL_STAR_ENTER_CEREMONY",
  AL_STAR_EMOJI_GUIDE_EDITION = "AL_STAR_EMOJI_GUIDE_EDITION",
  FULL_SCREEN_ON = "FULL_SCREEN_ON",
  BANQUET_COMMON1_AUTO_ATTACK_FLAG = "BANQUET_AUTO_ATTACK_FLAG",
  BANQUET_COMMON1_AUTO_ATTACK_FLAG = "BANQUET_AUTO_ATTACK_FLAG",
  EASTER_EGG_LIKE_DESCEND_ORDER = "EASTER_EGG_LIKE_DESCEND_ORDER",
  FULL_SCREEN_ON = "FULL_SCREEN_ON",
  SALA_HERO_POP_TIMES = "SALA_HERO_POP_TIMES_",
  SALA_HERO_POP_LASTTIME = "SALA_HERO_POP_LASTTIME_",
  SALA_HERO_BUuid = "SALA_HERO_BUUID_",
  HERO_GUIDE_POP = "HERO_GUIDE_POP",
  HERO_GUIDE_UNLOCK_POP = "HERO_GUIDE_UNLOCK_POP",
  AL_CHALLENGE_BOSS_BOX_SHARE = "AL_CHALLENGE_BOSS_BOX_SHARE",
  AL_CHALLENGE_NOT_FIRST_OPEN_PANEL = "AL_CHALLENGE_NOT_FIRST_OPEN_PANEL",
  SHAKE_COLLECT_TRUCK_RES = "SHAKE_COLLECT_TRUCK_RES",
  WORLD_SCOUT_RED_DOT = "WORLD_SCOUT_RED_DOT",
  SEASON_BANK_RED_DOT = "SEASON_BANK_RED_DOT",
  WORLD_BOSS_SHOW_SVR_TIME = "WORLD_BOSS_SHOW_SVR_TIME",
  PERSONAL_ARMS_SHOW_SVR_TIME = "PERSONAL_ARMS_SHOW_SVR_TIME",
  TACTICAL_EQUIP_SORT_TYPE = "TACTICAL_EQUIP_SORT_TYPE",
  HAS_OPENED_RADAR = "HAS_OPENED_RADAR",
  HAS_ATTACKMONSTER_MARCH_HELPER = "HAS_ATTACKMONSTER_HELPER",
  HAS_COLLECT_MARCH_HELPER = "HAS_COLLECT_HELPER",
  SHOW_MARCH_SECOND_BTN_TIPS = "SHOW_MARCH_SECOND_BTN_TIPS",
  MONSTER_INVASION_LAST_PLAN_TIME = "MONSTER_INVASION_LAST_PLAN_TIME",
  KIROV_BOSS_LAST_PLAN_TIME = "KIROV_BOSS_LAST_PLAN_TIME",
  BUILDING_DIG_TREASURE_GUIDE_SHOWN = "BUILDING_DIG_TREASURE_GUIDE_SHOWN",
  DETECT_DIG_TREASURE_GUIDE_SHOWN = "DETECT_DIG_TREASURE_GUIDE_SHOWN",
  SEASON_GOLD_TREE_THIRD_SHOW_BUBBLE = "SEASON_GOLD_TREE_THIRD_SHOW_BUBBLE",
  CHAMPION_GUIDE_CONDITION = "CHAMPION_GUIDE_CONDITION",
  FIREWORK_DEFAULT_ITEM_ID = "FIREWORK_DEFAULT_ITEM_ID",
  FIREWORK_GIFT_CHAT_TIP = "FIREWORK_GIFT_CHAT_TIP",
  FIREWORK_GIFT_UUID_TIME_GOT = "FIREWORK_GIFT_UUID_TIME_GOT",
  FIREWORK_LAST_POST_TIME = "FIREWORK_LAST_POST_TIME",
  AD_GACHA_TIP_BUBBLE_SHOWN = "AD_GACHA_TIP_BUBBLE_SHOWN",
  BOUNTY_HUNTER_ONLY_SELECT_ORANGE = "BOUNTY_HUNTER_ONLY_SELECT_ORANGE",
  BOUNTY_HUNTER_AUTO_ATTACK = "BOUNTY_HUNTER_AUTO_ATTACK",
  DSB_SET_SHOW_LOCAL_TIME = "DSB_SET_SHOW_LOCAL_TIME",
  DSB_IS_SHOWN_POP_UP_WINDOW = "DSB_IS_SHOWN_POP_UP_WINDOW",
  DSB_IS_SHOWN_ACT_TOP_ITEM_FINGER = "DSB_IS_SHOWN_ACT_TOP_ITEM_FINGER",
  DSB_IS_SHOWN_WEEK_END_POP_UP_WINDOW = "DSB_IS_SHOWN_WEEK_END_POP_UP_WINDOW",
  DSB_IS_OPEN_ENTRANCE_IN_TEAM_SIGN_UP = "DSB_IS_OPEN_ENTRANCE_IN_TEAM_SIGN_UP",
  DecorationPreview_ShowSeasonNode = "DecorationPreview_ShowSeasonNode",
  SURFING_ON_INVITE_SHARE_CD = "SURFING_ON_INVITE_SHARE_CD",
  SURFING_ON_FIRST_ENTER_GAME = "SURFING_ON_FIRST_ENTER_GAME",
  BATTLE_CENTER_BUILDING_GUIDE = "BATTLE_CENTER_BUILDING_GUIDE",
  SURFING_ON_FIRST_ENTER_GAME_NEW = "SURFING_ON_FIRST_ENTER_GAME_NEW",
  SURFING_BATTLE_BUFF_TIPS = "SURFING_BATTLE_BUFF_TIPS",
  OFFSEASON_RECAPTURE_BUBBLE_TIP_SHOWN = "OFFSEASON_RECAPTURE_BUBBLE_TIP_SHOWN",
  SURFING_BATTLE_INVITE_TIPS = "SURFING_BATTLE_INVITE_TIPS",
  AttackCityS0_Clue_Personal_Effect = "AttackCityS0_Clue_Personal_Effect",
  T11GameEventPlot = "T11_Game_Event_Plot",
  USE_SEASON_BGM = "USE_SEASON_BGM",
  FLOWER_TRAIN_RANK_CARD_SHARE_TIME = "FLOWER_TRAIN_RANK_CARD_SHARE_TIME",
  FLOWER_TRAIN_POSITION_SHARE_TIME = "FLOWER_TRAIN_POSITION_SHARE_TIME",
  BACK_GESTURE = "BACK_GESTURE",
  IS_SHOW_PLAYER_HEADS_IN_CITY_DETAIL = "IS_SHOW_PLAYER_HEADS_IN_CITY_DETAIL",
  ALLIANCE_FEATURE_HOW_TO_PLAY = "ALLIANCE_FEATURE_HOW_TO_PLAY",
  TRUCK_INSURANCE_HOW_TO_PLAY = "TRUCK_INSURANCE_HOW_TO_PLAY",
  LATEST_OPEN_HSR_MAIN_UI = "LATEST_OPEN_HSR_MAIN_UI",
  HSR_GET_ON_SUCCESS = "HSR_GET_ON_SUCCESS",
  GHOST_PARKOUR_ON_FIRST_ENTER_GAME = "GHOST_PARKOUR_ON_FIRST_ENTER_GAME",
  GHOST_PARKOUR_ON_FIRST_ENTER_RANK_PAGE = "GHOST_PARKOUR_ON_FIRST_ENTER_RANK_PAGE",
  GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND = "GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND",
  GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME = "GHOST_PARKOUR_ON_FIRST_ENTER_ACT_ROUND_START_TIME",
  GHOST_PARKOUR_ON_FIRST_CHALLENGE_BTN = "GHOST_PARKOUR_ON_FIRST_CHALLENGE_BTN",
  BOUNTY_SHOP_DAILY_RED = "BOUNTY_SHOP_DAILY_RED",
  SHOP_AUTO_SELECT_MAX_COUNT = "SHOP_AUTO_SELECT_MAX_COUNT",
  DISPATCH_TASK_MARK_LIST_PLOT = "DISPATCH_TASK_MARK_LIST_PLOT",
  ARMED_UPGRADE_SHOW_BANNER_POP_LAST_TIME = "ArmedUpgradeShowBannerPopLastTime",
  ARMED_UPGRADE_PLAYED_TIMELINE = "ArmedUpgradePlayedTimeline",
  RADAR_QUICK_DO_PLOT = "RADAR_QUICK_DO_PLOT",
  TRAIN_ROB_QUICK_PLOT = "TRAIN_ROB_QUICK_PLOT",
  S6_MILITARY_TREND_POPUP_SHOWN = "S6_MILITARY_TREND_POPUP_SHOWN",
  S6_MILITARY_REWARD_POPUP_SHOWN = "S6_MILITARY_REWARD_POPUP_SHOWN",
  ALLY_DUEL_BTN_TOTAL_LAST_RED = "ALLY_DUEL_BTN_TOTAL_LAST_RED",
  ALLY_DUEL_GACHA_BTN_LAST_RED = "ALLY_DUEL_GACHA_BTN_LAST_RED",
  TRUCK_SUPER_DEPARTURE_SELECT_REINDEER_CART = "TruckSuperDepartureSelectReindeerCart",
  TRUCK_SUPER_DEPARTURE_SELECT_REFRESH_TRUCK_DATA = "TruckSuperDepartureSelectRefreshTruckData",
  POWER_UP_BANNER_DETAIL = "POWER_UP_BANNER_DETAIL",
  LANDLORD_CITY_DETAIL_FIRST_SWITCH = "LANDLORD_CITY_DETAIL_FIRST_SWITCH",
  S6_MILITARY_ALTAR_ACTIVITY_SHOW = "S6_MILITARY_ALTAR_ACTIVITY_SHOW",
  S6_FISH_USE = "S6_FISH_USE",
  S6_MILITARY_ELITE_REWARD_DAILY_SHOW = "S6_MILITARY_ELITE_REWARD_DAILY_SHOW",
  S6_MILITARY_ELITE_DEFAULT_DROPDOWN = "S6_MILITARY_ELITE_DEFAULT_DROPDOWN",
  ALLIANCE_BOSS_S0_LAST_ATTEND_TIME = "ALLIANCE_BOSS_S0_LAST_ATTEND_TIME",
  RECHARGE_RED_DOT_LOCAL_SAVE = "RECHARGE_RED_DOT_LOCAL_SAVE_"
}
SoundGround = {
  Music = "Music",
  Sound = "Sound",
  AMBSound = "AMBSound",
  Effect = "Effect",
  Dub = "Dub",
  Hero = "Hero"
}
SoundAssetId = {
  Music_Effect_battle_start_btn = 10002,
  Music_Effect_opening_animation_1 = 10005,
  Music_Effect_opening_animation_2 = 10006,
  Music_Effect_opening_animation_3 = 10007,
  Music_Effect_bluesoldier_running = 10008,
  Music_Effect_zombie_collision = 10011,
  Music_Effect_go_into_battle = 10012,
  Music_Effect_quit_the_battle = 10013,
  Music_Effect_battle_start = 10014,
  Music_Effect_goal_show = 10015,
  Music_Effect_skill_release = 10016,
  Music_Effect_speed_up = 10017,
  Music_Effect_speed_up_bgm = 10018,
  Music_Effect_zombie_tide_warning = 10020,
  Music_Effect_zombies_cacophony = 10021,
  Music_Effect_goal_finish = 10022,
  Music_Effect_multiplication = 10025,
  Music_Effect_lamethrower_fire = 10026,
  Music_Effect_stage_win_bgm = 10027,
  Music_Effect_Soldier_filling = 10028,
  Music_Effect_army_setout = 10029,
  Music_Effect_goal_achieved = 10032,
  Music_Effect_boss_warning = 10033,
  Music_Effect_boss_born_voice = 10034,
  Music_Effect_boss_born = 10035,
  Music_Effect_battle_start_2 = 10036,
  Music_Effect_battle_end = 10037,
  Music_Effect_slip = 10045,
  Music_Effect_countdown_start = 10046,
  Music_Effect_countdown_end = 10047,
  Music_Effect_sound_countmaster_pace1 = 10048,
  Music_Effect_sound_countmaster_pace2 = 10049,
  Music_Effect_bus_run = 10050,
  Music_Effect_bus_hit = 10051,
  Music_Effect_soldier_shout_01 = 10052,
  Music_Effect_soldier_shout_02 = 10053,
  Music_Effect_soldier_shout_03 = 10054,
  Music_Effect_run_03 = 10055,
  Music_Effect_fireworks = 10056,
  Music_Effect_multiply_door_win = 10057,
  Music_Effect_multiply_door_win_bgm = 10058,
  Music_Effect_torch_relay_plane = 10059,
  SFX_Battle_Surfing_Whistle = 11004,
  SFX_Battle_Surfing_Coin = 11005,
  SFX_Battle_Surfing_Item = 11007,
  SFX_Battle_Surfing_Impact = 11008,
  SFX_Battle_Surfing_Death = 11009,
  SFX_Battle_Surfing_Run_LR = 11010,
  SFX_Battle_Surfing_Run_Dash = 11011,
  SFX_Battle_Surfing_Jetpack_Loop = 11012,
  SFX_Battle_Surfing_Ftsp_Loop = 11013,
  SFX_Battle_Surfing_Landing = 11015,
  SFX_Battle_Surfing_Run_Down = 11017,
  SFX_Battle_Surfing_Shield_Break = 11018,
  SFX_Battle_Surfing_Run_JumpDown = 11019,
  SFX_Battle_Surfing_Truck = 11021,
  strom_battle_field_music_better = 30002,
  winter_battle_field_music_better = 30004,
  s2_ares_missile_ignites = 40001,
  s2_ares_missile_explosion = 40002,
  s2_alliance_furnace_ignition = 40007,
  train_arrive = 50001,
  platform_soilder_walk = 50002,
  battle_change_position = 50003,
  battle_vs = 50004,
  battle_team_fight = 50005,
  battle_team_victory = 50006,
  battle_team_random = 50007,
  leader_selected = 50008,
  leader_troops_down = 50009,
  train_refresh_reward = 50010,
  train_turn_gold1 = 50011,
  train_turn_gold2 = 50012,
  train_leave = 50013,
  buy_golden_train = 50014,
  hummer_run_1 = 50015,
  hummer_run_2 = 50016,
  hummer_run_3 = 50017,
  hummer_run_4 = 50018,
  hummer_run_5 = 50019,
  speed_up = 50020,
  speed_up_bgm = 50021,
  hummer_drone_warning = 50022,
  hummer_piaoyi = 50024,
  zombie_hit = 50025,
  Kirov_reporting = 50028,
  feiting_build_bron = 50029,
  feiting_down = 50030,
  feiting_up = 50031,
  feiting_transfer = 50032,
  feiting_attack_up = 50033,
  feiting_attack_down = 50034,
  feiting_break = 50035,
  feiting_build_die = 50036,
  feiting_gun = 50037,
  feiting_building = 50038,
  feiting_die = 50039,
  SFX_UI_Baoxiang_Spark_Fly = 50109,
  SFX_UI_Baoxiang_Spark_Hit = 50110,
  Music_valentine_bgm = 60001,
  Music_Effect_Close = 61003,
  Music_Effect_Hero_Upgrade3 = 61007,
  Music_Effect_Finish = 61009,
  Music_Effect_Ue_GetReward = 61010,
  Music_Effect_Radar = 61015,
  Music_Effect_Build_Unclock = 61017,
  Music_Effect_Ue_BuildList = 61018,
  Music_Effect_Build_SelectCard = 61020,
  Music_Effect_Ue_GetPayReward = 61021,
  Music_Effect_Common_SelectGoods = 61059,
  Music_Effect_Plant1 = 61091,
  Music_Effect_Plant2 = 61092,
  Music_Effect_Plant3 = 61093,
  Music_Effect_Plant4 = 61094,
  Music_Effect_Product1_1 = 61095,
  Music_Effect_Product1_2 = 61096,
  Music_Effect_Product1_3 = 61097,
  Music_Effect_Product1_4 = 61098,
  Music_Effect_Bill = 62025,
  Music_Effect_Alliance = 62026,
  Music_Effect_Click_Add_Cattle = 62032,
  Music_Effect_Click_Add_Ostrich = 62033,
  Music_Effect_Click_Apartment = 62036,
  Music_Effect_Click_CattleFarm = 62042,
  Music_Effect_Click_Enemy1 = 62045,
  Music_Effect_Click_Factory = 62046,
  Music_Effect_Click_GroundGoods = 62050,
  Music_Effect_Click_Gulu = 62051,
  Music_Effect_Click_OstrichFarm = 62057,
  Music_Effect_Coin = 62064,
  Music_Effect_Collect_Crystal = 62065,
  Music_Effect_Common_ChangeNum = 62066,
  Music_Effect_Common_GetReward = 62068,
  Music_Effect_Common_SelectTab = 62069,
  Music_Effect_Earth_Order_Box = 62077,
  Music_Effect_Earth_Order_Robot = 62078,
  Music_Effect_Electric = 62079,
  Music_Effect_Farm_Ostrich1 = 62084,
  Music_Effect_Feed = 62085,
  Music_Effect_Ground = 62098,
  Music_Effect_Gas = 62086,
  Music_Effect_Gulu_Get_Reward = 62109,
  Music_Effect_Gulu_Order_Button = 62110,
  Music_Effect_Hero_Upgrade1 = 62115,
  Music_Effect_Plane_Arrive = 62126,
  Music_Effect_Plane_Leave = 62127,
  Music_Effect_Plant = 62128,
  Music_Effect_Produce_Box = 62131,
  Music_Effect_Produce_Put = 62132,
  Music_Effect_Produce_Transport = 62133,
  Music_Effect_Produce_Work = 62134,
  Music_Effect_Product1 = 62135,
  Music_Effect_Product2 = 62136,
  Music_Effect_Product3 = 62137,
  Music_Effect_Rocket = 62153,
  Music_Effect_Science_Finish = 62155,
  Music_Effect_Science_Start = 62156,
  Music_Effect_Start_March = 62165,
  Music_Effect_Water = 62170,
  Music_Effect_Train_Soldiers = 62172,
  Music_Effect_Train_Tank = 62173,
  Music_Effect_Train_Aircraft = 62174,
  Music_Effect_Train_Start1 = 62175,
  Music_Effect_Ue_Unclock = 62176,
  Music_Troop_Movement = 62177,
  Music_Effect_Ue_OneGood = 62178,
  Music_Effect_Ue_CombatPowerUp = 62179,
  Effect_Recruit_Card_Befall = 62087,
  Effect_Recruit_Card_Flip1 = 61041,
  Effect_Recruit_Card_Flip2 = 62088,
  Effect_Recruit_Card_Click = 61071,
  Music_Effect_Click_Building = 61040,
  Music_Effect_Common_FailClick = 62067,
  Music_Effect_Speed_Button = 62163,
  Music_Effect_Speed_Button2 = 62164,
  Music_Effect_Hit_Base = 62117,
  Music_Effect_Click_Formula = 62048,
  Music_Effect_Click_FoodFactory = 62047,
  Music_Effect_Click_Bakery = 62038,
  Effect_Click_TuckerStore = 62063,
  Music_Effect_Click_Bar = 62039,
  Music_Effect_Click_JewelryStore = 62054,
  Music_Effect_Put_Formula = 62138,
  Music_Effect_Click_Ground2 = 62049,
  Music_Effect_Click_Radar = 62060,
  Music_Effect_Click_Main_City = 61013,
  Music_Effect_Click_Hero_Build = 62052,
  Music_Effect_Click_INFANTRY_BARRACK = 62053,
  Music_Effect_Click_AIRCRAFT_BARRACK = 62034,
  Music_Effect_Click_BARRACKS = 62040,
  Music_Effect_Click_DRONE = 62044,
  Music_Effect_Click_LIBRARY = 62056,
  Music_Effect_Click_KONBINI = 62055,
  Music_Effect_Click_ALLIANCE_CENTER = 62035,
  Music_Effect_Click_POLICE_STATION = 62059,
  Music_Effect_Click_CAR_BARRACK = 62041,
  Music_Effect_Click_TRAINFIELD = 62062,
  Music_Effect_Click_COLD_STORAGE = 62043,
  Music_Effect_Click_SCIENE = 62061,
  Music_Effect_Repair = 62151,
  Music_Effect_Hero_Skill = 62113,
  Effect_Exp_FarmSystem = 62082,
  Music_Effect_Golloes_Trader = 62095,
  Music_Effect_Golloes_Warrior = 62096,
  Music_Effect_Golloes_Explorer = 62090,
  Music_Effect_Golloes_Worker = 62097,
  Music_Effect_Golloes_Build = 62089,
  Music_Effect_PlantFlag = 62129,
  Music_Effect_Dome_Scan = 62076,
  Music_Effect_show_to_plant = 62180,
  Music_Effect_show_to_water = 62185,
  Music_Effect_guide_plane_arrive = 62105,
  Music_Effect_guide_air_drop = 62099,
  Music_Effect_guide_robot = 62106,
  Music_Effect_guide_migrate = 62102,
  Music_Effect_guide_ostrich = 62103,
  Music_Effect_guide_cattle = 62100,
  Music_Effect_guide_pick_weapon = 62104,
  Music_Effect_enter_pve = 62081,
  Music_Effect_pve_finish = 62144,
  Music_Effect_self_attack_low = 62159,
  Music_Effect_pve_box_appear = 62139,
  Music_Effect_pve_box_get = 62140,
  Music_Effect_guide_second_migrate = 62107,
  Music_Effect_pve_debuff = 62143,
  Music_Effect_pve_buff = 62143,
  Music_Effect_pve_gunAttack = 62145,
  Music_Effect_pve_skill = 62149,
  Music_Effect_pve_hero_weak = 62146,
  Music_Effect_pve_lost = 62147,
  Music_Effect_pve_call_reward = 62142,
  Music_Effect_pve_reward_land_lock = 62148,
  Music_Effect_hero_box_open = 62111,
  Music_Effect_Task_Show = 62181,
  Music_Effect_Guide_Get_New_Hero = 62101,
  Music_Effect_Pirate_Fight_Bob = 62124,
  Music_Effect_guide_show_build = 62108,
  Music_Effect_pve_hero_vortex1 = 61099,
  Music_Effect_pve_hero_vortex2 = 61100,
  Music_Effect_Pirate_Show = 62125,
  Music_Effect_show_pve_effect = 62161,
  Music_Effect_select_pve_effect = 62157,
  Music_Effect_trigger_finish = 62182,
  Music_Effect_Golloes_Sort_Card = 62094,
  Music_Effect_Golloes_Show_All_Card = 62092,
  Music_Effect_Golloes_Show_One_Card = 62093,
  Music_Effect_Golloes_Refresh_Card = 62091,
  Music_Effect_Lucky_Roll_Click = 62118,
  Music_Effect_Lucky_Select = 62119,
  Music_Effect_Click_Ground = 61014,
  Music_Effect_Task_Done_Btn = 61004,
  Music_Effect_Scout_Btn = 62017,
  Music_Effect_HERO_RANK_CHANGE = 61026,
  Music_Effect_HERO_Upgrade = 61006,
  Music_Effect_HERO_EquipUpgrade = 61037,
  Music_Effect_Trumpet1 = 61142,
  Music_Effect_Trumpet2 = 61143,
  Effect_Golloes_Sort_Card = 62094,
  Effect_Golloes_Show_One_Card = 62093,
  Effect_GetHero_card1 = 61041,
  Effect_GetHero_card2 = 62088,
  Music_Popup_Appears = 62184,
  Music_Invasion_Aisilla_Born = 62002,
  Music_Invasion_Aisilla_Dead = 62003,
  Music_Invasion_Aisilla_Skill_Down = 62004,
  CollectSoldier = 61022,
  StartCollectSoldier = 61030,
  StartResearch = 62016,
  MainBuildingUpLevel = 61026,
  CitySoldierClick = 62007,
  HospitalCollectSoldier = 61022,
  TrainingSoldiersView = 61023,
  TrainingClickSoldier = 62018,
  SoldierClickEffect = 62191,
  SoldierUpLevelClick = 62192,
  DiamondsEmerges = 61058,
  DiamondsFlies = 61011,
  DialogueClaimedBtn = 62023,
  MoonCardUI = 61033,
  PowerIncrease = 61005,
  DeployBtn = 61034,
  SwitchScene01 = 61036,
  RadarMissionsBtn = 61019,
  RadarUI = 61039,
  RadarScan = 61012,
  RecruitmentUI = 61031,
  RecruitOnceCard = 61032,
  RecruitTenTimes = 61038,
  Recruit_Flip = 61016,
  Technology_UI = 62193,
  Tech_Lvl2_UI = 62194,
  Tech_Lvl3_UI = 62195,
  ResearchBtn = 62196,
  PAC_Factory_Interface = 62197,
  Select_Accessories = 62198,
  Crafting = 62021,
  Craft_btn = 62022,
  Tab_Switch_01 = 62199,
  Click_Action = 62011,
  Click_Disassemble = 62013,
  Recruit100Opening = 62200,
  Recruit100OrangeItemShow = 62201,
  Recruit100NormalItemShow = 61038,
  Recruit100OrangeFlip = 62202,
  Recruit100NormalFlip = 62203,
  Recruit100CardConvert = 62204,
  Music_Effect_Pioneer_Wood1 = 62213,
  Music_Effect_Pioneer_Wood2 = 62214,
  Music_Effect_Pioneer_Wood3 = 62215,
  Music_Effect_Pioneer_Wood4 = 62216,
  Music_Effect_Pioneer_Submit1 = 62217,
  Music_Effect_Pioneer_Submit2 = 62218,
  Music_Effect_Pioneer_Submit3 = 62219,
  Music_Effect_Pioneer_Submit4 = 62220,
  Music_Effect_Pioneer_Seed1 = 62221,
  Music_Effect_Pioneer_Seed2 = 62222,
  Music_Effect_Pioneer_Seed3 = 62223,
  Music_Effect_Pioneer_Water = 62224,
  Music_Effect_Pioneer_Cactus1 = 62225,
  Music_Effect_Pioneer_Cactus2 = 62226,
  Music_Effect_Pioneer_Cactus3 = 62227,
  Music_Effect_Pioneer_Cactus4 = 62228,
  Music_Effect_Pioneer_Sulphur1 = 62209,
  Music_Effect_Pioneer_Sulphur2 = 62210,
  Music_Effect_Pioneer_Sulphur3 = 62211,
  Music_Effect_Pioneer_Sulphur4 = 62212,
  Music_Effect_Pioneer_Rock1 = 62205,
  Music_Effect_Pioneer_Rock2 = 62206,
  Music_Effect_Pioneer_Rock3 = 62207,
  Music_Effect_Pioneer_Rock4 = 62208,
  Music_Effect_get_coin = 61024,
  Music_Effect_get_iron = 61025,
  Music_Effect_get_food = 61027,
  Music_Effect_get_exp = 61028,
  Music_Effect_click_material_box = 62014,
  Music_Effect_click_treaures = 62019,
  Music_Effect_welcome_back = 10060,
  BGM_bgm_base_day = 70011,
  BGM_Bgm_Movie_Battle1 = 70014,
  BGM_bgm_pve_30034 = 70012,
  BGM_bgm_base_day_01 = 70019,
  BGM_bgm_base_day_02 = 70020,
  BGM_Amb_S4_Bloodnight_Loop = 70029,
  SFX_UI_Chapter_Banner_Complete = 80001,
  SFX_UI_Novice_Route_Victory = 80002,
  SFX_UI_Novice_Reconstruct_GoldIn = 80003,
  SFX_UI_Novice_PopUp_Sarah_Free = 80004,
  SFX_UI_Novice_PopUp_DoomLegionAttack = 80005,
  SFX_UI_BaseCapital_LevelUp = 80007,
  SFX_UI_Ch6_Comic_Open = 80008,
  SFX_UI_PopUp_JoinAllianaceNow = 80009,
  SFX_Env_Building_ConstructionStart = 80013,
  NoviceGuide_Boss_BullDog_Runaway_TL = 80019,
  NoviceGuide_Boss_BullDog_Attack_TL = 80020,
  NoviceGuide_BaseOccupied_FlagRaising_TL = 80021,
  NoviceGuide_Collect_LostSupplies_TL = 80023,
  NoviceGuide_TransHeli_TL = 80027,
  SFX_Env_NewArea_TL = 80029,
  SFX_Env_HeroFirstEntry_Heli_TL = 80030,
  SFX_Hero_FirstEntry_BoxOpen = 80031,
  SFX_Novice_Chest_Open = 80034,
  SFX_UI_InitialBuyPack = 80036,
  SFX_NoviceGuide_Army_Attack_Giant_TL = 80038,
  NoviceGuide_BaseOccupied_Firework_TL = 80040,
  SFX_UI_SpecialEvent_Icon_Unlock = 80046,
  SFX_Env_NewArea_Pre = 80052,
  SFX_UI_Hero_PopUp_Skill_Unlock = 80061,
  SFX_Env_NewArea_RollUp = 80065,
  SFX_UI_Task_Single_Highlight = 80067,
  SFX_UI_PopUp_BombWarning = 80068,
  SFX_UI_Hero_SwitchHero_01 = 80070,
  SFX_UI_Hero_SwitchHero_02 = 80071,
  SFX_UI_Hero_Page_Element = 80073,
  SFX_UI_Hero_Page_Skill = 80074,
  SFX_UI_Hero_Page_Click = 80075,
  SFX_UI_General_Click_1st = 80077,
  SFX_UI_General_Return = 80078,
  SFX_UI_General_Click_2nd = 80079,
  SFX_Env_Rescue_ResistanceArmy_TL = 80080,
  SFX_UI_Battle_RewardTime_PopUp = 80132,
  SFX_HeroRecruit_SSR_Logo = 80142,
  SFX_HeroRecruit_UR_Logo = 80143,
  SFX_UI_Battle_Hero_Placement_Drag = 80148,
  SFX_UI_Battle_Hero_Placement_Drop = 80149,
  SFX_Enemy_Boss_Aisila_Born = 90001,
  SFX_Enemy_Boss_Aisila_Xiaqian = 90002,
  SFX_Enemy_Boss_Aisila_Emerge = 90003,
  SFX_Battle_Buff_Heli_Fly_Loop = 90004,
  SFX_Battle_Buff_Heli_Fly_Drop = 90005,
  SFX_Enemy_Boss_Aisila_Death = 90006,
  SFX_UI_Shangjin_Buqiang_Multi = 92001,
  SFX_UI_Shangjin_Xiyin_TL = 92003,
  SFX_UI_Shangjin_Huandan_TL = 92004,
  SFX_UI_Shangjin_Huojian_TL = 92005,
  SFX_UI_Shangjin_Items_Fly = 92006,
  SFX_UI_Shangjin_Jiguang = 92007,
  SFX_UI_Shangjin_Boss_Show_TL = 92010,
  SFX_UI_Shangjin_Boss_Hit = 92011,
  SFX_UI_Shangjin_Kimberly_Run_TL = 92012,
  SFX_UI_Shangjin_Jiguang_Big = 92013,
  SFX_Hero_Awaken_Upgrade_Star_Effect = 920160,
  SFX_Hero_Awaken_Unlock = 920161,
  SFX_Hero_Awaken_Upgrade = 920162,
  SFX_Hero_Awaken_Upgrade_Full_Star = 920163,
  SFX_TacticalCard_Show = 6100052,
  SFX_TacticalCard_Open = 6100053,
  SFX_TacticalCard_Reward = 6100054
}
SoundAssets = {
  Music_Effect_Close = "effect_close",
  Music_Effect_Ground = "effect_ground",
  Music_Effect_Electric = "effect_electric",
  Music_Effect_Stamina = "effect_stamina",
  Music_Effect_Water = "effect_water",
  Music_Effect_Gas = "effect_gas",
  Music_Effect_Coin = "effect_coin",
  Music_Effect_Product1 = "effect_product1",
  Music_Effect_Product2 = "effect_product2",
  Music_Effect_Product3 = "effect_product3",
  Music_Effect_Plant = "effect_plant",
  Music_Effect_Feed = "effect_feed",
  Music_Effect_Produce_Put = "effect_produce_put",
  Music_Effect_Produce_Box = "effect_produce_box",
  Music_Effect_Produce_Work = "effect_produce_work",
  Music_Effect_Produce_Transport = "Effect_Produce_Transport",
  Music_Effect_Bill = "effect_bill",
  Music_Effect_Earth_Order_Box = "Effect_Earth_Order_Box",
  Music_Effect_Earth_Order_Robot = "Effect_Earth_Order_Robot",
  Music_Effect_Button = "newbies/ui/b1/SFX_UI_General_Click_1st",
  Music_Effect_Gulu_Order_Button = "Effect_Gulu_Order_Button",
  Music_Effect_Gulu_Get_Reward = "Effect_Gulu_Get_Reward",
  Music_Effect_Finish = "effect_finished",
  Music_Effect_Rocket = "effect_rocket",
  Music_Effect_Plane_Arrive = "Effect_Plane_Arrive",
  Music_Effect_Plane_Leave = "Effect_Plane_Leave",
  Music_Effect_Radar = "effect_radar",
  Music_Effect_Alliance = "Effect_Bubble1",
  Music_Effect_Collect_Crystal = "Effect_Collect_Crystal",
  Music_Effect_Train_Soldiers = "Effect_Train_Soldiers",
  Music_Effect_Train_Tank = "Effect_Train_Tank",
  Music_Effect_Train_Aircraft = "Effect_Train_Aircraft",
  Music_Effect_Train_Start1 = "Effect_Train_Start1",
  Music_Effect_Hero_Upgrade1 = "Effect_Hero_Upgrade1",
  Music_Effect_Hero_Upgrade3 = "Effect_Hero_Upgrade3",
  Music_Effect_Science_Finish = "Effect_Science_Finish",
  Music_Effect_Ue_Unclock = "Effect_Ue_Unclock",
  Music_Effect_Science_Start = "Effect_Science_Start",
  Music_Effect_Click_CattleFarm = "Effect_Click_CattleFarm",
  Music_Effect_Click_OstrichFarm = "Effect_Click_OstrichFarm",
  Music_Effect_Click_Add_Cattle = "Effect_Click_Add_Cattle",
  Music_Effect_Click_Add_Ostrich = "Effect_Click_Add_Ostrich",
  Music_Effect_Click_Apartment = "Effect_Click_Apartment",
  Music_Effect_Click_Factory = "Effect_Click_Factory",
  Music_Troop_Movement = "Troop_Movement",
  Music_Effect_Click_Enemy1 = "Effect_Click_Enemy1",
  Music_Effect_Click_Gulu = "Effect_Click_Gulu",
  Music_Effect_Click_GroundGoods = "Effect_Click_GroundGoods",
  Music_Effect_Ue_OneGood = "Effect_Ue_OneGood",
  Music_Effect_Ue_GetPayReward = "Effect_Ue_GetPayReward",
  Music_Effect_Common_GetReward = "Effect_Common_GetReward",
  Music_Effect_Farm_Ostrich1 = "Effect_Farm_Ostrich1",
  Music_Effect_Build_Unclock = "Effect_Build_Unclock",
  Music_Effect_Ue_CombatPowerUp = "Effect_Ue_CombatPowerUp",
  Music_Effect_Ue_BuildList = "Effect_Ue_BuildList",
  Music_Effect_Build_SelectCard = "Effect_Build_SelectCard",
  Music_Effect_Common_SelectGoods = "Effect_Common_SelectGoods",
  Music_Effect_Common_ChangeNum = "Effect_Common_ChangeNum",
  Music_Effect_Ue_GetReward = "Effect_Ue_GetReward",
  Music_Effect_Common_SelectTab = "Effect_Common_SelectTab",
  Music_Effect_Start_March = "Effect_Start_March",
  Effect_Recruit_Card_Befall = "Effect_GetHero_card",
  Effect_Recruit_Card_Flip1 = "Effect_GetHero_card1",
  Effect_Recruit_Card_Flip2 = "Effect_GetHero_card2",
  Effect_Recruit_Card_Click = "Effect_GetHero_cardclick",
  Music_Effect_Click_Building = "Effect_Click_Building",
  Music_Effect_Common_FailClick = "Effect_Common_FailClick",
  Music_Effect_Speed_Button = "Effect_SpeedUp_goods",
  Music_Effect_Speed_Button2 = "Effect_SpeedUp_goods2",
  Music_Effect_Hit_Base = "Effect_Hit_Base",
  Music_Effect_Click_Formula = "Effect_Click_Formula",
  Music_Effect_Click_FoodFactory = "Effect_Click_FoodFactory",
  Music_Effect_Click_Bakery = "Effect_Click_Bakery",
  Music_Effect_Click_TuckerStore = "Effect_Click_TuckerStore",
  Music_Effect_Click_Bar = "Effect_Click_Bar",
  Music_Effect_Click_JewelryStore = "Effect_Click_JewelryStore",
  Music_Effect_Put_Formula = "Effect_Put_Formula",
  Music_Effect_Click_Ground2 = "Effect_Click_Ground2",
  Music_Effect_Click_Radar = "Effect_Click_Radar",
  Music_Effect_Click_Main_City = "Effect_Click_Main_City",
  Music_Effect_Click_Hero_Build = "Effect_Click_Hero_Build",
  Music_Effect_Click_INFANTRY_BARRACK = "Effect_Click_INFANTRY_BARRACK",
  Music_Effect_Click_AIRCRAFT_BARRACK = "Effect_Click_AIRCRAFT_BARRACK",
  Music_Effect_Click_BARRACKS = "Effect_Click_BARRACKS",
  Music_Effect_Click_DRONE = "Effect_Click_DRONE",
  Music_Effect_Click_LIBRARY = "Effect_Click_LIBRARY",
  Music_Effect_Click_KONBINI = "Effect_Click_KONBINI",
  Music_Effect_Click_ALLIANCE_CENTER = "Effect_Click_ALLIANCE_CENTER",
  Music_Effect_Click_POLICE_STATION = "Effect_Click_POLICE_STATION",
  Music_Effect_Click_CAR_BARRACK = "Effect_Click_CAR_BARRACK",
  Music_Effect_Click_TRAINFIELD = "Effect_Click_TRAINFIELD",
  Music_Effect_Click_COLD_STORAGE = "Effect_Click_COLD_STORAGE",
  Music_Effect_Click_SCIENE = "Effect_Click_SCIENE",
  Music_Effect_Repair = "Effect_Repair",
  Music_Effect_Hero_Skill = "Effect_Hero_Skill",
  Effect_Exp_FarmSystem = "Effect_Exp_FarmSystem",
  Music_Effect_Golloes_Trader = "Effect_Golloes_trader",
  Music_Effect_Golloes_Warrior = "Effect_Golloes_warrior",
  Music_Effect_Golloes_Explorer = "Effect_Golloes_explorer",
  Music_Effect_Golloes_Worker = "Effect_Golloes_worker",
  Music_Effect_Golloes_Build = "Effect_Golloes_build",
  Music_Effect_PlantFlag = "Effect_PlantFlag",
  Music_Effect_Dome_Scan = "Effect_Dome_Scan",
  Music_Effect_show_to_plant = "show_to_plant",
  Music_Effect_show_to_water = "show_to_water",
  Music_Effect_guide_plane_arrive = "Effect_guide_plane_arrive",
  Music_Effect_guide_air_drop = "Effect_guide_air_drop",
  Music_Effect_guide_robot = "Effect_guide_robot",
  Music_Effect_guide_migrate = "Effect_guide_migrate",
  Music_Effect_guide_ostrich = "Effect_guide_ostrich",
  Music_Effect_guide_cattle = "Effect_guide_cattle",
  Music_Effect_guide_pick_weapon = "Effect_guide_pick_weapon",
  Music_Effect_enter_pve = "Effect_enter_pve",
  Music_Effect_pve_finish = "Effect_pve_finish",
  Music_Effect_self_attack_low = "Effect_self_attack_low",
  Music_Effect_pve_box_appear = "Effect_pve_box_appear",
  Music_Effect_pve_box_get = "Effect_pve_box_get",
  Music_Effect_guide_second_migrate = "Effect_guide_second_migrate",
  Music_Effect_pve_debuff = "Effect_pve_debuff",
  Music_Effect_pve_buff = "Effect_pve_debuff",
  Music_Effect_pve_gunAttack = "Effect_pve_gunAttack",
  Music_Effect_pve_skill = "Effect_pve_skill",
  Music_Effect_pve_hero_weak = "Effect_pve_hero_weak",
  Music_Effect_pve_lost = "Effect_pve_lost",
  Music_Effect_pve_call_reward = "Effect_pve_call_reward",
  Music_Effect_pve_reward_land_lock = "Effect_pve_reward_land_lock",
  Music_Effect_hero_box_open = "Effect_hero_box_open",
  Music_Effect_Task_Show = "Effect_Task_Show",
  Music_Effect_Guide_Get_New_Hero = "Effect_Guide_Get_New_Hero",
  Music_Effect_Pirate_Fight_Bob = "Effect_Pirate_Fight_Bob",
  Music_Effect_guide_show_build = "Effect_guide_show_build",
  Music_Effect_pve_hero_vortex = "Effect_pve_hero_vortex_",
  Music_Effect_Pirate_Show = "Effect_Pirate_Show",
  Music_Effect_show_pve_effect = "Effect_show_pve_effect",
  Music_Effect_select_pve_effect = "Effect_select_pve_effect",
  Music_Effect_trigger_finish = "Effect_trigger_finish",
  Music_Effect_Golloes_Sort_Card = "Effect_Golloes_Sort_Card",
  Music_Effect_Golloes_Show_All_Card = "Effect_Golloes_Show_All_Card",
  Music_Effect_Golloes_Show_One_Card = "Effect_Golloes_Show_One_Card",
  Music_Effect_Golloes_Refresh_Card = "Effect_Golloes_Refresh_Card",
  Music_Effect_Lucky_Roll_Click = "Effect_Lucky_Roll_Click",
  Music_Effect_Lucky_Select = "Effect_Lucky_Select",
  Music_Effect_Click_Ground = "click_ground",
  Music_Effect_Task_Done_Btn = "click_taskdone_button",
  Music_Effect_Scout_Btn = "click_scout_button",
  Music_Effect_HERO_RANK_CHANGE = "commander_lvup",
  Music_Effect_HERO_Upgrade = "hero_common_upgrade",
  Music_Effect_HERO_EquipUpgrade = "part_common_upgrade",
  Effect_Golloes_Sort_Card = "Effect_Golloes_Sort_Card",
  Effect_Golloes_Show_One_Card = "Effect_Golloes_Show_One_Card",
  Effect_GetHero_card1 = "Effect_GetHero_card1",
  Effect_GetHero_card2 = "Effect_GetHero_card2",
  Music_Popup_Appears = "Assets/Main/Sound/Effect/Popup_appears.ogg"
}
LWSoundAssets = {
  CollectSoldier = "army_soldier_2",
  StartCollectSoldier = "city_train",
  StartResearch = "click_research",
  MainBuildingUpLeve = "commander_lvup",
  CitySoldierClick = "army_soldier",
  HospitalCollectSoldier = "army_soldier_2",
  TrainingSoldiersView = "Training_soldiers_screen_appears",
  TrainingClickSoldier = "Click_the_soldier_icon",
  SoldierClickEffect = "soldier_modal_particle_01",
  SoldierUpLevelClick = "Promotion_button",
  DiamondsEmerges = "Diamonds_emerges",
  DiamondsFlies = "Diamonds_flies",
  DialogueClaimedBtn = "Dialogue_Claimed_btn",
  MoonCardUI = "Moon_Card_UI",
  PowerIncrease = "Power_Increase",
  DeployBtn = "Deploy_btn",
  SwitchScene01 = "Switch_Scene_01",
  RadarMissionsBtn = "Radar_Missions_btn",
  RadarUI = "Radar_UI",
  RadarScan = "Radar_Scan",
  RecruitmentUI = "Recruitment_UI",
  RecruitOnceCard = "Recruit_Once_card",
  RecruitTenTimes = "Recruit_Ten_Times",
  Recruit_Flip = "Recruit_Flip",
  Technology_UI = "Technology_UI",
  Tech_Lvl2_UI = "Tech_Lvl2_UI",
  Tech_Lvl3_UI = "Tech_Lvl3_UI",
  ResearchBtn = "Research_btn",
  PAC_Factory_Interface = "PAC_Factory_Interface",
  Select_Accessories = "Select_Accessories",
  Craft_btn = "Craft_btn",
  Crafting = "Crafting",
  Tab_Switch_01 = "Tab_Switch_01",
  Click_Action = "Click_Action",
  Click_Disassemble = "Click_Disassemble",
  Recruit100Opening = "recruit/chouka_01",
  Recruit100OrangeItemShow = "recruit/chouka_02_long",
  Recruit100NormalItemShow = "Recruit_Ten_Times",
  Recruit100OrangeFlip = "recruit/chouka_03",
  Recruit100NormalFlip = "recruit/chouka_04",
  Recruit100CardConvert = "recruit/chouka_05"
}
local _TableName = {
  LW_Config_Split = "lw_config_split",
  RewardConfig = "reward",
  WorldBossConfig = "lw_worldboss_config",
  Government = "government",
  SeasonCampSkin = "lw_season_camp_skin",
  FishCollect = "lw_season_fish_collect",
  Fish = "lw_season_fish",
  LWZoneWar = "lw_zone_war",
  LWZoneWarScore = "lw_zone_war_score",
  Res_Lack_Tips = "res_lack_tips",
  ScienceNew = "APS_science",
  ScienceTab = "scienceTab",
  APSScienceTab = "aps_science_tab",
  Science = "science2",
  ArmsTab = "APS_arms",
  LWArmy = "lw_army",
  GuideTab = "guide",
  PlotTab = "plot",
  FieldMonster = "field_monster",
  HeroTab = "new_heroes",
  Robot = "robot",
  NewHeroes = "aps_new_heroes",
  NewHeroesB = "aps_new_heroes_B",
  HeroBounty = "hero_bounty",
  HeroAppearance = "lw_hero_appearance",
  HeroAppearance_B = "lw_hero_appearance_B",
  HeroAppearance_Opt = "lw_hero_appearance_opt",
  HeroSpecial = "lw_hero_special",
  NewHeroesQuality = "aps_heroes_quality",
  NewHeroesLevelUp = "heroes_levelup",
  NewHeroesTag = "hero_tag",
  HeroMilitaryRank = "aps_heroes_rank",
  HeroMilitaryRankLv = "aps_heroes_rankLv",
  WorldLod = "world_scene",
  DataConfig = "item",
  WorldMultiKill = "killstreak_report_world",
  HeroRecruit = "officer_recruit",
  DropInfoDetail = "lw_dropInfoDetail",
  EffectNumDesc = "effect_num_des",
  HeroArkCore = "hero_core",
  GoodsTabSkin = "goods_skin",
  GoodsTab = "goods",
  GoodsExchangeTab = "goods_exchange",
  GoodsTab_B = "goods_B",
  SkillTab = "skill",
  BattleAnimation = "battle_animation",
  StatusTab = "lw_status",
  StatusEffect = "lw_status_effect",
  EquipRandomEffect = "equip_random_effect",
  Recharge = "recharge",
  Recharge_B = "recharge_B",
  AllianceGift = "alliance_gift",
  AllianceGiftGroup = "alliance_gift_group",
  AllianceItemWarehouse = "alliance_item_warehouse",
  Territory = "territory",
  TerritoryEffect = "territory_effect",
  GoldrushBuilding = "goldrush_building",
  ServerPos = "serverpos",
  SiegeNPC = "siegeNPC",
  Diary = "diary",
  ActivityShow = "activity_show",
  HeroSkill = "new_hero_skills",
  RightsEffectLevel = "rights_effect_level",
  RightsEffect = "rights_effect",
  VipStoreUnlock = "vip_store_unlock",
  VipDetails = "vipdetails",
  Vip = "vip",
  Affect_Num = "affect_num",
  WorldSeason = "world_season",
  WorldBuilding = "building_world",
  DesertTalent = "DesertTalent_DesertTalent",
  TalentShading = "DesertTalent_Shading",
  TalentHome = "talentHome",
  DesertGoldmineWar = "DesertGoldmineWar",
  DesertTalentStats = "DesertTalentStats",
  Decompose = "decompose",
  ActivityPanel = "activity_panel",
  Activity = "activity",
  Activity_B = "activity_B",
  Missile = "missile",
  DateBaseOtherLoadingTips = "loadingTips",
  LoadingTips = "loadingTips",
  Mail_ChannelID = "Mail_ChannelID",
  PlayerCareerXml = "player_career",
  QuestXml = "quest",
  ActivityTaskXml = "activity_task",
  BN_ActivityTaskXml = "season_blood_night_task",
  DesertSkillXml = "desertSkill",
  GuideStep = "guide_step_GuideStep",
  GuideStepContentInfo = "guide_step_ContentInfo",
  Office = "office",
  DayAct = "DayAct",
  ActSeven = "AcitivitySeven_New",
  DoomsDayNote = "doomsdaynote_doomsdaynote",
  DD_Season_Group = "DD_season_group",
  Building = "building",
  Building_B = "building_B",
  Building_EA = "building_ea",
  BuildingHelper = "lw_building_helper",
  Chapter = "chapter_1",
  Chapter_B = "chapter_1_B",
  ScienceShow = "scienceShow",
  Global = "APS_global",
  DailyQuest = "daily_quest",
  Role = "role",
  HeroColor = "APS_hero_color",
  Score = "score",
  TalentType = "APS_talent_type",
  Talent = "APS_talent",
  TalentType = "talent_type",
  Talent_New = "talent",
  Order = "aps_purchase_order",
  LevelUp = "level_up",
  UavDialogue = "aps_uav_dialogue",
  Monster = "lw_world_monster",
  Monster_B = "lw_world_monster_B",
  ResourcesCollect = "resources_collect",
  AllianceResource = "alliance_resource",
  Resource = "aps_resources",
  BirthPoint = "birth_coordinate_0",
  DetectEvent = "detect_event",
  DetectEvent_B = "detect_event_B",
  WorldTreasure = "world_treasure",
  CityManage = "aps_city_buff",
  Rocket_Order = "rocket_order",
  MineCave = "mine",
  DigActivityDig = "activity_dig",
  DigActivityPara = "activity_dig_para",
  JigsawPuzzle = "activity_jigsaw",
  SpeedUpConfig = "speedup_config",
  Guide = "noviceboot",
  BuildQueue = "aps_build_queue",
  APS_PUSH = "APS_push",
  APS_PUSH_SETTINGS = "APS_push_settings",
  APS_SINGLEMAP_JUNK = "aps_singlemap_junk",
  APS_SINGLEMAP_PIONEER = "aps_singlemap_pioneer",
  DesertRefresh = "desert_refresh",
  Desert = "desert",
  ActivityOverview = "activity_showlist",
  Announcement = "scrolling_announcement",
  UnlockBtn = "interfaceSetting",
  TroopAction = "troop_action",
  PlayerLevel = "player_level",
  BaseExpansion = "aps_base_expansion",
  CityJunk = "aps_singlemap_junk",
  ArrowTip = "arrow_tips",
  SingleMapPosition = "aps_singlemap_position",
  SingleMapPosition_B = "aps_singlemap_position_B",
  GuideB = "noviceboot_B",
  HeroStation = "hero_station",
  Trends = "trends",
  TrendsFunction = "trends_function",
  Warning = "aps_warning",
  Farming = "aps_farming",
  SysRedPacket = "sys_red_packet",
  GarageModify = "car_modify",
  GaragePart = "car_transform",
  AlScienceTab = "lw_alliance_science_tab",
  AlScience = "lw_alliance_science_detail",
  PlayerCareer = "player_career",
  PlayerCareerEffect = "career_effect",
  AlEffect = "alliance_effect",
  Factory = "aps_factory",
  PVELevel = "aps_pve_level",
  PVEMonument = "aps_pve_monument",
  PVETrigger = "aps_pve_trigger",
  PVEZombie = "aps_pve_zombie",
  Army = "army",
  AllianceTask = "lw_alliance_milestone",
  Museum = "artifact",
  LandLock = "lw_base_landlock",
  LandLock_B = "lw_base_landlock_B",
  LandLock_C = "lw_base_landlock_C",
  HeroOfficial = "hero_official",
  QuestionAndAnswer = "questionAndAnswer",
  PveBuff = "aps_pve_buff",
  VirtualRoad = "aps_sandRoad",
  MonsterLock = "aps_monsterlock",
  ActivityPuzzleMonster = "activity_puzzle_monster",
  NationConf = "aps_country",
  HeroEntrust = "hero_entrust",
  BattlePass = "battlepass",
  AdventureEntrance = "explorer_entrance",
  AdventureCase = "explorer_case",
  PVEAtom = "aps_pve_atom",
  BattleBuff = "aps_pve_battlebuff",
  LevelExplore = "explore_level",
  ActivityMonster = "activity_monster",
  GatherResource = "lw_gather_resource",
  CollectResource = "aps_collect_resource",
  BuildZone = "lw_base_buildzone",
  BuildZone_B = "lw_base_buildzone_B",
  Aps_Resource_Item = "aps_resource_item",
  Hero_Lack_Tips = "hero_lack_tips",
  Alliance_War_Notice = "alliance_war_notice",
  LW_IDLE_GAME_EVENT = "lw_idle_game_event",
  LW_IDLE_GAME_BOSS = "lw_idle_game_boss",
  ACTIVITY_CALENDARGROUP = "activity_calendargroup",
  APS_Season = "aps_season",
  AllianceMine = "alliance_res_build",
  AllianceGovernmentSkill = "alliance_government_skill",
  AllianceGovernmentSkillScore = "alliance_government_skill_score",
  SeasonWeek = "season_week",
  Dialog_Skin = "dialog_skin",
  LW_Season = "lw_season",
  LW_Season_Damage = "lw_season_damage",
  LW_Season_Damage_New = "lw_season_damage_new",
  LW_Season_Trends = "lw_season_trends",
  LW_Season_rank = "lw_season_rank",
  Season_Week_Card = "season_weekcard",
  World_Skin = "world_skin",
  World_Chess_Color = "world_chess_color",
  LW_Season_Alliance_Reward = "lw_season_alliance_reward",
  LW_Season_Camp_Reward = "lw_season_camp_reward",
  LW_Season_Achievements = "season_achievements",
  LW_Season_builders_alliance_group = "season_builders_alliance_group",
  LW_Season_builders_alliance_level = "season_builders_alliance_level",
  LW_Season_builders_alliance_list = "season_builders_alliance_list",
  LW_Season_builders_city_list = "season_builders_city_list",
  Main_UI_Pop = "main_ui_pop",
  Like_Setting = "like_setting",
  Alliance_Bubble_Notice = "alliance_bubble_notice",
  LW_Battle_Report_Control = "lw_battle_report_control",
  LW_Sound = "lw_sound",
  LW_Sound_AudioMixer_Group = "lw_sound_audiomixer_group",
  LW_Sound_Max_Instances = "lw_sound_max_instances",
  LW_Sound_Server = "lw_sound_server",
  LW_Scene = "lw_scene",
  LW_Scene_B = "lw_scene_B",
  LW_Stage = "lw_stage",
  LW_Stage_B = "lw_stage_B",
  LW_StageFeatureBuilding = "lw_stage_feature_building",
  LW_StageGroup = "lw_stage_group",
  LW_PathPoint = "lw_path_point",
  LW_PathPoint_B = "lw_path_point_B",
  LW_Monster = "lw_monster",
  LW_Monster_B = "lw_monster_B",
  LW_Monster_C = "lw_monster_C",
  LW_Monster_Opt = "lw_monster_opt",
  LW_Hero = "lw_hero",
  LW_Skill = "lw_hero_skill",
  LW_Skill_Effect = "lw_hero_skill_effect",
  LW_Hero_Effect = "lw_hero_effect",
  LW_Skill_Effect_PVP = "lw_hero_skill_effect_pvp",
  LW_Bullet = "lw_bullet",
  LW_Buff = "lw_buff",
  LW_Technical_Report = "lw_technical_report",
  LW_Extra_Power_Report = "lw_other_report",
  LW_Extra_Power_Report_New = "lw_other_report_new",
  LW_Activity_Tips = "actvity_tips",
  LW_SIMPLAYER = "lw_simplayer",
  LW_Role = "lw_role",
  LW_Train_Property = "train_property",
  LW_Train_Para = "train_para",
  LW_War_Flag = "war_flag",
  Env_Temperature = "env_temperature",
  Freeze_Config = "freeze_config",
  Temperature = "temperature",
  Temperature_Help = "temperature_help",
  Temperature_Achievement = "temperature_achievement",
  WorldTrigger = "season_landmine",
  LW_Stage_Feature = "lw_stage_feature",
  LW_Stage_Feature_B = "lw_stage_feature_B",
  LW_Stage_Feature_C = "lw_stage_feature_C",
  LW_Stage_Feature_Opt = "lw_stage_feature_opt",
  LW_Monster_Born = "lw_monster_born",
  LW_Monster_Born_B = "lw_monster_born_B",
  LW_Monster_Born_C = "lw_monster_born_C",
  HeroEvent = "heroevent",
  Activity_Monster_Stage = "activity_monster_stage",
  LW_Stage_SkyBattle = "lw_stage_sky_battle",
  LW_SkyBattle_MonsterBorn = "lw_sky_battle_monster_born",
  LW_SkyBattle_Monster = "lw_sky_battle_monster",
  LW_Scene_Effect = "lw_scene_effect",
  LW_March_Type = "lw_march_type",
  LW_March_Target_Type = "target_type",
  LW_Count_Stage = "lw_count_stage",
  LW_Count_Stage_B = "lw_count_stage_B",
  LW_Count_Stage_Group = "lw_count_stage_group",
  LW_Count_Stage_Group_B = "lw_count_stage_group_B",
  LW_Count_Stage_Trap = "lw_count_stage_trap",
  LW_Count_Stage_Trap_B = "lw_count_stage_trap_B",
  LW_Count_Stage_Soilder = "lw_count_stage_soilder",
  LW_Count_Stage_Soilder_B = "lw_count_stage_soilder_B",
  Hero_pentagon = "lw_hero_pentagon",
  Hero_tag = "lw_hero_tag",
  Hero_Unique_Weapon = "lw_hero_unique_weapon",
  LW_Hero_Level = "lw_hero_level",
  LW_Hero_Skill = "lw_hero_skill",
  LW_Hero_Skill_B = "lw_hero_skill_B",
  LW_Hero_Unlock_Skill = "lw_hero_unlock_skill",
  LW_Hero_Para = "lw_hero_para",
  LW_Effect_Number = "lw_effect_number",
  LW_Effect_Overview = "lw_effect_overview",
  LW_Trigger_Item = "lw_trigger_item",
  LW_Trigger_Item_B = "lw_trigger_item_B",
  City_Visitor = "lw_base_visitor_event",
  LW_Soldier = "lw_soldier",
  LW_DK_City = "dark_knight_alliance_rank_reward",
  LW_DK_Dialog = "season_dark_knight_dialog",
  LW_Worker = "lw_worker",
  LW_Worker_Rank = "lw_worker_rank",
  LW_Template_Property = "lw_template_property",
  LW_Replay_Distance = "lw_replay_distance",
  LW_Dialog = "lw_dialog",
  LW_Equip = "lw_equip",
  LW_Equip_Upgrade = "lw_equip_upgrade",
  LW_Equip_Attribute = "lw_equip_attribute",
  LW_Equip_Material = "lw_equip_material",
  LW_Res_Lack_Tips = "lw_res_lack_tips",
  LW_Hero_Skill_Perform = "hero_skill_perform",
  ACTIVITY_SHOW_CONFIG = "activity_show_config",
  Festival_Interface_Config = "festival_interfaceconfig",
  ACTIVITY_PIC_GUIDE = "activity_pic_guide",
  LW_Alliance_Authority = "lw_alliance_authority",
  LW_Alliance_Officer_Info = "lw_alliance_officer_info",
  LW_FUNCTION_UNLOCK = "lw_function_unlock",
  LW_FUNCTION_UNLOCK_B = "lw_function_unlock_B",
  LW_EMOJI = "emoji",
  LW_Sticker = "sticker",
  LW_Ally_Drill = "activity_alliance_boss_property",
  LW_Ally_Drill_New_Boss = "activity_new_alliance_boss",
  LW_AllyDrillRoadHog = "activity_alliance_boss_plague",
  LW_Plot = "lw_plot",
  LW_Hero_Rank = "lw_hero_rank",
  LW_Monopoly = "monopoly",
  LW_Monopoly_B = "monopoly_B",
  LW_Monopoly_C = "monopoly_C",
  Adaptive_Box = "adaptive_box",
  LwDispatchTask = "lw_dispatch_tasks",
  LwDispatchSetting = "lw_dispatch_settings",
  ai_chat_character = "ai_character",
  ai_chat_chatroom = "ai_chatroom",
  ai_chat_switch = "ai_switch",
  ai_chat_faq = "faq_key_list",
  ai_chat_feedback_emo = "feedback_emo",
  ChatRoom = "chat_room",
  activity_challenge_zombie = "activity_challenge_zombie",
  AdvancedChallengeBoss = "advanced_challenge_boss",
  AdvancedChallengePlayerSkill = "advanced_challenge_player_skill",
  CommonBossSkill = "common_boss_skill",
  WonderGift = "wonder_gift",
  Activity_Stage = "activity_stage",
  TowerUp = "lw_towerup",
  TowerUp_B = "lw_towerup_B",
  LW_Dominator_Up = "lw_dominatorup",
  RichMan = "rich_man",
  RichManEvent = "rich_man_event",
  RichManBoss = "rich_man_boss",
  RichManPara = "rich_man_para",
  RichmanDropshow = "richman_dropshow",
  LW_Opening_Stage = "lw_opening_stage",
  LW_Opening_Stage_B = "lw_opening_stage_B",
  LW_Opening_Stage_JP = "lw_opening_stage_JP",
  Camp_effect = "camp_effect",
  LWBuildQueue = "construction_queue",
  CITY_BATTLE_QUEST = "citybattle_quest",
  Decoration = "lw_decoration",
  LW_Squad_Equip = "lw_squad_equip",
  LW_Squad_Equip_Lv = "lw_squad_equip_lv",
  LW_Shop = "shop",
  DecorationSkill = "lw_decoration_skill",
  DecorationDazzle = "decoration_colorful_skin",
  DETECT_LEVEL = "detect_level",
  DETECT_LEVEL_B = "detect_level_B",
  HERO_EVENT = "hero_event",
  MONSTER_SHOP = "monster_shop",
  ActivityBoxOpen = "activity_boxopen",
  ActivityBoxOpenPara = "activity_boxopen_para",
  ActivitySlotsBox = "activity_slots_box",
  ActivitySlotsGroup = "activity_slots_group",
  ActivitySlotsIcon = "activity_slots_icon",
  ActivitySlotsInfo = "activity_slots_info",
  ActivitySlotsPic = "activity_slots_pic",
  ActivitySlotsDropShow = "activity_slots_dropshow",
  Mastery = "season_mastery",
  MasterySkill = "season_active_skill",
  MasteryExp = "masteryExp",
  LW_MASTERY = "lw_mastery",
  LW_MASTERY_EXP = "lw_mastery_exp",
  LW_MASTERY_SHOW = "lw_mastery_show",
  ACTIVITY_ENTRANCE_CONFIG = "activity_entrance_config",
  LW_Hero_HonorLevel = "lw_hero_honorLevel",
  LW_Infinite_Gift_Group = "infinite_gift_group",
  LW_Guide_Flow = "lw_guide_flow",
  LW_Guide_Flow_B = "lw_guide_flow_B",
  LW_Guide_Flow_New = "lw_guide_flow_new",
  LW_WorldTrends = "lw_world_trends",
  LW_WorldTrends_Event = "lw_world_trends_event",
  LW_Equip_Promote = "lw_equip_promote",
  LW_CitySkin_Exchange = "activity_convert",
  LW_Newbie_Arena = "activity_arena_newbie",
  LW_Newbie_Arena_V2 = "activity_arena_v2_newbie",
  LW_Activity_Drop = "activity_drop",
  LW_Activity_Drop_Info = "activity_drop_info",
  LW_BattlePassV2 = "battlepass_v2",
  LW_Activity_Make_Food = "activity_makefood",
  LW_Activity_Party = "activity_party",
  LW_Activity_Party_New = "activity_partynew",
  LW_Activity_Party_Monster = "activity_party_monster",
  LW_Activity_Party_Group = "activity_party_monster_group",
  Activity_PartyNew_DropShow = "activity_partynew_dropshow",
  SHARE_COMPONENTS = "share_components",
  HERO_ACTIVITY = "hero_activity",
  LW_UAV_LEVEL = "lw_uav_level",
  LW_UAV = "lw_uav",
  LW_UAV_LEVEL_PREVIEW = "lw_uav_level_preview",
  LW_UAV_UPGRADE = "lw_uav_upgrade",
  Event_City_Star = "event_city_star",
  LW_DailyPackage = "custom_dailypackage",
  LW_Trail_Tower = "lw_trialtower",
  LW_Trail_Tower_Level = "lw_trialtowerlevel",
  LW_TrailTower_Buff = "lw_trialtowerbuff",
  LW_Activity_BargainShop = "activity_bargain_shop",
  Credit_Price = "credit_price",
  LW_Comic = "comic",
  LW_Comic_Group = "comicgroup",
  LW_PPT_Show = "lw_ppt_show",
  LW_PPT_Show_B = "lw_ppt_show_B",
  LW_Report_Helper = "report_helper",
  doomsday_quest = "doomsday_quest",
  HeroActivity = "heroactivity",
  WeekCard = "weekcard",
  LW_DRONE_BATTLESYSTEM_LEVEL = "lw_drone_battlesystem_level",
  LW_DRONE_BATTLESYSTEM_TIER = "lw_drone_battlesystem_tier",
  LW_Drone_Skill = "lw_drone_skillchip",
  LW_Drone_Skillchip_Exp = "lw_drone_skillchip_exp",
  LW_PointChest = "lw_pointChest",
  LW_hero_energy_levelup = "lw_hero_energy_levelup",
  Activity_Multiply_Door = "activity_multiply_door",
  Activity_Multiply_Map = "activity_multiply_map",
  LW_Chat_Packet = "red_packet",
  LW_Chat_RedPacket_Appearance = "red_packet_show",
  Activity_Rebate = "activity_rebate",
  Activity_Rebate_New = "activity_rebate_new",
  LWZombieRush = "lw_zombieRush",
  world_city_color = "world_city_color",
  GeneSynthesis = "gene_synthesis",
  SeasonCallback = "season_callback",
  SeasonWeatherEvent = "season_weather_event",
  SeasonWeatherConfig = "season_weather_config",
  SeasonWeatherGuider = "season_weather_guider",
  Splinter_Exchange = "splinter_exchange",
  Treasure_Map_Reward_Show = "Treasure_map_reward_show",
  Treasure_Map_Reward = "Treasure_map_reward",
  Activity_PowerUpConfig = "activity_powerupconfig",
  Activity_CommunityLink = "activity_community_link",
  RecommendDevelopPower = "rec_power",
  DevelopScore = "developing_score",
  AllyDuelTips = "alliance_duel_prompt_tips",
  Product_Init = "product_init",
  GoldBrick_Amount = "goldbrick_amount",
  GoldBrick_Price = "goldbrick_and_price",
  Lw_DmaLink = "lw_dmaLink",
  LW_Champion_Duel_Guide = "lw_champion_duel_guide",
  LW_Champion_Duel_Open = "lw_champion_duel_open",
  LW_Champion_Duel_Reward = "lw_champion_duel_reward",
  Activity_BlackMarket = "activity_blackmarket",
  ActivityBerserkBoss = "activity_berserkboss_config",
  LWIceSupplies = "ice_supplies",
  LW_AllianceRecord = "lw_allianceRecord",
  LW_AllianceMark = "lw_alliance_mark",
  Exchange = "exchange",
  Activity_Decoration_Gacha_Probability = "decoration_recruitdropshow",
  Activity_Decoration_Gacha_Info = "decoration_recriut",
  LwGhostreconTask = "lw_ghostrecon_tasks",
  LwGhostreconSetting = "lw_ghostrecon_settings",
  StormEvent = "storm_event",
  SeasonFoodMenu = "season_food_menu",
  Activity_Torch_Relay_Stage = "activity_torch_relay_stage",
  Activity_Torch_Relay_Stage_Cheer = "activity_torch_relay_stage_cheer",
  ACTIVITY_TORCH_RELAY_STAGE_RESOURCE = "activity_torch_relay_stage_resource",
  ACTIVITY_TORCH_RELAY_STAGE_RANDOM = "activity_torch_relay_stage_random",
  ACTIVITY_TORCH_RELAY_STAGE_ITEM = "activity_torch_relay_stage_item",
  Activity_Torch_Relay = "activity_torch_relay",
  Activity_Torch_Relay_Grow_Up = "activity_torch_relay_grow_up",
  Activity_Thanksgiving = "activity_thanksgiving",
  Activity_Thanksgiving_Lottery = "activity_thanksgiving_lottery",
  Activity_Thanksgiving_Rec_Type = "activity_thanksgiving_rec_type",
  Box_No_Put_Back = "box_no_put_back",
  VIP_EXTEND_PRIVILEGE = "vip_privilege",
  LW_STAGE_FEATURE_CHAPTER = "lw_stage_feature_chapter",
  LW_EASY_STAGE_FEATURE_CHAPTER = "lw_stage_feature_chapter_newbie",
  LW_SKY_BATTLE_CHAPTER = "lw_sky_battle_chapter",
  LW_SKY_BATTLE_CHAPTER_UPGRADE = "lw_sky_battle_chapter_upgrade",
  LW_SKY_BATTLE_PLANE = "lw_sky_battle_plane",
  LW_SKY_BATTLE_EQUIP = "lw_sky_battle_equip",
  LW_EASY_STAGE_FEATURE_CHAPTER_B = "lw_stage_feature_chapter_newbie_B",
  LW_SUMMONS = "lw_summons",
  EQUIP_RECOMMEND = "equip_recommend",
  Season_Congress_Boss = "season_Congress_boss",
  Season_Congress_Boss_Quest = "season_Congress_boss_quest",
  Alliance_Right_Show = "alliance_right_show",
  Activity_Clock = "activity_clock",
  Alliance_Leave_Tips = "alliance_leave_tips",
  LW_Migration_Open = "lw_migration_open",
  Migration_Guide = "migration_guide",
  Zone_Honor = "zone_honor",
  LW_Zone_Migration_Standard = "lw_zone_migration_standard",
  LW_Migration_Person_Standard = "lw_migration_person_standard",
  LW_Migration_Season_Tips = "lw_migration_season_tips",
  LW_Migration_Alliance_Tag = "lw_migration_alliance_tag",
  LW_Migration_Zone_Star = "lw_migration_zone_star",
  AdvancedMonsterInvasion = "advanced_monster_invasion",
  CityEvent = "city_event",
  LW_SEASON_DIGGING_GAME = "lw_season_digging_game",
  LW_SEASON_BLOCK = "lw_season_block",
  LW_Season_Oasis = "season_oasis",
  LW_UPGRADE_LOG = "lw_season_update_list",
  LW_Season_OasisViewScale = "season_oasis_view_scale",
  LW_Map_Surprise = "map_surprise",
  Armed_truck_config = "armed_truck_config",
  Armed_truck_trigger = "armed_truck_trigger",
  Armed_truck_buff = "armed_truck_buff",
  Armed_truck_bullet = "armed_truck_bullet",
  Armed_truck_hero = "armed_truck_hero",
  Activity_Valentine_Send = "activity_Valentine_Send",
  Activity_Valentine_BoxReward = "activity_Valentine_BoxReward",
  LW_SEASON_PHOTO = "season_alliance_photo",
  LW_SEASON_PHOTO_SIZE = "season_alliance_photo_size",
  LW_SEASON_PHOTO_BORDER = "season_alliance_photo_border",
  LW_SEASON_PHOTO_TASK = "season_alliance_photo_task",
  LW_LIGHTS_ON_S4 = "lw_lights_on",
  DOMINATOR_MAIN = "dominator_main",
  DOMINATOR_RANK = "dominator_rank",
  DOMINATOR_RANK_SHOW = "dominator_rank_show",
  DOMINATOR_TRAIN_GROUP = "dominator_train_group",
  DOMINATOR_TRAIN_LEVEL = "dominator_train_level",
  DECORATION_UPGRADE = "lw_decorationbuilding_lv",
  DOMINATOR_STORY_SHOW = "dominator_story_show",
  ActSevenV2 = "activity_seven_v2",
  Download_Packs = "download_packs",
  CaveExploration = "cave_exploration",
  CaveExplorationBox = "cave_explorations_box",
  DOUBLE_DROP = "activity_multiple_config",
  LW_VIP_PAY = "import_vip_pay",
  ZoneMobilizationStage = "zone_mobilization_stage",
  ZoneMobilizationBoss = "zone_mobilization_boss",
  Letter = "letter_config",
  MeteoriteBattleEntity = "yuntie_battle_entity",
  MeteoriteBattleReward = "yuntie_battle_reward",
  MeteoriteBattleGuide = "yuntie_battle_guide",
  MeteoriteBattleRefresh = "yuntie_battle_refresh",
  LW_BattleField_Season = "battlefield_season_config",
  LW_BattleField_Rules = "battlefield_rules",
  LW_BattleField_Guide = "battlefield_guide",
  LW_BattleField_Map = "battlefield_map",
  LW_BattleField_Update_Note = "battlefield_update_note",
  LW_Battlefield_tips = "battlefield_tips",
  LW_BattleField_MiniMap = "battlefield_minimap",
  LW_BattleField_Ping = "lw_battlefield_ping",
  LW_BattleField_Achievement = "battlefield_achievement",
  LW_BattleField_RewardPointShow = "battlefield_reward_point_show",
  Desert_Battle_Hero_Actions = "desert_strom_hero_actions",
  Desert_Battle_Update_Note = "desert_battle_update_note",
  LW_Season_Blood_Night = "season_blood_night",
  LW_Season_Blood_Night_Plan = "season_blood_night_plan",
  LW_Season_Blood_Night_Score = "season_blood_night_score",
  LW_TITLE = "lw_title",
  WorldBattleGuide = "world_tips",
  SeasonDesertShop = "season_desert_shop",
  LW_SEASON_PRE = "lw_season_pre",
  ALLIANCE_STAR = "alliance_star",
  ALLIANCE_STAR_CEREMONY = "alliance_star_ceremony",
  ALLIANCE_STAR_PLAYSCRIPT = "alliance_star_playscript",
  LW_DECORATION_SHOP = "decoration_shop",
  LW_GIFT_PRIVILEGE = "gift_privilege",
  LW_GIFT_LEVEL = "gift_level",
  LW_GIFT_GOODS = "gift_goods",
  Gift_Unlock = "gift_unlock",
  ValentineRank = "activity_Valentine_Rank",
  ValentineBox = "activity_Valentine_Box",
  Bounty_Hunter = "activity_hunter",
  Bounty_Hunter_Stage = "activity_hunter_stage",
  Bounty_Monster = "activity_hunter_monster",
  Bounty_Hunter_FreeChest = "activity_hunter_freebox",
  Bounty_Hunter_Event = "activity_hunter_event",
  Bounty_Hunter_Para = "activity_hunter_para",
  Bounty_Hunter_Event_Shop = "activity_hunter_eventshop",
  ACTIVITY_REVIVAL_CONFIG = "activity_revival_config",
  ACTIVITY_REVIVAL_SCORE_SHOW = "activity_revival_scoreshow",
  LW_UW_ENHANCE_LV = "lw_hero_unique_weapon_unit",
  LW_UW_ENHANCE_COST = "lw_hero_unique_weapon_unit_cost",
  ExplorerTreasure = "lw_dispatch_explorer_treasure",
  TacticalCardSlot = "battle_card_slot",
  TacticalCard = "battle_card",
  TacticalCardLevel = "battle_card_level",
  TacticalCardStar = "battle_card_star",
  TacticalCardSkill = "battle_card_skill",
  TacticalCardBox = "battle_card_box",
  TacticalCardBoxPool = "battle_card_box_pool",
  TacticalCardStageReward = "battle_card_reward",
  TacticalCardBattleReport = "battle_card_report",
  TacticalCardRecommendSeason = "battle_card_recommend_season",
  TacticalCardRecommend = "battle_card_recommend",
  LW_HOW_TO_PLAY = "lw_howtoplay",
  SEASON_BLOCK_REMOVAL = "season_block_removal",
  SEASON_BLOCK_LEVEL_SOLUTION = "season_block_level_solution",
  LW_SEASON_BLOCK_SHEEP = "lw_season_block_sheep",
  SEASON_BULLET_SHOOT_GAME = "season_bullet_shoot_game",
  SEASON_BULLET_SERVER = "season_bullet_server",
  SEASON_CAVE_EXPLORATION = "season_game_cave_exploration",
  LW_SEASON_PRE_VIRUS_BOSS = "lw_season_pre_virus_boss",
  ACTIVITY_EASTER_EGG = "activity_easter_egg",
  ACTIVITY_EASTER_TIPS = "activity_easter_tips",
  ActivityWorldTreasure = "activity_world_treasure",
  CHAPTER_NEWBIES = "chapter_newbies",
  SIMPLE_CITY_EVENT = "simple_city_event",
  SIMPLE_CITY_EVENT_B = "simple_city_event_B",
  RESOURCE_SPEED_SHOW = "resource_speed_show",
  REFUND_FAQ = "refund_faq",
  REFUND_GOLDBRICK = "refund_goldbrick",
  REFUND_GOLDBRICK_PC = "refund_pcgoldbrick",
  SEASON_GOLDEN_TREE = "season_golden_tree",
  SEASON_GOLDEN_TREE_CARD_POOL = "season_golden_tree_card_pool",
  SEASON_GOLDEN_TREE_CARD_MULTIPLIER = "season_golden_tree_card_multiplier",
  SEASON_GOLDEN_TREE_COMBINATIONS = "season_golden_tree_combinations",
  SEASON_GOLDEN_TREE_THIRD = "season_golden_tree_phase_third",
  SEASON_TRAVEL_WORLD = "season_travel_world",
  ACTIVITY_REWARD_CHANGE = "activity_reward_change",
  GIFT_PREVIEW_INFO = "gift_preview_info",
  SEASON_CHEST = "lw_season_chest",
  CRAZY_ROCK_SONG = "activity_fes_song",
  CRAZY_ROCK_SONG_NOTE = "activity_fes_songnote",
  Festival_Music_Config = "activity_fes_music",
  MONOPOLY_SEARCH = "monopoly_search",
  BattleField_Entrance = "battlefield_entrance",
  LW_OFFSEASON_QUEENCHALLENGE = "lw_offSeason_queenChallenge",
  LW_OFFSEASON_TASK = "activity_offSeason_task",
  ACT_CONCERT = "activity_fes_concert",
  FEATURE_PRELOAD_ASSET = "feature_preload_asset",
  Firework = "firework",
  ACTIVITY_HUNTER_SHOP = "activity_hunter_shop",
  ACTIVITY_HUNTER_DROPSHOW = "activity_hunter_dropshow",
  LW_MAIL_FILTER = "mail_filter",
  Mail = "mail",
  Mail_Group = "mail_group",
  LW_DSB_LEAGUE_GUIDE = "lw_dsb_leaguel_guide",
  LW_DSB_LEAGUE_OPEN = "lw_dsb_leaguel_open",
  LW_DSB_LEAGUE_RANK_REWARD = "lw_dsb_leaguel_rank_reward",
  Calendar = "calendar",
  ACTIVITY_UPDATE_LIST = "activity_updatelist",
  SEASON_S1_BLOCK = "season_s1_block",
  SEASON_S1_BLOCK_GAME = "season_s1_block_game",
  lw_surfing_stage = "lw_surfing_stage",
  lw_surfing_stage_scene = "lw_surfing_stage_scene",
  lw_surfing_monster_born = "lw_surfing_monster_born",
  lw_surfing_monster = "lw_surfing_monster",
  lw_parkour_buff = "parkour_buff",
  lw_parkour_battle_pass = "parkour_score_reward",
  T11_Stage_Config = "soldier_eleven_stage",
  T11_Upgrade_Config = "soldier_eleven_upgrade",
  T11_Equip_Config = "soldier_eleven_art",
  T11_Soldier_Config = "soldier_eleven",
  T11_Preview_Config = "soldier_eleven_preview",
  Desert_Battle_Guide = "desert_strom_guide",
  AD_Infinity_Box_Season = "al_duel_infinity_box_season",
  AD_Infinity_Box_Reward = "al_duel_infinity_box_reward",
  BattleCardBoxReward = "battle_card_box_reward",
  SEASON_BOUNTY_SHOP = "season_bounty_shop",
  City_Battle_Task = "city_battle_task",
  City_Battle_Clue = "city_battle_clue",
  LW_IDLE_GAME = "lw_idle_game",
  LW_IDLE_GAME_NODE = "lw_idle_game_node",
  LW_IDLE_GAME_EVENT = "lw_idle_game_event",
  LW_IDLE_GAME_REWARD_PREVIEW = "lw_idle_game_reward_preview",
  LW_IDLE_GAME_SHARE = "lw_idle_game_share",
  LW_MAKING_COFFEE = "lw_coffee",
  LW_SEASON_MONEY_RANK = "lw_season_money_rank",
  Upgrade_TreasureBox = "activity_upgradebox_info",
  Flower_Train_Level = "activity_treasure_info",
  Flower_Train_Para = "activity_treasure_para",
  Flower_Train_Config = "activity_treasure_common",
  Flower_Train_Display = "activity_treasure_show",
  Flower_Train_Drop_Box = "treasure_box_show",
  LW_Alliance_Congratulation = "alliance_congratulation",
  lw_last_stand_building = "lw_last_stand_building",
  lw_last_stand_feature = "lw_last_stand_feature",
  lw_last_stand_guide = "lw_last_stand_guide",
  BATTLE_CARD_RANDOM_ATTR_SHOW = "battle_card_random_attr_show",
  BATTLE_CARD_DECK = "battle_card_deck",
  LW_ARMED_UPGRADE = "lw_armed_upgrade",
  LW_ARMED_UPGRADE_JP = "lw_armed_upgrade_JP",
  LW_CAMP_SCIENCE_GROUP = "lw_camp_science_group",
  LW_CAMP_SCIENCE_TAB = "lw_camp_science_tab",
  LW_CAMP_SCIENCE_DETAIL = "lw_camp_science_detail",
  SEASON_CAMP_BUFF = "season_camp_buff",
  parkour_ghost_npc = "parkour_ghost_npc",
  parkour_score_tier = "parkour_score_tier",
  parkour_hero = "parkour_hero",
  LW_CIVILIZATION_SPARK = "lw_civilization_spark",
  MONOPOLY_PERFORMANCE = "monopoly_performance",
  LW_SEASON_PRE_VIRUS_STUDY = "lw_season_pre_virus_study",
  LW_HERO_UPGRADE_NEWBIE = "lw_hero_upgrade_newbie",
  LW_ADS_COLLECTION = "lw_ads_Collection",
  CRAZY_ROCK_SHOW = "activity_fes_music_show",
  chat_sharetype_config = "chat_sharetype_config",
  alliance_pay = "alliance_pay",
  RECHARGE_GIFT_SHOW = "recharge_gift_show",
  ACTIVITY_CYCLE = "activity_cycle",
  ACTIVITY_CYCLE_SHOP = "activity_cycle_shop",
  RECHARGE_MERGE = "recharge_merge",
  AUTO_STICKER = "auto_sticker",
  LW_FUNCTION_SEASON = "lw_function_season",
  DOWNLOAD_CENTER = "download_center",
  GOODS_ORDER_CONFIG = "goods_order_config",
  Exchange_Special = "exchange_special",
  LW_SEASON_MILITARY_LEVEL = "lw_season_military_level",
  LW_SEASON_MILITARY_RANK = "lw_season_military_rank",
  PAY_COUNTRY_CURRENCY = "country_currency",
  activity_Valentine_Get = "activity_Valentine_Get",
  TRAIN_ADDITION_PRICE = "train_addition_price",
  LW_HERO_TRY_OUT = "lw_hero_try_out",
  LW_HERO_TRY_OUT_TAG = "lw_hero_try_out_tag",
  LW_Integrated_Stage_Feature = "lw_stage_feature_chapter_unity",
  LW_R4_RECOMMEND = "lw_r4recommend",
  LW_CONVEYLUCK = "lw_conveyluck",
  LW_HERO_AWAKEN = "lw_hero_awaken",
  LW_HERO_AWAKEN_RANK = "lw_hero_awaken_rank",
  LW_HERO_SKIN = "lw_hero_skin",
  ACTIVITY_SURVIVOR = "activity_survivor",
  ACTIVITY_SURVIVOR_LIST = "activity_survivor_list",
  ACTIVITY_ALLIANCE_BOSS_S0 = "activity_alliance_boss_s0",
  quick_gift_component = "quick_gift_component",
  SEASON_TOWER_ARMY = "season_tower_army",
  SEASON_TOWER_STAGE = "season_tower_stage",
  SEASON_TOWER_DIFFICULTY = "season_tower_difficulty",
  SEASON_TOWER_GROUP = "season_tower_group",
  SEASON_TOWER_RANK_REWARD = "season_tower_rank_reward",
  LW_LOGIN_POPUP_NOTIFICATION = "login_popup_notification",
  LW_LOGIN_POPUP_ACTIVITY = "login_popup_activity"
}
TableName = setmetatable(_TableName, {
  __index = function(t, k)
    if k == "WorldCity" then
      local cityTbl = SeasonUtil.GetWorldCityTableName()
      _TableName.WorldCity = cityTbl
      return cityTbl
    end
    return nil
  end
})
NewQueueType = {
  Default = 0,
  FootSoldier = 8,
  Hospital = 3,
  Science = 6,
  CarSoldier = 1,
  BowSoldier = 9,
  ArmyUpgrade = 34,
  DomainHospital = 35,
  EquipMaterial = 36,
  Field = 39,
  Barn = 40,
  OstrichBarn = 41,
  CattleBarn = 42,
  SandWormBarn = 43,
  TransportRes = 104,
  Equip = 107,
  BlastMissile = 111,
  GasMissile = 112,
  FreezingMissile = 113,
  CombustionMissile = 114,
  IlluminationMissile = 115,
  DragonHospital = 116,
  RebirthHospital = 117,
  T11Break = 120
}
LWBuildQueueType = {NORMAL = 0, SPECIAL = 110}
QueueProductState = {
  DEFAULT = 0,
  PASTURE_MATURE = 1,
  PASTURE_BY_PRODUCT = 2
}
ResourceItemType = {
  Farming = 0,
  Industry = 1,
  EquipMaterial = 8
}
ResourceItemRealType = {
  Soldier = 7,
  HeroExp = 9,
  DragonSoldier = 12,
  MummySoldier = 18,
  OpeningHeroStar = 1101,
  MasterExp = 20
}
TroopIconShowState = {
  Hide = 0,
  Idle = 1,
  Broken = 2
}
ItemSpdMenu = {
  ItemSpdMenu_ALL = 1,
  ItemSpdMenu_Troop = 2,
  ItemSpdMenu_Soldier = 3,
  ItemSpdMenu_Heal = 4,
  ItemSpdMenu_Trap = 5,
  ItemSpdMenu_Science = 6,
  ItemSpdMenu_City = 7,
  ItemSpdMenu_DuanZao = 8,
  ItemSpdMenu_Helicopter = 9,
  ItemSpdMenu_Missile = 10,
  ItemSpdMenu_RemoveCity = 11,
  ItemSpdMenu_Siege_Heal = 20,
  ItemSpdMenu_Desert_Heal = 21,
  ItemSpdMenu_Fix_Ruins = 22,
  ItemSpdMenu_Chip_Crate = 23,
  ItemSpdT11_BreakUpgrade = 24
}
NewQueueState = {
  Free = 0,
  Prepare = 1,
  Work = 2,
  Finish = 3
}
FarmStateType = {
  None = -1,
  Plant = 0,
  Harvest = 1,
  Feed = 2,
  HarvestSecond = 3,
  Irrigate = 4
}
BuildType = {
  Normal = 0,
  Main = 1,
  Second = 2,
  Third = 3
}
BuildingStateType = {
  Normal = 0,
  Upgrading = 1,
  FoldUp = 2,
  PAUSE_Upgrading = 3,
  Crossing = 5
}
EffectLocalType = {
  Num = 1,
  Time = 2,
  Percent = 3,
  Dialog = 4,
  PositiveNum = 5,
  NegativeNum = 6,
  PositiveTime = 7,
  NegativeTime = 8,
  PositivePercent = 9,
  NegativePercent = 10
}
EffectLocalTypeInEffectDesc = {
  Num = 0,
  Percent = 1,
  Thousandth = 2,
  Str = 3,
  NegativePercent = 4
}
UIMainLeftButtonType = {None = 0, March = 1}
UIMainLeftButtonTypeSortList = {
  UIMainLeftButtonType.March
}
UIMainTopResourceChangeType = {Normal = 0, ChangeLevel = 1}
UIGiftTypeButtonType = {Hot = "Hot", Diamond = "Diamond"}
BattleType = {
  None = 0,
  Formation = 1,
  Building = 2,
  Turret = 3,
  Monster = 4,
  RallyFormation = 5,
  Boss = 6,
  City = 7,
  Road = 8,
  Explore = 9,
  ALLIANCE_NEUTRAL_CITY = 10,
  ALLIANCE_OCCUPIED_CITY = 11,
  ELITE_FIGHT_MAIL = 12,
  PVE_MARCH = 13,
  PVE_MONSTER = 14,
  ACT_BOSS = 15,
  PUZZLE_BOSS = 16,
  CHALLENGE_BOSS = 17,
  Desert = 18
}
UIBagBtnType = {
  Hot = 0,
  War = 1,
  Buff = 2,
  Resource = 3,
  Other = 4
}
GoToType = {
  None = -1,
  GotoBuilding = 0,
  GotoUI = 1
}
UIMainFunctionInfo = {
  None = 0,
  Report = 1,
  Goods = 2,
  Store = 3,
  Info = 4,
  Alliance = 5,
  Search = 6,
  Task = 7,
  Activity = 8,
  Hero = 9,
  Mail = 10,
  Chat = 11,
  Build = 12,
  Science = 13,
  Trade = 14,
  Position = 15,
  radarAlarm = 16,
  FastBuild = 17,
  Warning = 18,
  ChapterTask = 19,
  AllianceTaskShare = 20,
  Detect = 21,
  HeroDrop = 22,
  Visitor = 23,
  VIP = 24,
  Truck = 25,
  Alarm = 26,
  Train = 27,
  SeasonBuild = 28,
  DispatchTask = 29
}
ScienceTab = {
  Resource = 1,
  Fight = 2,
  AllianceDevelop = 101,
  AllianceFight = 102,
  AllianceDefense = 103,
  AllianceBuild = 104
}
ResourceTypeScience = {
  [ResourceType.Metal] = 731000,
  [ResourceType.Oil] = 751000,
  [ResourceType.Water] = 732000
}
ResourceTypeTxt = {
  [RewardType.METAL] = "100013",
  [RewardType.OIL] = "100014",
  [RewardType.WATER] = "100546",
  [RewardType.ELECTRICITY] = "100002",
  [RewardType.FOOD] = "100000",
  [RewardType.GOLD] = "100183",
  [RewardType.SAPPHIRE] = "390967",
  [RewardType.PVE_POINT] = "400011",
  [RewardType.DETECT_EVENT] = "140073",
  [RewardType.FORMATION_STAMINA] = "100510",
  [RewardType.WOOD] = "180265",
  [RewardType.PVE_STAMINA] = "100510",
  [RewardType.FLINT] = "resource_name004",
  [RewardType.OBSIDIAN] = "resource_name003",
  [ResourceType.Gold] = "100183"
}
UIScienceSortList = {
  ScienceTab.Resource,
  ScienceTab.Fight
}
ScienceResearchUseGold = {
  NoUseGold = 0,
  UseGold = 1,
  Free = 2
}
ScienceRecommendType = {
  None = 0,
  Commend1 = 1,
  Commend2 = 2
}
IsGold = {NoUseGold = 0, UseGold = 1}
AllianceButtonType = {
  None = 0,
  AllianceBattle = 1,
  AllianceBuilding = 2,
  AllianceHelp = 3,
  AllianceGift = 4,
  AllianceSalary = 5,
  AllianceScience = 6,
  AllianceShop = 7,
  AllianceSetting = 8,
  AllianceList = 9,
  AllianceRank = 10,
  AllianceCheck = 11,
  AllianceInvite = 12,
  AllianceQuit = 13,
  AllianceMail = 14,
  AllianceAnnounce = 15,
  AllianceMember = 16,
  EverydayTask = 17,
  AllianceCity = 18,
  BecomeLeader = 19,
  AlLeaderElect = 20,
  AllianceTask = 21,
  AllianceMoveInvite = 22
}
PLayerInfoButtonType = {
  None = 0,
  CopyID = 1,
  Account = 2,
  Setting = 3,
  RankList = 4,
  Service = 5
}
OldSoldierType = {
  FootSoldier = 1,
  BowSoldier = 2,
  CarSoldier = 3
}
BuildingTypes = {
  FUN_BUILD_MAIN = 10100000,
  FUN_BUILD_BUSINESS_CENTER = 401000,
  FUN_BUILD_SCIENE = 10123000,
  FUN_BUILD_SMITHY = 10106000,
  FUN_BUILD_CONDOMINIUM = 409000,
  FUN_BUILD_HOSPITAL = 411000,
  FUN_BUILD_STONE = 412000,
  FUN_BUILD_OIL = 413000,
  FUN_BUILD_RADAR_CENTER = 10113000,
  FUN_BUILD_ARROW_TOWER = 418000,
  FUN_BUILD_CAR_BARRACK = 423000,
  FUN_BUILD_INFANTRY_BARRACK = 424000,
  FUN_BUILD_AIRCRAFT_BARRACK = 425000,
  FUN_BUILD_TRAINFIELD_1 = 427000,
  FUN_BUILD_TRAINFIELD_2 = 793000,
  FUN_BUILD_TRAINFIELD_3 = 794000,
  FUN_BUILD_TRAINFIELD_4 = 795000,
  FUN_BUILD_WATER = 432000,
  FUN_BUILD_MARKET = 435000,
  FUN_BUILD_ROAD = 436000,
  FUN_BUILD_ELECTRICITY_STORAGE = 437000,
  FUN_BUILD_WATER_STORAGE = 438000,
  FUN_BUILD_OIL_STORAGE = 439000,
  FUN_BUILD_IRON_STORAGE = 441000,
  FUN_BUILD_WIND_TURBINE = 444000,
  FUN_BUILD_SOLAR_POWER_STATION = 447000,
  FUN_BUILD_DRONE = 477000,
  FUN_BUILD_VILLA = 700000,
  APS_BUILD_FARM = 701000,
  APS_BUILD_FARM_FIELD = 702000,
  APS_BUILD_PASTURE = 703000,
  APS_BUILD_PASTURE_FIELD = 704000,
  FUN_BUILD_FACTORY_STONE = 705000,
  FUN_BUILD_METALLURGY = 706000,
  FUN_BUILD_FOOD = 707000,
  FUN_BUILD_OIL_REFINERY = 708000,
  FUN_BUILD_INTEGRATED_FACTORY = 709000,
  FUN_BUILD_TRADING_CENTER = 710000,
  FUN_BUILD_FOODSHOP = 711000,
  FUN_BUILD_PRINT_FACTORY = 712000,
  FUN_BUILD_INFORMATION_CENTER = 713000,
  FUN_BUILD_COLD_STORAGE = 714000,
  FUN_BUILD_COMPREHENSIVE_STORAGE = 715000,
  FUN_BUILD_DEFENCE_CENTER = 716000,
  FUN_BUILD_FOOD_1 = 717000,
  FUN_BUILD_FOOD_2 = 718000,
  APS_BUILD_PASTURE_OSTRICH = 719000,
  APS_BUILD_PASTURE_CATTLE = 720000,
  APS_BUILD_PASTURE_SANDWORM = 721000,
  APS_BUILD_PUB = 722000,
  FUN_BUILD_FORGE = 429000,
  FUN_BUILD_ELECTRICITY = 431000,
  FUN_BUILD_HONOR_HALL = 446000,
  FUN_BUILD_BUILDING_CENTER = 448000,
  FUN_BUILD_OFFICER = 483000,
  FUN_BUILD_RECHARGE_GARAGE = 445000,
  FUN_BUILD_DOME = 449000,
  FUND_BUILD_ALLIANCE_CENTER = 10106000,
  APS_BUILD_WORMHOLE_MAIN = 791000,
  APS_BUILD_WORMHOLE_SUB = 792000,
  APS_BUILD_WORMHOLE_EXPORT = 792001,
  FUN_BUILD_TEMP_WIND_POWER_PLANT = 796000,
  FUN_BUILD_PVE_FACTORY = 723000,
  FUN_BUILD_GROCERY_STORE = 724000,
  FUN_BUILD_SCIENCE_PART = 725000,
  FUN_BUILD_BARRACKS = 797000,
  FUN_BUILD_POLICE_STATION = 726000,
  FUN_BUILD_MARS_CAMP = 727000,
  FUN_BUILD_LIBRARY = 728000,
  FUN_BUILD_KONBINI = 729000,
  FUN_BUILD_GREEN_CRYSTAL = 730000,
  FUN_BUILD_HERO_MONUMENT = 731000,
  FUN_BUILD_HERO_BOUNTY = 732000,
  FUN_BUILD_HERO_OFFICE = 733000,
  FUN_BUILD_HERO_BAR = 734000,
  WORM_HOLE_CROSS = 735000,
  FUN_BUILD_OUT_WOOD = 736000,
  FUN_BUILD_OUT_STONE = 737000,
  SEASON_DESERT_RESISTANCE_1 = 741000,
  SEASON_DESERT_MAX_DESERT_1 = 742000,
  SEASON_DESERT_MAX_FORMATION_SIZE_1 = 743000,
  SEASON_DESERT_ARMY_ATTACK_1 = 744000,
  SEASON_DESERT_ARMY_DEFEND_1 = 745000,
  SEASON_DESERT_RESISTANCE_2 = 746000,
  SEASON_DESERT_RESISTANCE_3 = 747000,
  SEASON_DESERT_RESISTANCE_4 = 748000,
  SEASON_DESERT_MAX_DESERT_2 = 749000,
  SEASON_DESERT_MAX_FORMATION_SIZE_2 = 750000,
  SEASON_DESERT_ARMY_ATTACK_2 = 751000,
  SEASON_DESERT_ARMY_DEFEND_2 = 752000,
  SEASON_DESERT_BUILD_DRONE_1 = 753000,
  SEASON_DESERT_BUILD_DRONE_2 = 754000,
  SEASON_DESERT_NEW_MAX_DESERT_1 = 755000,
  SEASON_DESERT_NEW_MAX_DESERT_2 = 756000,
  EDEN_WORM_HOLE_1 = 757000,
  EDEN_WORM_HOLE_2 = 758000,
  EDEN_WORM_HOLE_3 = 759000,
  ALLIANCE_RES_1 = 10000,
  ALLIANCE_RES_2 = 11000,
  ALLIANCE_RES_3 = 12000,
  ALLIANCE_RES_4 = 20000,
  ALLIANCE_RES_5 = 21000,
  ALLIANCE_RES_6 = 22000,
  ALLIANCE_RES_7 = 30000,
  ALLIANCE_RES_8 = 31000,
  ALLIANCE_RES_9 = 32000,
  SEASON_CAREER_BUILD = 10218000,
  ALLIANCE_FLAG_BUILD1 = 80000,
  ALLIANCE_FLAG_BUILD2 = 81000,
  ALLIANCE_FLAG_BUILD3 = 82000,
  ALLIANCE_FLAG_BUILD4 = 83000,
  ALLIANCE_FLAG_BUILD5 = 84000,
  SEASON_STOVE_CENTER = 200000,
  SEASON_STOVE_CENTER_CARRIER = 201000,
  SEASON_ARES_MISSILE = 202000,
  SEASON_ARES_MISSILE_GLOBAL = 202001,
  SEASON_ARES_MISSILE_S4 = 202002,
  CAMP_SEASON_MISSILE = 202003,
  GODDESS_MUMMY_TARGET = 203000,
  CAMP_GODDESS_MUMMY_TARGET = 203001,
  CAMP_TeslaCoil = 500001,
  CAMP_Reinforcement = 500002,
  SEASON_MUMMY_CENTER = 300000,
  SEASON_MUMMY_CENTER_CARRIER = 301000,
  SEASON_POWER_CENTER = 400000,
  SEASON_POWER_CENTER_CARRIER = 401000,
  SEASON_POWER_CENTER_PLUGIN1 = 402000,
  SEASON_POWER_CENTER_PLUGIN2 = 403000,
  SEASON_POWER_CENTER_PLUGIN3 = 404000,
  SEASON_MUMMY_CENTER_PLUGIN_JS = 302000,
  SEASON_MUMMY_CENTER_PLUGIN_KTT = 303000,
  SEASON_MUMMY_CENTER_PLUGIN_YLC = 304000,
  SEASON_MUMMY_CENTER_PLUGIN_SB = 305000,
  ALLIANCE_CENTER_1 = 41000,
  ALLIANCE_CENTER_2 = 42000,
  ALLIANCE_CENTER_3 = 43000,
  ALLIANCE_CENTER_4 = 44000,
  ALLIANCE_FRONT_BUILD_1 = 45000,
  ALLIANCE_FRONT_BUILD_2 = 46000,
  ALLIANCE_FRONT_BUILD_3 = 47000,
  ALLIANCE_ACT_RES_1 = 50000,
  ALLIANCE_ACT_RES_2 = 51000,
  ALLIANCE_ACT_RES_3 = 52000,
  EDEN_ALLIANCE_ACT_RES_1 = 60000,
  EDEN_ALLIANCE_ACT_RES_2 = 61000,
  EDEN_ALLIANCE_ACT_RES_3 = 62000,
  LW_ALLIANCE_WAR_CAMP_2 = 91003,
  LW_BUILD_LIBRARY = 10102000,
  LW_BUILD_FARMLAND = 10201000,
  LW_BUILD_QUARRY = 10202000,
  LW_BUILD_BAKERY = 10203000,
  LW_BUILD_IRON_MILL = 10204000,
  LW_BUILD_TRADING_POST = 10205000,
  LW_BUILD_STEEL_MILL = 10206000,
  LW_BUILD_GOLD_MILL = 10207000,
  LW_BUILD_PARKINGLOT = 10105000,
  LW_BUILD_PARKINGLOT_TWO = 10125000,
  LW_BUILD_PARKINGLOT_THREE = 10135000,
  LW_BUILD_PARKINGLOT_FOUR = 10145000,
  Lw_BUILD_BATTLE_FEATURE_ENTRY = 10114000,
  LW_BUILD_MILITARY_CAMP = 10103000,
  LW_BUILD_ARMY_YARD = 10104000,
  LW_BUILD_BATTLE_HANGUP_REWARD = 10115000,
  LW_BUILD_GATE = 10107000,
  LW_BUILD_SMITH_SHOP = 10101000,
  LW_BUILD_PUB = 10120000,
  LW_BUILD_WORKER_HOUSE = 10119000,
  LW_BUILD_SHOP = 10121000,
  LW_BUILD_HERO = 10122000,
  LW_BUILD_RADAR = 10113000,
  LW_BUILD_ALLIANCE_CENTER = 10106000,
  LW_CITY_RUIN = 10301000,
  LW_CITY_RUIN_1 = 10301001,
  LW_BUILD_HOSPITL = 10124000,
  LW_FIRST_PAY = 10126000,
  LW_BUILD_RAILWAY_STATION = 10127000,
  LW_GIFT_PACKAGE = 10128000,
  LW_BUILD_TRUCK_STATION_1 = 10138000,
  LW_BUILD_TRUCK_STATION_2 = 10139000,
  LW_BUILD_TRUCK_STATION_3 = 10140000,
  LW_BUILD_TRUCK_STATION_4 = 10141000,
  LW_COIN_STORAGE = 10208000,
  LW_STRENGTHEN_FACTORY = 10302000,
  LW_HERO_STRATEGY_HALL = 10303000,
  LW_BUILD_SMELTERY = 10209000,
  LW_BUILD_TRAINING_CENTER = 10210000,
  LW_BUILD_MATERIALS_WORKERSHOP = 10211000,
  LW_BUILD_FLAG = 10212000,
  LW_BUILD_TANKCENTER = 10116000,
  LW_BUILD_ARTILLERYCENTER = 10117000,
  LW_BUILD_AIRCRAFTCENTER = 10118000,
  LW_BUILD_COUNT_BATTLE = 10213000,
  LW_BUILD_SQUAD_EQUIP_FACTORY = 10214000,
  LW_BUILD_PVP_ARENA = 10215000,
  LW_BUILE_SCIENCE_TWO = 10142000,
  LW_BUILD_WORLDTREND = 10217000,
  LW_BUILD_TACTICAL_CENTER = 10143000,
  LW_DECORATION_EXHIBITION = 10219000,
  LW_BUILD_PYRAMID = 10129000,
  LW_BUILD_TALENT_HALL = 10220000,
  LW_BUILD_DECORATION = 103515000,
  LW_BUILD_DECORATION_PYRAMID = 103516000,
  LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY = 760000,
  LW_BUILDING_SEASON_FARMLAND_CTIY_1 = 761000,
  LW_BUILDING_SEASON_FARMLAND_CTIY_2 = 762000,
  LW_BUILDING_SEASON_FARMLAND_CTIY_3 = 763000,
  LW_BUILDING_SEASON_FARMLAND_CTIY_4 = 764000,
  LW_BUILDING_SEASON_FARMLAND_CTIY_5 = 765000,
  LW_BUILDING_SEASON_TANK_CTIY = 766000,
  LW_BUILDING_SEASON_PLANE_CTIY = 767000,
  LW_BUILDING_SEASON_MISSILE_CTIY = 768000,
  LW_BUILDING_SEASON2_PERSONAL_FURNACE = 770000,
  LW_BUILDING_SEASON2_FARMLAND_CTIY_1 = 771000,
  LW_BUILDING_SEASON2_FARMLAND_CTIY_2 = 772000,
  LW_BUILDING_SEASON2_FARMLAND_CTIY_3 = 773000,
  LW_BUILDING_SEASON2_FARMLAND_CTIY_4 = 774000,
  LW_BUILDING_SEASON2_FARMLAND_CTIY_5 = 775000,
  LW_BUILDING_SEASON2_TANK_CTIY = 776000,
  LW_BUILDING_SEASON2_PLANE_CTIY = 777000,
  LW_BUILDING_SEASON2_MISSILE_CTIY = 778000,
  LW_BUILDING_SEASON5_RESEARCH = 821000,
  LW_BUILDING_SEASON5_CTIY_1 = 822000,
  LW_BUILDING_SEASON5_CTIY_2 = 823000,
  LW_BUILDING_SEASON5_CTIY_3 = 824000,
  LW_BUILDING_SEASON5_CTIY_4 = 825000,
  LW_BUILDING_SEASON5_CTIY_5 = 826000,
  LW_BUILDING_SEASON5_SHOP = 827000,
  LW_BUILDING_SEASON5_TANK_CTIY = 828000,
  LW_BUILDING_SEASON5_PLANE_CTIY = 829000,
  LW_BUILDING_SEASON5_MISSILE_CTIY = 830000,
  LW_BUILD_DISPATCH_TASK = 10144000,
  LW_BUILD_PETROLEUM = 10221000,
  LW_BUILD_HERO_COUNTDOWN = 10222000,
  LW_BUILDING_REBIRTH_HOSPITAL = 10231000,
  LW_BUILD_BLACKMARKET = 10223000,
  LW_BUILD_ACTIVITY_ALARM_CLOCK = 10224000,
  LW_BUILD_TREASURE_CHEST = 10225000,
  LW_BUILE_SCIENCE_THREE = 10234000,
  LW_BUILD_TACTICAL_COMPONENT = 10233000,
  LW_BUILD_ALERTTOWER = 10216000,
  LW_BUILDING_TACTICAL_CHIP_FACTORY = 10232000,
  LW_BUILDING_CURSE_RESEARCH = 780000,
  LW_BUILDING_BLESSING_FOUNTAIN_1 = 781000,
  LW_BUILDING_BLESSING_FOUNTAIN_2 = 782000,
  LW_BUILDING_BLESSING_FOUNTAIN_3 = 783000,
  LW_BUILDING_BLESSING_FOUNTAIN_4 = 784000,
  LW_BUILDING_BLESSING_FOUNTAIN_5 = 785000,
  LW_BUILD_ALTAR_MUMMY = 786000,
  LW_BUILD_ARMY_YARD_MUMMY_S3 = 787000,
  LW_BUILD_ARMY_YARD_MUMMY_S4 = 806000,
  LW_BUILD_ARMY_YARD_MUMMY_S5 = 831000,
  LW_BUILD_ARMY_YARD_MUMMY_S6 = 851000,
  LW_BUILD_SEASON6_INSTITUTE = 841000,
  LW_BUILD_SEASON6_QUARTZ_FACTORY1 = 842000,
  LW_BUILD_SEASON6_QUARTZ_FACTORY2 = 843000,
  LW_BUILD_SEASON6_QUARTZ_FACTORY3 = 844000,
  LW_BUILD_SEASON6_QUARTZ_FACTORY4 = 845000,
  LW_BUILD_SEASON6_WEEK_CARD = 846000,
  LW_BUILD_SEASON6_BUILD1 = 847000,
  LW_BUILD_SEASON6_BUILD2 = 848000,
  LW_BUILD_SEASON6_BUILD3 = 849000,
  LW_BUILD_SEASON6_BUILD4 = 850000,
  LW_BUILD_SEASON4_INSTITUTE = 800000,
  LW_BUILD_SEASON4_QUARTZ_FACTORY1 = 801000,
  LW_BUILD_SEASON4_QUARTZ_FACTORY2 = 802000,
  LW_BUILD_SEASON4_QUARTZ_FACTORY3 = 803000,
  LW_BUILD_SEASON4_QUARTZ_FACTORY4 = 804000,
  LW_BUILD_SEASON4_WEEK_CARD = 805000,
  LW_BUILD_SEASON4_LIGHTHOUSE = 807000,
  LW_BUILD_SEASON4_POWER_STATION1 = 808000,
  LW_BUILD_SEASON4_POWER_STATION2 = 809000,
  LW_BUILD_SEASON4_POWER_STATION3 = 810000,
  LW_BUILD_SEASON4_POWER_STATION4 = 811000,
  LW_BUILD_DOMINATOR_MAIN = 10236000,
  LW_BUILD_DOMINATOR_TRAIN = 10235000,
  LW_BUILD_SEASON_BIG_PHOTO = 10228000,
  LW_BUILD_RACE_ENTRANCE = 10229000,
  LW_MO_FIE_HERO = 10130000,
  LW_BUILD_TREASURE_CHEST_1 = 10146000,
  LW_BUILD_TREASURE_CHEST_2 = 10147000,
  LW_BUILD_TREASURE_CHEST_3 = 10148000,
  LW_BUILD_TREASURE_CHEST_4 = 10149000,
  LW_BUILD_DIG_GAME = 10226000,
  LW_BUILD_SUPPLIES_SEARCH_1 = 10150000,
  LW_BUILD_SUPPLIES_SEARCH_2 = 10151000,
  LW_BUILD_SUPPLIES_SEARCH_3 = 10152000,
  LW_BUILD_SKY_BATTLE_1 = 10153000,
  LW_BUILD_SKY_BATTLE_2 = 10154000,
  LW_BUILD_SKY_BATTLE_3 = 10155000,
  LW_BUILD_SKY_BATTLE_4 = 10156000,
  LW_T11_Research = 10227000,
  LW_CIVILIZATION_SPARK = 10230000
}
DragonBuildingTypes = {
  DragonEmptyBuild = 10000,
  DragonWarBuild = 10010,
  DragonCenterBuild = 10020,
  DragonAllianceFlagSelf = 10030,
  DragonAllianceFlagOther = 10040,
  DragonHospitalBuild = 10050
}
DragonPlayerState = {
  None = 0,
  Main = 1,
  Sub = 2
}
HSRChartType = {
  Today = 1,
  Week = 2,
  Month = 3
}
HSRSellType = {
  Consign = 1,
  Dump = 2,
  BeLooted = 3,
  Failure = 4
}
HSRSellState = {
  Unboard = 1,
  Loading = 2,
  Selling = 3,
  Finish = 4
}
HSRDirection = {
  None = -1,
  East = 0,
  West = 1,
  South = 2,
  North = 3
}
HSRStationSortType = {
  Station = 0,
  Price = 1,
  Count = 2,
  MAX = 3
}
CarriagePos = {Locomotive = 0, Carriage = 1}
ServerType = {
  NORMAL = 0,
  DRAGON_BATTLE_FIGHT_SERVER = 8,
  EDEN_SERVER = 9,
  CROSS_THRONE = 10
}
ServerEnum = {
  None = 0,
  Source = 1,
  Login = 2,
  View = 3
}
ServerBattleType = {
  None = 0,
  VS4 = 4,
  VS8 = 8,
  VSCamp = 2
}
WorldSeasonBuild = {
  [BuildingTypes.SEASON_DESERT_RESISTANCE_1] = 1,
  [BuildingTypes.SEASON_DESERT_MAX_DESERT_1] = 2,
  [BuildingTypes.SEASON_DESERT_MAX_FORMATION_SIZE_1] = 3,
  [BuildingTypes.SEASON_DESERT_ARMY_ATTACK_1] = 4,
  [BuildingTypes.SEASON_DESERT_ARMY_DEFEND_1] = 5,
  [BuildingTypes.SEASON_DESERT_RESISTANCE_2] = 6,
  [BuildingTypes.SEASON_DESERT_RESISTANCE_3] = 7,
  [BuildingTypes.SEASON_DESERT_RESISTANCE_4] = 8,
  [BuildingTypes.SEASON_DESERT_MAX_DESERT_2] = 9,
  [BuildingTypes.SEASON_DESERT_MAX_FORMATION_SIZE_2] = 10,
  [BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2] = 11,
  [BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2] = 12,
  [BuildingTypes.SEASON_DESERT_BUILD_DRONE_1] = 13,
  [BuildingTypes.SEASON_DESERT_BUILD_DRONE_2] = 14,
  [BuildingTypes.SEASON_DESERT_NEW_MAX_DESERT_1] = 15,
  [BuildingTypes.SEASON_DESERT_NEW_MAX_DESERT_2] = 16
}
SeasonMapType = {
  Nothing = 0,
  Desert = 1,
  CityStronghold = 2,
  Snow = 3,
  Mummy = 4,
  Darkness = 5,
  NineNation = 6,
  NineNationRainforest = 60001
}
SeasonTrendState = {
  None = 0,
  Expire = 1,
  Open = 2,
  NotOpen = 3
}
SeasonTrendJumpType = {
  Function = 1,
  City = 2,
  CardPool = 3
}
HeroCamp = {
  NEW_HUMAN = 0,
  MAFIA = 1,
  UNION = 2,
  ZELOT = 3
}
FactoryBuild = {
  BuildingTypes.FUN_BUILD_FOODSHOP,
  BuildingTypes.FUN_BUILD_METALLURGY,
  BuildingTypes.FUN_BUILD_FOOD,
  BuildingTypes.FUN_BUILD_OIL_REFINERY,
  BuildingTypes.FUN_BUILD_FOOD_1,
  BuildingTypes.FUN_BUILD_FOOD_2,
  BuildingTypes.FUN_BUILD_PVE_FACTORY,
  BuildingTypes.FUN_BUILD_FACTORY_STONE
}
BarracksBuild = {
  BuildingTypes.FUN_BUILD_CAR_BARRACK,
  BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,
  BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK
}
CollectBuild = {
  BuildingTypes.FUN_BUILD_CONDOMINIUM,
  BuildingTypes.FUN_BUILD_STONE,
  BuildingTypes.FUN_BUILD_OIL,
  BuildingTypes.FUN_BUILD_WATER,
  BuildingTypes.FUN_BUILD_WIND_TURBINE,
  BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION,
  BuildingTypes.FUN_BUILD_ELECTRICITY,
  BuildingTypes.FUN_BUILD_GROCERY_STORE
}
AllianceTeamType = {
  ATTACK_BOSS = 0,
  ATTACK_BUILDING = 1,
  ATTACK_CITY = 2,
  ATTACK_AL_CITY = 3,
  ATTACK_ALLIANCE_THRONE = 4,
  ATTACK_DRAGON_BUILDING = 5,
  ATTACK_SERVER_THRONE = 6,
  ATTACK_AL_CENTER = 7,
  ATTACK_CITY_STRONGHOLD = 8,
  ATTACK_EPIDEMIC_BUILDING = 10,
  ATTACK_EPIDEMIC_CITY = 11,
  ATTACK_OUTPOST = 12,
  ATTACK_ZWL = 13
}
MarchStatus = {
  DEFAULT = -1,
  STATION = 0,
  MOVING = 1,
  ATTACKING = 2,
  COLLECTING = 3,
  BACK_HOME = 4,
  CHASING = 5,
  WAIT_RALLY = 6,
  IN_TEAM = 7,
  ASSISTANCE = 8,
  IN_WORM_HOLE = 9,
  SAMPLING = 10,
  PICKING = 11,
  GOLLOES_EXPLORING = 12,
  BUILD_WORM_HOLE = 13,
  DESTROY_WAIT = 14,
  BUILD_ALLIANCE_BUILDING = 15,
  TRANSPORT_BACK_HOME = 16,
  CROSS_SERVER = 17,
  TRAIN_PULL_IN = 18,
  TREASURE_DIGGING = 19,
  COLLECTING_ASSISTANCE = 20,
  ZOMBIE_RUSH_WAITING = 21,
  BERSERK_BOSS_WAITING = 22,
  BEHEMOTH_ATTACK_CITY = 23,
  BEHEMOTH_ARRIVING = 24
}
GotoType = {
  Build = 1,
  Science = 2,
  Package = 3,
  Activity = 4
}
MarchTargetType = {
  STATE = 0,
  ATTACK_MONSTER = 1,
  COLLECT = 2,
  BACK_HOME = 3,
  ATTACK_BUILDING = 4,
  ATTACK_ARMY = 5,
  JOIN_RALLY = 6,
  RALLY_FOR_BOSS = 7,
  RALLY_FOR_BUILDING = 8,
  RANDOM_MOVE = 9,
  ATTACK_ARMY_COLLECT = 10,
  ATTACK_CITY = 11,
  RALLY_FOR_CITY = 12,
  ASSISTANCE_BUILD = 13,
  ASSISTANCE_CITY = 14,
  ATTACK_ROAD = 15,
  GO_WORM_HOLE = 16,
  SCOUT_CITY = 17,
  SCOUT_BUILDING = 18,
  SCOUT_ARMY_COLLECT = 19,
  EXPLORE = 20,
  SAMPLE = 21,
  SCOUT_TROOP = 22,
  PICK_GARBAGE = 23,
  RESOURCE_HELP = 24,
  ATTACK_ALLIANCE_CITY = 25,
  ASSISTANCE_ALLIANCE_CITY = 26,
  RALLY_FOR_ALLIANCE_CITY = 27,
  SCOUT_ALLIANCE_CITY = 28,
  GOLLOES_EXPLORE = 29,
  GOLLOES_TRADE = 30,
  BUILD_WORM_HOLE = 31,
  TRANSPORT_ACT_BOSS = 32,
  DIRECT_ATTACK_ACT_BOSS = 33,
  BUILD_ALLIANCE_BUILDING = 34,
  COLLECT_ALLIANCE_BUILD_RESOURCE = 35,
  CROSS_SERVER_WORM = 36,
  TRAIN_MOVE = 37,
  ATTACK_TRAIN = 38,
  ASSIST_TRAIN = 39,
  SCOUT_TRAIN = 40,
  RALLY_THRONE = 41,
  SCOUT_THRONE = 42,
  ATTACK_THRONE = 43,
  ASSISTANCE_THRONE = 44,
  ATTACK_DRAGON_BUILDING = 45,
  RALLY_DRAGON_BUILDING = 46,
  SCOUT_DRAGON_BUILDING = 47,
  ASSISTANCE_DRAGON_BUILDING = 48,
  SCOUT_DRAGON_SCORE = 49,
  DETECT_TREASURE = 50,
  ATTACK_SERVER_THRONE_BUILDING = 51,
  ASSISTANCE_SERVER_THRONE_BUILDING = 52,
  SCOUT_SERVER_THRONE_BUILDING = 53,
  RALLY_SERVER_THRONE_BUILDING = 54,
  RUNNING_BOSS = 55,
  RUNNING_BOSS_MOVING = 56,
  RUNNING_BOSS_ATTACK_CITY = 57,
  ATTACK_DESERT = 58,
  ASSISTANCE_DESERT = 59,
  SCOUT_DESERT = 60,
  TRAIN_DESERT = 61,
  ATTACK_ALLIANCE_BUILDING = 62,
  RALLY_ALLIANCE_BUILDING = 63,
  SCOUT_ALLIANCE_BUILDING = 64,
  ASSISTANCE_ALLIANCE_BUILDING = 65,
  ATTACK_EMPTY_DESERT = 66,
  ALLIANCE_CITY_BOSS = 67,
  ATTACK_WINTER_ENTITY = 68,
  ASSISTANCE_WINTER_ENTITY = 69,
  SCOUT_WINTER_ENTITY = 70,
  ATTACK_CITY_STRONGHOLD = 71,
  RALLY_CITY_STRONGHOLD = 72,
  ASSISTANCE_CITY_STRONGHOLD = 73,
  SCOUT_CITY_STRONGHOLD = 74,
  ALLIANCE_RESOURCE_COLLECT = 75,
  SCOUT_TREAT = 76,
  ZOMBIE_BOSS_ATTACK_CITY = 77,
  DARK_KNIGHT_CITY = 78,
  ACT_BERSERK_BOSS_ATTACK_THRONE = 79,
  DIRECT_ATTACK_ACT_BERSERK_BOSS = 80,
  SCOUT_SUPPLIES = 81,
  DIG_ICE_ALLY = 82,
  SEND_COAL = 83,
  BuildingNuclearPowerPlant = 85,
  SEASON_REPAIR_NUCLEAR = 85,
  DIG_ICE_ENEMY = 86,
  ASSISTANCE_WINTER_STORM_CITY = 87,
  SCOUT_WINTER_STORM_CITY = 88,
  ATTACK_WINTER_STORM_CITY = 89,
  BEHEMOTH_ATTACK_CITY = 90,
  ATTACK_BEHEMOTH = 92,
  MONSTER_INVASION_BOSS = 93,
  SEASON_FARMER_SEND_RES = 94,
  ZONE_MOBILIZATION_MOVE = 104,
  SCOUT_ZONE_MOBILIZATION_DONATE = 105,
  RALLY_SANDWORM = 95,
  SEASON_MUMMY_CONVERT = 96,
  ATTACK_CITY_TRADE = 98,
  SCOUT_CITY_TRADE = 99,
  ASSISTANCE_CITY_TRADE = 100,
  LOTTO_RECEIVE_BASE_REWARD = 101,
  GREEN = 102,
  FAKE_ATTACK = 103,
  RUNNING_MUMMY = 106,
  RALLY_MUMMY = 107,
  SAND_FISH_PATROL = 108,
  ATTACK_SANDWORM = 109,
  ATTACK_PLAYER_RUIN_BUILDING = 111,
  VALENTINE_RECEIVE_BASE_REWARD = 112,
  COLLECT_METEORITE = 113,
  ATTACK_METEORITE = 114,
  SCOUT_METEORITE = 115,
  ATTACK_EPIDEMIC_BUILDING = 116,
  ASSISTANCE_EPIDEMIC_BUILDING = 117,
  SCOUT_EPIDEMIC_BUILDING = 118,
  RALLY_EPIDEMIC_BUILDING = 119,
  ATTACK_EPIDEMIC_CITY = 120,
  ASSISTANCE_EPIDEMIC_CITY = 121,
  SCOUT_EPIDEMIC_CITY = 122,
  RALLY_EPIDEMIC_CITY = 123,
  PIC_EPIDEMIC_SCORE = 124,
  COLLECT_EPIDEMIC_RES = 126,
  DARKNESS_MONSTER_MOVE = 129,
  DARKNESS_MONSTER_ATTACK_CITY = 130,
  DARKNESS_MONSTER_ATTACK_AL_BUILDING = 131,
  ALLIANCE_BOSS_SAND_ATTACK_CITY = 132,
  ALLIANCE_RESCUE_ARRIVAL = 133,
  POWER_WORKER_BACK = 134,
  WHISTLE_MONSTER = 135,
  DETECT_ZOMBIE_BUS = 136,
  POWER_WORK_HELPER_CHARGE = 137,
  CHARGE_SUPPLIES = 138,
  CHARGE_GOLD_TREE = 139,
  ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE = 140,
  SKILL_SPREAD_VIRUS = 141,
  BLOODY_QUEEN_ATTACK_CITY = 142,
  CROSS_ATTACK_CITY = 143,
  CROSS_BACK_HOME = 144,
  CROSS_COLLECT = 145,
  CROSS_ATTACK_ARMY_COLLECT = 146,
  CROSS_ATTACK_MONSTER = 147,
  CROSS_SCOUT_CITY = 148,
  CROSS_BANK_ATTACK = 149,
  CROSS_BANK_DEPOSIT = 150,
  CROSS_ASSISTANCE_CITY = 151,
  CROSS_DIRECT_ATTACK_ACT_BOSS = 152,
  CROSS_ATTACK_CITY_STRONGHOLD = 153,
  CROSS_ASSISTANCE_CITY_STRONGHOLD = 154,
  CROSS_ATTACK_ALLIANCE_CITY = 155,
  CROSS_ASSISTANCE_ALLIANCE_CITY = 156,
  CROSS_FORTIFY_CITY_CHARGE = 157,
  REPAIR_OUTPOST = 162,
  ATTACK_OUTPOST_BUILDING = 163,
  ASSISTANCE_OUTPOST_BUILDING = 164,
  SCOUT_OUTPOST_BUILDING = 165,
  RALLY_OUTPOST_BUILDING = 166,
  ATTACK_CENTER_THRONE = 168,
  ASSISTANCE_CENTER_THRONE = 169,
  SCOUT_CENTER_THRONE = 170,
  RALLY_CENTER_THRONE = 171,
  CROSS_DIRECT_ATTACK_ACT_BERSERK_BOSS = 177,
  CROSS_DETECT_TREASURE = 182,
  RAINFOREST_THRONE_ATTACK = 183,
  RAINFOREST_THRONE_ASSISTANCE = 184,
  RAINFOREST_THRONE_SCOUT = 185,
  RAINFOREST_THRONE_RALLY = 186,
  ATTACK_ZWL_BUILDING = 178,
  ASSISTANCE_ZWL_BUILDING = 179,
  SCOUT_ZWL_BUILDING = 180,
  RALLY_ZWL_BUILDING = 181,
  PUZZLE_BOSS = 1001,
  DISPATCH_TASK = 1005,
  NORMAL_FAKE_MARCH = 1006,
  SCOUT_FAKE_MARCH = 1007,
  RESCUE_FAKE_MARCH = 1008,
  AOS_ALERT = 1009,
  SIMPLE_CITY_EVENT_ATTACK = 1010,
  SIMPLE_CITY_EVENT_COLLECT = 1011,
  ATTACK_CITY_ALTAR = 187,
  ASSISTANCE_CITY_ALTAR = 188
}
IsStartRally = {
  [MarchTargetType.RALLY_FOR_BOSS] = 1,
  [MarchTargetType.RALLY_FOR_BUILDING] = 2,
  [MarchTargetType.RALLY_FOR_CITY] = 3,
  [MarchTargetType.RALLY_FOR_ALLIANCE_CITY] = 4,
  [MarchTargetType.RALLY_THRONE] = 5,
  [MarchTargetType.RALLY_DRAGON_BUILDING] = 6,
  [MarchTargetType.RALLY_SERVER_THRONE_BUILDING] = 7,
  [MarchTargetType.RALLY_ALLIANCE_BUILDING] = 8,
  [MarchTargetType.RALLY_CITY_STRONGHOLD] = 9,
  [MarchTargetType.RALLY_EPIDEMIC_BUILDING] = 10,
  [MarchTargetType.RALLY_EPIDEMIC_CITY] = 11,
  [MarchTargetType.RALLY_OUTPOST_BUILDING] = 12,
  [MarchTargetType.RALLY_CENTER_THRONE] = 13,
  [MarchTargetType.RAINFOREST_THRONE_RALLY] = 14
}
MarchGoType = {
  Unknown = 0,
  Normal = 1,
  Monster = 2,
  Player = 3,
  City = 4,
  Collect = 5,
  Assistance = 6,
  RallyJoin = 7,
  RallyGo = 8,
  RallyBack = 9,
  Activity = 10,
  Scout = 11,
  Ruins = 12
}
AlarmEffect = {
  Pvp = 1,
  Pve = 2,
  Help = 3
}
AlarmType = {
  [MarchTargetType.AOS_ALERT] = AlarmEffect.Pvp,
  [MarchTargetType.ATTACK_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.CROSS_ATTACK_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.FAKE_ATTACK] = AlarmEffect.Pvp,
  [MarchTargetType.ATTACK_WINTER_STORM_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.ATTACK_EPIDEMIC_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.RALLY_FOR_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.RALLY_EPIDEMIC_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.ASSISTANCE_CITY] = AlarmEffect.Help,
  [MarchTargetType.ASSISTANCE_WINTER_STORM_CITY] = AlarmEffect.Help,
  [MarchTargetType.ASSISTANCE_EPIDEMIC_CITY] = AlarmEffect.Help,
  [MarchTargetType.DIG_ICE_ALLY] = AlarmEffect.Help,
  [MarchTargetType.DIG_ICE_ENEMY] = AlarmEffect.Pvp,
  [MarchTargetType.SCOUT_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.SCOUT_WINTER_STORM_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.SCOUT_EPIDEMIC_CITY] = AlarmEffect.Pvp,
  [MarchTargetType.RUNNING_BOSS_ATTACK_CITY] = AlarmEffect.Pve,
  [MarchTargetType.RUNNING_MUMMY] = AlarmEffect.Pve,
  [MarchTargetType.ZOMBIE_BOSS_ATTACK_CITY] = AlarmEffect.Pve,
  [MarchTargetType.ALLIANCE_BOSS_SAND_ATTACK_CITY] = AlarmEffect.Pve,
  [MarchTargetType.DARKNESS_MONSTER_ATTACK_CITY] = AlarmEffect.Pve
}
AlarmImagePatch = {
  [MarchTargetType.AOS_ALERT] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.CROSS_ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.FAKE_ATTACK] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.ATTACK_WINTER_STORM_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.ATTACK_EPIDEMIC_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.RALLY_FOR_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_jijie.png",
  [MarchTargetType.RALLY_EPIDEMIC_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_jijie.png",
  [MarchTargetType.ASSISTANCE_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_yuanzhu.png",
  [MarchTargetType.ASSISTANCE_WINTER_STORM_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_yuanzhu.png",
  [MarchTargetType.ASSISTANCE_EPIDEMIC_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_yuanzhu.png",
  [MarchTargetType.SCOUT_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_zhencha.png",
  [MarchTargetType.SCOUT_WINTER_STORM_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_zhencha.png",
  [MarchTargetType.SCOUT_EPIDEMIC_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_zhencha.png",
  [MarchTargetType.RUNNING_BOSS_ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.RUNNING_MUMMY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.ZOMBIE_BOSS_ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.DIG_ICE_ALLY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_yuanzhu.png",
  [MarchTargetType.DIG_ICE_ENEMY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.ALLIANCE_BOSS_SAND_ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png",
  [MarchTargetType.DARKNESS_MONSTER_ATTACK_CITY] = "Assets/Main/Sprites/UI/UILWAllianceAlarm/od_zjmgongjiyujing_gongji.png"
}
MarchTargetTypeShowTeamFallback = {
  [MarchTargetType.ASSISTANCE_CITY] = true,
  [MarchTargetType.ASSISTANCE_WINTER_STORM_CITY] = true
}
HospitalPanelStateType = {
  NoSoldier = 0,
  Treating = 1,
  Select = 2
}
EffectDefine = {
  TREAT_NUM_MAX_EFFECT_ADD = 73,
  TREAT_NUM_MAX_EFFECT = 57,
  CURE_RESOURCE_REDUCE = 108,
  TRADE_TEX_DECREASE_938 = 938,
  BUILD_QUEUE_NUM = 30050,
  OIL_SPEED = 30000,
  METAL_SPEED = 30001,
  NUCLEAR_SPEED = 30002,
  FOOD_SPEED = 30003,
  WATER_SPEED = 30004,
  HERO_ONE_KEY_OPEN = 30005,
  ELECTRICITY_SPEED = 30006,
  OIL_ELECTRICITY_SPEED = 30008,
  NUCLEAR_ELECTRICITY_SPEED = 30010,
  PEOPLE_MAX = 30007,
  HOS_MAX = 30009,
  TRAD_MAX = 30011,
  RD_ADD = 30013,
  OPERA_ADD = 30014,
  MAINTAIN_MAX_ADD = 30016,
  BUILD_ADD = 30017,
  ENVIR_SPEED = 30020,
  PEOPLE_SPEED = 30021,
  PEOPLE_SPEED_PER = 30022,
  MONEY_SPEED = 30023,
  MONEY_SPEED_PER = 30024,
  OIL_MAX_LIMIT = 30030,
  METAL_MAX_LIMIT = 30031,
  NUCLEAR_MAX_LIMIT = 30032,
  FOOD_MAX_LIMIT = 30033,
  WATER_MAX_LIMIT = 30034,
  OXYGEN_MAX_LIMIT = 30035,
  ELECTRICITY_MAX_LIMIT = 30036,
  ELECTRICITY_DEC = 30037,
  NUCLEAR_DEC = 30038,
  OIL_DEC = 30039,
  PVE_POINT_MAX_LIMIT = 30019,
  PEOPLE_REC_SPEED = 30040,
  FREEZER_STORAGE_MAX_LIMIT = 30044,
  WAREHOUSE_STORAGE_MAX_LIMIT = 30045,
  EARTH_ORDER_EXTRA_MONEY_ADD_PERCENT = 30046,
  EARTH_ORDER_EXTRA_MONEY_ADD_VALUE = 30093,
  WAREHOUSE_PROTECT_MAX_LIMIT = 30047,
  WATER_CAPACITY_ADD = 30064,
  METAL_CAPACITY_ADD = 30065,
  GAS_CAPACITY_ADD = 30066,
  METALLURGY_FACTORY_OUT_SPEED_ADD = 30067,
  CHEMISTRY_FACTORY_OUT_SPEED_ADD = 30068,
  PRINT_FACTORY_OUT_SPEED_ADD = 30069,
  BUILD_SPEED_ADD = 30070,
  SCIENCE_SPEED_ADD = 30071,
  WIND_ELECTRICITY_SPEED_ADD = 30072,
  WIND_ELECTRICITY_CAPACITY_ADD = 30073,
  HOTEL_MONEY_SPEED_ADD = 30074,
  HOUSE_MONEY_SPEED_ADD = 30075,
  METAL_SPEED_ADD = 30076,
  SOLAR_ELECTRICITY_SPEED_ADD = 30077,
  RESOURCE_PROTECT_CAPACITY_ADD = 30078,
  BUILD_ROAD_NUM_ADD = 30079,
  FREEZER_STORAGE_ADD = 30080,
  MONEY_SPEED_ADD = 30081,
  SOLAR_ELECTRICITY_CAPACITY_ADD = 30082,
  FIRE_ELECTRICITY_CAPACITY_ADD = 30083,
  FIRE_ELECTRICITY_SPEED_ADD = 30084,
  HOTEL_MONEY_CAPACITY_ADD = 30085,
  HOUSE_MONEY_CAPACITY_ADD = 30086,
  MONEY_CAPACITY_ADD = 30087,
  UNLOCK_WATER_GET = 30088,
  UNLOCK_GAS_GET = 30089,
  UNLOCK_METAL_GET = 30090,
  GAS_BUILD_COLLECT_SPEED_ADD = 30091,
  WATER_BUILD_COLLECT_SPEED_ADD = 30092,
  ADD_OSTRICH_NUM = 30052,
  ADD_COW_NUM = 30053,
  ADD_PIG_NUM = 30054,
  STORAGE_SHOP_REFRESH_TIME_REDUCE = 30026,
  ADD_FIELD_NUM = 30094,
  ADD_CAN_BUILD_NUM = 30095,
  ADD_WATER_BUILD_NUM = 30096,
  ADD_HOTEL_NUM = 30097,
  ADD_METAL_COLLECT_NUM = 30098,
  BUILD_TIME_REDUCE = 30099,
  RESEARCH_TIME_REDUCE = 30100,
  SEASON_BUILD_TIME_REDUCE = 30270,
  ROBOT_IN_FARM = 30101,
  ROBOT_IN_FACTORY = 30102,
  ROBOT_IN_PASTURE = 30103,
  ADD_SCIENCE_QUEUE = 30104,
  ADD_FARM_SPEED = 30105,
  ADD_PASTURE_SPEED = 30106,
  ADD_FACTORY_SPEED = 30107,
  EARTH_ORDER_VIP = 30108,
  GLOBAL_MONEY_EXTRA_PERCENT = 30109,
  EARTH_ORDER_UNLOCK = 30110,
  GLOBAL_HERO_EXP_EXTRA_PERCENT = 30111,
  TROOP_LIMIT_EXTRA = 30018,
  STORAGE_MAX_EXTRA = 30112,
  CAREER_ATTACK_CITY_COLLECT_ADD_PERCENT = 30137,
  CAREER_COLLECT_ADD_PERCENT = 30138,
  CAREER_JOIN_TEAM_SPEED_ADD_PERCENT = 30139,
  STORAGE_SHOP_ADD_MAX_NUM = 30191,
  HAS_UNCLAIMED_FREE_GOLLOES = 30192,
  MINE_CAVE_CAN_PREVIEW = 30203,
  STAMINA_COST_ADD = 30368,
  LW_SCOUT_SPEED_30502 = 30502,
  TANK_TRAIN_SPEED_ADD = 31000,
  ROBOT_TRAIN_SPEED_ADD = 31001,
  PLANE_TRAIN_SPEED_ADD = 31002,
  TANK_TRAIN_NUM_ADD = 31003,
  ROBOT_TRAIN_NUM_ADD = 31004,
  PLANE_TRAIN_NUM_ADD = 31005,
  DETECT_ARMY_SPEED = 31006,
  REPAIR_SPEED_ADD = 31007,
  ARMY_TRAIN_SPEED_ADD = 31008,
  ARMY_TRAIN_MAX_ADD = 31009,
  INFANTRY_UPGRADE_SWITCH = 31010,
  TANK_UPGRADE_SWITCH = 31011,
  PLANE_UPGRADE_SWITCH = 31012,
  ATTACK_ADD_BASE_ALL_ARMY = 35000,
  ATTACK_ADD_BASE_ARM_1 = 35001,
  ATTACK_ADD_BASE_ARM_2 = 35002,
  ATTACK_ADD_BASE_ARM_3 = 35003,
  HEALTH_ADD_BASE_ALL_ARMY = 35012,
  ATTACK_ADD_BUILD_ALL_ARMY = 35048,
  ATTACK_ADD_BUILD_ARM_1 = 35049,
  ATTACK_ADD_BUILD_ARM_2 = 35050,
  ATTACK_ADD_BUILD_ARM_3 = 35051,
  DEFENCE_ADD_BASE_ALL_ARMY = 35004,
  DEFENCE_ADD_BASE_ARM_1 = 35005,
  DEFENCE_ADD_BASE_ARM_2 = 35006,
  DEFENCE_ADD_BASE_ARM_3 = 35007,
  DEFENCE_ADD_BUILD_ALL_ARMY = 35052,
  DEFENCE_ADD_BUILD_ARM_1 = 35053,
  DEFENCE_ADD_BUILD_ARM_2 = 35054,
  DEFENCE_ADD_BUILD_ARM_3 = 35055,
  ATTACK_MONSTER = 35056,
  DEFENCE_MONSTER = 35057,
  GAS_COLLECT_SPEED = 30058,
  WATER_COLLECT_SPEED = 30059,
  CRYSTAL_COLLECT_SPEED = 30060,
  OIL_COLLECT_SPEED_PERCENT = 30061,
  WATER_COLLECT_SPEED_PERCENT = 30062,
  CRYSTAL_COLLECT_SPEED_PERCENT = 30063,
  MONEY_COLLECT_SPEED_PERCENT = 35109,
  WAR_ATTACK = 35064,
  WAR_DEFENCE = 35065,
  APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT = 35073,
  APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT = 35074,
  STAMINA_COST_DEC = 35111,
  STAMINA_MAX_LIMIT = 35117,
  TOWER_RANGE_ADD = 35122,
  TOWER_ATTACK_ADD = 35123,
  APS_FORMATION_SIZE = 40001,
  APS_FORMATION_SIZE_ENHANCE = 40002,
  APS_DEFENCE_FORMATION_SIZE = 40003,
  APS_DEFENCE_FORMATION_FIRST_HERO_COUNT = 40004,
  APS_DEFENCE_FORMATION_SECOND_HERO_COUNT = 40005,
  APS_DEFENCE_FORMATION_THIRD_HERO_COUNT = 40006,
  APS_DEFENCE_DOME_NUM = 40007,
  APS_DEFENCE_DOME_SPEED = 40008,
  ARMY_CARRY_WEIGHT_ADD_PERCENT = 40010,
  SIEGE_DAMAGE_ADD_PERCENT = 40011,
  MAIN_SHIELD = 40012,
  APS_ALLIANCE_TEAM_MAX_ARMY = 40014,
  APS_FORMATION_FIRST_HERO_COUNT = 40016,
  APS_FORMATION_SECOND_HERO_COUNT = 40017,
  APS_FORMATION_THIRD_HERO_COUNT = 40018,
  APS_FORMATION_FORTH_HERO_COUNT = 40019,
  ARMY_SPEED_ADD = 40020,
  APS_WORM_SPEED_ADD_PERCENT = 40021,
  APS_SCOUT_FORMATION_SIZE = 40022,
  APS_NORMAL_FORMATION_1_ATK = 40036,
  APS_NORMAL_FORMATION_2_ATK = 40037,
  APS_NORMAL_FORMATION_3_ATK = 40038,
  APS_NORMAL_FORMATION_4_ATK = 40039,
  APS_NORMAL_FORMATION_1_DEF = 40040,
  APS_NORMAL_FORMATION_2_DEF = 40041,
  APS_NORMAL_FORMATION_3_DEF = 40042,
  APS_NORMAL_FORMATION_4_DEF = 40043,
  APS_NORMAL_FORMATION_1_FORMATION_COUNT = 40044,
  APS_NORMAL_FORMATION_2_FORMATION_COUNT = 40045,
  APS_NORMAL_FORMATION_3_FORMATION_COUNT = 40046,
  APS_NORMAL_FORMATION_4_FORMATION_COUNT = 40047,
  STAMINA_RECOVER_SPEED_ADD = 40050,
  APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_PERCENT = 40083,
  APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_PERCENT = 40084,
  APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_PERCENT = 40085,
  APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_PERCENT = 40086,
  APS_NORMAL_FORMATION_1_MARCH_SPEED_ADD_PERCENT = 40087,
  APS_NORMAL_FORMATION_2_MARCH_SPEED_ADD_PERCENT = 40088,
  APS_NORMAL_FORMATION_3_MARCH_SPEED_ADD_PERCENT = 40089,
  APS_NORMAL_FORMATION_4_MARCH_SPEED_ADD_PERCENT = 40090,
  APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_NUM = 40091,
  APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_NUM = 40092,
  APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_NUM = 40093,
  APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_PNUM = 40094,
  APS_SEASON_DESERT_NUM_ADD = 41000,
  APS_SEASON_DESERT_RESISTANCE = 41001,
  APS_SEASON_VIRUS_EFFECT = 100200,
  APS_ALLIANCE_ARMS_USE_NUM = 220,
  APS_ARMY_NUM_MAX = 40049,
  LW_SOLDIER_MAX_STOCK = 30122,
  LW_MUMMY_MAX_STOCK = 94064,
  LW_MUMMY_MAX_STOCK_ADD = 94065,
  APS_ALCOMPETE_ACT_UNLOCK_BOX_2 = 92001,
  APS_ALCOMPETE_ACT_UNLOCK_BOX_3 = 92002,
  APS_ALCOMPETE_ACT_UNLOCK_BOX_4 = 92018,
  ALCOMPETE_SCORE_GACHA_UNLOCK = 92019,
  GREEN_CTRSTAL_SPEED_ADD = 30118,
  FARMER_IRRIGATE_FRAM = 30147,
  FARMER_IRRIGATE_PASTURE = 30148,
  TRADER_EXTRA_FARM_BOX = 30151,
  ALLIANCE_STORAGE_MAX = 30143,
  SAPPHIRE_PRODUCT_SPEED_PERCENT = 30144,
  SAPPHIRE_PRODUCT_SPEED_NUM = 30145,
  KONBINI_EXTRA_FREE_COUNT = 30025,
  KONBINI_EXTRA_GREEN_STONE = 30149,
  STORAGESHOP_EXTRA_SLOT = 30029,
  EFFECT_ROCKET_NUM = 30027,
  ALLIANCE_SCIENCE_RESEARCH_CONSUME = 30159,
  ALLIANCE_CITY_MAX_NUM = 30160,
  ASSIST_SPEED_ADD = 30158,
  PLUNDER_REST_COUNT = 30152,
  GROCERY_STORE_COIN_ADD_PERCENT = 30155,
  EFFECT_PRODUCT_QUEUE_ADD_711000 = 30113,
  EFFECT_PRODUCT_QUEUE_ADD_707000 = 30114,
  EFFECT_PRODUCT_QUEUE_ADD_717000 = 30115,
  EFFECT_PRODUCT_QUEUE_ADD_718000 = 30116,
  EFFECT_PRODUCT_QUEUE_ADD_708000 = 30117,
  ADD_BUILD_ARROW_TOWER_NUM = 31013,
  DEC_UPGRADE_BUILD_ARROW_TOWER_ITEM = 30162,
  EFFECT_GULU_STORE_OPEN = 30041,
  FARM_EXP_ADD = 30119,
  GARAGE_REFIT_FREE_EXTRA = 30176,
  GARAGE_REFIT_X2_PROB_EXTRA = 30177,
  GARAGE_REFIT_X3_PROB_EXTRA = 30178,
  GARAGE_REFIT_X5_PROB_EXTRA = 30179,
  GARAGE_REFIT_X10_PROB_EXTRA = 30181,
  MAX_DAILY_COUNT_ADD = 90103,
  TRADE_CD_REDUCE_RATE = 90104,
  DAILY_FREE_INFANTRY = 30167,
  DAILY_FREE_TANK = 30168,
  DAILY_FREE_PLANE = 30169,
  DAILY_FREE_MAIN_PAPER = 30170,
  DAILY_FREE_MONUMENT_PAPER = 30171,
  DAILY_FREE_TRADE_PAPER = 30172,
  DAILY_FREE_BARRACKS_PAPER = 30173,
  DAILY_FREE_GARAGE_REFIT_ITEM = 30174,
  DAILY_FREE_TREAT = 30175,
  SEASON_BUILDING_MAXLV_1 = 30243,
  SEASON_BUILDING_MAXLV_2 = 30244,
  SEASON_WEEK_CARD_FLINT_ADD_PERCENT30305 = 30305,
  SEASON_WEEK_CARD_DESERT_SWEEP_FIELD = 30308,
  EFFECT_BUSINESS_CENTER_DELETE = 30187,
  ALLOW_FORCE_END_PVE = 30180,
  ALLOW_DRAG_MARCH = 30186,
  ALLOW_ATTACK_SAME_MONSTER = 30193,
  FACTORY_CANCEL_EFFECT_ID = 30190,
  AUTO_RALLY_REWARD_NUM_ADD = 30195,
  REFRESH_MINE_CAVE_REFRESH_TIME_ADD = 30198,
  UNLOCK_PUZZLE_BOSS_2 = 30199,
  UNLOCK_PUZZLE_BOSS_3 = 30200,
  TALENT_REFRESH_TIME = 30209,
  UNLOCK_ARM_ACT_BUILD = 30210,
  UNLOCK_ARM_ACT_SCIENCE = 30211,
  UNLOCK_ARM_ACT_HERO = 30212,
  INDIVIDUAL_ORDER_REFRESH_TIME = 30214,
  DETECT_EVENT_FUNCTION_OPEN = 30215,
  PVE_STAMINA_MAX = 30216,
  PVE_ATTACK_WOOD_OUT_NUM = 30217,
  PVE_ATTACK_STONE_OUT_NUM = 30218,
  PVE_START_ATTACK_SKILL = 30221,
  GAME_EFFECT_30224 = 30224,
  APS_MONEY_WEIGHT_PERCENT = 35112,
  APS_HERO_CAMP_COUNTER_INCR_PERCENT = 35115,
  ADD_FORMATION_DAMAGE_BY_CAMP_35200 = 35200,
  ADD_FORMATION_DAMAGE_BY_CAMP_35201 = 35201,
  ADD_FORMATION_DAMAGE_BY_CAMP_35202 = 35202,
  ADD_FORMATION_DAMAGE_BY_CAMP_35203 = 35203,
  ADD_FORMATION_DAMAGE_BY_CAMP_35204 = 35204,
  ADD_FORMATION_DAMAGE_BY_CAMP_35205 = 35205,
  ADD_FORMATION_DAMAGE_BY_CAMP_35206 = 35206,
  ADD_FORMATION_DAMAGE_BY_CAMP_35207 = 35207,
  ADD_FORMATION_DAMAGE_BY_CAMP_35208 = 35208,
  ADD_FORMATION_DAMAGE_BY_CAMP_35209 = 35209,
  ADD_FORMATION_DAMAGE_BY_CAMP_35210 = 35210,
  ADD_FORMATION_DAMAGE_BY_CAMP_35211 = 35211,
  ADD_FORMATION_DAMAGE_BY_CAMP_35212 = 35212,
  ADD_FORMATION_DAMAGE_BY_CAMP_35213 = 35213,
  ADD_FORMATION_DAMAGE_BY_CAMP_35214 = 35214,
  ADD_FORMATION_DAMAGE_BY_CAMP_35215 = 35215,
  ADD_UNION_HERO_ATK = 35216,
  ADD_UNION_HERO_DEF = 35217,
  ADD_UNION_HERO_TRP = 35218,
  ADD_ZEALOT_HERO_ATK = 35219,
  ADD_ZEALOT_HERO_DEF = 35220,
  ADD_ZEALOT_HERO_TRP = 35221,
  ADD_MAFIA_HERO_ATK = 35222,
  ADD_MAFIA_HERO_DEF = 35223,
  ADD_MAFIA_HERO_TRP = 35224,
  ADD_NEW_HUMAN_HERO_ATK = 35225,
  ADD_NEW_HUMAN_HERO_DEF = 35226,
  ADD_NEW_HUMAN_HERO_TRP = 35227,
  ADD_CAMP_RESTRAINT_35228 = 35228,
  ADD_CAMP_RESTRAINT_35229 = 35229,
  ADD_CAMP_RESTRAINT_35230 = 35230,
  ADD_CAMP_RESTRAINT_35231 = 35231,
  EXTRA_WOOD = 30219,
  EXTRA_STONE = 30220,
  MONSTER_EXTRA_REWARD = 30204,
  BOSS_EXTRA_REWARD = 30205,
  UPGRADE_ADD_RES_CONDOMINIUM = 30182,
  UPGRADE_ADD_RES_WIND = 30184,
  FLINT_PROTECT_BASE = 30230,
  FLINT_PROTECT_PERCENT = 30231,
  FLINT_GATHER_ADD_PERCENT30232 = 30232,
  FLINT_MAX_LIMIT = 30234,
  FLINT_MAX_LIMIT_ADD_PERCENT = 30235,
  SEASON_BUILDING_FLINT_DEC = 30259,
  SEASON_BUILDING_OBSIDIAN_DEC = 30260,
  SEASON_BUILDING_BUILD_SPEED_INC = 30261,
  SEASON_BUILDING_HP_INC = 30262,
  SEASON_DESERT_RES_94015 = 94015,
  SEASON_WEEK_CARD_DESERT_SWEEP_FIELD = 30308,
  LW_EFF_EPIDEMIC_SKILL_COST_41015 = 41015,
  LW_EFF_EPIDEMIC_SKILL_COST_41022 = 41022,
  LW_EFF_EPIDEMIC_HOSPITAL_SPEED_ADD = 41026,
  CAMP_EFFECT_CONDITION_4 = 42004,
  VISITOR_EVENT_FUNCTION_OPEN = 90004,
  LW_71000 = 71000,
  LW_71001 = 71001,
  LW_71002 = 71002,
  LW_71003 = 71003,
  LW_71004 = 71004,
  LW_71005 = 71005,
  LW_71039 = 71039,
  LW_71040 = 71040,
  LW_71041 = 71041,
  LW_71042 = 71042,
  LW_71043 = 71043,
  HERO_LOAD_ADD_71014 = 71014,
  MAX_MY_CITY_DEFENCE = 71015,
  HERO_FINAL_BURDEN = 71016,
  LW_MARCH_NORMAL_SPEED_ADD_PERCENT_71018 = 71018,
  LW_MARCH_MONSTER_SPEED_ADD_PERCENT_71019 = 71019,
  LW_MARCH_PLAYER_SPEED_ADD_PERCENT_71020 = 71020,
  LW_MARCH_ALLIANCE_CITY_SPEED_ADD_PERCENT_71021 = 71021,
  LW_MARCH_GATHER_SPEED_ADD_PERCENT_71031 = 71031,
  MARCH_LOAD_ADD_71032 = 71032,
  FINAL_NORMAL_SPEED_71050 = 71050,
  FINAL_MONSTER_SPEED_71051 = 71051,
  FINAL_PLAYER_SPEED_71052 = 71052,
  FINAL_ALLIANCE_CITY_SPEED_71053 = 71053,
  FINAL_GATHER_SPEED_71054 = 71054,
  FINAL_ASSIST_SPEED_71057 = 71057,
  LW_UNLIMIT_BUILD_QUEUE = 90005,
  Food_Produce_Add_50023 = 50023,
  Iron_Produce_Add_50024 = 50024,
  Gold_Produce_Add_50101 = 50101,
  LW_HOSPITAL_MAX_STOCK = 50137,
  LW_MONOPOLY_FUNCTION_OPEN = 90016,
  LW_BUILDSPEEDUP_WORKER = 50114,
  BUILD_SPEED_UP_Pyramid = 50129,
  BUILD_SPEED_UP_SuperBuilding = 50114,
  LW_STAGE_ADDTIME = 50115,
  LW_SCIENCE_CUTDOWN = 50139,
  LW_SCIENCE_RESEARCH_SPEED = 50108,
  LW_SCIENCE_RESEARCH_SPEEDUP = 50202,
  LW_PARTS_MAKE_SPEED = 50111,
  LW_PARTS_GOLD_REDUCE = 50112,
  LW_HOSPITAL_HEALSPEEDUP = 50131,
  LW_HOSPITAL_HEALGOLD_REDUCE = 50132,
  LW_CommonCollect_Add = 50116,
  LW_Collect_Add_71030 = 71030,
  LW_FoodCollect_Add = 50144,
  LW_MetalCollect_Add = 50145,
  LW_GoldCollect_Add = 50146,
  LW_RADAR_RES_REWARD_ADD = 50206,
  LW_VIP_WORKER_DETECT_REWARD_LIMIT = 50209,
  LW_VIP_WORKER_DETECT_REWARD_ADD_COUNT = 50210,
  LW_VIP_WORKER_DETECT_REWARD_CHANGE_ITEM = 50211,
  LW_UAV_SKILL_CHIP_LEVEL_FINAL = 50231,
  LW_PVE_SPEED_UP_GAS_NUM = 80007,
  LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN = 90017,
  LW_SHOW_OTHER_PLAYER_BIG_ICON = 90018,
  LW_OPEN_TOWER_JEEP_ADVENTURE = 90019,
  SOLDIER_LOAD_ADD_91078 = 91078,
  EFFECT_ONE_MORE_TIMES = 92003,
  LW_DRAGON_MV_CD_ADD_PERCENT = 90151,
  LW_DRAGON_SOLDIER_HOSPITAL_SPEED_ADD_PERCENT = 90152,
  LW_DRAGON_HOSPITAL_HEAL_ADD = 90156,
  LW_DRAGON_PRODUCE_ADD_PERCENT = 90160,
  LW_DSB_DUEL_HOSPITAL_HEAL_ADD = 90161,
  LW_ALARM_OPEN = 90023,
  LW_SEASON_STOVE_CENTER_OPEN = 94058,
  LW_SEASON_ALLIANCE_CENTER_OPEN = 94001,
  LW_SEASON_ALLIANCE_CENTER_OPEN_MUMMY = 94089,
  LW_SEASON_ALLIANCE_CENTER_OPEN_DARKNESS = 94138,
  TACTICAL_CARD_UNLOCK = 94139,
  LW_MASTERY_OPEN = 94034,
  LW_BASIC_RESOURCE_PRODUCT_PROMOTION = 50097,
  LW_IMPROVE_TRAIN_SPEED = 90109,
  LW_TRAIN_FAILURE_COUNT_LIMIT = 90107,
  LW_SEASON_EFFECT_94024 = 94024,
  LW_SEASON_EFFECT_94035 = 94035,
  LW_SEASON_EFFECT_94037 = 94037,
  JOIN_RALLY_SPEED_UP_94038 = 94038,
  LW_STAGE_RES_ADD_RATE = 50205,
  SEASON_MUMMY_GROUND_BUILD_EFFECT_ID = 94081,
  SEASON_MUMMY_Effect_Id_RALLY_MARCH = 94085,
  SEASON_MUMMY_Effect_Id_CURSE1 = 94086,
  SEASON_MUMMY_Effect_Id_CURSE2 = 94087,
  SEASON_MUMMY_Effect_Id_CURSE3 = 94088,
  SEASON_MUMMY_Effect_Id_BLESS1 = 71000,
  SEASON_MUMMY_Effect_Id_BLESS2 = 94012,
  SEASON_MUMMY_Effect_Id_BLESS3 = 50150,
  SEASON_MUMMY_Status_Id_CURSE1 = 703050,
  SEASON_MUMMY_Status_Id_CURSE2 = 703060,
  SEASON_MUMMY_Status_Id_CURSE3 = 703070,
  SEASON_MUMMY_Status_Id_BLESS1 = 703080,
  SEASON_MUMMY_Status_Id_BLESS2 = 703090,
  SEASON_MUMMY_Status_Id_BLESS3 = 703100,
  SEASON_DARKNESS_Status_Id_HUNTER = 704102,
  SEASON_OPEN_LIGHT_ADD_RESISTANCE = 704090,
  LW_DISPATCH_TASK_SUPER_MODE = 50208,
  LW_Effect_Id_50065 = 50065,
  LW_Effect_Id_50066 = 50066,
  LW_Effect_Id_50067 = 50067,
  LW_Effect_Id_50068 = 50068,
  LW_Effect_Id_50069 = 50069,
  LW_Effect_Id_50070 = 50070,
  LW_Effect_Id_50076 = 50076,
  LW_Effect_Id_50077 = 50077,
  LW_Effect_Id_50078 = 50078,
  LW_Effect_Id_50080 = 50080,
  LW_Effect_Id_50160 = 50160,
  LW_DISPATCH_TASK_ADD_SEQ = 50212,
  LW_DISPATCH_TASK_ADD_BOX = 50213,
  LW_SHAKE_COLLECT_RES = 90028,
  LW_BLACK_MARCH_SPEED_ADD_94055 = 94055,
  LW_TRAIL_TOWER_SWEEP = 50217,
  LW_BLACK_MARCH_SPEED_ADD_94055 = 94055,
  DRONE_FACTORY_SPEED_ADD_94101 = 94101,
  DAILY_TASK_REWARD_CRIT_94103 = 94103,
  PERSONAL_STOVE_OVERLOAD_ADD_94105 = 94105,
  SEND_COAL_ADD_94107 = 94107,
  SEASON_VIRUS_MAX_ADD = 94051,
  SEASON_VIRUS_MAX_EXPLODE = 94062,
  LW_REBIRTH_HOSPITAL_SOLDIER_COUNT_MAX = 50222,
  LW_REBIRTH_HOSPITAL_SOLDIER_COUNT_FACTOR = 50225,
  LW_REBIRTH_HOSPITAL_COOLDOWN_TIME = 50223,
  TradeOfficial_1 = 94108,
  TradeOfficial_2 = 94109,
  TradeOfficial_3 = 94110,
  TradeOfficial_4 = 94111,
  TradeOfficial_5 = 94112,
  TradeShopDiscount = 94094,
  BANK_ROBE_PERCENT = 94146,
  BANK_DEPOSIT_PERCENT = 94147,
  UNLOCK_T11 = 90031,
  Minor_Injury_Recovery = 42001,
  LW_Effect_Id_42002 = 42002,
  Truck_Super_Departure_50248 = 50248,
  Military_ADD_PERCENT = 94181,
  CAMP_SCIENCE_SKIN_FUNCTION1 = 94161,
  CAMP_SCIENCE_SKIN_FUNCTION2 = 94162,
  CAMP_SCIENCE_SKIN_FUNCTION = 94163,
  CAMP_SCIENCE_SKILL_FUNCTION = 94164,
  CAMP_SCIENCE_PRODUCE_FUNCTION = 94165,
  CAMP_SCIENCE_BUFF_FUNCTION = 94166,
  CAMP_SCIENCE_ALLIANCE_FUNCTION = 94167,
  CAMP_SCIENCE_MARCH_SPEED_ADD = 94170,
  CAMP_SCIENCE_DESTROY_FUNCTION = 94171,
  MULTI_THREAD_FISHING = 95013
}
CheckHeroRestraintEffectList = {
  EffectDefine.ADD_CAMP_RESTRAINT_35228,
  EffectDefine.ADD_CAMP_RESTRAINT_35229,
  EffectDefine.ADD_CAMP_RESTRAINT_35230,
  EffectDefine.ADD_CAMP_RESTRAINT_35231,
  EffectDefine.APS_HERO_CAMP_COUNTER_INCR_PERCENT
}
PlayBackEndJumpType = {
  Mail = 1,
  Chat = 2,
  Arena = 3,
  MineCave = 4
}
ExchangeDefine = {
  MONTH_CARD_ID = "9007",
  SUB_MONTH_CARD_ID = "9012",
  LW_WEEK_CARD_ID = "300001"
}
ExchangeUnlockConditionType = {LandUnlock = 138}
ItemColor = {
  WHITE = 1,
  GREEN = 2,
  BLUE = 3,
  PURPLE = 4,
  ORANGE = 5,
  GOLDEN = 6
}
DetectEventColor = {
  DETECT_EVENT_WHITE = 1,
  DETECT_EVENT_GREEN = 2,
  DETECT_EVENT_BLUE = 3,
  DETECT_EVENT_PURPLE = 4,
  DETECT_EVENT_ORANGE = 5,
  DETECT_EVENT_GOLDEN = 6
}
CheckNameType = {
  None = 0,
  MinNameChar = 1,
  MaxNameChar = 2,
  IllegalChar = 3,
  SensitiveWords = 4,
  Exist = 5,
  Unchanged = 6
}
RankType = {
  None = 0,
  AllianceKill = 1,
  AlliancePower = 2,
  CommanderKill = 3,
  CommanderPower = 4,
  CommanderBase = 5,
  AllianceOrder = 6,
  SeasonForce = 13,
  SeasonDesert = 14,
  AllianceSeasonForce = 15,
  MONSTER_SIEGE_USER = 17,
  MONSTER_SIEGE_ALLIANCE = 18,
  OtherServerAlliancePower = 19,
  ActLeadingQuestAllianceRank = 26,
  HeroPluginRank = 31
}
AllianceDonateRankType = {
  None = 0,
  RankDay = 1,
  RankWeek = 2,
  RankHistory = 3
}
BuildTimeType = {
  BuildTime_Upgrading = 0,
  BuildTime_FootSoldier = 1,
  BuildTime_CarSoldier = 2,
  BuildTime_BowSoldier = 3,
  BuildTime_Injuries = 4,
  BuildTime_Science = 5,
  BuildTime_Farm = 6,
  BuildTime_pasture = 7,
  BuildTime_tradingCenter = 8,
  BuildTime_Fixing = 9,
  BuildTime_HeroCountdown = 10
}
BuildBubbleType = {
  BuildFixFinishEnd = 0,
  NeedConnect = 1,
  DetectEventFinished = 2,
  StorageShopFirstOpen = 3,
  HeroStationAvailable = 4,
  UpgradeAllianceHelp = 5,
  ScienceAllianceHelp = 6,
  HospitalAllianceHelp = 7,
  FootSoldierFree = 8,
  FootSoldierEnd = 9,
  CarSoldierFree = 10,
  CarSoldierEnd = 11,
  BowSoldierFree = 12,
  BowSoldierEnd = 13,
  HospitalFree = 14,
  HospitalEnd = 15,
  ScienceFree = 16,
  ScienceEnd = 17,
  ResidentOrder = 18,
  EarthOrder = 19,
  ExtendDome = 20,
  PastureProduct = 21,
  GetItem = 22,
  GetResource = 23,
  NoGetResource = 24,
  NeedTransport = 25,
  AllianceHelp = 26,
  GetFoodProduct = 27,
  DetectEvent = 28,
  HeroAdvance = 29,
  HeroRecruit = 30,
  BuildZeroUp = 31,
  AllianceBattle = 32,
  AllianceTask = 33,
  AllianceGift = 34,
  GolloesGift = 35,
  GolloesMonthCard = 36,
  GroceryStore = 37,
  NoAlliance = 38,
  HeroStationSkill = 39,
  Assistance = 40,
  StorageShopMoney = 41,
  StorageShopGolloes = 42,
  FixBuildingAllianceHelp = 43,
  KonbiniFree = 44,
  HeroFreeScienceAddTime = 45,
  HeroFreeBuildAddTime = 46,
  WorldTrendStateRefresh = 47,
  AllianceCareer = 48,
  AllianceApply = 49,
  GarageRefitFree = 50,
  InactivePlayer = 51,
  WormHoleSub = 52,
  WormHoleSubZero = 53,
  PveMonument = 54,
  BuildingLv0Ruins = 55,
  BuildCanUpgrade = 56,
  AllianceCityDeclareWar = 57,
  BuildUpgradeReward = 58,
  CanUseHeroEffectSkill = 59,
  HeroRecruitOther = 60,
  CommonShopFree = 61,
  Talent = 62,
  HeroBountyFree = 63,
  HeroBountyFinish = 64,
  HeroOfficialEmpty = 65,
  FootSoldierUnlock = 66,
  CarSoldierUnlock = 67,
  BowSoldierUnlock = 68,
  LevelExploreEnergyEnough = 69,
  EnergyOrder = 70,
  CrossWormHoleSub = 71,
  RemoveRoad = 72,
  EnergyTreasure = 73,
  PubFreeItem = 74,
  ProductLineFull = 75,
  ProductLineLack = 76,
  ProductLineNoHero = 77,
  ProductLineMoreHero = 78,
  ProductLineNormal = 79,
  ParkourBattle = 80,
  BuildingNoWorker = 81,
  BuildingNoFunctioning = 82,
  BuildingFunctioning = 83,
  BuildingFunctioningFinish = 84,
  BattleHangUp = 85,
  BattleHangUpFinish = 86,
  LWResBuilding = 87,
  LWResBuildingFull = 88,
  SmithShopCanCraftNewEquip = 89,
  ZoneSpreadingBattle = 90,
  CanFreeRecruitHero = 91,
  AlWelcome = 92,
  BuildingReplaceWorker = 93,
  BuildingHero = 94,
  LWMonthCard = 95,
  UpgradeItem = 96,
  FirstPayNotFixing = 97,
  FirstPayFixing = 98,
  FirstPayFixed = 99,
  ParkingLotUnlock = 100,
  NewFirstPay = 101,
  BuildHammer = 102,
  ParkingLotState = 103,
  BattleHangUpBattleJump = 104,
  CountBattleEntrance = 105,
  CountBattleSoldiers = 106,
  PVPArena = 107,
  QueueWorking = 109,
  HeroHonroLevelUpgrade = 110,
  BuyScienceBuildGift = 111,
  GiftPackage = 113,
  LWMastery = 116,
  LWWorkerUp = 117,
  NewbiesFixBuilding = 118,
  MysteryTreasureChest = 119,
  AllianceWelcomeCelebration = 120,
  AllianceRewardCelebration = 121,
  MysteryTreasureMasterChest = 122,
  TrainFirstReward = 201,
  TrainCanRob = 202,
  TruckReady = 203,
  TruckReward = 204,
  TruckTravelling = 205,
  FireExtinguisher = 206,
  SaveGirl = 207,
  WorldTrend = 208,
  PVPArenaNew = 209,
  PyramidGift = 210,
  DecoratorExhibition = 211,
  TacticalWepaonUpgrade = 300,
  SquadEquipChange = 301,
  TWSkillChipUnlockCountDown = 302,
  TWSkillChipCanUnlock = 303,
  TWSkillChip = 304,
  TacticalWeaponBasic = 310,
  DispatchTask = 311,
  SeasonWeekCard = 312,
  DecorationPlaySound = 313,
  RebirthHospitalFree = 314,
  RebirthHospitalEnd = 315,
  RebirthHospitalAllianceHelp = 316,
  BuildHeroCountdownReady = 317,
  BlackMarket = 318,
  PersonalFurnaceTip = 319,
  RecruitHeroNew = 320,
  AlertTowerEntrance = 321,
  ActivityAlarmClock = 322,
  TacticalChipFactoryNormal = 325,
  BuildMummyYard = 326,
  DominatorMainEntrance = 323,
  TrainVIP = 324,
  DecorationShop = 327,
  BuildSeasonBigPhoto = 328,
  BuildSeasonLightHouse = 329,
  BuildSeasonPowerStation = 330,
  BuildSeasonWorld = 331,
  MoFieHeroBubble = 332,
  DigGame = 333,
  SuppliesSearch = 334,
  TreasureChest = 335,
  ChampionDuel = 336,
  RaceEntrance = 337,
  PowerUpActivity = 338,
  HighFive = 339,
  BuildNormalTaskBubble = 340,
  T11Research = 341,
  T11IdleGame = 342,
  MakingCoffee = 343,
  CoffeeCanUnlocked = 344,
  OpenSeasonBountyShop = 345,
  SeasonBuildingLv0Ruins = 346,
  SkyBattle = 350,
  SkyBattleChapter = 351,
  GiftVoucher = 352,
  BuildingMainDetail = 353,
  SeasonEatFish = 354,
  SeasonTower = 355,
  CivilizationSparkSoldiers = 356,
  CivilizationSparkEntrance = 357,
  CivilizationSparkLvUp = 358,
  BuildingMainPopupActivity = 359
}
BuildBubbleTypeOrder = {
  [BuildBubbleType.BuildFixFinishEnd] = 0,
  [BuildBubbleType.BuildingLv0Ruins] = 1.1,
  [BuildBubbleType.FireExtinguisher] = 1.2,
  [BuildBubbleType.CanUseHeroEffectSkill] = 1.5,
  [BuildBubbleType.CrossWormHoleSub] = 1.6,
  [BuildBubbleType.DetectEventFinished] = 2,
  [BuildBubbleType.StorageShopFirstOpen] = 3,
  [BuildBubbleType.HeroStationAvailable] = 4,
  [BuildBubbleType.HeroFreeScienceAddTime] = 4.5,
  [BuildBubbleType.HeroFreeBuildAddTime] = 4.6,
  [BuildBubbleType.UpgradeAllianceHelp] = 5,
  [BuildBubbleType.ScienceAllianceHelp] = 6,
  [BuildBubbleType.HospitalAllianceHelp] = 7,
  [BuildBubbleType.FootSoldierFree] = 8,
  [BuildBubbleType.FootSoldierEnd] = 9,
  [BuildBubbleType.FootSoldierUnlock] = 9.1,
  [BuildBubbleType.CarSoldierFree] = 10,
  [BuildBubbleType.CarSoldierEnd] = 11,
  [BuildBubbleType.CarSoldierUnlock] = 11.1,
  [BuildBubbleType.BowSoldierFree] = 12,
  [BuildBubbleType.BowSoldierEnd] = 13,
  [BuildBubbleType.BowSoldierUnlock] = 13.1,
  [BuildBubbleType.HospitalFree] = 14,
  [BuildBubbleType.HospitalEnd] = 15,
  [BuildBubbleType.RebirthHospitalAllianceHelp] = 15.1,
  [BuildBubbleType.RebirthHospitalFree] = 15.2,
  [BuildBubbleType.RebirthHospitalEnd] = 15.3,
  [BuildBubbleType.ScienceFree] = 16,
  [BuildBubbleType.ScienceEnd] = 17,
  [BuildBubbleType.ResidentOrder] = 18,
  [BuildBubbleType.EarthOrder] = 19,
  [BuildBubbleType.Talent] = 19.9,
  [BuildBubbleType.ExtendDome] = 20,
  [BuildBubbleType.PastureProduct] = 21,
  [BuildBubbleType.GetItem] = 22,
  [BuildBubbleType.GolloesGift] = 22.6,
  [BuildBubbleType.GroceryStore] = 22.7,
  [BuildBubbleType.CommonShopFree] = 22.8,
  [BuildBubbleType.GolloesMonthCard] = 22.9,
  [BuildBubbleType.GetResource] = 23,
  [BuildBubbleType.NoGetResource] = 24,
  [BuildBubbleType.NeedTransport] = 25,
  [BuildBubbleType.AllianceHelp] = 26,
  [BuildBubbleType.GetFoodProduct] = 27,
  [BuildBubbleType.DetectEvent] = 28,
  [BuildBubbleType.PubFreeItem] = 28.5,
  [BuildBubbleType.HeroRecruitOther] = 29,
  [BuildBubbleType.HeroAdvance] = 29.2,
  [BuildBubbleType.HeroRecruit] = 29.1,
  [BuildBubbleType.BuildZeroUp] = 31,
  [BuildBubbleType.AllianceBattle] = 32,
  [BuildBubbleType.AllianceGift] = 33,
  [BuildBubbleType.AllianceApply] = 34,
  [BuildBubbleType.NoAlliance] = 38,
  [BuildBubbleType.HeroStationSkill] = 39,
  [BuildBubbleType.Assistance] = 40,
  [BuildBubbleType.StorageShopMoney] = 41,
  [BuildBubbleType.StorageShopGolloes] = 42,
  [BuildBubbleType.FixBuildingAllianceHelp] = 43,
  [BuildBubbleType.EnergyTreasure] = 43.3,
  [BuildBubbleType.PveMonument] = 43.4,
  [BuildBubbleType.BuildUpgradeReward] = 43.5,
  [BuildBubbleType.BuildCanUpgrade] = 43.6,
  [BuildBubbleType.KonbiniFree] = 44,
  [BuildBubbleType.WorldTrendStateRefresh] = 47,
  [BuildBubbleType.AllianceTask] = 48,
  [BuildBubbleType.InactivePlayer] = 48.1,
  [BuildBubbleType.AllianceCareer] = 49,
  [BuildBubbleType.GarageRefitFree] = 50,
  [BuildBubbleType.WormHoleSub] = 51,
  [BuildBubbleType.WormHoleSubZero] = 52,
  [BuildBubbleType.AllianceCityDeclareWar] = 56,
  [BuildBubbleType.HeroBountyFinish] = 58,
  [BuildBubbleType.HeroBountyFree] = 59,
  [BuildBubbleType.HeroOfficialEmpty] = 60,
  [BuildBubbleType.LevelExploreEnergyEnough] = 61,
  [BuildBubbleType.EnergyOrder] = 64,
  [BuildBubbleType.BuildingReplaceWorker] = 69,
  [BuildBubbleType.ProductLineNormal] = 70,
  [BuildBubbleType.ProductLineFull] = 71,
  [BuildBubbleType.ProductLineLack] = 72,
  [BuildBubbleType.ProductLineMoreHero] = 74,
  [BuildBubbleType.ParkourBattle] = 80,
  [BuildBubbleType.BuildingFunctioningFinish] = 81,
  [BuildBubbleType.BuildingNoWorker] = 82,
  [BuildBubbleType.SmithShopCanCraftNewEquip] = 83,
  [BuildBubbleType.BuildingNoFunctioning] = 84,
  [BuildBubbleType.BuildingFunctioning] = 85,
  [BuildBubbleType.BattleHangUpBattleJump] = 89,
  [BuildBubbleType.BattleHangUp] = 90,
  [BuildBubbleType.BattleHangUpFinish] = 91,
  [BuildBubbleType.LWResBuilding] = 92,
  [BuildBubbleType.LWResBuildingFull] = 93,
  [BuildBubbleType.CanFreeRecruitHero] = 94,
  [BuildBubbleType.AlWelcome] = 95,
  [BuildBubbleType.UpgradeItem] = 96,
  [BuildBubbleType.FirstPayNotFixing] = 97,
  [BuildBubbleType.FirstPayFixing] = 98,
  [BuildBubbleType.FirstPayFixed] = 99,
  [BuildBubbleType.ParkingLotUnlock] = 100,
  [BuildBubbleType.NewFirstPay] = 101,
  [BuildBubbleType.BuildHammer] = 102,
  [BuildBubbleType.ParkingLotState] = 103,
  [BuildBubbleType.CountBattleSoldiers] = 104,
  [BuildBubbleType.CountBattleEntrance] = 105,
  [BuildBubbleType.QueueWorking] = 107,
  [BuildBubbleType.HeroHonroLevelUpgrade] = 108,
  [BuildBubbleType.BuyScienceBuildGift] = 109,
  [BuildBubbleType.LWMastery] = 116,
  [BuildBubbleType.LWWorkerUp] = 117,
  [BuildBubbleType.TrainFirstReward] = 201,
  [BuildBubbleType.TrainCanRob] = 202,
  [BuildBubbleType.TruckReady] = 203,
  [BuildBubbleType.TruckReward] = 204,
  [BuildBubbleType.TruckTravelling] = 205,
  [BuildBubbleType.PVPArena] = 206,
  [BuildBubbleType.PVPArenaNew] = 206.5,
  [BuildBubbleType.SaveGirl] = 207,
  [BuildBubbleType.WorldTrend] = 208,
  [BuildBubbleType.GiftPackage] = 209,
  [BuildBubbleType.PyramidGift] = 210,
  [BuildBubbleType.DecoratorExhibition] = 211,
  [BuildBubbleType.TacticalWepaonUpgrade] = 300,
  [BuildBubbleType.SquadEquipChange] = 301,
  [BuildBubbleType.TWSkillChipUnlockCountDown] = 302,
  [BuildBubbleType.TWSkillChipCanUnlock] = 303,
  [BuildBubbleType.TWSkillChip] = 304,
  [BuildBubbleType.TacticalWeaponBasic] = 310,
  [BuildBubbleType.DispatchTask] = 311,
  [BuildBubbleType.DecorationPlaySound] = 312,
  [BuildBubbleType.BuildHeroCountdownReady] = 317,
  [BuildBubbleType.BlackMarket] = 318,
  [BuildBubbleType.PersonalFurnaceTip] = 1,
  [BuildBubbleType.RecruitHeroNew] = 93.5,
  [BuildBubbleType.AlertTowerEntrance] = 321,
  [BuildBubbleType.ActivityAlarmClock] = 322,
  [BuildBubbleType.TacticalChipFactoryNormal] = 325,
  [BuildBubbleType.DominatorMainEntrance] = 323,
  [BuildBubbleType.DecorationShop] = 324,
  [BuildBubbleType.T11Research] = 325,
  [BuildBubbleType.T11IdleGame] = 326,
  [BuildBubbleType.MakingCoffee] = 328,
  [BuildBubbleType.CoffeeCanUnlocked] = 327,
  [BuildBubbleType.SkyBattle] = 330,
  [BuildBubbleType.SkyBattleChapter] = 331,
  [BuildBubbleType.CivilizationSparkLvUp] = 332,
  [BuildBubbleType.CivilizationSparkSoldiers] = 332,
  [BuildBubbleType.CivilizationSparkEntrance] = 333,
  [BuildBubbleType.BuildingMainDetail] = 334,
  [BuildBubbleType.BuildingMainPopupActivity] = 335
}
BuildBubbleIconName = {
  BuildFixFinishEnd = "bubble_icon_build_repair",
  EarthOrder = "bubble_icon_earth",
  EarthOrderRecall = "bubble_icon_earth_rocketrecall",
  DomeExtend = "bubble_icon_dome",
  BuildUpgrade = "bubble_bg_build_upgrade",
  ScienceAllianceHelp = "bubble_icon_alliance_help_new",
  HospitalAllianceHelp = "bubble_icon_alliance_help_new",
  UpgradeAllianceHelp = "bubble_icon_alliance_help_new",
  ScienceFree = "lyp_zhujiemian_qipao_kejishu",
  ScienceFreeTwo = "od_zhuchengqipao2nd",
  HospitalFree = "bubble_icon_hospital",
  Business = "bubble_icon_business_free",
  NoGetResource = "bubble_icon_warning",
  AllianceHelpOthers = "bubble_icon_alliance_help_others",
  AllianceTask = "bubble_icon_alliance_task",
  AllianceGift = "bubble_icon_alliance_award",
  CommonShopFree = "bubble_icon_alliance_award",
  StorageShopMoney = "bubble_icon_trading_bank",
  BgCircle = "bubble_bg_circle",
  BgUnSelect = "cfm_zhujiemian_qipao_1",
  BgSelect = "cfm_zhujiemian_qipao_2",
  BgSelect2 = "cfm_zhujiemian_qipao_2",
  GetItem = "bubble_icon_alliance_gift",
  NeedConnect = "uibuild_road_warning",
  EarthOrderClock = "Common_icon_time",
  HeroAdvance = "bubble_icon_hero_advance",
  HeroRecruit = "bubble_icon_hero_recruit",
  DetectEvent = "bubble_icon_detect_event",
  DetectEventComplete = "bubble_icon_detect_complete",
  AllianceBattle = "bubble_icon_alliance_battle",
  GolloesGift = "bubble_icon_golloes_gift",
  AnimalBg = "bubble_bg_animal",
  AnimalBgYellow = "bubble_bg_animal_yellow",
  NoAlliance = "bubble_icon_no_alliance",
  AllianceApply = "bubble_icon_alliance_apply",
  HeroStationAvailable = "bubble_icon_hero_station_available",
  HeroStationSkill = "bubble_icon_hero_station_skill",
  StorageShopFirstOpen = "bubble_icon_trading_bank2",
  StorageShopGolloes = "bubble_icon_trading_bank3",
  KonbiniFree = "bubble_icon_konbini_free",
  WorldTrendStateRefresh = "bubble_icon_Mars",
  Mars = "bubble_icon_plane",
  GolloesMc = "bubble_icon_golloes_mc",
  AllianceCareer = "bubble_icon_alliance_career",
  InactivePlayer = "bubble_icon_alliance_inactive",
  GarageRefitFree = "bubble_icon_garagerefit",
  PveMonument = "bubble_icon_level_explore_energy_enough",
  BuildingLv0RuinsWhite = "bubble_bg_landlock_white",
  BuildingLv0RuinsYellow = "bubble_bg_landlock_yellow",
  AllianceCityDeclareWar = "bubble_icon_declare",
  BuildUpgradeReward = "bubble_icon_alliance_award",
  Talent = "bubble_icon_talent",
  HeroBounty = "bubble_icon_reward",
  HeroOfficialEmpty = "bubble_icon_hero_official_empty",
  LevelExploreEnergyEnough = "bubble_icon_level_explore_energy_enough",
  ClaimTreasureEnergy = "bubble_icon_museum",
  EnergyOrder = "bubble_icon_energy_order",
  RemoveRoad = "bubble_icon_warning",
  ReplaceWorker = "cfm_zhujiemian_qipao_gongren",
  LWWorkerUp = "zyf_zhujiemian_qipao_maozi",
  BuildingIdle = "cfm_gongren_7",
  MilitaryCampTrainingBg = "bubble_bg_bd_white",
  MilitaryCampFinishTrainingBg = "bubble_bg_bd_yellow",
  MonthCardBuy = "lyp_zjm_yuekarukou",
  MonthCardReward = "lyp_zjm_yuekajiangli",
  SubscriptionReward = "zyf_zhuangbeitehuilibao_qipaoicon",
  RoundBgRed = "cfm_zhujiemian_qipao_3",
  RoundBgWhite = "cfm_zhujiemian_qipao_1",
  RoundBgYellow = "cfm_zhujiemian_qipao_2",
  Bubble_Bg1 = "cfm_zhujiemian_qipao_1",
  Bubble_Bg1_1 = "cfm_zhujiemian_qipao_1_1",
  Bubble_Bg2 = "cfm_zhujiemian_qipao_2",
  Bubble_Bg3 = "cfm_zhujiemian_qipao_3",
  Bubble_Bg4 = "cfm_zhujiemian_qipao_4",
  Bubble_Bg5 = "cfm_zhujiemian_qipao_5",
  Beizengmen = "cfm_zhujiemian_qipao_beizengmen",
  Hospital_soldier = "zyf_zhuchengyiyuan_zhuyeqipao",
  HeroFree = "cfm_zhujiemian_qipao_yingxiong",
  TrainArmy = "cfm_zhujiemian_qipao_zaobing",
  FirstPay = "cfm_zhujiemian_qipao_yingxiong2",
  BuildHammer = "lyp_zhujiemian_qipao_chuizi",
  ParkingLotLock = "zyf_zhujiemian_suo",
  SquadEquip = "od_zhujiemian_qipao_cheku",
  PVPArena = "lrb_dianfengduijue_zhujiemianicon",
  FireExtinguisher = "od_zhujiemian_miehuoqi",
  HeroHonroLevelUpgrade = "lrb_dianfengduijue_zhujiemianicon",
  TacticalWeaponUpgrade = "bubble_icon_drone_upgrade",
  TrailTowerBubble = "zyf_zhujiemian_qipao_huizhang1",
  PyramidGiftBubble = "zyf_zhujiemian_qipao_jinzita",
  DispatchTask = "lyp_huodong_paiqian_icon",
  SeasonWeekCard = "lrb_danbainongchang_qipaoicon",
  MasterySkill = "mjc_zhujiemian_qipao_zhiyejineng",
  TacticalCardBubble = "FX_zhanshukapai_rukouicon_",
  MasteryClassBubbleIcon = {
    [101] = "mjc_zhujiemian_qipao_zhiye_1",
    [102] = "mjc_zhujiemian_qipao_zhiye_2",
    [103] = "mjc_zhujiemian_qipao_zhiye_3"
  },
  DecorationPlaySound = "zyf_bofangyinyue_tingzhi_button",
  RebirthHospitalFree = "mjc_zhujiemian_qipao_jijiu",
  BlackMarket = "zyf_heishishangcheng_huobi_qipao",
  PersonalFurnaceTip = "mjc_zhujiemian_qipao_s2_dianhuo",
  ActivityAlarmClockBubbleIcon = "cfm_zhujiemian_fangke_qipao_4",
  TacticalChipFactoryBubble = "bubble_icon_FX_xinpiangongchang",
  ScienceThree = "zyf_zhuchengqipao_3rd",
  NewBeizengmen = "zyf_zhujiemian_logo_qipao_icon",
  BuildMummyYard = "ljq_zhujiemian_munaiyi",
  GetMummyBubble = "ljq_saijis3_qipao_munaiyi",
  DominatorMainBuildingBubbleIconGorilla = "zxl_zhuzai_zhujiemian_rukou",
  DecorationShopBuildBubbleIcon = "lrb_pifushangdian_icon",
  GiftVoucherBubbleIcon = "lrb_daojv_liwuduihuan",
  T11ResearchBuildBubbleIcon = "ljq_zhujiemian_qipao_t11",
  HighFive = "mjc_zhujiemian_qipao_jizhang",
  SkyBattle = "ljq_zhujiemian_qipao_feiji"
}
PickResEffectLevel = {
  Low = 1,
  Middle = 2,
  High = 3
}
TaskState = {
  NotExist = -2,
  NotStart = -1,
  NoComplete = 0,
  CanReceive = 1,
  Received = 2
}
AllianceHelpType = {
  None = -1,
  Building = 0,
  Queue = 1,
  FIX_BUILDING = 2
}
DailyBoxActive = {
  30,
  70,
  120,
  180,
  260
}
GoType = {
  None = 0,
  Go = 2,
  BuildList = 5,
  Science = 8,
  Hero = 13,
  Farm = 40,
  BuildRoad = 43,
  Searching = 44,
  CollectResource = 45,
  DailyBuildUp = 51,
  DailyBarn = 52,
  DailyFoodFactory = 53
}
TaskGoBuild = {
  None = 0,
  Upgrade = 1,
  Train = 2,
  Treat = 3,
  Plant = 4,
  FoodFactory = 5,
  BuyAnimal = 10,
  FeedAnimal = 11,
  GetAnimal = 12,
  HeroGet = 13,
  HeroUpStar = 14,
  ResidentOrder = 15,
  EarthOrder = 16,
  GetResource = 17,
  GetResourceRandom = 18
}
QuestGoType = {
  None = 0,
  BuildBtn = 1,
  Farm = 2,
  FarmGet = 3,
  Pasture = 4,
  GetResource = 5,
  GetResourceRandom = 6,
  BuildList = 7,
  Science = 8,
  HeroUpgrade = 9,
  BuildRoad = 10,
  SearchingMonster = 11,
  CollectResource = 12,
  DailyBuildUp = 13,
  DailyBarn = 14,
  DailyFoodFactory = 15,
  AttackMonster = 16,
  AllianceHelp = 17,
  RadarProbe = 18,
  ChangePlayerName = 19,
  GoBusinessCenterWindow = 20,
  CollectGarbage = 21,
  FactoryWork = 22,
  GoRobot = 23,
  GoTrainingCamp = 24,
  GoBindAccount = 25,
  GoConnectBuild = 26,
  MonsterReward = 27,
  GoHeroStation = 28,
  GoGiftMall = 29,
  GoBagPackUseItem = 30,
  GoSearchEnemy = 31,
  GoGarageUpgrade = 32,
  GoHeroStationScores = 33,
  GoHospital = 34,
  GoPveLevel = 35,
  GoTile = 36,
  GoUnlockedTile = 37,
  GoLockMonster = 38,
  GoHeroTrust = 39,
  FactoryWorkNew = 40,
  GoTriggerPve = 41,
  GoLandPve = 42,
  GoEnergy = 43,
  GoFelledTree = 44,
  GoPveAutoTo = 45,
  GoActUI = 46,
  GoCityCollect = 47,
  GoFormation = 48,
  GoTaskToBuild = 49,
  GoCheckBuild = 50,
  GoHeroBag = 51,
  GoHeroSkill = 52,
  GoBuildOpenUpgrade = 53,
  GoMainUIBtn = 54,
  GoLWParkourBattle = 55,
  GoDoorWorker = 56,
  GoOpeningStage = 57,
  GoMonopolyPlaceality = 58,
  GoAllianceIntro = 59,
  GoWorldSearch = 60,
  GoWorld = 61,
  GoAllianceTech = 62,
  GoVistor = 63,
  GoUpgradeBuilding = 64,
  GoVip = 65,
  GoActCommonGroup = 66,
  GoActDontClose = 67,
  GoActWindowByType = 68,
  GoHeroDetails = 69,
  GoHeroRank = 70,
  GoActWorldBoss = 71,
  GoActShop = 72,
  GoHeroRecruit = 73,
  SeasonBuilding = 74,
  GoToSeasonBuilding = 75,
  GoToMonsterBoss = 76,
  GoTWSkillChip = 77,
  AllianceGift = 78,
  GoSeasonTrendMain = 80,
  GoMasteryMain = 81,
  GoUnownedCityStronghold = 82,
  GoCityStronghold = 83,
  GoToCountBattleMap = 84,
  GoToAllianceFurnace = 85,
  FindAllianceMemberWorldPoint = 86,
  GoWorldCity = 87,
  SeasonCityList = 88,
  Season2CookFoodActivity = 89,
  OpenUICollectReward = 90,
  GoToSeasonActivity = 91,
  OpenHeroUniqueWeaponPreview = 92,
  OpenUIDispatchTaskMain = 93,
  GoDominatorGorillaTreatment = 94,
  GoDominatorMainUI = 95,
  GoMasterySkillPanel = 96,
  Season3JumpMummyMainUI = 97,
  Season3JumpHelpConvert = 98,
  Season3JumpLackSoldierUI = 99,
  Season3JumpLackMummyUI = 100,
  FindNearMonsterBySpecialType = 101,
  GotoNearestTradeStationWithoutLord = 102,
  GotoNearestTradeStationWithLord = 103,
  GoCityEventBoss = 110,
  GoDecalreWarCity = 111,
  GoToNearestDispatchTask = 112,
  OpenHeroAwakenPage = 113,
  GoSeasonMain = 304,
  GoCommonShop = 308,
  GoTacticalCard = 310,
  GoMonopolyPlaceality_Newbies = 401,
  CutTheLine_Newbies = 402,
  GotoToFixBuilding_Newbies = 403,
  GotoBuilding_Newbies = 404,
  GoToMonopolyNext_Newbies = 400,
  GotoSimpleCityEvent = 405,
  GoMonopolyPlacealityComplete_Newbies = 406,
  GoUnlockedTile_Newbies = 407,
  BuildBtn_Newbies = 408,
  UnlockFog_Newbies = 409,
  FogBattle_Newbies = 410,
  GotoMastery = 421,
  GotoBag = 422,
  GotoAllianceCity = 423,
  GoToConsumeEnergy = 501,
  GotoTW = 502,
  GotoAccelerateBuilding = 503,
  GotoBuildingPowerUp = 504,
  GotoTruckView = 505,
  GotoWorkerRecruitView = 506,
  GotoHospital = 507,
  GotoADCrossServer = 508,
  GotoFirstPay = 600,
  GoToArmedUpgradePanel = 601,
  GoToCivilizationSparkBattle = 602,
  GoToCivilizationSparkUpgrade = 603,
  GoToCampScience = 630,
  GoToNewAllianceSkill = 631,
  GoToTacticalCard = 632
}
QuestDescType = {
  Normal = 1,
  Build = 2,
  Train = 3,
  Farm = 4,
  Factory = 5,
  ResourceItem = 6,
  HeroUpStar = 7,
  Resource = 8,
  Science = 9,
  Monster = 10,
  Robot = 11,
  LandLockMonster = 12,
  HeroQuality = 13,
  HeroName = 14,
  HeroSkill = 15,
  LandLockStage = 16,
  Season = 19,
  SeasonHero = 20,
  HeroRank = 18,
  HeroTrial = 17,
  ThanksGiving = 18,
  ActMonopoly = 19,
  SlotMachine = 20,
  ActMonopolyLoopTask = 21,
  CountBattleMap = 22,
  ActGiftGivingTask = 23,
  Repaire = 24,
  SaveGirl = 25,
  UnlockMist = 26,
  SparkMonopoly = 27
}
TaskGoBuild44Type = {
  Monster = 1,
  Gas = 2,
  Metal = 3,
  Water = 4
}
TaskResourceType = {
  [1] = ResourceType.Oil,
  [2] = ResourceType.Metal,
  [3] = ResourceType.Water,
  [4] = ResourceType.Electricity
}
TaskType = {
  Chapter = 1,
  Main = 2,
  Daily = 3
}
TaskTypeSort = {
  TaskType.Chapter
}
SettingType = {
  Notice = 1,
  Setting = 2,
  Description = 4,
  Language = 5,
  Voice = 6,
  Ban = 7,
  NewGame = 11,
  ChangeId = 16,
  PVE = 17,
  PVEFreeCamera = 18,
  AllowTracking = 19,
  PlayerNation = 20,
  Roles = 21,
  Ping = 22,
  ChangeScene = 23,
  GameNotice = 24,
  CustomDecoration = 25,
  AIHelp = 26,
  DeleteAccount = 27,
  PrivacyAgreement = 28,
  UserAgreement = 29,
  AutoMarch = 30,
  push = 31,
  CopyAccount = 32,
  ChatTranslateLanguage = 33,
  RemarkNameList = 34,
  DebugChooseURL = 35,
  GMPanel = 36,
  Attention = 37,
  ItemRevert = 38,
  DownloadCenter = 39
}
UserSettingKey = {
  AutoMarch = 1,
  TrainBlockOwnServer = 2,
  ActivityAlarmClock = 3,
  EliminateVirus = 4,
  SeasonResourceSetting = 5,
  ALLIANCE_TRAIN_RANDOM = 6,
  NEW_ARENA_KOF_RANDOM = 7,
  TRAIN_VIP_TIME_SELECT = 8,
  REFUSE_POWER_HELPER = 9,
  AGREE_SEASON_AROUND_WORLD = 10,
  STEALTH_MOBILE_FORCE_UI_POP = 11,
  ELECTRICITY_ASSISTANCE_UI_POP = 12,
  BE_LIKED_UI_POP = 13,
  BE_GIFTED_UI_POP = 14,
  BE_ASSISTED_UI_POP = 15,
  BE_EXTINGUISHED_UI_POP = 16,
  BE_GIVEN_VOCATIONAL_SKILLS_UI_POP = 17,
  DIAMOND_USAGE_REMINDER = 18,
  FINISH_BUILDING_RECEIVE_REMINDER = 19,
  ALLIANCE_RALLY_HIDE_TEXT = 20,
  ALLIANCE_VIP_REWARD_SELF_SELECT = 21,
  GHOST_PARKOUR_ALLOW_SAME_SERVER_WATCH = 22,
  GHOST_PARKOUR_ALLOW_CROSS_SERVER_WATCH = 23,
  SHOW_OFFICIAL_EFFECT = 24,
  SeasonBountyShopNewItem = 25,
  SeasonMilitaryTradePopup = 26,
  SeasonMilitaryAutoUpgrade = 27
}
InteractionBubbleType = {
  STEALTH_MOBILE_FORCE = 1,
  ELECTRICITY_ASSISTANCE = 2,
  BE_LIKED = 3,
  BE_GIFTED = 4,
  BE_ASSISTED = 5,
  BE_EXTINGUISHED = 6,
  BE_GIVEN_VOCATIONAL_SKILLS = 7,
  GET_FIREWORK_GIFT = 8
}
InteractionBubbleType2SettingKey = {
  [InteractionBubbleType.BE_LIKED] = UserSettingKey.BE_LIKED_UI_POP,
  [InteractionBubbleType.BE_GIFTED] = UserSettingKey.BE_GIFTED_UI_POP,
  [InteractionBubbleType.BE_ASSISTED] = UserSettingKey.BE_ASSISTED_UI_POP,
  [InteractionBubbleType.BE_GIVEN_VOCATIONAL_SKILLS] = UserSettingKey.BE_GIVEN_VOCATIONAL_SKILLS_UI_POP
}
SettingShowTypes = {
  SettingType.Notice,
  SettingType.Setting,
  SettingType.Language,
  SettingType.NewGame
}
SettingTypeSort = {
  SettingType.Setting,
  SettingType.Language,
  SettingType.Voice,
  SettingType.PlayerNation,
  SettingType.push,
  SettingType.Ban,
  SettingType.DeleteAccount,
  SettingType.NewGame,
  SettingType.PrivacyAgreement,
  SettingType.UserAgreement,
  SettingType.AutoMarch,
  SettingType.CopyAccount,
  SettingType.DebugChooseURL
}
AIHelpEntranceIdType = {DelAllAcct = "E004"}
AllianceMemberManageType = {
  MemberData = 1,
  MemberRankChange = 2,
  LeaderTrans = 3,
  LeaderReplace = 4,
  MemberQuit = 5,
  Mail = 6,
  ResSupport = 7,
  GolloesTrade = 8
}
SettingNoticeType = {
  PUSH_GM = 0,
  PUSH_QUEUE = 1,
  PUSH_WORLD = 2,
  PUSH_MAIL = 3,
  PUSH_STATUS = 4,
  PUSH_ALLIANCE = 5,
  PUSH_ACTIVITY = 6,
  PUSH_RESOURCE = 7,
  PUSH_CHAT = 8,
  PUSH_REWARD = 9,
  PUSH_WEB_ONLINE = 10,
  PUSH_ATTACK = 11,
  PUSH_SCOUT = 12,
  NOT_CHECK = 99
}
SettingNoticeTypeSort = {
  SettingNoticeType.PUSH_WORLD,
  SettingNoticeType.PUSH_MAIL,
  SettingNoticeType.PUSH_ALLIANCE,
  SettingNoticeType.PUSH_ACTIVITY,
  SettingNoticeType.PUSH_RESOURCE,
  SettingNoticeType.PUSH_CHAT,
  SettingNoticeType.PUSH_REWARD,
  SettingNoticeType.PUSH_ATTACK,
  SettingNoticeType.PUSH_SCOUT
}
SettingNoticeStatus = {Off = 0, On = 1}
SettingNoticeUnlock = {Lock = 0, UnLock = 1}
Language = {
  Unspecified = 0,
  Afrikaans = 1,
  Albanian = 2,
  Arabic = 3,
  Basque = 4,
  Belarusian = 5,
  Bulgarian = 6,
  Catalan = 7,
  ChineseSimplified = 8,
  ChineseTraditional = 9,
  Croatian = 10,
  Czech = 11,
  Danish = 12,
  Dutch = 13,
  English = 14,
  Estonian = 15,
  Faroese = 16,
  Finnish = 17,
  French = 18,
  Georgian = 19,
  German = 20,
  Greek = 21,
  Hebrew = 22,
  Hungarian = 23,
  Icelandic = 24,
  Indonesian = 25,
  Italian = 26,
  Japanese = 27,
  Korean = 28,
  Latvian = 29,
  Lithuanian = 30,
  Macedonian = 31,
  Malayalam = 32,
  Norwegian = 33,
  Persian = 34,
  Polish = 35,
  PortugueseBrazil = 36,
  PortuguesePortugal = 37,
  Romanian = 38,
  Russian = 39,
  SerboCroatian = 40,
  SerbianCyrillic = 41,
  SerbianLatin = 42,
  Slovak = 43,
  Slovenian = 44,
  Spanish = 45,
  Swedish = 46,
  Thai = 47,
  Turkish = 48,
  Ukrainian = 49,
  Vietnamese = 50,
  Hindi = 51,
  Bengali = 52,
  Farsi = 53
}
SuportedLanguages = {
  Language.English,
  Language.French,
  Language.German,
  Language.Russian,
  Language.Korean,
  Language.Thai,
  Language.Japanese,
  Language.PortuguesePortugal,
  Language.Spanish,
  Language.Turkish,
  Language.ChineseTraditional,
  Language.Italian,
  Language.Arabic,
  Language.Vietnamese,
  Language.Indonesian,
  Language.ChineseSimplified,
  Language.Polish
}
SuportedLanguagesName = {}
SuportedLanguagesName[Language.English] = "English"
SuportedLanguagesName[Language.French] = "Fran\195\167ais"
SuportedLanguagesName[Language.German] = "Deutsch"
SuportedLanguagesName[Language.Russian] = "P\209\131\209\129\209\129\208\186\208\184\208\185"
SuportedLanguagesName[Language.Korean] = "\237\149\156\234\181\173\236\150\180"
SuportedLanguagesName[Language.Thai] = "\224\185\132\224\184\151\224\184\162"
SuportedLanguagesName[Language.Japanese] = "\230\151\165\230\156\172\232\170\158"
SuportedLanguagesName[Language.PortuguesePortugal] = "Portugu\195\170s"
SuportedLanguagesName[Language.Spanish] = "Espa\195\177ol"
SuportedLanguagesName[Language.Turkish] = "T\195\188rk\195\167e"
SuportedLanguagesName[Language.Indonesian] = "Indonesia"
SuportedLanguagesName[Language.ChineseTraditional] = "\231\185\129\233\171\148\228\184\173\230\150\135"
SuportedLanguagesName[Language.ChineseSimplified] = "\231\174\128\228\189\147\228\184\173\230\150\135"
SuportedLanguagesName[Language.Italian] = "Italiano"
SuportedLanguagesName[Language.Polish] = "Polski"
SuportedLanguagesName[Language.Dutch] = "Nederlands"
SuportedLanguagesName[Language.Arabic] = "\216\167\217\132\216\185\216\177\216\168\217\138\216\169"
SuportedLanguagesName[Language.Hindi] = "\224\164\185\224\164\191\224\164\168\224\165\141\224\164\166\224\165\128"
SuportedLanguagesName[Language.Bengali] = "\224\166\172\224\166\190\224\166\130\224\166\178\224\166\190"
SuportedLanguagesName[Language.Farsi] = "\217\129\216\167\216\177\216\179\219\140"
SuportedLanguagesName[Language.Swedish] = "svenska"
SuportedLanguagesName[Language.Danish] = "dansk"
SuportedLanguagesName[Language.Finnish] = "suomi"
SuportedLanguagesName[Language.Greek] = "\206\181\206\187\206\187\206\183\206\189\206\185\206\186\206\172"
SuportedLanguagesName[Language.Czech] = "\196\141e\197\161tina"
SuportedLanguagesName[Language.Hungarian] = "magyar"
SuportedLanguagesName[Language.Lithuanian] = "lietuvi\197\179 kalba"
SuportedLanguagesName[Language.Norwegian] = "Bokm\195\165l"
SuportedLanguagesName[Language.Romanian] = "limba rom\195\162n\196\131"
SuportedLanguagesName[Language.Ukrainian] = "\209\131\208\186\209\128\208\176\209\151\208\189\209\129\209\140\208\186\208\176 \208\188\208\190\208\178\208\176"
SuportedLanguagesName[Language.Vietnamese] = "Ti\225\186\191ng Vi\225\187\135t"
SuportedLanguagesLocalName = {}
SuportedLanguagesLocalName[Language.English] = "390752"
SuportedLanguagesLocalName[Language.French] = "390754"
SuportedLanguagesLocalName[Language.German] = "390756"
SuportedLanguagesLocalName[Language.Russian] = "390757"
SuportedLanguagesLocalName[Language.Korean] = "390758"
SuportedLanguagesLocalName[Language.Thai] = "390780"
SuportedLanguagesLocalName[Language.Japanese] = "390766"
SuportedLanguagesLocalName[Language.PortuguesePortugal] = "390755"
SuportedLanguagesLocalName[Language.Spanish] = "390753"
SuportedLanguagesLocalName[Language.Turkish] = "390773"
SuportedLanguagesLocalName[Language.Indonesian] = "390783"
SuportedLanguagesLocalName[Language.ChineseTraditional] = "391083"
SuportedLanguagesLocalName[Language.ChineseSimplified] = "390759"
SuportedLanguagesLocalName[Language.Italian] = "390760"
SuportedLanguagesLocalName[Language.Polish] = "390769"
SuportedLanguagesLocalName[Language.Dutch] = "390768"
SuportedLanguagesLocalName[Language.Arabic] = "390782"
SuportedLanguagesLocalName[Language.Hindi] = "language_hi"
SuportedLanguagesLocalName[Language.Bengali] = "language_bn"
SuportedLanguagesLocalName[Language.Farsi] = "language_fa"
SuportedLanguagesLocalName[Language.Lithuanian] = "language_lt"
SuportedLanguagesLocalName[Language.Swedish] = "390772"
SuportedLanguagesLocalName[Language.Danish] = "390762"
SuportedLanguagesLocalName[Language.Finnish] = "390764"
SuportedLanguagesLocalName[Language.Greek] = "390763"
SuportedLanguagesLocalName[Language.Czech] = "390761"
SuportedLanguagesLocalName[Language.Hungarian] = "390765"
SuportedLanguagesLocalName[Language.Norwegian] = "390767"
SuportedLanguagesLocalName[Language.Romanian] = "390770"
SuportedLanguagesLocalName[Language.Ukrainian] = "390778"
SuportedLanguagesLocalName[Language.Vietnamese] = "390781"
SuportedServerLanguagesLocalName = {}
SuportedServerLanguagesLocalName.en = Language.English
SuportedServerLanguagesLocalName.fr = Language.French
SuportedServerLanguagesLocalName.de = Language.German
SuportedServerLanguagesLocalName.ru = Language.Russian
SuportedServerLanguagesLocalName.ko = Language.Korean
SuportedServerLanguagesLocalName.th = Language.Thai
SuportedServerLanguagesLocalName.ja = Language.Japanese
SuportedServerLanguagesLocalName.pt = Language.PortuguesePortugal
SuportedServerLanguagesLocalName.es = Language.Spanish
SuportedServerLanguagesLocalName.tr = Language.Turkish
SuportedServerLanguagesLocalName.id = Language.Indonesian
SuportedServerLanguagesLocalName.zh_TW = Language.ChineseTraditional
SuportedServerLanguagesLocalName.zh_CN = Language.ChineseSimplified
SuportedServerLanguagesLocalName.it = Language.Italian
SuportedServerLanguagesLocalName.pl = Language.Polish
SuportedServerLanguagesLocalName.nl = Language.Dutch
SuportedServerLanguagesLocalName.ar = Language.Arabic
SuportedServerLanguagesLocalName.hi = Language.Hindi
SuportedServerLanguagesLocalName.bn = Language.Bengali
SuportedServerLanguagesLocalName.fa = Language.Farsi
SuportedServerLanguagesLocalName.lt = Language.Lithuanian
SuportedServerLanguagesLocalName.sv = Language.Swedish
SuportedServerLanguagesLocalName.da = Language.Danish
SuportedServerLanguagesLocalName.fi = Language.Finnish
SuportedServerLanguagesLocalName.el = Language.Greek
SuportedServerLanguagesLocalName.cs = Language.Czech
SuportedServerLanguagesLocalName.hu = Language.Hungarian
SuportedServerLanguagesLocalName.no = Language.Norwegian
SuportedServerLanguagesLocalName.ro = Language.Romanian
SuportedServerLanguagesLocalName.uk = Language.Ukrainian
SuportedServerLanguagesLocalName.vi = Language.Vietnamese
SuportedServerLanguagesLocalName.pr = Language.Persian
SettingSetType = {
  Effect = 0,
  Sound = 1,
  Message = 2,
  Game = 3,
  Task = 4,
  Question = 5,
  Position = 6,
  DebugChooseServer = 7,
  SceneParticles = 9,
  Resolution = 10,
  FPS = 11,
  Surface = 12,
  Build = 13,
  Decorations = 14,
  Monster = 15,
  SkyBox = 16,
  ShaderLod = 17,
  Diamond = 18,
  ShowAnimal = 19,
  ShowFarm = 20,
  Vibrate = 21,
  SendNotice = 22,
  PveResetPos = 23,
  PowerSaving = 24,
  ShowVipLevel = 25,
  DeleteAccount = 26,
  PvpAlert = 27,
  BuildFinishRemind = 28,
  GetPersonDuelScoreTip = 29,
  GetAllyDuelScoreTip = 30,
  ShakeCollectRes = 31,
  FullScreen = 32,
  ShakeCollectTruckRes = 33,
  RecruitCardRewardGet = 34,
  UseSeasonBGM = 35,
  BackGesture = 36,
  OneKeyCollectRes = 37,
  envSound = 38,
  PowerUpBannerDetail = 39,
  ShowOfficialEffect = 40
}
SettingSetSoundTypeSort = {
  SettingSetType.Effect,
  SettingSetType.Sound,
  SettingSetType.envSound,
  SettingSetType.UseSeasonBGM,
  SettingSetType.Vibrate,
  SettingSetType.PvpAlert
}
SettingSetChatTypeSort = {
  SettingSetType.ShowVipLevel
}
ChatPrivateListShowType = {
  Normal = 1,
  Search = 2,
  BatchDel = 3
}
ChatAlNoticeShowType = {Normal = 1, BatchDel = 2}
SettingSetClearTypeSort = {
  SettingSetType.Game
}
SettingSetDeleteAccountTypeSort = {
  SettingSetType.DeleteAccount
}
SettingSetPromptTypeSort = {
  SettingSetType.Diamond,
  SettingSetType.GetPersonDuelScoreTip,
  SettingSetType.GetAllyDuelScoreTip,
  SettingSetType.RecruitCardRewardGet,
  SettingSetType.PowerUpBannerDetail
}
SettingSetPerformanceTypeSort = {
  SettingSetType.ShaderLod
}
SettingSetResolutionTypeSort = {
  SettingSetType.Resolution,
  SettingSetType.FPS
}
SettingSetPowerTypeSort = {
  SettingSetType.PowerSaving
}
SettingSetFullScreenTypeSort = {
  SettingSetType.FullScreen
}
CountryCode = {
  "AE",
  "AL",
  "AM",
  "AO",
  "AR",
  "AT",
  "AU",
  "AZ",
  "AW",
  "BD",
  "BE",
  "BG",
  "BH",
  "BR",
  "BY",
  "BL",
  "BIH",
  "CA",
  "CH",
  "CL",
  "CN",
  "CP",
  "CZ",
  "CU",
  "CY",
  "CR",
  "DE",
  "DK",
  "DZ",
  "DO",
  "EC",
  "EE",
  "EG",
  "ES",
  "ENG",
  "FI",
  "FR",
  "GB",
  "GR",
  "GE",
  "GH",
  "HK",
  "HR",
  "HU",
  "HN",
  "ID",
  "IE",
  "IL",
  "IN",
  "IR",
  "IT",
  "IQ",
  "JP",
  "JO",
  "JM",
  "KH",
  "KR",
  "KW",
  "KZ",
  "KE",
  "LA",
  "LB",
  "LI",
  "LT",
  "LU",
  "LV",
  "LK",
  "LY",
  "MK",
  "MM",
  "MX",
  "MY",
  "MN",
  "MA",
  "ME",
  "MD",
  "NG",
  "NL",
  "NO",
  "NZ",
  "NP",
  "OM",
  "PA",
  "PE",
  "PH",
  "PK",
  "PL",
  "PT",
  "PR",
  "QA",
  "RO",
  "RS",
  "RU",
  "SA",
  "SE",
  "SG",
  "SI",
  "SK",
  "SY",
  "SCO",
  "SV",
  "TH",
  "TN",
  "TR",
  "TW",
  "UA",
  "UN",
  "US",
  "UZ",
  "UKL",
  "VE",
  "VN",
  "YE",
  "YU",
  "ZA"
}
AccountBandState = {
  UnBand = 0,
  UnCheck = 1,
  Band = 2
}
AccountBandType = {
  Mail = 0,
  GoogleSign = 1,
  PlayGames = 2,
  GameCenter = 3
}
AccountCheckState = {UnCheck = 0, Check = 1}
AccountBindType = {Bind = 1, Change = 2}
AccountDelConfirmType = {SendReview = 0, RealDel = 1}
RuntimePlatform = {
  OSXEditor = 0,
  OSXPlayer = 1,
  WindowsPlayer = 2,
  WindowsEditor = 7,
  IPhonePlayer = 8,
  Android = 11,
  LinuxPlayer = 13,
  LinuxEditor = 16,
  WebGLPlayer = 17,
  WSAPlayerX86 = 18,
  WSAPlayerX64 = 19,
  WSAPlayerARM = 20,
  PS4 = 25,
  XboxOne = 27,
  tvOS = 31,
  Switch = 32,
  Lumin = 33
}
BIND_TYPE = {
  DEVICE = 0,
  FACEBOOK = 1,
  GOOGLEPLAY = 2,
  CUSTOM = 3,
  APPSTORE = 4,
  OICQ = 6,
  WEIBO = 7,
  WX = 8
}
PinPwdStatus = {NoHave = 0, Have = 1}
AccountCreateType = {Register = 0, ChangePassword = 1}
UIPinInputType = {
  Enter = 0,
  Set = 1,
  Change = 2
}
UIPinOpenState = {Open = 0, Close = 2}
BindSuccessType = {BindAccount = 0, ChangePassword = 1}
BuildState = {
  BUILD_LIST_RECEIVED = 1,
  BUILD_LIST_STATE_OK = 2,
  BUILD_LIST_LACK_PEOPLE = 3,
  BUILD_LIST_LACK_RESOURCE = 4,
  BUILD_LIST_STATE_NEED_RESOURCE_ITEM = 5,
  BUILD_LIST_STATE_NEED_BUY_ITEM = 6,
  BUILD_LIST_STATE_NEED_ITEM_FORM_GIFT = 7,
  BUILD_LIST_SCIENCE = 8,
  BUILD_LIST_SCIENCE_BUILD = 9,
  BUILD_LIST_STATE_NEED_LEVEL = 10,
  BUILD_LIST_STATE_VIP_LEVEL = 11,
  BUILD_LIST_NEED_GUIDE = 12,
  BUILD_LIST_REACH_CUR_MAX = 13,
  BUILD_LIST_PREBUILD = 14,
  BUILD_LIST_STATE_NEED_BUY = 15,
  BUILD_LIST_STATE_NEED_BUY_MONTH = 16,
  BUILD_LIST_REACH_MAX = 17,
  BUILD_LIST_NEED_PARA3_SCIENCE = 18,
  BUILD_LIST_NEED_UNLOCK_TILE = 19,
  BUILD_LIST_NEED_UNLOCK_TALENT = 20,
  BUILD_LIST_NEED_QUEST = 21,
  BUILD_LIST_NEED_CHAPTER = 22,
  BUILD_LIST_STATE_NEED_MONOPOLY = 23,
  BUILD_LIST_NEED_ALLIANCE_CITY_BUILD = 24,
  BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_REPLACE = 25,
  BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD = 26,
  BUILD_LIST_NEED_MASTERY = 27,
  BUILD_LIST_NEED_DIRECTION = 28,
  BUILD_LIST_SCIENCE_SEASON = 29,
  BUILD_LIST_NEED_BUY_WEEKCARD_SEASON = 30,
  BUILD_LIST_INSUFFICIENT_EFFECT_CONDITION = 31,
  BUILD_LIST_SEASON_TIME_CONDITION = 32,
  BUILD_LIST_TABLE_SWITCH_CONDITION = 33,
  BUILD_LIST_SEASON_TIME_PRE_CONDITION = 34
}
HeroListSortType = {
  Quality = 0,
  Level = 1,
  Power = 2
}
HeroListSortTypeSort = {
  HeroListSortType.Quality,
  HeroListSortType.Level,
  HeroListSortType.Power
}
HeroState = {
  Free = 0,
  FormationMarch = 1,
  StationBuilding = 7,
  FormationInCity = 8
}
SlotState = {Lock = 0, UnLock = 1}
ShowHeroListType = {
  OwnTitle = 1,
  Own = 2,
  UnOwnTitle = 3,
  UnOwn = 4
}
HeroXmlState = {
  HeroXMLState_Normal = 1,
  HeroXMLState_Prepare = 2,
  HeroXMLState_Hide = 3,
  HeroXMLState_NeverGet = 4,
  HeroXMLState_Max = 5
}
HeroSkillState = {
  Unlock = 0,
  Lock = 1,
  CanLock = 2
}
HeroStarUseType = {
  UseSelf = 1,
  SameCampAndSameColor = 2,
  OnlySameColor = 3
}
HeroStarUseCommon = {No = 0, Yes = 1}
FrameType = {HeroFrame = 0, Common = 1}
UIHeroListState = {HeroList = 0, Star = 1}
UIHeroListUpStarStarState = {Yes = 0, No = 1}
ActivityEventType = {
  NULL = 0,
  PERSONAL = 1,
  ALLIANCE = 2,
  KINGDOM_PERSONAL = 3,
  KINGDOM_ALLIANCE = 4,
  MERGE_PERSONAL = 5,
  MERGE_ALLIANCE = 6,
  BF_PERSONAL = 7,
  LS_WORLD_PERSONAL = 8,
  LS_WORLD_ALLIANCE = 9,
  LS_WORLD_ALLIANCE_TO_ALLIANCE = 10,
  PERSONAL_LIMITTIME = 11,
  KINGDOM_WARMUP_PERSONAL = 12,
  KINGDOM_WARMUP_ALLIANCE = 13,
  ALLIANCE_ORDER = 16,
  INDIVIDUAL_ORDER = 19
}
ActivityEnum = {
  ActivityType = {
    None = 0,
    Farmer = 9,
    TurntableActivity = 10,
    HeroActivity = 11,
    Arms = 12,
    AllianceArmRaceAct = 14,
    AllianceOrder = 16,
    MonsterActivity = 100,
    WorldBoss = 123,
    EdenWar = 13,
    RadarRally = 17,
    IndividualOrder = 19,
    Puzzle = 22,
    LuckyRoll = 24,
    BattlePass = 27,
    Adventure = 28,
    GolloesCards = 29,
    PveAct = 32,
    MonsterTower = 33,
    ActSevenDay = 34,
    SeasonWeekCard = 46,
    SeasonRank = 48,
    AllianceSeasonForce = 50,
    WorldTrend = 51,
    AllianceSeasonWeekRank = -1,
    DoubleSeasonScore = 63,
    Mastery = 67,
    SeasonShop = 74,
    TaskActivity = 129,
    GiftBox = 132,
    HeroTrial = 133,
    LuckyShop = 134,
    AllyBase = 202,
    SevenDay = 999
  }
}
Activity_ChampionBattle_Stage_State = {
  None = 0,
  SingUp = 1,
  Auditions = 2,
  Strongest = 3
}
AuditionsBoxState = {
  Fail = -1,
  NotStart = 0,
  CanReceive = 1,
  HasReceived = 2
}
ChampionBattlePosterType = {
  None = 0,
  Strongest_Eight = 1,
  Strongest_Four = 2,
  Strongest_Two = 3,
  Strongest_King = 4
}
SeasonStage = {
  None = 0,
  Preview = 1,
  Open = 2,
  toSettle = 3,
  ToFinish = 4,
  Finished = 5
}
EnumActivity = {
  None = {Type = 0},
  FakeActivity = {Type = 1},
  TurntableActivity = {Type = 10},
  PersonalArms = {Type = 12},
  EdenWar = {Type = 13},
  AllianceCompete = {
    Type = 14,
    ActId = "55000",
    EventType = 15
  },
  AllianceOrder = {Type = 16},
  RadarRally = {Type = 17},
  LeadingQuest = {Type = 18},
  IndividualOrder = {Type = 19},
  BarterShop = {Type = 20},
  BarterShopNotice = {Type = 21},
  RallyBossAct = {Type = 21, ActId = "40005"},
  Puzzle = {Type = 22},
  MineCave = {Type = 25, ActId = "20001"},
  Arena = {Type = 26, ActId = "30000"},
  BattlePass = {Type = 27},
  Adventure = {Type = 28, ActId = "40006"},
  GolloesCards = {Type = 29},
  ActivitySummary = {Type = 30},
  JigsawPuzzle = {Type = 31},
  PveAct = {Type = 32},
  MonsterTower = {Type = 33},
  ActSevenDay = {Type = 34},
  DigActivity = {Type = 35},
  StrongestCommander = {Type = 105},
  LockhartActivity = {Type = 106},
  KillZombieActivity = {Type = 107},
  DispatchTask = {Type = 108},
  AttackCityActivity = {Type = 109},
  SeasonAttackCityActivity = {Type = 212},
  SeasonCrossAttackCityActivity = {Type = 213},
  SeasonAttackWorldDesertActivity = {Type = 214},
  SeasonCrossDeclareWarActivity = {Type = 215},
  SeasonServerBattleV8Activity = {Type = 217},
  SeasonFactionSelectionActivity = {Type = 232},
  SeasonFactionDeclareWarActivity = {Type = 233},
  SeasonFactionDeclareWarActivityMummy = {Type = 244},
  SeasonFactionSelectionActivityMummy = {Type = 242},
  SeasonFactionBigWarActivity = {Type = 234},
  SeasonNuclearPowerPlantActivity = {Type = 235},
  SeasonFactionKingWarActivity = {Type = 236},
  SeasonCallbackActivity = {Type = 237},
  SeasonFarmer = {Type = 239},
  SeasonLastWar = {Type = 250},
  SeasonPhoto = {Type = 253},
  SeasonWarZoneOutpostFix = {Type = 268},
  SeasonWarZoneOutpostAttack = {Type = 266},
  SeasonRainforestKingBattle = {Type = 399},
  DiggingGame = {Type = 241},
  TradeStation = {Type = 243},
  SeasonPreview = {Type = 248},
  SeasonGreen = {Type = 246},
  LeadingQuestV2 = {Type = 219},
  TruckActivity = {Type = 110},
  WorldBoss = {Type = 123},
  LuckyRoll = {Type = 124},
  PersonalArmsNew = {Type = 125},
  AccuRecharge = {Type = 126},
  KingActivity = {Type = 200},
  NewKingActivity = {Type = 0},
  GrowFoundation = {Type = 127},
  SunriseFoundation = {Type = 183},
  RebateActivity = {Type = 128},
  TaskActivity = {Type = 129},
  TreasureHuntActivity = {Type = 130},
  ScratchOffGame = {Type = 131},
  GiftBoxActivity = {
    Type = 132,
    ActId = "98001",
    SubActId1 = "98002",
    SubActId2 = "98003",
    SubActId3 = "98004"
  },
  HeroTrialActivity = {Type = 133},
  LuckyShop = {Type = 134, ActId = "7001"},
  TaskActivity2 = {Type = 135},
  ContinuePay = {Type = 136},
  KingActivity = {Type = 200},
  ActDragon = {
    Type = 201,
    ActId = "40038",
    needMainCityLevel = 15
  },
  ActWinterStorm = {
    Type = 218,
    ActId = "40039",
    needMainCityLevel = 10
  },
  AllyDrill = {Type = 202},
  TrainActivity = {Type = 203},
  SevenDay = {Type = 999},
  InfiniteGift = {Type = 205},
  CitySkinGet = {Type = 137},
  CitySkinExchange = {Type = 138},
  MonsterInvasion = {Type = 210},
  SandWormHunt = {Type = 240},
  JungleTrial = {Type = 394},
  SandWormFishing = {Type = 247},
  FishingMaster = {Type = 393},
  ArenaNewbie = {Type = 140},
  LimitedTimeFeast = {Type = 141},
  BattlePass_new = {Type = 142},
  BattlePass_new222 = {Type = 222},
  ArenaNewbieV2 = {Type = 143},
  Cooking = {Type = 150},
  Banquet = {Type = 151},
  BargainShop = {Type = 155},
  ActMonopoly = {Type = 153},
  ActGiftGiving = {Type = 321},
  ActLottery = {Type = 322},
  ActTask = {Type = 154},
  ActHeroLevelReplace = {Type = 211},
  ActHeroPromotion = {Type = 100},
  TitaniumBlueStore = {Type = 156},
  OptionalWeekCard = {Type = 206},
  Doomsday = {Type = 157},
  SignIn = {Type = 158},
  ActSlotMachine = {Type = 159},
  BanquetAttackMonster = {Type = 160},
  Introduction = {Type = 170},
  ActBingo = {Type = 171},
  MultipleParkour = {Type = 301},
  SeasonKillMonsterRank = {Type = 223},
  SeasonStrongholdRank = {Type = 224},
  SeasonPeriodicCard = {Type = 228},
  SeasonSuppliesShare = {Type = 229},
  SeasonSynthesis = {Type = 225},
  CounterAttack = {Type = 226},
  DispatchTreasure = {Type = 302},
  ZombieRush = {Type = 303},
  DoomCommander = {Type = 220},
  Questionnaire = {Type = 304},
  TreasureHuntNewActivity = {Type = 139},
  CommunityLink = {Type = 305},
  ActivityRebateNew = {Type = 161},
  ChampionDuelMain = {Type = 306, needMainCityLevel = 15},
  BlackMarket = {Type = 172},
  BerserkBoss = {Type = 307},
  DecorationGacha = {Type = 173},
  Ghostrecon = {Type = 308},
  CookFood = {Type = 230},
  SnowStormComing = {Type = 231},
  BloodyNight = {Type = 254},
  WestwardExpansion = {Type = 263},
  DarknessSupplies = {Type = 255},
  GoldTree = {Type = 256},
  TorchRelay = {Type = 309},
  ActTrends = {Type = 320},
  LotteLink = {Type = 310},
  ActMigration = {Type = 311},
  FrontBreakSunday = {Type = 312},
  HeroMonthCard = {Type = 313},
  ActSevenDayV2 = {Type = 174},
  MultiReward = {Type = 180},
  ActMeteorite = {Type = 342, ActId = "40040"},
  ActEpidemic = {
    Type = 344,
    ActId = "40041",
    needMainCityLevel = 1
  },
  ActDsbDuel = {
    Type = 352,
    ActId = "40042",
    needMainCityLevel = 1
  },
  DesertTreasure = {Type = 249},
  VirusResearch = {Type = 388},
  BossLogin = {Type = 387},
  CampScience = {Type = 392},
  RevivalPlan = {Type = 182},
  ActHeroLevelAndStarReplace = {Type = 323},
  HighSpeedRailway = {Type = 262},
  ActValentineSendGift = {Type = 331},
  ActValentineReceiveGift = {Type = 332},
  SeasonHunter = {Type = 346},
  ActEasterEgg = {Type = 185},
  ExploreTreasure = {Type = 251},
  SheepGame = {Type = 345},
  DigTreasure = {Type = 252},
  DigTreasurePreview = {Type = 257},
  OffSeason1Recapture = {Type = 347},
  OffSeason1QueenOfBlood = {Type = 348},
  CrazyRock = {Type = 186},
  ActBountyHunter = {Type = 350},
  MonsterInvasionS4Buff = {Type = 258},
  DetectS1Buff = {Type = 259},
  OFF_SEASON_DIG_REWARD = {Type = 260},
  OFF_SEASON_Treasure_V2 = {Type = 261},
  SurfingBattleAct = {Type = 349},
  SeasonSelectLocation = {Type = 361},
  SeasonSelectLocationGame = {Type = 351},
  ActivityTetris = {Type = 351},
  SeasonBountyShop = {Type = 353},
  S0AttackCityNew = {Type = 354},
  S0AttackCityBattlePass = {Type = 355},
  S0AttackCityClue = {Type = 356},
  SeasonMoneyRank = {Type = 363},
  ActCalendar = {Type = 370},
  ActSkyBattleGrowth = {Type = 371},
  SeasonAllianceWarTime = {Type = 360},
  BiuBiu = {Type = 362, ActId = 1200045},
  GGGo = {Type = 400, ActId = 1200118},
  AllianceCongratulation = {Type = 364},
  GhostParkour = {Type = 357},
  SurvivalVipGift = {Type = 380},
  NineNationKingBattle = {Type = 385},
  AllianceSalary = {Type = 372},
  MonthCardInsurance = {Type = 373},
  ActLandlord = {Type = 386, ActId = 40043},
  Recycle = {Type = 187},
  SeasonMilitary = {Type = 389},
  SeasonMilitaryElite = {Type = 391},
  SeasonSelectCamp = {Type = 390},
  SeasonCityAltar = {Type = 397},
  Season6CampDestroy = {Type = 398},
  SurvivorPack = {Type = 188},
  S0AllianceBoss = {Type = 269}
}
EnumActivityStatus = {
  Preview = 1,
  Open = 2,
  Close = 3
}
SeasonPassRewardType = {NormalReward = 0, SpecialReward = 1}
SeasonCallbackType = {
  Base = 1,
  Drone = 2,
  Decoration = 3,
  Hero = 4,
  SystemBuff = 5
}
SeasonCallbackSpecialEffect = {PvpSoldierDeathReduce = 50228}
SeasonWeatherType = {
  Unknown = -1,
  Cloud = 0,
  Fog = 1,
  Rain = 2,
  AcidRain = 3,
  Rainbow = 4,
  Sunny = 5,
  Monsoon = 6
}
WeatherObjectInfo = {
  SnowStorm = {
    type = "SnowStorm",
    path = "Assets/Main/Prefabs/UI/LWMainUI/weatherObj.prefab",
    script = "UI.LWMainUI.Component.UIMainLeft.UIMainWeatherObj"
  },
  SeasonWeather = {
    type = "SeasonWeather",
    path = "Assets/Main/Prefabs/UI/LWSeason1/SeasonWeatherObj.prefab",
    script = "UI.LWMainUI.Component.UIMainLeft.UIMainSeasonWeatherObj"
  },
  BloodyMoon = {
    type = "BloodyMoon",
    path = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/BloodyMoonObj.prefab",
    script = "UI.UIBloodyNight.UIBloodyMoonObj"
  },
  Hunter = {
    type = "Hunter",
    path = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/Component/SeasonHunterInfo.prefab",
    script = "UI.LWSeason.LWSeasonHunter.Component.SeasonHunterInfo"
  },
  QueenOfBlood = {
    type = "QueenOfBlood",
    path = "Assets/Main/Prefabs/UI/LWOffSeason1/QueenOfBlood/QueenOfBloodTip.prefab",
    script = "UI.LWOffSeason1.QueenOfBloodTip.QueenOfBloodTip"
  }
}
HeroTalentColor = {
  Red = 1,
  Orange = 2,
  Blue = 3
}
HeroTalentCellIconType = {Big = 1, Small = 2}
HeroTalentCellState = {
  NoPre = 0,
  Pre = 1,
  Yes = 2
}
HeroTalentLineCellState = {Gray = 0, Light = 1}
HeroTalentUseType = {Reset = 1, Change = 2}
LoadPath = {
  SoundEffect = "Assets/Main/Sound/Effect/%s.ogg",
  UIGovernment = "Assets/Main/Sprites/UI/UIGovernment/Sprites/%s",
  HeroIconsSmallPath = "Assets/Main/Sprites/HeroIconsSmall/",
  HeroIconsBigPath = "Assets/Main/Sprites/HeroIconsBig/",
  HeroListPath = "Assets/Main/Sprites/UI/UIHeroList/%s",
  HeroDetailPath = "Assets/Main/Sprites/UI/UIHeroDetail/%s",
  HeroAdvancePath = "Assets/Main/Sprites/UI/UIHeroAdvance/%s",
  HeroRecruitPath = "Assets/Main/Sprites/UI/UIHeroRecruit/LW/%s",
  HeroBodyPath = "Assets/Main/Sprites/HeroBody/%s",
  LWHeroBodyPath = "Assets/Main/Sprites/LW_HeroBody/",
  LWHeroRecruitPreviewIconPath = "Assets/Main/Sprites/UI/UIHeroRecruit_PreviewHeroIcon/",
  HeroCommonPath = "Assets/Main/Sprites/UI/UIHeroCommon/%s",
  SkillIconsPath = "Assets/Main/Sprites/SkillIcons/",
  SkillBigIconsPath = "Assets/Main/Sprites/UI/UIPveHeroAppear/",
  LWCommonPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/%s",
  LWAllianceCityPath = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/",
  LWMainUINewPath = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/%s",
  GarbageIconsPath = "Assets/Main/Sprites/UI/UIGarbage/",
  GolloesCampPath = "Assets/Main/Sprites/UI/UIGolloesCamp/%s",
  ActivityIconPath = "Assets/Main/Sprites/ActivityIcons/%s",
  HeroIconPath = "Assets/Main/Sprites/HeroIcons/%s",
  TalentPath = "Assets/Main/Sprites/HeroTalent/%s",
  UIHeroInfoPath = "Assets/Main/Sprites/UI/UIHeroInfo/%s",
  CommonApsNewPath = "Assets/Main/Sprites/UI/UIRank/%s",
  ItemPath = "Assets/Main/Sprites/ItemIcons/%s",
  UIChatChat = "Assets/Main/Sprites/UI/UIChat/Chat/%s",
  BuildIconInCity = "Assets/Main/Sprites/BuildIconInCity/%s",
  BuildIconOutCity = "Assets/Main/Sprites/BuildIconOutCity/%s",
  SeasonDesert = "Assets/Main/Sprites/SeasonDesert/%s",
  DailyActivityUnlock = "Assets/Main/Sprites/DailyActivityUnlock/%s",
  ResLackIcons = "Assets/Main/Sprites/ResLackIcons/%s",
  ResourceIcons = "Assets/Main/Sprites/Resource/%s",
  UIBuildBtns = "Assets/Main/Sprites/UI/UIBuildBtns/%s",
  UIBuildBubble = "Assets/Main/Sprites/UI/UIBuildBubble/%s",
  UILandLock = "Assets/Main/Sprites/UI/UILandLock/%s",
  UINPCPath = "Assets/Main/Sprites/UI/UINPC/%s",
  CommonPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/%s",
  UIBuild = "Assets/Main/Sprites/UI/UIBuild/%s",
  UILWBuild = "Assets/Main/Sprites/UI/UILWBuild/%s",
  ScienceIcons = "Assets/Main/Sprites/UI/UILWScience/%s",
  SoldierIcons = "Assets/Main/Sprites/SoldierIcons/%s",
  UIScience = "Assets/Main/Sprites/UI/UILWScience/%s.png",
  UIResidentOrder = "Assets/Main/Sprites/UI/UIResidentOrder/%s",
  UISciencePrefab = "Assets/Main/Prefabs/UI/UIScience/%s",
  Soldier = "Assets/Main/Sprites/Soldier/%s",
  UISoldier = "Assets/Main/Sprites/UI/UISoildier/%s",
  AvatorFolder = "Assets/Main/Sprites/UI/UIChatNew/%s",
  ChatFolder = "Assets/Main/Sprites/UI/UIChatNew2/%s",
  LWChatFolder = "Assets/Main/Sprites/UI/UIChatNew3/%s",
  LWChat2Common = "Assets/Main/Sprites/UI/LWChat_v2/Common/%s",
  LWChat2Folder = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatWindow/%s",
  CommonNewPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/%s",
  UIFormationDefencePath = "Assets/Main/Sprites/UI/UIFormationDefence/%s",
  UIChatNew1 = "Assets/Main/Sprites/UI/UIChatNew1/%s",
  UIMainNew = "Assets/Main/Sprites/UI/UIMain/UIMainNew/%s",
  LWMainUINew = "Assets/Main/Sprites/UI/UIMain/LWMainUI/%s",
  UIPopupPackage = "Assets/Main/Sprites/UI/UIMain/UIPopupPackage/%s",
  RadarCenterPath = "Assets/Main/Sprites/UI/UIRadarCenter/%s",
  UITroops = "Assets/Main/Sprites/UI/UITroops/%s",
  UITroopsNew = "Assets/Main/Sprites/UI/UITroopsNew/%s",
  Guide = "Assets/Main/Sprites/Guide/%s",
  UITask = "Assets/Main/Sprites/UI/UITask/%s",
  UIPlayerIcon = "Assets/Main/Sprites/UI/UIHeadIcon/%s",
  UserHeadPath = "Assets/Main/Sprites/UI/UIHeadIcon/%s",
  UIActivity = "Assets/Main/Sprites/UI/UIActivity/%s",
  UIPersonalArms = "Assets/Main/Sprites/UI/UIPersonalArms/%s",
  UIAllianceArmament = "Assets/Main/Sprites/UI/UIAllianceArmament/%s",
  UISevenDay = "Assets/Main/Sprites/UI/UISevenDay/%s",
  UIAlliance = "Assets/Main/Sprites/UI/UIAlliance/%s",
  UIAllianceNew = "Assets/Main/Sprites/UI/UIAllianceNew/%s",
  UILWAlliance = "Assets/Main/Sprites/UI/UILWAlliance/%s",
  UIAllianceGift = "Assets/Main/Sprites/UI/UIAllianceGift/%s",
  NPCModel = "Assets/PackageRes/Prefabs/NPCModel/%s.prefab",
  UIMail = "Assets/Main/Sprites/UI/UIMail/%s",
  AllianceMark = "Assets/Main/Sprites/UI/UIAllianceMark/%s",
  GuideTipSpine = "Assets/Main/Prefabs/Guide/%s.prefab",
  UIPlayerLevel = "Assets/Main/Sprites/UI/UIPlayerLevel/%s",
  UIPlayerCareer = "Assets/Main/Sprites/UI/UICareer/%s",
  DecorationTreePath = "Assets/Main/Prefabs/World/WorldCityTree%s.prefab",
  UILevelUpItem = "Assets/Main/Prefabs/UI/UILevelUp/UILevelUpItem.prefab",
  UIVipPath = "Assets/Main/Sprites/UI/UIVip/%s",
  UIHeroMonthCard = "Assets/Main/Sprites/UI/UIHeroMonthCard/%s",
  WarDetail = "Assets/Main/Sprites/UI/UIAlliance/WarDetail/%s",
  UIRobotPack = "Assets/Main/TextureEx/UIDronePack/UIrobot_img_%s",
  UIHeroStation = "Assets/Main/Sprites/UI/UIHeroStation/%s",
  UIChampionBattle = "Assets/Main/Sprites/UI/UIChampion/%s",
  UIMainQuest = "Assets/Main/Sprites/UI/UITask/%s",
  UILuckyRoll = "Assets/Main/Sprites/UI/UILuckyRoll/%s",
  UIGolloesCards = "Assets/Main/Sprites/UI/UIGolloesCards/%s",
  UIChronicle = "Assets/Main/Sprites/UI/UIChronicle/%s",
  UIWorldTrend = "Assets/Main/Sprites/UI/UIWorldTrend/%s",
  UIMonsterTower = "Assets/Main/Sprites/UI/UIMonsterTower/%s",
  LodIcon = "Assets/Main/Sprites/LodIcon/%s",
  UIPveLoading = "Assets/Main/Sprites/UI/UIPveLoading/%s",
  UIGrowFoundation = "Assets/Main/Sprites/UI/UIGrowFoundation/%s",
  UIWeekPackage = "Assets/Main/Sprites/UI/UIWeeklyPack/%s",
  UIDetectTextureExPath = "Assets/Main/TextureEx/UILWRadarCenter/%s",
  LWMasterySpritePath = "Assets/Main/Sprites/UI/UIMastery/%s",
  LWMasteryTexturePath = "Assets/Main/TextureEx/LWUIMastery/%s",
  ActSlotMachineTexturePath = "Assets/Main/ActivityFestival/ActSlotMachine/%s",
  ChatRedPacketTexturePath = "Assets/Main/TextureEx/ChatRedPacket/%s",
  SeasonReward = "Assets/Main/Sprites/UI/UISeasonReward/%s",
  ActBingoSpritePath = "Assets/Main/Sprites/UI/ActBingo/%s.png",
  UIBattlePassNormalNewPath = "Assets/Main/Sprites/UI/UIBattlePassNormalNew/%s.png",
  LWUIMigrationIconPath = "Assets/Main/Sprites/UI/LWUIMigrationIcon/%s",
  ActMonopolyRuleTexturePath = "Assets/Main/TextureEx/ActMonopolyRule/%s.png",
  CityScene = "Assets/Main/Prefabs/CityScene/%s.prefab",
  Building = "Assets/Main/Prefabs/Building/%s.prefab",
  DyHero = "Assets/Main/Prefabs/PVE/DyHeroes/%s.prefab",
  UICommonPackageBig = "Assets/Main/Sprites/UI/UICommonPackageBig/CommonPackageBig_img_%s",
  UIKonbiniRes = "Assets/Main/Sprites/UI/UIKonbini/UIKonbini_icon_res_%s",
  UIKonbiniResItem = "Assets/Main/Sprites/UI/UIKonbini/UIKonbini_icon_res_item_%s",
  UIGarageRefit = "Assets/Main/Sprites/UI/UIGarageRefit/UIRetrofit_%s",
  UIChapter = "Assets/Main/Sprites/UI/UIChapter/%s",
  PVEScene = "Assets/Main/Sprites/pve/%s",
  UIPveBattleBuff = "Assets/Main/Sprites/UI/UIPveBattleBuff/%s",
  UITreasurePuzzle = "Assets/Main/Sprites/UI/UITreasurePuzzle/%s",
  PVELevel = "Assets/Main/Prefabs/PVELevel/%s.prefab",
  PVETriggerIcons = "Assets/Main/Sprites/PVETriggerIcons/%s",
  UIPveAct = "Assets/Main/Sprites/UI/UIPveAct/%s",
  CollectResource = "Assets/Main/Prefabs/CollectResource/%s.prefab",
  UISeasonIntro = "Assets/Main/Sprites/UI/UISeasonIntro/%s",
  UISeasonHint = "Assets/Main/Sprites/UI/UISeasonHint/%s",
  UISeasonWeek = "Assets/Main/Sprites/UI/UISeasonWeek/%s",
  UIMastery = "Assets/Main/Sprites/UI/UIMastery/",
  UIWorldTrendBg = "Assets/Main/TextureEx/UIWorldTrend/%s",
  LWWorkerHeroIconsBigPath = "Assets/Main/Sprites/HeroIconsBig/",
  UILWScience = "Assets/Main/Sprites/UI/UILWScience/%s.png",
  GiftPackageIcons = "Assets/Main/Sprites/GiftPackageIcons/%s",
  UIJeepAdventure = "Assets/Main/Sprites/UI/UIJeepAdventure/%s.png",
  UITitleIcon = "Assets/Main/Sprites/UI/UITitleTag/%s",
  UIDecoration = "Assets/Main/Sprites/UI/UIDecoration/%s",
  UIAccuRecharge = "Assets/Main/Sprites/UI/UIAccuRecharge/%s",
  UImystery = "Assets/Main/Sprites/UI/UIActivityGiftBox/%s",
  UIScratchOffLuckyIcon = "Assets/Main/Sprites/UI/UIScratchOff/%s",
  UISeasonRobots = "Assets/Main/Sprites/UI/UISeasonRobots/%s",
  UILuckyShop = "Assets/Main/Sprites/UI/UIGroceryStore/%s",
  UIAccuRechargeBanner = "Assets/Main/TextureEx/UILimitedPack/Dynamic/AccuRecharge/%s",
  UIAccuRechargeFestival = "Assets/Main/ActivityFestival/AccuRecharge/%s",
  UILimitedTimeFeast = "Assets/Main/Sprites/UI/UILimitedTimeFeast/%s",
  UITitaniumBlueStore = "Assets/Main/Sprites/UI/UILWTitaniumBlueStore/%s",
  UILimitedTimeFeastFestival = "Assets/Main/ActivityFestival/ActLimitedTimeFeast/%s",
  SoundHero = "Assets/Main/Sound/Hero/%s/%s.ogg",
  AudioSourceHero = "Assets/Main/Sound/Hero/%s/%s.prefab",
  SoundDub = "Assets/Main/Sound/Dub/%s/%s.ogg",
  UIPopPackForeGround = "Assets/Main/TextureEx/UILimitedPack/Dynamic/PopPackageBanner/ForeGround/%s",
  UIPopPackBackGround = "Assets/Main/TextureEx/UILimitedPack/Dynamic/PopPackageBanner/BackGround/%s",
  UIDailyMustBuy = "Assets/Main/TextureEx/UILimitedPack/Dynamic/DailyMustBuy/%s",
  UIWeeklyPackTextureEx = "Assets/Main/TextureEx/UILimitedPack/Dynamic/WeeklyPackage/%s",
  UILimitedPackFullBg = "Assets/Main/TextureEx/UILimitedPack/Dynamic/LimitedPacckFullBg/%s",
  UIDailyMustBuyBackGround = "Assets/Main/Prefabs/UI/LWGift/DailyMustBuy/BackGround/%s.prefab",
  ActivityInfiniteGiftBannerPath = "Assets/Main/TextureEx/UIActivityBg/Banner/InfiniteGift/%s",
  ActivityLimitedTimeFeastBannerPath = "Assets/Main/TextureEx/UIActivityBg/Banner/LimitedTimeFeast/%s",
  ActivityTaskActivityBannerPath = "Assets/Main/TextureEx/UIActivityBg/Banner/TaskActivity/%s",
  ActivityBattlePassBannerPath = "Assets/Main/TextureEx/UIActivityBg/Banner/BattlePass/%s",
  LuckyRollShopBannerPath = "Assets/Main/ActivityFestival/LuckyRollShop/%s",
  TorchRelayShopBannerPath = "Assets/Main/TextureEx/LWUITorchRelay/%s",
  UIPackageShop = "Assets/Main/Sprites/UI/UIPackageShop/%s",
  UIPlayerLevelPackage = "Assets/Main/Sprites/UI/UIPlayerLevelPackage/%s",
  UICitySkinSkill = "Assets/Main/Sprites/UI/UICitySkinSkill/%s.png",
  TWSkillChipIcons = "Assets/Main/Sprites/TWSkillChipIcons/%s",
  BPNewYear = "Assets/Main/Sprites/UI/UINewYearBP/%s",
  ChampionDuelTexturePath = "Assets/Main/TextureEx/ChampionDuel/%s",
  UIChampionDuelSpritePath = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/%s",
  UIWorkerSpritePath = "Assets/Main/Sprites/UI/UIWorker/%s.png",
  UIWorkerTexturePath = "Assets/Main/TextureEx/UIWorker/%s.png",
  BPNewYearTextureEx = "Assets/Main/TextureEx/UIActivityBg/NewYear/%s",
  ActivityBargainShopBannerPath = "Assets/Main/TextureEx/UIActivityBg/Banner/BargainShop/%s",
  ActivityBargainShopUIPath = "Assets/Main/Sprites/UI/LWUIActivityBargainShop/%s",
  CitySkinExchangeUIPath = "Assets/Main/Sprites/UI/UICitySkinExchange/%s",
  CitySkinExchangeTexturePath = "Assets/Main/TextureEx/UIActivityBg/Easter/CitySkinExchange/%s",
  CitySkinExchangeFestivalPath = "Assets/Main/ActivityFestival/ActCitySkinExchange/%s",
  DispatchTreasure = "Assets/Main/Sprites/UI/UIDispatchTreasure/%s",
  TWSkillChipEmptyBgPath = "Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_icon_0%d.png",
  TWSkillChipQualityBgPath = "Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_xingpiankuang0%d.png",
  UILWBattle = "Assets/Main/Sprites/UI/UILWBattle/%s",
  UIMainBubble = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/%s",
  UILWBerserkBoss = "Assets/Main/Sprites/UI/UILWBerserkBoss/%s.png",
  QuestionMark = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_zhanbao_ganrao_icon.png",
  ActRadarRawImg = "Assets/Main/TextureEx/UILWRadarCenter/ActRadarRawImg/%s.png",
  DailyPackageUniqueWeapon = "Assets/Main/TextureEx/UIDailyPackage/%s.png",
  UILWAssemblyBgPath = "Assets/Main/TextureEx/LWUIAllianceAssemblyInfo/%s.png",
  UISeasonPath = "Assets/Main/Sprites/UI/UISeason/Sprites/%s.png",
  UISeason2Path = "Assets/Main/Sprites/UI/UISeason/UISeason2/%s.png",
  Season3Path = "Assets/Main/SeasonRes/S3/%s",
  UISeason3Path = "Assets/Main/SeasonRes/S3/Sprites/UI/%s",
  UISeason3CommonPath = "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/%s",
  UISeason3ComponentPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/Component/%s",
  UISeason4Path = "Assets/Main/SeasonRes/S4/Sprites/UI/%s",
  TextureSeason4Path = "Assets/Main/SeasonRes/S4/Textures/%s",
  UISeason5Path = "Assets/Main/SeasonRes/S5/Sprites/%s",
  S3ActivityTex = "Assets/Main/SeasonRes/S3/Textures/Activity/%s.png",
  UIDiggingGame = "Assets/Main/SeasonRes/S3/Sprites/UI/DiggingGame/%s.png",
  UIDiggingTex = "Assets/Main/SeasonRes/S3/Textures/DiggingGame/%s.png",
  UIDiggingGameC = "Assets/Main/SeasonRes/Shared/Sprites/AlliacneBoss/%s.png",
  UIDiggingTexC = "Assets/Main/SeasonRes/Shared/Textures/AlliacneBossTexure/%s.png",
  UISeasonGreen = "Assets/Main/SeasonRes/S3/Sprites/UI/SeasonGreen/%s.png",
  UISeasonGreenTex = "Assets/Main/SeasonRes/S3/Textures/SeasonGreen/%s.png",
  UIMummy = "Assets/Main/SeasonRes/Shared/Sprites/UIMummy/%s.png",
  UILWDominatorRankShowBigIconPath = "Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorRankIcon/ljq_zhuzai_duanwei_0%s.png",
  UILWDominatorTrainLevelNumberIconPath = "Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorCommon/zxl_shuzi%s.png",
  DominatorIconBg = "Assets/Main/Sprites/UI/UIHeroCommon/zxl_zhuzai_touxiangkuang.png",
  DominatorIconBgBig = "Assets/Main/Sprites/UI/UIHeroCommon/zxl_zhuzai_touxiangkuang_chang2.png",
  DominatorDefaultRoundIcon = "Assets/Main/Sprites/HeroRoundIcon/zxl_zhuzai_biandui.png",
  DominatorRoundIconPath = "Assets/Main/Sprites/HeroRoundIcon/%s",
  LWUIZoneMobilizationTexturePath = "Assets/Main/TextureEx/LWUIZoneMobilization/%s.png",
  LWUIZoneMobilizationSpritePath = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png",
  LWActMeteoriteBattlePath = "Assets/Main/Sprites/UI/LWActMeteorite/%s",
  HeroMonthCardNewTexturePath = "Assets/Main/TextureEx/UIHeroMonthCard/NewMonthCard/%s.png",
  HeroMonthCardSpritePath = "Assets/Main/Sprites/UI/LWHeroMonthCard/%s.png",
  UIDispatchTaskSpritePath = "Assets/Main/Sprites/UI/UIDispatchTask/%s",
  LWPVPArenaPath = "Assets/Main/Sprites/UI/LWPVPArena/%s",
  LWActRewardCommonPath = "Assets/Main/Sprites/UI/ActRewardCommon/%s",
  LWBattleFieldPath = "Assets/Main/Sprites/UI/BattleField/%s",
  LWBattleFieldCommanderPath = "Assets/Main/Sprites/UI/BattleFieldCommander/%s",
  LWBattleFieldMvpPath = "Assets/Main/Sprites/UI/BattleFieldMvp/%s",
  LWBattleFieldDesertDetailPath = "Assets/Main/Sprites/UI/UIDesertBattle/detail/%s",
  LWBattleFieldDesertPath = "Assets/Main/Sprites/UI/UIDesertBattle/Sprites/%s",
  LWBattleFieldDesertTexturePath = "Assets/Main/TextureEx/BF_Desert/%s",
  LWBattleFieldWinterPath = "Assets/Main/Sprites/UI/BF_Winter/UI/%s",
  LWBattleFieldWinterDetailPath = "Assets/Main/Sprites/UI/BF_Winter/Detail/%s",
  LWBattleFieldWinterAchievementPath = "Assets/Main/Sprites/UI/BF_Winter/Achievement/%s",
  LWBattleFieldWinterTexturePath = "Assets/Main/TextureEx/BF_Winter/%s",
  LWBattleFieldWinterTextureGuidePath = "Assets/Main/TextureEx/BF_Winter/Guide/%s",
  LWBattleFieldEpidemicPath = "Assets/Main/Sprites/UI/BF_Epidemic/UI/%s",
  LWBattleFieldDsbDuelPath = "Assets/Main/Sprites/UI/BF_Dsb_Duel/UI/%s",
  LWBattleFieldDsbDuelWorldPath = "Assets/Main/Sprites/UI/BF_Dsb_Duel/World/%s",
  LWBattleFieldDsbDuelDetailPath = "Assets/Main/Sprites/UI/BF_Dsb_Duel/Detail/%s",
  LWBattleFieldDsbDuelTexturePath = "Assets/Main/TextureEx/BF_Dsb_Duel/%s",
  LWBattleFieldEpidemicDetailPath = "Assets/Main/Sprites/UI/BF_Epidemic/Detail/%s",
  LWBattleFieldEpidemicTexture0Path = "Assets/Main/TextureEx/BF_Epidemic/part0/%s",
  LWBattleFieldEpidemicTexture1Path = "Assets/Main/TextureEx/BF_Epidemic/part1/%s",
  LWBattleFieldEpidemicTexture2Path = "Assets/Main/TextureEx/BF_Epidemic/part2/%s",
  LWBattleFieldEpidemicTexture3Path = "Assets/Main/TextureEx/BF_Epidemic/part3/%s",
  LWBattleFieldEpidemicEffectPath = "Assets/Main/Prefabs/Effect/BF_Epidemic/%s",
  UIDigTreasureSpritePath = "Assets/Main/Sprites/UI/UIDigTreasure/%s",
  UIDigTreasureTexturePath = "Assets/Main/TextureEx/UIDigTreasure/%s",
  UIDisPatchTreasureBannerPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/%s",
  PartyMonsterSpritePath = "Assets/Main/Sprites/UI/UIActChristmasTree/%s.png",
  TMPFontMaterialPath = "Assets/Main/TMPFont/Main/%s.mat",
  TacticalCardSkillPath = "Assets/Main/Sprites/TacticalCardSkill/%s.png",
  UIOffSeasonDiggingGame = "Assets/Main/Sprites/UI/UIOffSeasonDiggingGame/%s.png",
  UIOffSeasonDiggingTexturePath = "Assets/Main/TextureEx/OffSeasonDiggingGame/%s.png",
  SurfingBattlePassBoxIconPath = "Assets/Main/Sprites/UI/UISurfingBattle/UISurfingBattleMainUI/%s.png",
  SurfingBuffSkillIconPath = "Assets/Main/Sprites/UI/UISurfingBattle/%s.png",
  ActBuffSpritesPath = "Assets/Main/Sprites/UI/%s",
  ActBuffTextureExPath = "Assets/Main/TextureEx/%s",
  WeekCardPath = "Assets/Main/Sprites/UI/UILWCommonStore/%s.png",
  ActivityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s",
  UINoticeRecordSpritePath = "Assets/Main/Sprites/UI/UINoticeRecord/%s",
  ActCalendar = "Assets/Main/Sprites/UI/ActCalendar/%s.png",
  ActCalendarTexture = "Assets/Main/TextureEx/ActCalendar/%s.png",
  LastStandSpritesPath = "Assets/Main/Sprites/UI/LastStand/%s",
  UILWTC = "Assets/Main/Sprites/UI/UILWTC/%s.png",
  LWAllianceMilitaryPayIconPath = "Assets/Main/Sprites/UI/LWAllianceMilitaryPay/%s.png",
  LWAllianceMilitaryPayTexturePath = "Assets/Main/TextureEx/UILWAllianceMilitary/%s.png",
  LandlordPath = "Assets/Main/Sprites/UI/Landlord/%s",
  LandlordTexturePath = "Assets/Main/TextureEx/Landlord/%s",
  UILWArmedUpgradeIconPath = "Assets/Main/Sprites/UI/UILWArmedUpgrade/%s.png",
  CommonHeroRedStarFragImagePath = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_yingxiong_xingxing_hong0%s.png",
  CommonHeroYellowStarFragImagePath = "Assets/Main/Sprites/UI/LWCommon/Sprite2/FX_yingxiong_xingxing_0%s.png"
}

function LoadPath.GetBuildBtnSpritePath(btnType)
  local fileName
  if SeasonUtil.IsInSeason() then
    local x = SeasonUtil.GetSeasonType()
    local btnDic = WorldPointBtnTypeImageSeason[SeasonUtil.GetSeasonType()]
    if btnDic then
      fileName = btnDic[btnType]
    end
  end
  fileName = fileName or WorldPointBtnTypeImage[btnType]
  return UIUtil.GetFullPath(LoadPath.UIBuildBtns, fileName)
end

ResourceTypeIconName = {}
ResourceTypeIconName[ResourceType.BatteryPower] = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_05.png"
ResourceTypeIconName[ResourceType.Electricity] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_electricity"
ResourceTypeIconName[ResourceType.Metal] = "Assets/Main/Sprites/UI/LWCommon/Sprite/tubiao_gangcai_da"
ResourceTypeIconName[ResourceType.Food] = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zhujiemian_cfm_tubiao_2"
ResourceTypeIconName[ResourceType.Water] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_water"
ResourceTypeIconName[ResourceType.Gold] = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/zhujiemian_cfm_tubiao_3"
ResourceTypeIconName[ResourceType.Oil] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_oil"
ResourceTypeIconName[ResourceType.PvePoint] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_pvecode"
ResourceTypeIconName[ResourceType.MedalOfWisdom] = "Assets/Main/Sprites/ItemIcons/item210454"
ResourceTypeIconName[ResourceType.FarmBox] = "Assets/Main/Sprites/UI/LWCommon/Sprite/item200150"
ResourceTypeIconName[ResourceType.PvePoint] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_pvecode"
ResourceTypeIconName[ResourceType.DETECT_EVENT] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_radar"
ResourceTypeIconName[ResourceType.FORMATION_STAMINA] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_stamina"
ResourceTypeIconName[ResourceType.Wood] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_wood.png"
ResourceTypeIconName[ResourceType.PVE_STAMINA] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_stamina"
ResourceTypeIconName[ResourceType.People] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_people"
ResourceTypeIconName[ResourceType.DragonItem] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_alPoint"
ResourceTypeIconName[ResourceType.AlliancePoint] = "Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmengkejijuanxian_jifen"
ResourceTypeIconName[ResourceType.DragonPoint] = "Assets/Main/Sprites/ItemIcons/zyf_xunzhang_icon"
ResourceTypeIconName[ResourceType.OBSIDIAN] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_recruit_firecrystal"
ResourceTypeIconName[ResourceType.FLINT] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_recruit_massif3"
ResourceTypeIconName[ResourceType.ResistancePoint] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_saijikaifa_dangqiankangxing_icon.png"
ResourceTypeIconName[ResourceType.AllianceBattleReward] = "Assets/Main/Sprites/UI/LWCommon/Sprite/itemBox.png"
ResourceTypeIconName[ResourceType.PAID_GOLD] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_zuanshishangdian_youliao.png"
ChatChannelType = {
  CHAT_CHANNEL_COUNTRY = 0,
  CHAT_CHANNEL_ALLIANCE = 1,
  CHAT_CHANNEL_USER = 2,
  CHAT_CHANNEL_ROOM = 3
}
ChatRoomCategory = {
  WORLD = "WORLD",
  ALLIANCE = "ALLIANCE",
  ACTIVITY = "ACTIVITY",
  PRIVATE = "PRIVATE",
  MOMENT = "MOMENT"
}
ChatMessageType = {
  COMMON = 0,
  SYSTEM = 1,
  FESTIVAL = 2
}
ChatMsgReqState = {
  None = 0,
  Request = 1,
  HaveData = 2,
  NoData = 3
}
RestrictType = {BLOCK = 1, BAN = 2}
SendStateType = {
  OK = 0,
  PENDING = 1,
  FAILED = 2
}
ScreenType = {Portrait = 0, Landscape = 1}
RecordResultState = {
  RECORD_SAVE_ERROR = -4,
  RECORD_USER_CANCELED = -3,
  RECORD_TOO_SHORT = -2,
  MICROPHONE_UNAVAILABLE = -1,
  OK = 0
}
ArmyFormationState = {
  Free = 0,
  March = 1,
  Prison = 2,
  Death = 3,
  GoHome = 4,
  Revival = 5,
  Prison_PickDNA = 6,
  StationBuilding = 7,
  Formation = 8
}
BuildTilesSize = {
  One = 1,
  Two = 2,
  Three = 3,
  Four = 4,
  Five = 5,
  Seven = 7,
  Nine = 9
}
BuildNeedMonth = {No = 0, Yes = 1}
BuildInside = {
  In = 0,
  Out = 1,
  All = 2
}
ResidentOrderState = {
  No = 0,
  Yes = 1,
  CanBuy = 2
}
UIMailOpenType = {
  Default = 1,
  Detail = 2,
  History = 3,
  Train = 4
}
UIMailRegion = {
  ReplayBtn = 1,
  Equip = 2,
  Skill = 3,
  UniqueWeapon = 4
}
MailDetailLinkOperateType = {COPY = "COPY"}
UIBuildListTabType = {
  SeasonBuild = 4,
  EdenSubway = 6,
  Robot = 10,
  SeasonRobot = 11,
  Economy = 1,
  Military = 2,
  Decorate = 3,
  SeasonCityBuild = 7
}
UIBuildListTabTypeSort = {
  UIBuildListTabType.Robot,
  UIBuildListTabType.InBuild,
  UIBuildListTabType.OutBuild,
  UIBuildListTabType.Road
}
UIBuildListBuildType = {
  BuildRoad = 1,
  RemoveRoad = 2,
  Build = 3,
  Robot = 4,
  Decorate = 5
}
UIMainAnimType = {
  AllHide = "OutWithResource",
  LeftRightBottomHide = "OutWithoutResource",
  AllShow = "EnterWithResource",
  LeftRightBottomShow = "EnterWithoutResource",
  ChangeAllShow = "ChangeAllShow",
  BottomHide = "OutBottom",
  BottomShow = "EnterBottom"
}
UIMainAnimFlag = {
  TopLeft = 1,
  TopRight = 2,
  TopCenter = 4,
  BottomLeft = 8,
  BottomRight = 16,
  BottomCenter = 32,
  ArabicTopLeft = 64,
  ArabicTopRight = 128,
  ArabicTopCenter = 256,
  ArabicBottomLeft = 512,
  ArabicBottomRight = 1024,
  ArabicBottomCenter = 2048
}
UIMainAnimMask = {
  All = UIMainAnimFlag.TopLeft + UIMainAnimFlag.TopRight + UIMainAnimFlag.TopCenter + UIMainAnimFlag.BottomLeft + UIMainAnimFlag.BottomRight + UIMainAnimFlag.BottomCenter,
  Top = UIMainAnimFlag.TopLeft + UIMainAnimFlag.TopRight + UIMainAnimFlag.TopCenter,
  Bottom = UIMainAnimFlag.BottomLeft + UIMainAnimFlag.BottomRight + UIMainAnimFlag.BottomCenter,
  ArabicAll = UIMainAnimFlag.ArabicTopLeft + UIMainAnimFlag.ArabicTopRight + UIMainAnimFlag.ArabicTopCenter + UIMainAnimFlag.ArabicBottomLeft + UIMainAnimFlag.ArabicBottomRight + UIMainAnimFlag.ArabicBottomCenter,
  ArabicTop = UIMainAnimFlag.ArabicTopLeft + UIMainAnimFlag.ArabicTopRight + UIMainAnimFlag.ArabicTopCenter,
  ArabicBottom = UIMainAnimFlag.ArabicBottomLeft + UIMainAnimFlag.ArabicBottomRight + UIMainAnimFlag.ArabicBottomCenter
}
ResourceTabSelectImage = {}
ResourceTabSelectImage[ResourceType.Oil] = "Assets/Main/Sprites/Resource/Oil_select"
ResourceTabSelectImage[ResourceType.Metal] = "Assets/Main/Sprites/Resource/Metal_select"
ResourceTabSelectImage[ResourceType.Water] = "Assets/Main/Sprites/Resource/Water_select"
ResourceTabSelectImage[ResourceType.Electricity] = "Assets/Main/Sprites/Resource/Electricity_select"
ResourceTabSelectImage[ResourceType.Food] = "Assets/Main/Sprites/Resource/Money_select"
ResourceTabSelectImage[ResourceType.Wood] = "Assets/Main/Sprites/Resource/Wood_select"
ResourceTabUnSelectImage = {}
ResourceTabUnSelectImage[ResourceType.Oil] = "Assets/Main/Sprites/Resource/Oil_unSelect"
ResourceTabUnSelectImage[ResourceType.Metal] = "Assets/Main/Sprites/Resource/Metal_unSelect"
ResourceTabUnSelectImage[ResourceType.Water] = "Assets/Main/Sprites/Resource/Water_unSelect"
ResourceTabUnSelectImage[ResourceType.Electricity] = "Assets/Main/Sprites/Resource/Electricity_unSelect"
ResourceTabUnSelectImage[ResourceType.Food] = "Assets/Main/Sprites/Resource/Money_unSelect"
ResourceTabUnSelectImage[ResourceType.Wood] = "Assets/Main/Sprites/Resource/Wood_unSelect"
UICapacityTableTab = {
  Farming = 0,
  Industry = 1,
  Resource = 2,
  Item = 3,
  ResourceItem = 4
}
UIBagTab = {
  Special = 1,
  Resource = 2,
  SpeedUp = 3,
  Hero = 4,
  Equip = 5,
  Gift = 6
}
UIBagShowTab = {
  UIBagTab.Special,
  UIBagTab.Resource,
  UIBagTab.SpeedUp,
  UIBagTab.Hero,
  UIBagTab.Equip,
  UIBagTab.Gift
}
UIBagTabTitle = {
  [UIBagTab.Special] = "129001",
  [UIBagTab.Resource] = "129002",
  [UIBagTab.SpeedUp] = "129003",
  [UIBagTab.Hero] = "129004",
  [UIBagTab.Equip] = "129024",
  [UIBagTab.Gift] = "string_gifts"
}
CapacityTabSelectImage = {}
CapacityTabSelectImage[UICapacityTableTab.Farming] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_warehouse"
CapacityTabSelectImage[UICapacityTableTab.Industry] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_warehouse_select"
CapacityTabSelectImage[UICapacityTableTab.Resource] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_resentrepot"
CapacityTabSelectImage[UICapacityTableTab.Item] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_prop"
CapacityTabUnSelectImage = {}
CapacityTabUnSelectImage[UICapacityTableTab.Farming] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_warehouse_unchecked"
CapacityTabUnSelectImage[UICapacityTableTab.Industry] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_warehouse_unselect"
CapacityTabUnSelectImage[UICapacityTableTab.Resource] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_resentrepot_unchecked"
CapacityTabUnSelectImage[UICapacityTableTab.Item] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_prop_unchecked"
UIWorldTileTopBtnType = {
  Share = 1,
  Book = 2,
  Emoji = 3,
  PackUp = 4
}
UIWorldTileTopBtnSort = {
  UIWorldTileTopBtnType.Share,
  UIWorldTileTopBtnType.Book
}
UIWorldTileTopBtnImage = {}
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Share] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_share_position"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Book] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_collect"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Emoji] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_meme"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.PackUp] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_recycle"
WorldTileBtnType = {
  City_BuildingHelper = 0,
  City_Repair = 1,
  City_Robot_Set = 2,
  City_Details = 3,
  City_Assistance = 4,
  City_Upgrade = 5,
  City_MyProfile = 6,
  City_Attack = 7,
  City_EarthOrder = 8,
  City_Product = 9,
  City_Science = 10,
  City_Call = 11,
  City_QiFei = 12,
  City_SpeedUp = 13,
  March_ViewTroop = 14,
  March_SpeedUp = 15,
  March_Callback = 16,
  March_Rally = 17,
  March_Attack = 18,
  City_PickUp = 19,
  City_Recovery = 20,
  City_BusinessCenter = 21,
  City_ColdCapacity = 22,
  City_IntegratedWarehouse = 23,
  City_ResourceTransport = 24,
  City_SpeedUpTrain = 25,
  City_SpeedUpScience = 26,
  City_SpeedUpHospital = 27,
  City_TrainingAircraft = 28,
  City_TrainingInfantry = 29,
  City_TrainingTank = 30,
  City_Defence = 31,
  Hero_Advance = 32,
  Hero_Bag = 33,
  City_BatteryrAttack = 34,
  City_Garrison = 35,
  WormHole_Enter = 36,
  RadarCenter_Alert = 37,
  RadarCenter_Detective = 38,
  AllianceResSupport = 39,
  AllianceEntrance = 40,
  AllianceBattle = 41,
  ARMY = 44,
  WormHole_Create = 45,
  WormHole_Dismantle = 46,
  GolloesCamp = 47,
  City_GROCERY_STORE = 48,
  Hero_Station = 49,
  City_SpeedUpRuins = 50,
  Konbini = 51,
  StorageShop = 52,
  GarageRefit = 53,
  PoliceStation = 54,
  WorldTrend = 55,
  WormHoleToB = 56,
  WormHoleToC = 57,
  CommonShop = 59,
  HeroResetShop = 60,
  WorldNews = 61,
  Talent = 62,
  HeroBounty = 63,
  HeroOfficial = 64,
  LevelExplore = 65,
  PveMonument = 66,
  CrossWormHoleEnter = 67,
  EnergyOrder = 68,
  Museum = 69,
  Hero_Recruit = 70,
  Train_Soldier = 71,
  Worker_List = 72,
  Worker_BuildQueue = 73,
  Equip = 74,
  Collect_Soldier = 75,
  Wall_Deployment = 76,
  City_Shield = 77,
  Hospital_soldier = 78,
  Hospital_speed = 79,
  HeroSquad = 80,
  EffectOverview = 82,
  JumpStage = 83,
  ChangeNation = 84,
  Decoration = 85,
  TrainList = 86,
  SquadEquip = 87,
  Decirate_Details = 88,
  PVPArena = 89,
  HeroHOF = 90,
  SaveGirl = 91,
  TacticalWeapon = 92,
  Season = 93,
  AssistanceSeasonBuild = 94,
  SeasonBuildDetails = 95,
  SeasonBuildPickUp = 96,
  Mastery = 97,
  CrossWormHero = 98,
  DecoratorExhibition = 99,
  WorkerOverview = 100,
  MasterySkill = 101,
  SeasonWeekCard = 102,
  City_BuildingFullLevelDetail = 103,
  DecorationPlaySound = 104,
  RebirthHospital = 105,
  PersonalFurnace = 106,
  AlertTowerTrail = 107,
  TacticalChipFactory = 108,
  DominatorMain = 109,
  DominatorTrain = 110,
  MummyMainUI = 111,
  LightHouseMainUI = 112,
  SeasonBigPhoto = 113,
  SeasonWorld = 114,
  TacticalCard = 115,
  ChampionDuel = 116,
  T11Research = 117,
  T11IdleGameEntrance = 118,
  MakingCoffee = 119,
  OpenSeasonBountyShop = 120,
  OpenSeasonMilitary = 121,
  OpenSeasonMilitaryElite = 122,
  SeasonTowerEntrance = 123,
  CivilizationSparkFrontBreak = 124,
  CivilizationSparkUpgrade = 125
}
WorldTileBtnTypeImage = {}
WorldTileBtnTypeImage[WorldTileBtnType.OpenSeasonBountyShop] = "Assets/Main/Sprites/UI/UIBuildBtns/mjc_S4_zhujiemian_myz_shangdian.png"
WorldTileBtnTypeImage[WorldTileBtnType.OpenSeasonMilitary] = "Assets/Main/Sprites/UI/UIBuildBtns/ljq_zhujiemian_jungong.png"
WorldTileBtnTypeImage[WorldTileBtnType.OpenSeasonMilitaryElite] = "Assets/Main/Sprites/UI/UIBuildBtns/zyf_shijieboss_rank_icon.png"
WorldTileBtnTypeImage[WorldTileBtnType.LightHouseMainUI] = "Assets/Main/SeasonRes/S4/Textures/Common/ljq_zhujiemian_diandeng.png"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonBigPhoto] = "ljq_zhujiemian_saijidahezhao"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonWorld] = "ljq_zhujiemian_diqiu"
WorldTileBtnTypeImage[WorldTileBtnType.MummyMainUI] = "uibuild_btn_mummy"
WorldTileBtnTypeImage[WorldTileBtnType.City_BuildingHelper] = "uibuild_btn_wenhao"
WorldTileBtnTypeImage[WorldTileBtnType.City_Repair] = "uibuild_btn_repair"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpRuins] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_MyProfile] = "uibuild_btn_info_des"
WorldTileBtnTypeImage[WorldTileBtnType.City_Attack] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_Upgrade] = "uibuild_btn_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_Science] = "uibuild_btn_science"
WorldTileBtnTypeImage[WorldTileBtnType.City_Call] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_QiFei] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUp] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_Recovery] = "uibuild_btn_hospital"
WorldTileBtnTypeImage[WorldTileBtnType.TrainList] = "uibuild_btn_hospital"
WorldTileBtnTypeImage[WorldTileBtnType.March_ViewTroop] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_SpeedUp] = "lyp__buduizhuangtai_jiasu"
WorldTileBtnTypeImage[WorldTileBtnType.March_Callback] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_Rally] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_Attack] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_PickUp] = "lrb_zhuangshiwu_huishou"
WorldTileBtnTypeImage[WorldTileBtnType.City_Details] = "uibuild_btn_info_des"
WorldTileBtnTypeImage[WorldTileBtnType.City_EarthOrder] = "uibuild_btn_rocket"
WorldTileBtnTypeImage[WorldTileBtnType.City_Product] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_BusinessCenter] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_ColdCapacity] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Advance] = "UIreset_icon_degree"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Recruit] = "UIreset_icon_recruit"
WorldTileBtnTypeImage[WorldTileBtnType.City_IntegratedWarehouse] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_ResourceTransport] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpTrain] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpScience] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpHospital] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingAircraft] = "uibuild_btn_aircraft"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingInfantry] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingTank] = "uibuild_btn_tank"
WorldTileBtnTypeImage[WorldTileBtnType.City_Defence] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.City_BatteryrAttack] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_Garrison] = "uibuild_btn_tank"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Enter] = "uibuild_btn_transmit"
WorldTileBtnTypeImage[WorldTileBtnType.City_Assistance] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.RadarCenter_Alert] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.RadarCenter_Detective] = "uibuild_btn_detect_event"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceResSupport] = "uibuild_btn_al_help"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceEntrance] = "uibuild_btn_al_entrance"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceBattle] = "uibuild_btn_al_battle"
WorldTileBtnTypeImage[WorldTileBtnType.City_GROCERY_STORE] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_Robot_Set] = "uibuild_btn_robot"
WorldTileBtnTypeImage[WorldTileBtnType.ARMY] = "uibuild_btn_al_troop"
WorldTileBtnTypeImage[WorldTileBtnType.WorldNews] = "uibuild_btn_worldNews"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Create] = "uibuild_btn_xiujian"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Dismantle] = "uibuild_btn_chaichu"
WorldTileBtnTypeImage[WorldTileBtnType.WormHoleToB] = "uibuild_btn_shachong_b"
WorldTileBtnTypeImage[WorldTileBtnType.WormHoleToC] = "uibuild_btn_shachong_c"
WorldTileBtnTypeImage[WorldTileBtnType.GolloesCamp] = "uibuild_btn_golloesCamp"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Station] = "uibuild_btn_hero_station"
WorldTileBtnTypeImage[WorldTileBtnType.StorageShop] = "uibuild_btn_storageShop"
WorldTileBtnTypeImage[WorldTileBtnType.CommonShop] = "uibuild_btn_commonShop"
WorldTileBtnTypeImage[WorldTileBtnType.Konbini] = "uibuild_btn_konbini"
WorldTileBtnTypeImage[WorldTileBtnType.GarageRefit] = "uibuild_btn_garagerefit"
WorldTileBtnTypeImage[WorldTileBtnType.PoliceStation] = "uibuild_btn_police_station"
WorldTileBtnTypeImage[WorldTileBtnType.WorldTrend] = "uibuild_btn_mars"
WorldTileBtnTypeImage[WorldTileBtnType.PveMonument] = "uibuild_btn_heroMounment"
WorldTileBtnTypeImage[WorldTileBtnType.Talent] = "uibuild_btn_Talent"
WorldTileBtnTypeImage[WorldTileBtnType.HeroResetShop] = "uibuild_btn_heroShop"
WorldTileBtnTypeImage[WorldTileBtnType.HeroBounty] = "uibuild_btn_reward"
WorldTileBtnTypeImage[WorldTileBtnType.HeroOfficial] = "uibuild_btn_hero_official"
WorldTileBtnTypeImage[WorldTileBtnType.LevelExplore] = "uibuild_btn_level_explore"
WorldTileBtnTypeImage[WorldTileBtnType.CrossWormHoleEnter] = "uibuild_btn_cross"
WorldTileBtnTypeImage[WorldTileBtnType.CrossWormHero] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.Museum] = "uibuild_btn_museum"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Bag] = "uibuild_btn_heroShop"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonBuildPickUp] = "uibuild_btn_pickup"
WorldTileBtnTypeImage[WorldTileBtnType.AssistanceSeasonBuild] = "uibuild_btn_reinforce"
WorldTileBtnTypeImage[WorldTileBtnType.Train_Soldier] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.Worker_List] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.Worker_BuildQueue] = "uibuild_btn_reward"
WorldTileBtnTypeImage[WorldTileBtnType.Equip] = "uibuild_btn_xiujian"
WorldTileBtnTypeImage[WorldTileBtnType.TacticalChipFactory] = "uibuild_btn_xiujian"
WorldTileBtnTypeImage[WorldTileBtnType.Collect_Soldier] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.Wall_Deployment] = "uibuild_btn_appointment"
WorldTileBtnTypeImage[WorldTileBtnType.City_Shield] = "lyp_buff_fanghu"
WorldTileBtnTypeImage[WorldTileBtnType.Hospital_soldier] = "zyf_zhuchengyiyuan_zhuyeqipao"
WorldTileBtnTypeImage[WorldTileBtnType.HeroSquad] = "uibuild_btn_tank"
WorldTileBtnTypeImage[WorldTileBtnType.EffectOverview] = "lyp_zhujiemian_shuxingjiachengrukou"
WorldTileBtnTypeImage[WorldTileBtnType.JumpStage] = "uibuild_btn_attack"
WorldTileBtnTypeImage[WorldTileBtnType.ChangeNation] = "cfm_zhujiemian_qizi"
WorldTileBtnTypeImage[WorldTileBtnType.Decoration] = "zyf_zhujiemian_zhuangban"
WorldTileBtnTypeImage[WorldTileBtnType.SquadEquip] = "zyf_zhujiemian_cheku"
WorldTileBtnTypeImage[WorldTileBtnType.Decirate_Details] = "uibuild_btn_info"
WorldTileBtnTypeImage[WorldTileBtnType.PVPArena] = "lrb_zhujiemian_dianfengduijue"
WorldTileBtnTypeImage[WorldTileBtnType.HeroHOF] = "zyf_zhenyingrongyuqiang_rukou"
WorldTileBtnTypeImage[WorldTileBtnType.SaveGirl] = "lrb_zhujiemian_chaidan"
WorldTileBtnTypeImage[WorldTileBtnType.Mastery] = "zyf_zhujiemian_zhiyezhuanjing_icon"
WorldTileBtnTypeImage[WorldTileBtnType.Season] = "zyf_zhujiemian_saijizhuui_icon"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonBuildDetails] = "uibuild_btn_info"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonBuildPickUp] = "uibuild_btn_operate"
WorldTileBtnTypeImage[WorldTileBtnType.TacticalWeapon] = "uibuild_btn_aircraft"
WorldTileBtnTypeImage[WorldTileBtnType.WorkerOverview] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.MasterySkill] = "od_zhujiemian_zhiyejineng"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonWeekCard] = "uibuild_btn_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_BuildingFullLevelDetail] = "uibuild_btn_info"
WorldTileBtnTypeImage[WorldTileBtnType.DecorationPlaySound] = "uibuild_btn_decoration_play_sound"
WorldTileBtnTypeImage[WorldTileBtnType.RebirthHospital] = "od_zhujiemian_jiuhuche"
WorldTileBtnTypeImage[WorldTileBtnType.PersonalFurnace] = "mjc_zhujiemian_s2_dianhuo"
WorldTileBtnTypeImage[WorldTileBtnType.AlertTowerTrail] = "ljq_zhujiemian_feiji"
WorldTileBtnTypeImage[WorldTileBtnType.DominatorMain] = "zxl_zhuzai_zhujiemian_icon"
WorldTileBtnTypeImage[WorldTileBtnType.DominatorTrain] = "zxl_zhuzai_zhujiemian_icon"
WorldTileBtnTypeImage[WorldTileBtnType.TacticalCard] = "FX_zhanshukapai_icon_"
WorldTileBtnTypeImage[WorldTileBtnType.ChampionDuel] = "lyt_zhujiemian_guanjunduijue"
WorldTileBtnTypeImage[WorldTileBtnType.T11IdleGameEntrance] = "wxy_t11guaji_icon_huanxing"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonTowerEntrance] = "Assets/Main/Sprites/UI/LWUISeasonTower/FX_S6yuanzheng_jipurukou_icon.png"
WorldTileBtnTypeImage[WorldTileBtnType.T11Research] = "Assets/Main/Sprites/UI/UIT11Icon_InnerCity/ljq_zhujiemian_t11.png"
WorldTileBtnTypeImage[WorldTileBtnType.MakingCoffee] = "Assets/Main/SeasonRes/S5/Sprites/MakingCoffee/zxl_zhujiemian_kafei_tubiao.png"
WorldTileBtnTypeImage[WorldTileBtnType.CivilizationSparkFrontBreak] = "lrb_zhujiemian_qianxiantuwei"
WorldTileBtnTypeImage[WorldTileBtnType.CivilizationSparkUpgrade] = "uibuild_btn_up"
WorldPointBtnType = {
  BankRob = -8,
  BankDeposit = -7,
  SendPowerHelper = -6,
  MummyConvert = -5,
  MapSticker = -4,
  DeclareCityPrepare = -3,
  EliminateVirus = -2,
  Detail = -1,
  None = 0,
  AttackMonster = 1,
  RallyBoss = 2,
  AttackCity = 3,
  AttackBuild = 4,
  AttackRoad = 5,
  RallyCity = 6,
  RallyBuild = 7,
  AssistanceCity = 8,
  AssistanceBuild = 9,
  ScoutCity = 10,
  ScoutBuild = 11,
  ScoutArmyCollect = 12,
  ResourceHelp = 13,
  Collect = 14,
  CallBack = 15,
  AttackArmyCollect = 16,
  Search = 17,
  Explore = 18,
  GetReward = 19,
  Sample = 20,
  PickGarbage = 21,
  SingleMapGarbage = 22,
  StorageShop = 23,
  AllianceCollect = 25,
  TransPos = 26,
  AttackActBoss = 27,
  CheckActBossRank = 28,
  DeclareWar = 29,
  MonsterLockAttack = 30,
  AttackPuzzleBoss = 31,
  CheckPuzzleBossRank = 32,
  ChallengeHelp = 33,
  AttackActChallenge = 34,
  GoBackToCity = 35,
  AssistanceDesert = 36,
  AttackDesert = 37,
  ScoutDesert = 38,
  GiveUpDesert = 39,
  CancelGiveUpDesert = 40,
  CityShield = 41,
  GiveUpAllianceCity = 42,
  GiveUpAllianceCity_Cancel = 43,
  Wall_Deployment = 44,
  DetectEventPVE = 45,
  HelpMe = 46,
  DispatchTask = 47,
  DetectEventFakePVP = 48,
  AttackTrain = 49,
  Decoration = 50,
  HelperDetect = 51,
  Treasure = 52,
  DispatchTaskHelp = 53,
  DispatchTaskSteal = 54,
  DesertBuildList = 55,
  MoveCity = 56,
  PutAlliancePoint = 57,
  AttackAllianceBuild = 58,
  ScoutAllianceBuild = 59,
  AssistanceAllianceBuild = 60,
  RallyAllianceBuild = 61,
  ReBuildAllianceRuin = 62,
  BuildAllianceCenter = 63,
  AttackAllianceActMine = 64,
  RallyAllianceActMine = 65,
  ScoutAllianceActMine = 66,
  AllianceActMineDetail = 67,
  AllianceActMine_Collect = 68,
  AllianceMine_Construct = 69,
  AllianceMine_Collect = 70,
  AllianceMineDetail = 71,
  AllianceMineCallback = 72,
  FoldUpAllianceBuild = 73,
  MasterySkill = 74,
  CancelDeclareWar = 75,
  AllOut = 76,
  DetectScoutCity = 77,
  DetectOccupyCity = 78,
  WorldAllianceResourceCollect = 79,
  DesertWallDeployment = 80,
  Rescue = 81,
  Firefighting = 82,
  AllyDrilDonatel = 83,
  AllyDrilStart = 84,
  AllyDrilReward = 85,
  AllyDrilMove = 86,
  BerserkBossAttack = 87,
  BerserkBossRank = 88,
  WorldDetectSaveSurvivor = 89,
  SeasonStoveCenterInfo = 90,
  SeasonStoveCenterMove = 91,
  SendCoal = 92,
  DigIceAlly = 93,
  DigIceEnemy = 94,
  WorldSupplies = 95,
  GhostreconTaskSteal = 96,
  BuildNuclear = 97,
  PutAresMissile = 98,
  AttackAisilla = 99,
  AssistanceWinterEntity = 100,
  AttackWinterEntity = 101,
  ScoutWinterEntity = 102,
  StealWinterEntity = 103,
  AssistanceDragonBuild = 104,
  AttackDragonBuild = 105,
  ScoutDragonBuild = 106,
  PickDragonBuild = 107,
  RallyDragonBuild = 108,
  StatusDragonBuild = 109,
  BuildCityAttachment = 110,
  DestroyCityAttachment = 111,
  ShowCityAttachmentList = 112,
  DragonCommandOrder = 113,
  DragonCommandOrderTypePick = 114,
  DragonCommandOrderTypeAtk = 115,
  DragonCommandOrderTypeAssist = 116,
  DragonCommandOrderDelete = 117,
  DominatorGuide = 118,
  DragonCommandOrderBack = 119,
  RallySandworm = 120,
  SeasonMummyCenterInfo = 121,
  SeasonMummyCenterMove = 122,
  SeasonTradeShopRefresh = 123,
  SeasonTradeShopEnter = 124,
  DetectEventCaveExploration = 125,
  GiveUpTradeStation = 126,
  ZoneMobilizationDonate = 127,
  ZoneMobilizationDonateSupplies = 128,
  AttackSandworm = 129,
  GoddessMummy = 130,
  AllianceCityRally = 131,
  TradeStationBattleInfo = 132,
  CollectMeteorite = 133,
  AttackArmyMeteoriteCollect = 134,
  ScoutArmyMeteoriteCollect = 135,
  AttackPlayerRuinBuilding = 136,
  KillZombieKirovBox = 137,
  ClickWorldTreasure = 138,
  WhistleMonster = 139,
  Charge = 140,
  ChargeBack = 141,
  TacticalCardSkill = 142,
  GoldTreeCharge = 143,
  GoldTreeBless = 144,
  AttackDetectZombieBusTrain = 145,
  DetectRetryRescue = 146,
  DetectRetryResource = 147,
  DetectEventDigGame = 148,
  DetectEventSuppliesSearch = 149,
  TreasureChest = 150,
  DominatorCockatriceUnlock_1 = 151,
  DominatorCockatriceUnlock_2 = 152,
  GuardianTowerSkill = 153,
  KirovBossPlanTime = 154,
  AisillaPlanTime = 155,
  KirovBossRank = 156,
  AssistanceEpidemic = 157,
  AttackEpidemic = 158,
  ScoutEpidemic = 159,
  PickEpidemic = 160,
  RallyEpidemic = 161,
  CollectEpidemic = 163,
  BFCommandOrder = 164,
  DetectEventAttackCityS0Radar = 165,
  DetectEventAttackCityS0BattleRadar = 166,
  StatusBattlefieldBuild = 167,
  CrossZoneOutpostFix = 168,
  CrossZoneOutpostAssistance = 169,
  CrossZoneOutpostAttack = 170,
  CrossZoneOutpostRally = 171,
  CrossZoneOutpostScout = 172,
  AttackHSR = 173,
  TradeHSR = 174,
  DetectEventLastStand = 175,
  FlowerTrainConnect = 176,
  FlowerTrainDisconnect = 177,
  FlowerTrainGetReward = 178,
  FlowerTrainGiftPreview = 179,
  SkyBattle = 185,
  GiveUpTradeStation_Cancel = 186,
  AllyDrillDig = 187,
  LLAttackCity = 188,
  LLAssistanceCity = 189,
  LLScoutCity = 190,
  LLRallyCity = 191,
  AssistanceAllyFriendCity = 192,
  Fishing = 193,
  CampDestroy = 194,
  AllianceSkillReinforceCharge = 195,
  DestroyDeclareCity = 196,
  ReinforceWall = 197,
  CityAltarFish = 198,
  CityAltarGiveUp = 199,
  CityAltarCancelGiveUp = 200,
  S0AllianceBossBuildingMove = 201,
  S0AllianceBossBossMove = 202,
  S0AllianceBossBuildingDonate = 203,
  S0AllianceBossBuildingSetting = 204,
  S0AllianceBossBuildingRank = 205,
  S0AllianceBossBuildingRally = 206,
  S0AllianceBossBuildingGift = 207
}
WorldPointBtnTypeImage = {}
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceAllyFriendCity] = "Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_zhujiemian_jiemengzhushou.png"
WorldPointBtnTypeImage[WorldPointBtnType.CrossZoneOutpostFix] = "uibuild_btn_repair"
WorldPointBtnTypeImage[WorldPointBtnType.CrossZoneOutpostAssistance] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.CrossZoneOutpostAttack] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.CrossZoneOutpostRally] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.CrossZoneOutpostScout] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.GuardianTowerSkill] = "Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_zhujiemian_S4zyjn_dianta.png"
WorldPointBtnTypeImage[WorldPointBtnType.ShowCityAttachmentList] = "zxl_jianzao_chuizi"
WorldPointBtnTypeImage[WorldPointBtnType.BuildCityAttachment] = "mjc_S2_zhujiemian_jianzao"
WorldPointBtnTypeImage[WorldPointBtnType.DestroyCityAttachment] = "uibuild_btn_chaichu"
WorldPointBtnTypeImage[WorldPointBtnType.PutAresMissile] = "zyf_zhujiemian_feidan"
WorldPointBtnTypeImage[WorldPointBtnType.GoddessMummy] = "ljq_zhujiemian_dajisi_anniu"
WorldPointBtnTypeImage[WorldPointBtnType.TradeStationBattleInfo] = "uibuild_btn_info"
WorldPointBtnTypeImage[WorldPointBtnType.EliminateVirus] = "uibuild_btn_virus"
WorldPointBtnTypeImage[WorldPointBtnType.MummyConvert] = "ljq_zhujiemian_huanxing"
WorldPointBtnTypeImage[WorldPointBtnType.SendPowerHelper] = "Assets/Main/SeasonRes/S4/Textures/Common/ljq_zhujiemian_diangong.png"
WorldPointBtnTypeImage[WorldPointBtnType.MoveCity] = "zyf_saiji_qiancheng_icon"
WorldPointBtnTypeImage[WorldPointBtnType.PutAlliancePoint] = "zyf_saiji_jijie_icon"
WorldPointBtnTypeImage[WorldPointBtnType.AttackMonster] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.WhistleMonster] = "zxl_zhujiemian_chuishao"
WorldPointBtnTypeImage[WorldPointBtnType.AttackSandworm] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackCity] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackRoad] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackDesert] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackArmyCollect] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.RallyBoss] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.RallyCity] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.DeclareCityPrepare] = "uibuild_btn_declare_wait"
WorldPointBtnTypeImage[WorldPointBtnType.RallyBuild] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceCity] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.HelperDetect] = "od_zhujiemian_yuanzhu"
WorldPointBtnTypeImage[WorldPointBtnType.DetectScoutCity] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.DetectOccupyCity] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.Treasure] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceBuild] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceDesert] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutCity] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutArmyCollect] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutDesert] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ResourceHelp] = "uibuild_btn_help"
WorldPointBtnTypeImage[WorldPointBtnType.Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.CollectMeteorite] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AttackArmyMeteoriteCollect] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutArmyMeteoriteCollect] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.CollectMeteorite] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceCollect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.CallBack] = "uibuild_btn_return"
WorldPointBtnTypeImage[WorldPointBtnType.Search] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.Explore] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.GetReward] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.Sample] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.Rescue] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.PickGarbage] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.SingleMapGarbage] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.StorageShop] = "uibuild_btn_storageShop"
WorldPointBtnTypeImage[WorldPointBtnType.Detail] = "uibuild_btn_info"
WorldPointBtnTypeImage[WorldPointBtnType.TransPos] = "uibuild_btn_aircraft"
WorldPointBtnTypeImage[WorldPointBtnType.AttackActBoss] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.CheckActBossRank] = "zyf_shijieboss_rank_icon"
WorldPointBtnTypeImage[WorldPointBtnType.DeclareWar] = "uibuild_btn_declare"
WorldPointBtnTypeImage[WorldPointBtnType.Fishing] = "FX_diaoyu_rukouicon"
WorldPointBtnTypeImage[WorldPointBtnType.ReinforceWall] = "ljq_zhujiemian_jiagu"
WorldPointBtnTypeImage[WorldPointBtnType.SendCoal] = "mjc_zhujiemian_s2_dianhuo"
WorldPointBtnTypeImage[WorldPointBtnType.DigIceAlly] = "FX_S2saiji_icon_zaobing"
WorldPointBtnTypeImage[WorldPointBtnType.DigIceEnemy] = "FX_S2saiji_icon_zaobing"
WorldPointBtnTypeImage[WorldPointBtnType.RallySandworm] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.CancelDeclareWar] = "zyf_zhujiemian_zhongzhi"
WorldPointBtnTypeImage[WorldPointBtnType.AllOut] = "uibuild_btn_garagerefit"
WorldPointBtnTypeImage[WorldPointBtnType.MonsterLockAttack] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackPuzzleBoss] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.CheckPuzzleBossRank] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.AttackActChallenge] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ChallengeHelp] = "uibuild_btn_alliancehelp"
WorldPointBtnTypeImage[WorldPointBtnType.GoBackToCity] = "uibuild_btn_maincity"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpDesert] = "uibuild_btn_pickup"
WorldPointBtnTypeImage[WorldPointBtnType.CancelGiveUpDesert] = "uibuild_btn_cancel"
WorldPointBtnTypeImage[WorldPointBtnType.CityShield] = "lyp_buff_fanghu"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpAllianceCity] = "uibuild_btn_chaichu"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpAllianceCity_Cancel] = "uibuild_btn_canceldismantle"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventPVE] = "uibuild_btn_infantry"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventFakePVP] = "uibuild_btn_infantry"
WorldPointBtnTypeImage[WorldPointBtnType.Wall_Deployment] = "uibuild_btn_appointment"
WorldPointBtnTypeImage[WorldPointBtnType.HelpMe] = "zyf_sangshitiaozhan_bangzhu"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTask] = "lyp_daditu_paiqian"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTaskHelp] = "od_zhujiemian_yuanzhu"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTaskSteal] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.AttackTrain] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackHSR] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.TradeHSR] = "uibuild_btn_al_trading"
WorldPointBtnTypeImage[WorldPointBtnType.Decoration] = "zyf_zhujiemian_zhuangban"
WorldPointBtnTypeImage[WorldPointBtnType.DesertBuildList] = "uibuild_btn_tacticalbuilding"
WorldPointBtnTypeImage[WorldPointBtnType.BuildAllianceCenter] = "uibuild_btn_tacticalbuilding_r4"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAllianceBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutAllianceBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceAllianceBuild] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.RallyAllianceBuild] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.ReBuildAllianceRuin] = "uibuild_btn_repair"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAllianceActMine] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.RallyAllianceActMine] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutAllianceActMine] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceActMineDetail] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceActMine_Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMine_Construct] = "uibuild_btn_xiujian"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMine_Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMineDetail] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMineCallback] = "uibuild_btn_return"
WorldPointBtnTypeImage[WorldPointBtnType.FoldUpAllianceBuild] = "uibuild_btn_pickup"
WorldPointBtnTypeImage[WorldPointBtnType.MasterySkill] = "od_zhujiemian_zhiyejineng"
WorldPointBtnTypeImage[WorldPointBtnType.WorldAllianceResourceCollect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.DesertWallDeployment] = "uibuild_btn_tank"
WorldPointBtnTypeImage[WorldPointBtnType.WorldSupplies] = "FX_zhujiemian_shouji"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonStoveCenterInfo] = "mjc_zhujiemian_s2_dianhuo"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonStoveCenterMove] = "uibuild_btn_jump"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonMummyCenterInfo] = "uibuild_btn_commonShop"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonMummyCenterMove] = "uibuild_btn_jump"
WorldPointBtnTypeImage[WorldPointBtnType.Rescue] = "uibuild_btn_army"
WorldPointBtnTypeImage[WorldPointBtnType.AllyDrilDonatel] = "uibuild_btn_repair"
WorldPointBtnTypeImage[WorldPointBtnType.AllyDrilStart] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AllyDrilReward] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.AllyDrillDig] = "ljq_s5_qiaozhuankuai_qiang"
WorldPointBtnTypeImage[WorldPointBtnType.AllyDrilMove] = "zyf_saiji_qiancheng_icon"
WorldPointBtnTypeImage[WorldPointBtnType.Firefighting] = "ljq_zhujiemian_miehuoqi"
WorldPointBtnTypeImage[WorldPointBtnType.GhostreconTaskSteal] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.BerserkBossRank] = "zyf_shijieboss_rank_icon"
WorldPointBtnTypeImage[WorldPointBtnType.KirovBossRank] = "zyf_shijieboss_rank_icon"
WorldPointBtnTypeImage[WorldPointBtnType.BerserkBossAttack] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.WorldDetectSaveSurvivor] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.BuildNuclear] = "mjc_S2_zhujiemian_jianzao"
WorldPointBtnTypeImage[WorldPointBtnType.MapSticker] = "ljq_daditubiaoqing_icon"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAisilla] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.DominatorGuide] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.ZoneMobilizationDonate] = "ljq_zhujiemian_feitingweixiu"
WorldPointBtnTypeImage[WorldPointBtnType.ZoneMobilizationDonateSupplies] = "FX_zhujiemian_shouji"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceWinterEntity] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.AttackWinterEntity] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutWinterEntity] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceDragonBuild] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.AttackDragonBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutDragonBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.PickDragonBuild] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.RallyDragonBuild] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.StatusDragonBuild] = "uibuild_btn_build"
WorldPointBtnTypeImage[WorldPointBtnType.StatusBattlefieldBuild] = "uibuild_btn_build"
WorldPointBtnTypeImage[WorldPointBtnType.DragonCommandOrder] = "mjc_smfb_zhujiemian_icon_zhihui"
WorldPointBtnTypeImage[WorldPointBtnType.DragonCommandOrderTypePick] = "mjc_smfb_zhujiemian_icon_caiji"
WorldPointBtnTypeImage[WorldPointBtnType.DragonCommandOrderTypeAtk] = "mjc_smfb_zhujiemian_icon_gongji"
WorldPointBtnTypeImage[WorldPointBtnType.DragonCommandOrderTypeAssist] = "mjc_smfb_zhujiemian_icon_fangyu"
WorldPointBtnTypeImage[WorldPointBtnType.DragonCommandOrderDelete] = "uibuild_btn_cancel"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonTradeShopRefresh] = "mjc_S3_zhujiemian_myz_hujiaoshangdui"
WorldPointBtnTypeImage[WorldPointBtnType.SeasonTradeShopEnter] = "mjc_S3_zhujiemian_myz_shangdian"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventCaveExploration] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpTradeStation] = "uibuild_btn_chaichu"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpTradeStation_Cancel] = "uibuild_btn_canceldismantle"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceCityRally] = "uibuild_btn_allianceCityRally"
WorldPointBtnTypeImage[WorldPointBtnType.AttackPlayerRuinBuilding] = "mjc_zhujiemian_S3_chaichufeixu"
WorldPointBtnTypeImage[WorldPointBtnType.AttackDetectZombieBusTrain] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.Charge] = "zxl_zhujiemian_nengliang"
WorldPointBtnTypeImage[WorldPointBtnType.ChargeBack] = "uibuild_btn_return"
WorldPointBtnTypeImage[WorldPointBtnType.DominatorCockatriceUnlock_1] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.DominatorCockatriceUnlock_2] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceEpidemic] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.AttackEpidemic] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutEpidemic] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.PickEpidemic] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.RallyEpidemic] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.CollectEpidemic] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.ClickWorldTreasure] = "lrb_FHJ_zhujiemian_qiaodan"
WorldPointBtnTypeImage[WorldPointBtnType.KillZombieKirovBox] = "zxl_zhujiemian_liwu"
WorldPointBtnTypeImage[WorldPointBtnType.TacticalCardSkill] = "FX_zhanshukapai_icon_"
WorldPointBtnTypeImage[WorldPointBtnType.GoldTreeCharge] = "zxl_zhujiemian_nengliang"
WorldPointBtnTypeImage[WorldPointBtnType.GoldTreeBless] = "zxl_zhujiemian_qiuqian"
WorldPointBtnTypeImage[WorldPointBtnType.TreasureChest] = "zxl_zhujiemian_liwu"
WorldPointBtnTypeImage[WorldPointBtnType.SkyBattle] = "zxl_zhujiemian_jiuyuan"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventDigGame] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.DetectRetryRescue] = "zxl_zhujiemian_jiuyuan"
WorldPointBtnTypeImage[WorldPointBtnType.DetectRetryResource] = "zxl_zhujiemian_jiuyuan"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventSuppliesSearch] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.KirovBossPlanTime] = "ljq_zhujiemian_feitingweixiu"
WorldPointBtnTypeImage[WorldPointBtnType.AisillaPlanTime] = "ljq_zhujiemian_feitingweixiu"
WorldPointBtnTypeImage[WorldPointBtnType.BankRob] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.BankDeposit] = "zxl_zhujiemian_cunqian"
WorldPointBtnTypeImage[WorldPointBtnType.BFCommandOrder] = "mjc_YBJQ_zhujiemian_zhihui"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventAttackCityS0Radar] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventAttackCityS0BattleRadar] = "zxl_zhujiemian_jiuyuan"
WorldPointBtnTypeImage[WorldPointBtnType.DetectEventLastStand] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.FlowerTrainGiftPreview] = "zxl_zhujiemian_liwu"
WorldPointBtnTypeImage[WorldPointBtnType.FlowerTrainGetReward] = "zxl_zhujiemian_liwu"
WorldPointBtnTypeImage[WorldPointBtnType.LLAttackCity] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.LLScoutCity] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.LLAssistanceCity] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.LLRallyCity] = "zyf_zhujiemian_jijie"
WorldPointBtnTypeImage[WorldPointBtnType.CityAltarGiveUp] = "uibuild_btn_chaichu"
WorldPointBtnTypeImage[WorldPointBtnType.CityAltarCancelGiveUp] = "uibuild_btn_canceldismantle"
WorldPointBtnTypeImage[WorldPointBtnType.CityAltarFish] = "FX_jitanzhengduozhan_rukou_icon"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceSkillReinforceCharge] = "zxl_jianzao_chuizi"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingMove] = "zyf_saiji_qiancheng_icon"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBossMove] = "zyf_saiji_qiancheng_icon"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingDonate] = "uibuild_btn_repair"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingSetting] = "ljq_zhujiemian_feitingweixiu"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingGift] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingRank] = "zyf_shijieboss_rank_icon"
WorldPointBtnTypeImage[WorldPointBtnType.S0AllianceBossBuildingRally] = "zyf_zhujiemian_jijie"
local WorldPointBtnTypeImageSeasonDarkness = {}
WorldPointBtnTypeImageSeasonDarkness[WorldPointBtnType.SeasonTradeShopRefresh] = "mjc_S4_zhujiemian_myz_hujiaoshangdui"
WorldPointBtnTypeImageSeasonDarkness[WorldPointBtnType.SeasonTradeShopEnter] = "mjc_S4_zhujiemian_myz_shangdian"
WorldPointBtnTypeImageSeasonDarkness[WorldPointBtnType.PutAresMissile] = "Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/missile04/ljq_zhujiemian_shandianqiu_anniu.png"
local WorldPointBtnTypeImageSeasonNineNation = {}
WorldPointBtnTypeImageSeasonNineNation[WorldPointBtnType.SeasonTradeShopRefresh] = "mjc_S4_zhujiemian_myz_hujiaoshangdui"
WorldPointBtnTypeImageSeasonNineNation[WorldPointBtnType.CampDestroy] = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_zhujiemian_S6_cuihui.png"
WorldPointBtnTypeImageSeason = {
  [SeasonMapType.Darkness] = WorldPointBtnTypeImageSeasonDarkness,
  [SeasonMapType.NineNation] = WorldPointBtnTypeImageSeasonNineNation
}
WorldPointUIType = {
  None = 0,
  Monster = 1,
  Boss = 2,
  City = 3,
  Build = 4,
  CollectPoint = 5,
  CollectArmy = 6,
  Road = 7,
  Explore = 8,
  MonsterReward = 9,
  Sample = 10,
  PickGarbage = 11,
  SingleMapGarbage = 12,
  AllianceCity = 13,
  AllianceCollectPoint = 14,
  ActBoss = 15,
  MonsterLock = 16,
  PuzzleBoss = 17,
  ChallengeBoss = 18,
  CityResPoint = 19,
  DesertOld = 20,
  DetectEventPVE = 21,
  DispatchTask = 22,
  DetectEventFakePVP = 23,
  Train = 24,
  DragonBuild = 25,
  DragonScore = 26,
  Treasure = 27,
  DrillBase = 28,
  GuideEventMonster = 29,
  Desert = 30,
  AllianceMine = 31,
  AllianceActMine = 32,
  AllianceBuild = 33,
  Ruin = 34,
  WorldAllianceResourceCollect = 35,
  WinterEntity = 36,
  ZombieRush = 37,
  Rescue = 38,
  BerserkBoss = 39,
  WorldSuppliesPoint = 40,
  WorldDetectSurvivor = 41,
  WorldTrigger = 42,
  Ghostrecon = 43,
  Aisilla = 44,
  Barricade = 45,
  CityAttachmentBuild = 46,
  DominatorGuide = 47,
  ZoneMobilization = 48,
  ZoneMobilizationBoss = 49,
  ZoneMobilizationSuppliesPoint = 50,
  SandWorm = 51,
  WorldDetectCaveExploration = 52,
  MeteoriteResPoint = 53,
  MeteoriteResCollectArmy = 54,
  WorldRuinDestroyBuilding = 55,
  AllyDrillHugeSandWorm = 56,
  KillZombieKirovBoss = 57,
  KillZombieKirovBox = 58,
  WorldActivityTreasure = 59,
  DarknessSuppliesPoint = 60,
  PlayerKillMonsterTreasure = 61,
  DetectRetryRescue = 62,
  DetectRetryResource = 63,
  DetectZombieBusTrain = 65,
  DetectEventDigGame = 66,
  DetectEventSuppliesSearch = 67,
  HSR = 68,
  TreasureChest = 70,
  DominatorCockatriceUnlock_1 = 71,
  DominatorCockatriceUnlock_2 = 72,
  EpidemicBuild = 73,
  S1RestCityDefendMonster = 74,
  S1RestBloodyQueenMonster = 75,
  DetectAttackCityS0Monster = 76,
  DetectEventLastStand = 78,
  FlowerTrain = 79,
  FlowerTrainReward = 80,
  SkyBattle = 81,
  WolfShadow = 82,
  AllyDrillRoadHog = 83,
  S0AllianceDrillBuilding = 84,
  S0AllianceDrillBoss = 85
}
WorldMarchTileBtnType = {
  None = 0,
  March_ViewTroop = 1,
  March_Stop = 2,
  March_Callback = 3,
  March_Rally = 4,
  March_Attack = 5,
  March_Scout = 6,
  March_Rapid = 7,
  March_AssistTrain = 8,
  March_ScoutTrain = 9,
  March_AttackTrain = 10,
  March_ViewTrain = 11,
  March_ReinforceTrain = 12,
  March_PlayerInfo = 13,
  March_Sticker = 14,
  March_AttackZombieBusTrain = 15
}
WorldMarchBtnTypeImage = {}
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_ViewTroop] = "uibuild_btn_info"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Stop] = "uibuild_btn_station"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Callback] = "uibuild_btn_return"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Rally] = "uibuild_btn_rally"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Attack] = "uibuild_btn_attack"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Scout] = "uibuild_btn_scout"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Rapid] = "lyp__buduizhuangtai_jiasu"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_ReinforceTrain] = "uibuild_btn_assistance"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_AssistTrain] = "uibuild_btn_assistance"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_ScoutTrain] = "uibuild_btn_scout"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_AttackTrain] = "uibuild_btn_attack"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_ViewTrain] = "uibuild_btn_info"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_PlayerInfo] = "uibuild_btn_info_des"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Sticker] = "ljq_daditubiaoqing_icon"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_AttackZombieBusTrain] = "uibuild_btn_attack"
BtnWidth = {380, 320}
StickerUseTtype = {
  Chat = 1,
  Map = 2,
  ChatAndMap = 3
}
TipsUI = {
  UIWindowNames.UIBuildUpgradeAddDes,
  UIWindowNames.UIItemTips,
  UIWindowNames.UIHeroTip,
  UIWindowNames.UIFormationTip,
  UIWindowNames.UIHeroSquadPanel,
  UIWindowNames.UIHeroSquadAssignPanel,
  UIWindowNames.UIHeroPVPFormation,
  UIWindowNames.UICommonTips,
  UIWindowNames.UISmallTips,
  UIWindowNames.UIFormationSoldierTip,
  UIWindowNames.UIFlowerCarRank,
  UIWindowNames.LWUIActMeteoriteRankChangedNotice,
  UIWindowNames.UILWPlot,
  UIWindowNames.SeasonAllianceWarTimeStateTipsView,
  UIWindowNames.UICommonSimpleTipView,
  UIWindowNames.UITCCardSkillTip,
  UIWindowNames.UIResistanceWarningPanel,
  UIWindowNames.UIActivityDetail,
  UIWindowNames.UIActivityDetailPopup
}
ClickWorldNeedCloseWorldUI = {
  UIWindowNames.UISearch,
  UIWindowNames.UIAllianceRally,
  UIWindowNames.UIWorldBlackTile,
  UIWindowNames.UIArrow,
  UIWindowNames.UIWorldExplorePointUI,
  UIWindowNames.UIWorldSamplePointUI,
  UIWindowNames.UIWorldGarbagePointUI,
  UIWindowNames.UIGuideGarbage,
  UIWindowNames.UIFarmIrrigate
}
ClickUINeedCloseExtraWorldUI = {
  UIWindowNames.UIPasture,
  UIWindowNames.UIFarmGather,
  UIWindowNames.UIFarm,
  UIWindowNames.UIWorldTileUI,
  UIWindowNames.UIResourceCost,
  UIWindowNames.UIWorldSiegePoint,
  UIWindowNames.UIWorldSiegePointSeason,
  UIWindowNames.UIWorldOutpostCityPoint,
  UIWindowNames.UIWorldOutpostCanonPoint,
  UIWindowNames.UIFormationSelectListNew,
  UIWindowNames.UIFormationSelectListV2,
  UIWindowNames.UIFarmIrrigate,
  UIWindowNames.UIFingerArrow,
  UIWindowNames.UIFormationSoldierTip,
  UIWindowNames.UIWorldActRadarTreasurePoint,
  UIWindowNames.UIWorldLLCityPoint,
  UIWindowNames.UIWorldLLCanonPoint
}
DragWorldNeedCloseExtraWorldUI = {
  UIWindowNames.UIPasture,
  UIWindowNames.UIFarmGather,
  UIWindowNames.UIFarm,
  UIWindowNames.UIPasture,
  UIWindowNames.UIWorldSiegePoint,
  UIWindowNames.UIWorldSiegePointSeason,
  UIWindowNames.UIWorldOutpostCityPoint,
  UIWindowNames.UIWorldOutpostCanonPoint,
  UIWindowNames.UIFarmIrrigate,
  UIWindowNames.UIWorldNewsTips,
  UIWindowNames.UIWorldNewsAbbrDetail,
  UIWindowNames.UIActBossTips,
  UIWindowNames.UIWorldPoint,
  UIWindowNames.UIWorldActRadarTreasurePoint,
  UIWindowNames.UIWorldLLCityPoint,
  UIWindowNames.UIWorldLLCanonPoint
}
BarracksBuildToBtnType = {
  [BuildingTypes.FUN_BUILD_CAR_BARRACK] = WorldTileBtnType.City_TrainingTank,
  [BuildingTypes.FUN_BUILD_INFANTRY_BARRACK] = WorldTileBtnType.City_TrainingInfantry,
  [BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK] = WorldTileBtnType.City_TrainingAircraft
}
OrderAllFinished = {No = 0, Yes = 1}
OrderType = {
  Resident = 0,
  Earth = 1,
  GROCERY_ORDER = 2
}
MessageBarType = {
  Get = 0,
  Cost = 1,
  Lack = 2
}
BuildUpgradeUseGoldType = {
  No = 0,
  Yes = 2,
  Free = 3
}
OrderPriorShowType = {Normal = 0, Prior = 1}
FactoryWorkState = {
  Free = 0,
  Work = 1,
  Full = 2,
  NotOpen = 3
}
WarningType = {
  Meteorite = 1,
  Attack = 2,
  Scout = 3,
  Assistance = 4,
  ResourceAssistance = 5,
  AllianceAttack = 6
}
WarningTypeIcon = {}
WarningTypeIcon[WarningType.Meteorite] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_warning_btn_meteorite"
UIScienceTopBtnType = {
  Electricity = 1,
  Money = 2,
  Gold = 3
}
ScienceType = {Build = 1, Alliance = 2}
ScienceTabState = {
  Lock = 0,
  UnLock = 1,
  CanUnlock = 2,
  LockShow = 3
}
ScienceTabUnlockType = {
  PreScienceTreePro = 1,
  PreScienceLevel = 2,
  PreBuildingLevel = 3,
  RequireActivityId = 4
}
MainUITipType = {
  Activity = 1,
  Gift = 2,
  AllyCity = 3,
  WarZone = 4,
  AllyDuel = 5,
  Season = 6,
  Alliance = 7,
  AccountBind = 8,
  MeteoriteBattle = 9,
  ActMigration = 10,
  AttackCityS0 = 11,
  Special = 100
}
AllyDuelRankType = {
  Day = 0,
  Week = 1,
  Month = 2
}
MainUITipCondition = {
  ActivityId = 0,
  ActivityType = 1,
  Daily = 2,
  Login = 3,
  ActivityOpen = 4,
  Custom = 100,
  ZoneMobilization = 101,
  ZoneWar1 = 111,
  ZoneWar2 = 112,
  AllyDuel1 = 113,
  AllyDuel2 = 114,
  AllyDuel3 = 115,
  CityWar = 116,
  ActDragon1 = 117,
  ActDragon2 = 118,
  StrongCmd1 = 119,
  StrongCmd2 = 120,
  AllyDrill1 = 121,
  AllyDrill2 = 122,
  AllyDuel4 = 123,
  AllyDuel5 = 124,
  CityWarPre = 125,
  CityWarSuccess = 126,
  AccountBindTip = 127,
  ActivityGroupIsHaveFin = 130,
  MeteoriteBattle = 131,
  ActMigrationOpen = 133,
  ActQueenOfBlood = 134,
  SeasonNuclearActivityMonster = 128,
  SeasonNuclearActivityNonFinish = 129,
  SeasonCityOccupy_Declare = 160,
  SeasonCityOccupy_CityOpen = 161,
  SeasonBlackKnight = 162,
  SeasonCrossAttackCity_Open = 163,
  SeasonCrossAttackCity_HasBuild = 164,
  SeasonCrossAttackCity_CanPutBuild = 165,
  SeasonCrossDeclareWar_MyDeclare = 166,
  SeasonCrossDeclareWar_BeDeclare = 167,
  SeasonFactionSelection_Open = 168,
  SeasonFactionSelection_Shown = 169,
  SeasonFactionSelection_Move = 170,
  SeasonFactionDeclareWar_Declare = 171,
  SeasonFactionDeclareWar_CanJoin = 172,
  SeasonFactionDeclareWar_Battle = 173,
  SeasonFactionDeclareWar_CanInvite = 174,
  SeasonFactionDeclareWar_BeInvite = 175,
  SeasonFactionKingWar_Open = 176,
  SeasonFactionKingWar_Start = 177,
  SeasonHeroUpdate = 178,
  SeasonFactionBigWar = 179,
  AllOut = 10001
}
MessageBallType = {
  None = 0,
  BuildingUpgrade = 1,
  JoinRoad = 2,
  EmptyFarm = 3,
  CanGatherFarm = 4,
  EmptyPasture = 5,
  CanGatherPasture = 6,
  FactoryFree = 7,
  FactoryCanGather = 8,
  MoneyFull = 11,
  WaterFull = 12,
  OilFull = 13,
  MetalFull = 14,
  ElectricityFull = 15,
  BuildingComplete = 16,
  SoldierTrainComplete = 17,
  ScienceSearchComplete = 18,
  ArmyQueueFree = 19,
  HeroStationWarning = 21,
  FactoryFreeNew = 22,
  BagMax = 23
}
BusinessBubbleState = {
  No = 0,
  NoSubmit = 1,
  Yes = 2
}
ResourceItemOutType = {
  Farm = 0,
  Pasture = 1,
  Food = 2
}
BuildRedDotType = {
  No = 0,
  AllShow = 1,
  Once = 2
}
BuildLevelUpShowType = {
  New = 1,
  Unlock = 2,
  AddNum = 3
}
BuildLevelUpUnlockType = {Build = 1, ResourceItem = 2}
ScienceShowTag = {No = 0, Recommend = 1}
ItemHotPage = {No = 0, Yes = 1}
BuildingConnectState = {UnConnect = 0, Connect = 1}
UIBuildQueueState = {
  None = 0,
  Free = 1,
  Work = 2,
  Locked = 3
}
UICapacityTableResourceType = {
  ResourceType.Water,
  ResourceType.Electricity
}
UIBuildQueueUnlockType = {Upgrade = 0, Buy = 1}
UIBuildQueueImageTypeScale = {
  Unlock = Vector3.New(1, 1, 1),
  Build = Vector3.New(0.4, 0.4, 0.4)
}
UIBattlefieldCameraOffset = {
  Desert = Vector3.New(0, 0, 5),
  Winter = Vector3.New(0, 0, 5),
  Epidemic = Vector3.New(0, 0, 5)
}
UIFarmViewResourceItemPositions = {
  {
    Vector3.New(15, -10, 0)
  },
  {
    Vector3.New(66, 28, 0),
    Vector3.New(-30, -78, 0)
  },
  {
    Vector3.New(137, 60, 0),
    Vector3.New(10, -20, 0),
    Vector3.New(-45, -156, 0)
  },
  {
    Vector3.New(66, 28, 0),
    Vector3.New(-30, -78, 0),
    Vector3.New(35, 154, 0),
    Vector3.New(-88, 67, 0)
  },
  {
    Vector3.New(66, 28, 0),
    Vector3.New(-30, -78, 0),
    Vector3.New(35, 154, 0),
    Vector3.New(-88, 67, 0),
    Vector3.New(-166, -63, 0)
  }
}
UIBuildQueueEnterType = {
  None = 0,
  Build = 1,
  Upgrade = 2,
  Science = 3
}
UIMainBuildQueueAnimState = {Empty = 0, Free = 1}
UIMainBuildQueueAnimName = {}
UIMainBuildQueueAnimName[UIMainBuildQueueAnimState.Empty] = "BuildQueueEmpty"
UIMainBuildQueueAnimName[UIMainBuildQueueAnimState.Free] = "BuildQueueFree"
BuildQueueTalkShowType = {
  Free = 1,
  StartQueue = 2,
  EndQueue = 3
}
UITrainState = {
  Select = 1,
  Training = 2,
  NoReason = 3
}
UITrainDetailType = {
  Attack = 1,
  Defense = 2,
  Blood = 3,
  Speed = 4,
  Load = 5,
  Power = 6
}
UITrainDetailTypeList = {
  UITrainDetailType.Attack,
  UITrainDetailType.Defense,
  UITrainDetailType.Blood,
  UITrainDetailType.Speed,
  UITrainDetailType.Load,
  UITrainDetailType.Power
}
UITrainDetailTypeIcon = {}
UITrainDetailTypeIcon[UITrainDetailType.Attack] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_gongjili"
UITrainDetailTypeIcon[UITrainDetailType.Defense] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_fangyu"
UITrainDetailTypeIcon[UITrainDetailType.Blood] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_shengmingzhi"
UITrainDetailTypeIcon[UITrainDetailType.Speed] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_xingjunsudu"
UITrainDetailTypeIcon[UITrainDetailType.Load] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_fuzai"
UITrainDetailTypeIcon[UITrainDetailType.Power] = "Assets/Main/Sprites/UI/LWCommon/Sprite/UITroops_icon_power"
UISearchType = {
  None = 0,
  Monster = 1,
  Oil = 2,
  Metal = 3,
  Water = 4,
  Boss = 5,
  Resource = 6,
  WorldDesert = 7
}
AnimalAnimationState = {
  None = 0,
  Free = 1,
  Feed = 2,
  Walk = 3,
  Finish = 4,
  Fly = 5,
  GuideShow = 6
}
WarningBallState = {
  Free = 0,
  Cold = 1,
  Wait = 2,
  Show = 3,
  ShowOnce = 4
}
EffectCoupleType = {
  BASE_ATTACK = 100001,
  BASE_DEFEND = 100002,
  BASE_HEALTH = 100003,
  BASE_HEALTH_PERCENT = 100004,
  COLLECT_ATTACK = 100101,
  COLLECT_DEFEND = 100102,
  OUTSIDE_ATTACK = 100201,
  OUTSIDE_DEFEND = 100202,
  TEAM_ATTACK = 100301,
  TEAM_DEFEND = 100302,
  ATTACK_BUILD_ATTACK = 100401,
  ATTACK_BUILD_DEFEND = 100402,
  STATE_BUILD_ATTACK = 100501,
  STATE_BUILD_DEFEND = 100502,
  ATTACK_MONSTER_ATTACK = 100601,
  ATTACK_MONSTER_DEFEND = 100602,
  ATTACK_ALLIANCE_NEUTRAL_CITY_ATTACK = 100701,
  ATTACK_ALLIANCE_NEUTRAL_CITY_DEFEND = 100702
}
UIMainResourceSort = {}
UIMainResourceSort[ResourceType.Water] = 2
UIMainResourceSort[ResourceType.Electricity] = 3
UIMainResourceSort[ResourceType.Food] = 4
UIMainResourceSort[ResourceType.Metal] = 5
UIMainResourceSort[ResourceType.Wood] = 6
UIMainResourceSort[ResourceType.OBSIDIAN] = 7
UIMainResourceSort[ResourceType.FLINT] = 8
UIMainResourceSort[ResourceType.Petroleum] = 9
RomeNum = {
  "I",
  "II",
  "III",
  "IV",
  "V",
  "VI",
  "VII",
  "VIII",
  "IX",
  "X"
}
OutResourceTypeIconName = {}
OutResourceTypeIconName[ResourceType.Electricity] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_electricity"
OutResourceTypeIconName[ResourceType.Metal] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_metal"
OutResourceTypeIconName[ResourceType.Oil] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_oil"
OutResourceTypeIconName[ResourceType.Water] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_water"
OutResourceTypeIconName[ResourceType.Food] = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_money"
UIBuildTimeTextShowType = {Time = 1, Des = 2}
UIResourceCostState = {Normal = 1, Animation = 2}
WorldPointType = {
  Other = 0,
  WorldCollectResource = 1,
  PlayerRoad = 2,
  PlayerBoard = 3,
  WorldMonster = 4,
  WorldBoss = 5,
  PlayerBuilding = 6,
  WorldResource = 7,
  EXPLORE_POINT = 8,
  SAMPLE_POINT = 9,
  GARBAGE = 10,
  WORLD_ALLIANCE_CITY = 11,
  MONSTER_REWARD = 12,
  SAMPLE_POINT_NEW = 13,
  DETECT_EVENT_PVE = 14,
  WORLD_ALLIANCE_BUILD = 15,
  RESCUE_POINT = 16,
  HERO_DISPATCH = 17,
  DRAGON_BUILDING = 18,
  DRAGON_SCORE_POINT = 20,
  TREASURE = 21,
  INVASION_WORLD_MONSTER = 22,
  SEASON_DESERT = 23,
  WINTER_ENTITY = 24,
  WORLD_CITY_STRONGHOLD = 25,
  WorldAllianceCollectResource = 26,
  WorldSuppliesPoint = 27,
  RadarSeasonSnowSurvivor = 28,
  GHOSTRECON_POINT = 29,
  CITY_ATTACHMENT_BUILD = 30,
  CITY_ATTACHMENT_WALL = 31,
  CAVE_EXPLORATION = 32,
  RADAR_DOMINATOR_GUIDE = 33,
  RADAR_DOMINATOR_CURE = 34,
  WORLD_CITY_TRADE = 35,
  SURPRISE_POINT = 36,
  ZONE_MOBILIZATION = 37,
  WORLD_RUIN_DESTROY_BUILDING = 38,
  METEORITE_POINT = 39,
  EPIDEMIC_BUILD = 40,
  BATTLEFIELD_BUILD = 40,
  GOLD_TREE = 41,
  MONSETER_CHALLENGE_NEW_TREASURE = 42,
  ACTIVITY_WORLD_TREASURE = 43,
  DETECT_RETRY_TASK = 44,
  DETECT_DIG_GAME = 45,
  TreasureChest = 46,
  RADAR_DOMINATOR__COCKATRICE_UNLOCK_1 = 47,
  RADAR_DOMINATOR__COCKATRICE_UNLOCK_2 = 48,
  DETECT_SUPPLIES_SEARCH = 49,
  DETECT_ALLIANCE_CITY_SCOUT_MONSTER = 50,
  SkyBattle = 51,
  WORLD_CITY_OUTPOST = 52,
  WORLD_CITY_OUTPOST_TOWER = 53,
  DETECT_LAST_STAND = 54,
  ZWL_BUILDING = 55,
  ZWL_BUILDING_THRONE = 56,
  ZWL_BUILDING_BUFF = 57,
  ZWL_BUILDING_TOWER = 58,
  ALLIANCE_BOSS_S0 = 59,
  CITY_ALTAR = 61,
  WorldRuinPoint = 999
}
ThermalConductorType = {
  Base = 1,
  City = 2,
  Stronghold = 3,
  Throne = 4,
  StrongholdBoss = 5,
  SeasonGoods = 7,
  Treasure = 8,
  Survivor = 9,
  CommonBoss = 10
}
UIResourceBagBtnType = {
  Use = 1,
  Buy = 2,
  PickUp = 3,
  Build = 4,
  Go = 5,
  LackResMode = 6
}
SpecialItemId = {
  ITEM_MOVE_RANDOM = "200001",
  ITEM_MOVE_CITY = "200002",
  ITEM_ALLIANCE_CITY_MOVE = "200005",
  LW_ITEM_ALLY_MOVE_CITY = "200008",
  CHANGE_GENDER = "200019",
  CHANGE_NAME = "200021"
}
MoveCityUseItemIds = {
  SpecialItemId.ITEM_MOVE_CITY
}
ArmType = {
  Tank = 1,
  Robot = 2,
  Plane = 3
}
BuildGetResourceState = {
  No = 1,
  Add = 2,
  Full = 3
}
QuestType = {
  Main = 1,
  Chapter = 2,
  Daily = 3,
  PVE = 9,
  PveAct = 11
}
UIMainQuestState = {
  None = 0,
  Quest = 1,
  BubbleQuest = 2,
  ChapterReward = 3,
  WarningBall = 4
}
CityManageBuffType = {
  CityFever = 100001,
  WarGuard = 100002,
  GolloesFever = 100003,
  GolloesGuard = 100004
}
DetectEvenColorImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_1",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_2",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_3",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_4",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_5",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_5",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_5"
}
DetectEvenFakePlayerColorImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_lv",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_lv",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_lan",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_zi",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_cheng",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_cheng",
  "Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_cheng"
}
DetectEvenBeSelectColorImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_6",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_7",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_8",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_9",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_10",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_10",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_10"
}
DetectEvenCircleColorImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_11",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_12",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_13",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_14",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_15",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_15",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_15"
}
DetectEvenColorSpecialImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
  "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold"
}
DetectResourceCollectColorImage = {
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_1",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_2",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_3",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_4",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_5",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_5",
  "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_tubiao_buff_5"
}
DetectEventState = {
  DETECT_EVENT_STATE_NOT_FINISH = 0,
  DETECT_EVENT_STATE_FINISHED = 1,
  DETECT_EVENT_STATE_REWARDED = 2,
  DETECT_EVENT_STATE_NOT_IN_WORLD = 3
}
ScoutReportVisibleState = {
  DEFAULT = 0,
  ENABLE = 1,
  DISABLE = 2,
  NOT_MATCH = 3
}
BuildQueueUnlockType = {
  Build = 1,
  Gift = 2,
  Talent = 3
}
AnimalQIdToAreaId = {}
AnimalQIdToAreaId[1] = 5
AnimalQIdToAreaId[2] = 1
AnimalQIdToAreaId[3] = 3
AnimalQIdToAreaId[4] = 7
AnimalQIdToAreaId[5] = 9
PositionType = {
  World = 1,
  Screen = 2,
  PointId = 3
}
ArrowType = {
  Normal = 0,
  Monster = 1,
  Capacity = 2,
  Building = 3,
  Guide_Garbage = 4,
  BuildBox = 5,
  Farm = 6,
  Factory = 7,
  Chapter = 8,
  PlayerLevel = 9,
  LackResource = 10,
  ChapterGetReward = 11,
  WaitTimeChapter = 12,
  WaitTimeChapterNew = 13,
  LandLock = 14,
  CollectMoney = 15,
  CityNpc = 16
}
DetectEventType = {
  DetectEventTypeSpecial = 1,
  DetectEventTypeNormal = 2,
  DetectEventRadarRally = 5,
  DetectEventPickGarbage = 6,
  DetectEventPVE = 7,
  DetectEventTypeBoss = 8,
  HeroTrial = 9,
  SPECIAL_OPS = 10,
  RESCUE = 11,
  PARKOUR_BATTLE = 12,
  PLOT = 14,
  FAKE_PVP = 15,
  GATHER_RESOURCE = 16,
  FAKE_PLAYER = 17,
  HELPER = 18,
  TREASURE = 19,
  WANDERING_BOSS = 20,
  ScoutDeclareCity = 21,
  ScoutOccupyCity = 22,
  TREASURE_ACTIVITY = 23,
  CAVE_EXPLORATION = 25,
  DOMINATOR_CURE = 26,
  DOMINATOR_GUIDE = 27,
  DOMINATOR_SPECIAL = 28,
  ZOMBIE_BUS_TRAIN = 29,
  COLLECT_TASK = 31,
  RESCUE_TASK = 32,
  TreasureChest = 34,
  DOMINATOR_COCKATRICE_GUIDE_1 = 35,
  DOMINATOR_COCKATRICE_GUIDE_2 = 36,
  DOMINATOR_COCKATRICE_GUIDE_3 = 37,
  OFF_SEASON_TREASURE = 38,
  OFF_SEASON_COLLECT_TASK = 40,
  OFF_SEASON_RESCUE_TASK = 41,
  OFF_SEASON_TreasureChest = 43,
  SEASON_VISITOR = 44,
  AttackCityS0_City_Scout = 45,
  AttackCityS0_City_Monster = 46,
  SkyBattle = 47
}
DetectEventZombieBusTrainJumpToType = {
  WorldBattle = 1,
  CityBattle = 2,
  RadarUI = 3
}
GuideTriggerType = {
  None = 0,
  Quest = 1,
  UIPanel = 2,
  Plot = 3,
  Queue = 4,
  OwnQueue = 5,
  CityGarbage = 6,
  OpenFog = 7,
  BuildUpgrade = 8,
  QuestGoto = 9,
  ChapterQuestCanReward = 10,
  QuestTriggerBuild = 11,
  FirstJoinAlliance = 12,
  TaskFinish = 13,
  NoFreeQueue = 14,
  ChapterQuestAfterReward = 15,
  OpenSpecialPanel = 16,
  ResourceItemFull = 17,
  MonsterGetReward = 18,
  PickUpGarbageItem = 19,
  QuestFarmUpgrade = 20,
  AllianceAutoMoveCity = 21,
  MoveToWorldJoinAlliance = 22,
  CityTroopFightMonsterTip = 23,
  SubmitGolloesOrder = 24,
  FactoryProductStart = 25,
  FarmPlantStart = 26,
  BuildUpgradeStart = 27,
  BusinessNoSubmit = 28,
  NeedConnect = 29,
  PlayerLevel = 30,
  Science = 31,
  FactoryCanUnlock = 32,
  ClickBubble = 33,
  UseHeroExp = 34,
  MarchHeroQuality = 35,
  GetNewAnim = 36,
  TreatSoldier = 37,
  ShowNewQuest = 38,
  ClearAllianceMember = 40,
  FinishBattleLevel = 41,
  ClickLandLock = 42,
  PveEnterBattle = 43,
  PveShopBuyItem = 44,
  LandLockRewardSoldier = 45,
  BackCityAfterRecruit = 46,
  ClickRocketLaunch = 47,
  PveOwnRes = 48,
  LandLockReceiveReward = 49,
  StartScience = 50,
  ClickRadarMonster = 51,
  ClickHeroRecruit = 52,
  HeroEntrustComplete = 53,
  PrologueStartMove = 54,
  PveEndBattle = 55,
  ResourceLackShowGoto = 56,
  ClickMonster = 60,
  ClickPveBackBtn = 61,
  UIBuildUpgradeLackResource = 62,
  EnterPve = 63,
  OpenBuyBuffShop = 64,
  PveEnterSubmitResource = 65,
  PveStaminaZero = 66,
  OpenActivityPanel = 67,
  CrossServer = 68,
  DefendWall = 69,
  OpenBuildUpgrade = 70,
  BagFullInPve = 71,
  UIPlaceBuild = 72,
  PrologueOwnNum = 73,
  PlaceBuild = 74,
  ClickWorldCollectPoint = 75,
  ClickResItemUse = 76,
  FightLevelLackPanel = 77,
  UIBuildUpgradeEveryLackResource = 78,
  PveBattleShowResult = 79,
  ClickBagFullBtn = 80,
  LandLockReward = 81,
  TaskToUpgradeView = 82,
  AfterCityDomeExpend = 83,
  OpenUIPVEMonument = 84,
  SeasonLogin = 85,
  ClickAttackDesert = 86,
  ClickNoConnectAttackDesert = 87,
  ClickOutValueDesertTile = 88,
  OwnDesert = 89,
  ClickDesertCity = 90,
  ClickMarchNeedChangeHero = 91,
  OpenHeroListPanel = 92,
  BuildAllianceFlag = 93,
  ClickAttackGuideMonster = 94,
  GotoBuildAllianceCenter = 95,
  WaitRallyTeamMarch = 96,
  ClickProtectThrone = 97,
  ClickWarThrone = 98,
  UnlockBauble = 99,
  Login = 200,
  PrologueCityUnlock = 100,
  PrologueErrorGuide = 110,
  EnterBridge = 111,
  ExitBridge = 112,
  BridgeClickStart = 113,
  BridgeStageMoveEnd = 114,
  BridgeFinishInScene = 115,
  MergeExitFinishOrder = 116,
  MergeEnterOrder = 117,
  MergeOrderFinish = 118,
  CloseNewHero = 119,
  RocketBombCanClickReward = 120,
  BridgeReachVictory = 121,
  CanUnlockNewArmyWhenEnterPve = 122,
  EnterSeasonOpenIntro = 201,
  EnterSeasonOpenAllianceSiege = 202
}
GuideGoType = {None = 0, Build = 1}
GuideForceType = {Soft = 0, Force = 1}
GuideNpcPosition = {Left = 1, Right = 2}
GuideType = {
  None = 0,
  ClickButton = 1,
  ShowTalk = 2,
  ClickBuild = 3,
  BuildPlace = 4,
  BuildRoad = 5,
  PlantFarm = 6,
  GetFarm = 7,
  QueueBuild = 8,
  PlantAnimal = 9,
  Factory = 10,
  Bubble = 11,
  CityGarbage = 12,
  GotoMoveBubble = 13,
  OpenFog = 14,
  CityGarbageResultShow = 15,
  DragCityTroop = 16,
  PlayMovie = 17,
  WaitMovieComplete = 18,
  ClickQuest = 19,
  WaitPlaceBuilding = 20,
  WaitTroopArrive = 21,
  WaitGarbageTroopMoveLeft = 22,
  WaitCloseUI = 23,
  ClickBuildFinishBox = 24,
  WaitMessageFinish = 25,
  ShowBlackUI = 26,
  MoveCamera = 27,
  ClickTime = 28,
  CloseAllUI = 29,
  ShowUIGuideGrow = 30,
  SetRecommendShow = 31,
  UnlockBtn = 32,
  ShowTroopTalk = 33,
  ShowGuideTip = 34,
  PlayEffectSound = 35,
  ShowChapterAnim = 36,
  ClickQuickBuildBtn = 37,
  StopAllEffectSound = 38,
  ClickMonster = 39,
  ClickTimeLineBubble = 40,
  ClickCityPointType = 41,
  ShowBuildRoadAnim = 42,
  ClickGolloesCanSubmitOrder = 43,
  DoUIMainAnim = 44,
  ClickRadarBubble = 45,
  ClickUISpecialBtn = 46,
  ShowAllianceCityEffect = 47,
  WaitQuestionEnd = 48,
  WaitTime = 49,
  FakeQuest = 50,
  ShowCommunicationTalk = 51,
  ClickLandLockBubble = 52,
  ClickCollectResource = 53,
  CollectUISpecialGuide = 54,
  ClickLandLockRewardBox = 55,
  SetLandLockBubbleVisible = 56,
  PveShowYellowArrow = 57,
  PveShowBattleSpeedBtn = 58,
  PveShowBattleFinishBtn = 59,
  PveShowBattlePowerLight = 60,
  ShowUIBlackChangeMask = 61,
  PveShowBattleBloodLight = 62,
  PveHideYellowArrow = 63,
  WaitMarchFightEnd = 64,
  ClickRadarMonster = 65,
  OpenSelectQuestionPanel = 66,
  NoNpcTalk = 67,
  ShowFakeHero = 68,
  ClickMonsterReward = 69,
  SetAttackSpecialStateFlag = 70,
  WaitPanelOpen = 71,
  LandLockChangeModel = 72,
  SetBubbleShow = 73,
  AlliancePanelGuide = 74,
  DoQuestJump = 75,
  CheckBecomeAllianceLeader = 76,
  ShowLoadMask = 77,
  SetShowLandLock = 78,
  ChangeBgm = 79,
  ChangeBgmVolume = 80,
  WaitGolloesArrived = 81,
  SetRadarMonsterVisible = 82,
  SetCityPeopleAndCarVisible = 83,
  WaitBackCity = 84,
  PveSkillVisible = 85,
  PveShowStaminaLight = 86,
  SetPveStaminaNpcVisible = 87,
  FullPveSkill = 88,
  ClickPveTriggerBubble = 89,
  WaitPveEnterComplete = 90,
  SetPveBuyBuffShopEffectActive = 91,
  SetPveStopRefreshStamina = 92,
  SetPveNoClickStamina = 93,
  OpenHeadTalkPanel = 94,
  CloseHeadTalkPanel = 95,
  SetPveBagGuide = 96,
  HeroAdvanceGuide = 97,
  SetHeroAdvanceGuideHeroVisible = 98,
  SetHeroAdvanceGuideSubHeroVisible = 99,
  SetAllVisible = 100,
  PrologueShowBuild = 101,
  PrologueShowTrigger = 102,
  PrologueUnlockFog = 103,
  PrologueShowNpc = 104,
  PrologueShowNoMovePoint = 105,
  PrologueShowSetManPosition = 106,
  Wastelan_Guide = 107,
  Prologure_CarryingFlag = 108,
  Prologure_PlantFlag = 109,
  Wastelan_ResetManState = 110,
  ShowUIWindow = 111,
  Wastelan_ShowFarm = 112,
  Wastelan_ShowNpcTalk = 113,
  Wastelan_HideNpcTalk = 114,
  Wastelan_GuideNpcTalk = 115,
  Wastelan_ShowYellowArrow = 116,
  Wastelan_CheckFarmArrow = 117,
  Wasteland_ShowTank = 118,
  Wasteland_ShowMonster = 119,
  Wasteland_AttackDone = 120,
  Prologure_ManJump = 121,
  PrologueHideNpc = 122,
  PrologueManRotation = 123,
  PrologueAddOneSpaceMan = 124,
  PVEFinishOneTrigger = 125,
  PrologueSubmitTrigger = 126,
  PVESetTriggerVisible = 127,
  ShakeCamera = 128,
  SetWoundedBubbleVisible = 129,
  ClickWoundedCompensateBubble = 130,
  SetGuideQuestVisible = 131,
  ShowCurtain = 132,
  UIBuildListSpecial = 133,
  BackBuildCollectTime = 134,
  SetHeroAdvanceMaskVisible = 135,
  SetPveOutBagGuide = 136,
  SetQuestCanShowInGuide = 137,
  OpenPanel = 138,
  UIScrollToSomeWhere = 139,
  ShowJumpBtn = 140,
  BlackHoleMask = 141,
  UIPathArrow = 142,
  BuildCanDoAnim = 143,
  ShowNewHero = 144,
  SetWorldArrowVisible = 145,
  ShowWorldArrow = 146,
  OpenSeasonIntro = 156,
  ControlUISeasonIntro = 157,
  ClickLandLock = 160,
  NetUnConnect = 1000
}
GuideArrowStyle = {
  Finger = 0,
  Yellow = 1,
  Green = 2,
  ClickCallAirDrop = 3
}
CloseUIType = {
  ClickWorld = 1,
  ClickUI = 2,
  DragWorld = 3
}
CityPointType = {
  Other = 0,
  Garbage = 1,
  Monster = 2,
  MonsterReward = 3,
  GarbageReward = 4,
  LandLockReward = 5,
  Building = 100,
  Road = 101,
  Fog = 102,
  LandLock = 103,
  Collect = 104,
  CollectRange = 105
}
OrderItemType = {
  ORDER_ITEM_TYPE_RESOURCE_ITEM = 0,
  ORDER_ITEM_TYPE_GOODS = 1,
  ORDER_ITEM_TYPE_RESOURCE = 2,
  ORDER_ITEM_TYPE_MONSTER = 3,
  ORDER_ITEM_TYPE_SPECIAL_MONSTER = 4
}
TroopActionType = {
  TROOP_ACTION_TYPE_NULL = 0,
  TROOP_ACTION_TYPE_ATTACK = 1,
  TROOP_ACTION_TYPE_GATHER_RESOURCE = 2,
  TROOP_ACTION_TYPE_FIGHTING = 3,
  TROOP_ACTION_TYPE_GET_REWARD = 4,
  TROOP_ACTION_TYPE_FIGHT_FAIL = 5,
  TROOP_ACTION_TYPE_MARCH_RETURN = 6,
  TROOP_ACTION_TYPE_ALL_FREE = 7,
  TROOP_ACTION_TYPE_UNSET_FORMATION = 8,
  CITY_TROOP_ACTION_GROCERY_STORE_HINT = 20,
  TROOP_ACTION_TYPE_RADAR_CENTER = 21,
  CITY_TROOP_ACTION_CLICK_ON_HEAD = 201,
  CITY_TROOP_ACTION_COLLECT_GARBAGE = 202
}
local EnumType = {}
TroopType = {
  Total = 1,
  Inside = 2,
  Outside = 3,
  Turret = 4
}
PurchaseOrderType = {
  PURCHASE_ORDER = 0,
  GROCERY_ORDER = 1,
  ENERGY_ORDER = 2
}
PurchaseOrderState = {
  NORMAL = 0,
  LOCKED = 1,
  DELETE = 2,
  FINISH = 3
}
BusinessRereshType = {
  InitOrderFinish = 0,
  DeleteOrderFinish = 1,
  PurchaseOrderFinish = 2,
  ImmediateRefresh = 3
}
ConnectDirection = {
  TopToLeft = 1,
  TopToDown = 2,
  TopToRight = 3,
  LeftToDown = 4,
  LeftToRight = 5,
  LeftToTop = 6,
  DownToLeft = 7,
  DownToTop = 8,
  DownToRight = 9,
  RightToTop = 10,
  RightToLeft = 11,
  RightToDown = 12,
  Left = 13,
  Right = 14,
  Top = 15,
  Down = 16
}
CityFightResult = {Success = 1, Fail = 2}
CityGarbageResult = {None = 0, Reward = 1}
VipPayGoodState = {
  Lock = 1,
  CanBuy = 2,
  CanGet = 3,
  HasGet = 4
}
CityGarbageResultShowType = {
  People = 1,
  UseItem = 2,
  NoUseItem = 3
}
GuidePlayMovieType = {
  Farm = 1,
  SavePeople = 2,
  Radar = 3,
  Wind = 4,
  FightGetPeople = 5,
  GameStartRocketFall = 6,
  WorkManJump = 7,
  BuildBuilding = 8,
  RocketFly = 9,
  ShowSandMonster = 10,
  BaseZeroUpgrade = 11,
  ShowOstrichAnim = 12,
  MoveToWorld = 13,
  ShowGarbage = 14,
  FarmWithoutTimeLine = 15,
  BusinessPlaneArrive = 16,
  ShowBusinessBubble = 17,
  ShowMigrateScene = 18,
  RadarShowAnim = 19,
  ShowCowAnim = 20,
  ShowRobotScene = 21,
  ShowBaseLight = 22,
  ShowChangeFarm = 23,
  FromMjBuildMainBuild = 24,
  MainZeroUpgradeScene = 25,
  SecondMigrateScene = 26,
  TilePlaneRuin = 27,
  SaveBobScene = 28,
  PirateFightBobScene = 29,
  PirateComeScene = 30,
  PirateAwayScene = 31,
  PirateShowScene = 32,
  RadarScanScene = 33,
  ShowFakePlayerFlag = 34,
  ShowRadarBubble = 35,
  ShowWorldCollectPoint = 36,
  RadarWorldScanScene = 37,
  PickUpWeaponScene = 38,
  TankScene = 39,
  FactoryShowFreeBtn = 40,
  PvePirateBoomScene = 41,
  ShowRadarMonsterScene = 42,
  PveThreeBombs = 43,
  PveDestroyHdc1 = 44,
  PveDestroyHdc2 = 45,
  PveDestroyHdc3 = 46,
  PveMissileAttackMain = 47,
  PveHdc1Attack = 48,
  PveHdc2Attack = 49,
  PveTurretTurn = 50,
  PveDestroyMountain = 51,
  PveHdc3Attack = 52,
  PveMissileInSky = 53,
  GuluOutFromBaseScene = 54,
  GuideTimeline2Scene = 55,
  PveMorganAttack = 56,
  PveHdcEscape = 57,
  DefendWallScene = 58,
  ShowEnemyAllianceCityEffect = 59,
  GuideTimeline3Scene = 60,
  PveHdcEscape31014 = 61,
  ConnectElectricityScene = 62,
  Chapter2CameraMoveScene = 63
}
MarkType = {
  Special = 0,
  Friend = 1,
  Enemy = 2,
  Alliance_Attack = 3,
  Alliance_Sun = 4,
  Alliance_LuckyClover = 5,
  Alliance_6 = 6,
  Alliance_7 = 7,
  Alliance_8 = 8,
  Alliance_9 = 9,
  Alliance_10 = 10,
  Alliance_11 = 11,
  Alliance_12 = 12,
  Alliance_13 = 13,
  Alliance_14 = 14,
  Alliance_15 = 15,
  Alliance_16 = 16,
  Alliance_17 = 17,
  Alliance_18 = 18,
  Alliance_19 = 19,
  Alliance_20 = 20,
  Alliance_21 = 21,
  Alliance_22 = 22,
  Alliance_END = 22,
  Alliance_rally = 100,
  Alliance_OtherServerRally = 101,
  Country_A = 1001,
  Country_B = 1002,
  Country_C = 1003,
  Country_D = 1004,
  Country_E = 1005,
  Country_F = 1006,
  Country_G = 1007,
  Country_H = 1008,
  Country_I = 1009,
  Country_J = 1010,
  COUNTRY_END = 1010
}
AllianceRallyType = {
  [MarkType.Alliance_rally] = 1,
  [MarkType.Alliance_OtherServerRally] = 2
}
AllianceMarkName = {
  [MarkType.Alliance_Attack] = "100150",
  [MarkType.Alliance_Sun] = "alliance_tag_opt_name_3",
  [MarkType.Alliance_LuckyClover] = "391107",
  [MarkType.Alliance_6] = "391108",
  [MarkType.Alliance_7] = "391109",
  [MarkType.Alliance_8] = "130066",
  [MarkType.Alliance_9] = "390817",
  [MarkType.Alliance_10] = "391110",
  [MarkType.Alliance_11] = "391111",
  [MarkType.Alliance_12] = "391112",
  [MarkType.Alliance_OtherServerRally] = "143589"
}
AllianceMarkIconName = {
  [MarkType.Alliance_Attack] = "UIAlliance_mark_03",
  [MarkType.Alliance_Sun] = "UIAlliance_mark_04",
  [MarkType.Alliance_LuckyClover] = "UIAlliance_mark_05",
  [MarkType.Alliance_6] = "UIAlliance_mark_06",
  [MarkType.Alliance_7] = "UIAlliance_mark_07",
  [MarkType.Alliance_8] = "UIAlliance_mark_08",
  [MarkType.Alliance_9] = "UIAlliance_mark_09",
  [MarkType.Alliance_10] = "UIAlliance_mark_10",
  [MarkType.Alliance_11] = "UIAlliance_mark_11",
  [MarkType.Alliance_12] = "UIAlliance_mark_12"
}
AllianceMapMarkIconName = {
  [MarkType.Alliance_Attack] = "UIAlliance_map_mark_03",
  [MarkType.Alliance_Sun] = "UIAlliance_map_mark_04",
  [MarkType.Alliance_LuckyClover] = "UIAlliance_map_mark_05",
  [MarkType.Alliance_6] = "UIAlliance_map_mark_06",
  [MarkType.Alliance_7] = "UIAlliance_map_mark_07",
  [MarkType.Alliance_8] = "UIAlliance_map_mark_08",
  [MarkType.Alliance_9] = "UIAlliance_map_mark_09",
  [MarkType.Alliance_10] = "UIAlliance_map_mark_10",
  [MarkType.Alliance_11] = "UIAlliance_map_mark_11",
  [MarkType.Alliance_12] = "UIAlliance_map_mark_12",
  [MarkType.Alliance_rally] = "zyf_lianmengjijiedian_biaoji",
  [MarkType.Alliance_OtherServerRally] = "zyf_lianmengjijiedian_biaoji 1"
}
AllianceMarkPrefabPath = {
  [MarkType.Alliance_Attack] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_3.prefab",
  [MarkType.Alliance_Sun] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_4.prefab",
  [MarkType.Alliance_LuckyClover] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_5.prefab",
  [MarkType.Alliance_6] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_6.prefab",
  [MarkType.Alliance_7] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_7.prefab",
  [MarkType.Alliance_8] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_8.prefab",
  [MarkType.Alliance_9] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_9.prefab",
  [MarkType.Alliance_10] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_10.prefab",
  [MarkType.Alliance_11] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_11.prefab",
  [MarkType.Alliance_12] = "Assets/Main/Prefabs/UI/AllianceWorldMark/AllianceWorldMark_12.prefab",
  [MarkType.Special] = "Assets/Main/Prefabs/UI/AllianceWorldMark/WorldBookMark_Special.prefab",
  [MarkType.Friend] = "Assets/Main/Prefabs/UI/AllianceWorldMark/WorldBookMark_Friend.prefab",
  [MarkType.Enemy] = "Assets/Main/Prefabs/UI/AllianceWorldMark/WorldBookMark_Enemy.prefab"
}
AllianceMarkPrefabPathFriends = {
  [MarkType.Alliance_13] = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/AllianceWorldMark/AllianceWorldMark_13.prefab",
  [MarkType.Alliance_14] = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/AllianceWorldMark/AllianceWorldMark_14.prefab",
  [MarkType.Alliance_15] = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/AllianceWorldMark/AllianceWorldMark_15.prefab",
  [MarkType.Alliance_16] = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/AllianceWorldMark/AllianceWorldMark_16.prefab",
  [MarkType.Alliance_17] = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/AllianceWorldMark/AllianceWorldMark_17.prefab"
}
GuideArrowDirection = {RightDown = 0, LeftDown = 1}
GuideMoveArrowPlayAnimName = {Down = 1, Up = 2}
GuideAnimObjectType = {
  Scene = 1,
  SavePeople = 2,
  ExploreMonster = 3,
  ShowOstrichAnim = 4,
  ShowOstrichEgg = 5,
  ShowMigrateScene = 6,
  ShowBusinessPlaneArriveScene = 7,
  ShowCowScene = 8,
  ShowRobotScene = 9,
  ShowFromMjBuildMainBuildScene = 10,
  MainZeroUpgradeScene = 11,
  SecondMigrateScene = 12,
  TilePlaneRuin = 13,
  SaveBobScene = 14,
  PirateFightBobScene = 15,
  PirateComeScene = 16,
  PirateAwayScene = 17,
  PirateShowScene = 18,
  RadarScanScene = 19,
  ShowFakePlayerFlagScene = 20,
  RadarWorldScanScene = 21,
  PickUpWeaponScene = 22,
  ShowTankScene = 23,
  PvePirateBoomScene = 24,
  ShowRadarMonsterScene = 25,
  PveThreeBombs = 26,
  PveDestroyHdc1 = 27,
  PveDestroyHdc2 = 28,
  PveDestroyHdc3 = 29,
  PveMissileInSky = 30,
  PveDestroyMountain = 31,
  GuluOutFromBaseScene = 32,
  GuideTimeline2Scene = 33,
  PveHdcEscape = 34,
  DefendWallScene = 35,
  GuideTimeline3Scene = 36,
  PveHdcEscape31014 = 37,
  SecondExpandDomeScene = 38,
  ConnectElectricityScene = 39,
  Chapter2CameraMoveScene = 40,
  FirstExpandDomeScene = 41
}
GuideTimeLineShowMarkerType = {
  Zero = 0,
  One = 1,
  Two = 2,
  Three = 3,
  Four = 4,
  Five = 5,
  End = 999
}
CanUnlockFogSmallDirection = {
  LeftDown = 1,
  RightDown = 2,
  RightTop = 3,
  LeftTop = 4
}
FogCanUnlockEffectAnimName = {
  CanLockToUnlock = "CanLockToUnlock",
  CanUnlockIdle = "CanUnlockIdle",
  LockIdle = "LockIdle",
  LockToCanUnlock = "LockToCanUnlock"
}
CanUnlockFogSmallState = {DeepColor = 1, WeakColor = 2}
UnlockFogDirection = {
  Own = 1,
  Left = 2,
  Right = 3,
  Top = 4,
  Down = 5
}
FogCanUnlockEffectAnimSort = {
  [FogCanUnlockEffectAnimName.CanLockToUnlock] = 1,
  [FogCanUnlockEffectAnimName.CanUnlockIdle] = 2,
  [FogCanUnlockEffectAnimName.LockToCanUnlock] = 3,
  [FogCanUnlockEffectAnimName.LockIdle] = 4
}
ShowCircleType = {Show = 0, No = 1}
BuildScanAnim = {
  No = 0,
  Play = 1,
  NoFly = 2
}
FirstJoinAllianceType = {No = 0, Yes = 1}
UnlockWindowType = {
  None = 0,
  Product = 1,
  Building = 2,
  GuideBtn = 3,
  Activity = 4
}
GuideCanDoType = {Yes = 1, No = 2}
FarmingEnoughType = {Plant = 1, Feed = 2}
WaitMessageFinishType = {
  PlantAnim = 1,
  PlantFarm = 2,
  GetAnim = 3,
  FeedAnim = 4,
  AllianceMember = 5,
  PurchaseOrderFinish = 6,
  FirstJoinAlliance = 7,
  MoveCityToWorld = 8,
  LevelExploreGetInfo = 9,
  TaskRewardGet = 10
}
PlaceBuildType = {
  None = 0,
  Build = 1,
  Move = 2,
  Replace = 3,
  MoveCity = 4,
  MoveCity_Al = 5,
  MoveCity_Cmn = 6,
  CityAttachment = 7,
  EpidemicSkill = 8,
  AllianceSkill = 9
}
AllianceCityState = {
  NEUTRAL = 0,
  OCCUPIED = 1,
  BUILDING = 2,
  DRAGON_BUILDING_OCCUPYING = 3,
  SERVER_NEUTRAL = 4,
  SERVER_OCCUPIED = 5,
  SERVER_BUILD_THRONE = 6,
  SERVER_TOWER_NOT_START = 7,
  DESTROY = 8
}
ThroneType = {
  Native = 1,
  Cross = 2,
  Outpost = 3,
  Center = 4,
  Destroyer = 5
}
DeclareWarState = {
  None = 0,
  Formal = 1,
  PreDeclare = 2
}
BuildPutState = {
  None = 0,
  Ok = 1,
  Collect = 2,
  CollectRange = 3,
  OtherCollectRange = 4,
  NoCollectRange = 5,
  OutMyRange = 6,
  InOtherBaseRange = 7,
  StaticPoint = 8,
  Building = 9,
  Board = 10,
  OutUnlockRange = 11,
  UnConnectBoard = 12,
  WorldBoss = 13,
  WorldMonster = 14,
  CollectTimeOver = 15,
  OutMyInside = 16,
  InMyInside = 17,
  OutMainSubRange = 18,
  OnBaseExpansion = 19,
  OnWorldResource = 20,
  OnlyBuildRoad = 21,
  ReachBuildMax = 22,
  OnExplore = 23,
  OnSample = 24,
  OnGarbage = 25,
  GuideBuildRoad = 26,
  MONSTER_REWARD = 27,
  NoBuildInMyInside = 28,
  NoRemoveInMyInside = 29,
  OnLandLock = 30,
  PveMonster = 31,
  OutBuildZone = 32,
  ItemLack = 33,
  NotInAlArea = 34,
  OnDispatchTask = 35,
  OnDragonMoveCityCD = 36,
  AlCityBuilding = 37,
  NoInAllianceCenterRange = 38,
  NotConnectDesert = 39,
  InBlackLandRange = 40,
  MoveCityNotInUnLockRange = 41,
  CanNotPlaceEdenSubway = 42,
  AllianceBuildNotInBirthRange = 43,
  AllianceMineNotInBirthRange = 44,
  NotNearAlRuin = 45,
  AlResNotEnough = 46,
  ZoneLevelNotEnough = 47,
  NotEmptyOrNotSelfAlliance = 48,
  NotEmptyDesert = 49,
  ZoneTypeOrLevelNotMatch = 50,
  HasCityStrongholdMonster = 51,
  Landmine = 52,
  OnGhostrecon = 53,
  ZoneMobilizationBuilding = 54,
  WORLD_RUIN_DESTROY_BUILDING = 55,
  MONSTER_CHALLENGE_NEW_TREASURE = 56,
  WerewolfCantUseMCItem = 57,
  DetectRetryTask = 58,
  TreasureChest = 59,
  WerewolfMCCD = 60,
  SkyBattle = 61,
  UnavailableServer = 62,
  WarFlag = 63,
  S0AllianceBuilding = 64
}
ResourceItemMonsterJumpType = {MonsterJumpType_Monster = 1, MonsterJumpType_Boss = 2}
PlaceRoadState = {Build = 1, Remove = 2}
PlaceRoadFlagState = {
  None = 0,
  Start = 1,
  End = 2
}
ThermalPhase = {
  None = 0,
  Normal = 1,
  Frozen = 2,
  Fire = 3
}
PhaseChangeType = {
  None = 0,
  ToFrozen = 1,
  ToFire = 2,
  FrozenToNormal = 3,
  FireToNormal = 4
}
AllianceCityShowTimeState = {
  None = 0,
  Lock = 1,
  UnAttack = 2,
  Recover = 3,
  GiveUp = 4,
  KingMode = 5,
  DeclareWar = 6,
  TradeLock = 7,
  TradeBattle = 8,
  TradeOver = 9,
  AltarLock = 10,
  AltarBattle = 11,
  AltarOver = 12
}
PackageImgPath = {
  PackageBg = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_bg01",
  PackageTitle = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_name.prefab",
  RewardBg = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_bg02",
  EntranceIcon = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_icon",
  ScrollPack = "Assets/Main/TextureEx/UICommonPackageBig/CommonPackageBig_img_%s"
}
NoticeType = {
  RecruitHero = 1,
  FirstKill = 2,
  FirstOccupyCity = 3,
  ChangeOccupyCity = 4,
  HeroCard_Use = 5,
  OccupyEmptyCity = 6,
  NewServer_Act_Reward = 7,
  RadarRally = 8,
  AcquireHero = 9,
  AlElectResult = 10,
  ActBossOpen = 11,
  ActBossClose = 12,
  CrossServer = 13,
  ActBoss1stNo1 = 14,
  ActBossNo1New = 15,
  ActBossNo1Modify = 16,
  KingdomPositionAppoint = 17,
  CrossServer = 18,
  ArenaUnlock = 19,
  ArenaChampion = 20,
  PUSH_3V3ARENA = 21,
  ActScratchFirstReward = 22,
  BoxGetReward = 25,
  CrossKingdomNotice26 = 26,
  CrossKingdomNotice27 = 27,
  CrossKingdomNotice28 = 28,
  CrossKingdomNotice29 = 29,
  CrossKingdomNotice30 = 30,
  CrossKingdomNotice31 = 31,
  NewbieArena = 32,
  PUSH_COMMON_NOTICE = 33,
  MonsterInvasion = 34,
  LuckyRoll = 35,
  RunningBossKillTip = 36,
  RecruitWorker = 37,
  FisrtOccupyFLINT = 38,
  FisrtOccupyOBSIDIAN = 39,
  DispatchTreasure = 40,
  BlackMarket = 41,
  DestroyCampCity = 42,
  SlotMachineEvent = 50,
  SlotMachienGain = 51,
  OpenGetBigReward = 52,
  DecorationGacha = 53,
  MultipleRankTop = 54,
  BerserkBoss = 55,
  ActMonopolyRewardTip1 = 56,
  ActMonopolyRewardTip2 = 57,
  ActMonopolyRewardTip3 = 58,
  MultiKill = 80,
  AresMissile = 59,
  BehemothShow = 60,
  BehemothSkill = 61,
  BehemothDeath = 62,
  StoveCenterBattleFinish = 63,
  InvasionMonsterLastKill = 64,
  ADGachaGoldenReward = 65,
  Ghostrecon = 70,
  ActLotteryBigReward = 81,
  DiscoverHugeSandWorm = 82,
  SuperRunningBoss = 90,
  DetectCaveExplorationFinish = 91,
  ExplorerTreasure = 92,
  RecaptureBuff = 93,
  SurfingZoneRankListed = 95,
  WeatherSummon = 96,
  GhostParkourRank = 97,
  FrontBreakSunday = 98,
  RecursionLang = 99
}
GiftPackageTab = {MonthCard = 1}
ClickWorldType = {Ground = 0, Collider = 1}
WorldCamp = {
  Enemy = 0,
  Ally = 1,
  Neutral = 2,
  Self = 3,
  WsTeammate = 4,
  WsEnemy = 5
}
WorldTroopColorType = {
  name = 0,
  line = 1,
  light = 2
}
RobotState = {
  FREE = 0,
  BUILD = 1,
  SCIENCE = 2,
  FARM = 3,
  FACTORY = 4,
  PASTURE = 5
}
RobotSkillType = {
  DEFAULT = 0,
  BUILD = 1,
  SCIENCE = 2,
  FARM = 3,
  FACTORY = 4
}
UIGuideGrowType = {PlantFarm = 1}
RecommendShowState = {ShowBuild = 1, ShowPanel = 2}
RecommendShowType = {
  FarmPlant = 1,
  FarmGet = 2,
  FeedOstrich = 3
}
GolloesType = {
  Worker = 1,
  Explorer = 2,
  Trader = 3,
  Warrior = 4
}
GolloesSound = {
  [GolloesType.Worker] = SoundAssetId.Music_Effect_Golloes_Worker,
  [GolloesType.Explorer] = SoundAssetId.Music_Effect_Golloes_Explorer,
  [GolloesType.Trader] = SoundAssetId.Music_Effect_Golloes_Trader,
  [GolloesType.Warrior] = SoundAssetId.Music_Effect_Golloes_Warrior
}
GolloesTypeOrderList = {
  GolloesType.Worker,
  GolloesType.Explorer,
  GolloesType.Trader,
  GolloesType.Warrior
}
CommonShopType = {
  Goods = 1,
  Vip = 2,
  LimitTime = 3,
  HeroReset = 4,
  Adventure = 5,
  GolloesShop = 6,
  AllianceShop = 7,
  HonorShop = 8,
  GiftShop = 9,
  GiftVoucher = 10,
  TrailTowerShop = 100,
  DecorationShop = 150,
  SeasonShop = 200
}
TradeShopType = {NORMAL = 0, NIGHT = 1}
AllianceMemberOpenType = {
  AllianceMember = 1,
  ResSupport = 2,
  GolloesTrande = 3,
  OtherAlMember = 4
}
GolloesShow = {
  [GolloesType.Worker] = {
    name = "320246",
    nameBg = "UI_dispatch_namebg_blue",
    desc = "320216",
    icon = "UI_dispatch_blue",
    bg = "UI_dispatch_bg_blue",
    costBg = "UI_dispatch_consumebg_blue",
    costIcon = "UI_dispatch_consumeIcon_blue",
    claimBg = "UI_dispatch_receive_blue",
    color = Color.New(0.1, 0.9, 1, 1),
    tipOffsetX = 50,
    rewardIcon = "UI_dispatch_icon_01"
  },
  [GolloesType.Explorer] = {
    name = "320247",
    nameBg = "UI_dispatch_namebg_red",
    desc = "320217",
    icon = "UI_dispatch_red",
    bg = "UI_dispatch_bg_red",
    costBg = "UI_dispatch_consumebg_red",
    costIcon = "UI_dispatch_consumeIcon_red",
    claimBg = "UI_dispatch_receive_red",
    color = Color.New(1, 0.51, 0.51, 1),
    tipOffsetX = 0,
    rewardIcon = "UI_dispatch_icon_02"
  },
  [GolloesType.Trader] = {
    name = "320248",
    nameBg = "UI_dispatch_namebg_yellow",
    desc = "320218",
    icon = "UI_dispatch_yellow",
    bg = "UI_dispatch_bg_yellow",
    costBg = "UI_dispatch_consumebg_yellow",
    costIcon = "UI_dispatch_consumeIcon_yellow",
    claimBg = "UI_dispatch_receive_yellow",
    color = Color.New(1, 0.91, 0.45, 1),
    tipOffsetX = 0,
    rewardIcon = "UI_dispatch_icon_03"
  },
  [GolloesType.Warrior] = {
    name = "320249",
    nameBg = "UI_dispatch_namebg_purple",
    desc = "320219",
    icon = "UI_dispatch_purple",
    bg = "UI_dispatch_bg_purple",
    costBg = "UI_dispatch_consumebg_purple",
    costIcon = "UI_dispatch_consumeIcon_purple",
    claimBg = "UI_dispatch_receive_purple",
    color = Color.New(1, 0.52, 0.95, 1),
    tipOffsetX = -50,
    rewardIcon = "UI_dispatch_icon_04"
  }
}
RecommendShowAnimType = {Default = 1, Show = 2}
RecommendShowAnimName = {
  [RecommendShowAnimType.Default] = "UIRecommendDefault",
  [RecommendShowAnimType.Show] = "UIRecommendShow"
}
RecommendShowImgAnimName = {
  [RecommendShowAnimType.Default] = "UIRecommendLightDefault",
  [RecommendShowAnimType.Show] = "UIRecommendLightShow"
}
AssistanceType = {
  Build = 0,
  MainCity = 1,
  AllianceCity = 2,
  APS_ASSISTANCE_THRONE = 3,
  Train = 4,
  DragonBuild = 5,
  APS_ASSISTANCE_SERVER_THRONE = 6,
  Desert = 7,
  AllianceBuild = 8,
  WinterEntity = 9,
  CityStronghold = 10,
  TradeState = 11,
  EpidemicBuild = 12,
  ASSISTANCE_QUARANTINE_CITY = 13,
  ASSISTANCE_SERVER_THRONE_MISSILE_FACTORY = 14,
  ASSISTANCE_OUTPOST = 15,
  ASSISTANCE_ZWL_BUILDING = 17,
  ASSISTANCE_ALTAR = 18
}
GuideTipPosition = {
  LeftUp = 1,
  RightUp = 2,
  LeftDown = 3,
  RightDown = 4
}
GuideMoveCameraType = {
  Point = 1,
  Build = 2,
  CityTroop = 3,
  AllianceChief = 4,
  AllianceMember = 5,
  NewbieSpaceMan = 6,
  Npc = 7,
  FollowNpc = 8,
  CollectResource = 9,
  Garbage = 10,
  MonsterReward = 11,
  RadarMonster = 12,
  WorldCity = 13,
  LandLock = 14
}
TemplateUnlockType = {
  Build = 0,
  Science = 1,
  MonthCard = 2,
  Career = 2,
  Talent = 4,
  Mastery = 5
}
UnlockBtnType = {
  Quest = 1,
  Build = 2,
  CityTroop = 3,
  Resource = 4,
  FastBuild = 5,
  Search = 6,
  Tool_Goods = 100,
  Tool_Resource = 101,
  Tool_ResourceItem = 102
}
UnlockBtnIconPath = {
  [UnlockBtnType.Quest] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_icon_task",
  [UnlockBtnType.Build] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_robot",
  [UnlockBtnType.CityTroop] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIGuide_queue",
  [UnlockBtnType.Resource] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_Technology",
  [UnlockBtnType.FastBuild] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIGuide_queue",
  [UnlockBtnType.Search] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIGuide_queue"
}
UserSayCodeMap = {}
UserSayCodeMap.en = "Account Banned"
UserSayCodeMap.ru = "\208\144\208\186\208\186\208\176\209\131\208\189\209\130 \208\191\208\190\208\180 \208\177\208\176\208\189\208\190\208\188"
UserSayCodeMap.ja = "\227\130\162\227\130\171\227\130\166\227\131\179\227\131\136\229\135\141\231\181\144"
UserSayCodeMap.cn = "\232\180\166\229\143\183\232\162\171\229\176\129\229\129\156___*\231\166\129\232\168\128*___*\229\176\129\229\143\183*"
UserSayCodeMap.tw = "\229\184\179\232\153\159\232\162\171\229\176\129\229\129\156"
UserSayCodeMap.ar = "\216\170\217\133 \216\173\216\184\216\177 \216\167\217\132\216\173\216\179\216\167\216\168"
UserSayCodeMap.de = "Konto verbannt"
UserSayCodeMap.fr = "Compte bloqu\195\169"
UserSayCodeMap.ko = "\234\179\132\236\160\149\236\157\180 \236\176\168\235\139\168\235\144\168"
UserSayCodeMap.pt = "Conta foi congelada"
UserSayCodeMap.th = "\224\184\154\224\184\177\224\184\141\224\184\138\224\184\181\224\185\130\224\184\148\224\184\153\224\185\129\224\184\154\224\184\153"
UserSayCodeMap.tr = "Hesap donduruldu"
UserSayCodeMap.id = "Akun Diblokir"
UserSayCodeMap.es = "Cuenta bloqueada"
UserSayCodeMap.it = "Account bloccato"
UIMainSavePosType = {
  Quest = 1,
  Build = 2,
  CityTroop = 3,
  FastBuild = 4,
  Goods = 5,
  PlayerLevel = 6,
  Search = 7,
  StorageLimit = 9,
  Power = 10,
  Gold = 11,
  Stamina = 12,
  LWBattleBtn = 13,
  RecruitBtn = 14,
  HeroBtn = 15,
  BagBtn = 16,
  AllianceBtn = 17,
  MailBtn = 18,
  VisitorBtn = 19,
  BuildQueue = 20,
  SaveGirlWarning = 21,
  Mummy = 22,
  GoldBrickBtn = 23
}
MoveToWorldJoinAllianceType = {Join = "1", No = "2"}
BuildConnectRoadDirection = {
  None = 0,
  Top = 1,
  Right = 2,
  Left = 3,
  Down = 4
}
DirectionType = {
  Top = 1,
  Right = 2,
  Left = 3,
  Down = 4
}
PreviewActivityType = {OffSeason = "OffSeason"}
EnumQualitySetting = {
  PostProcess_Bloom = "QualitySetting.PostProcess.Bloom",
  PostProcess_ColorAdjustments = "QualitySetting.PostProcess.ColorAdjustments",
  PostProcess_Vignette = "QualitySetting.PostProcess.Vignette",
  PostProcess_Tonemapping = "QualitySetting.PostProcess.Tonemapping",
  PostProcess_LiftGammaGain = "QualitySetting.PostProcess.LiftGammaGain",
  PostProcess_DepthOfField = "QualitySetting.PostProcess.DepthOfField",
  Resolution = "QualitySetting.Resolution",
  FPS = "QualitySetting.FPS",
  Terrain = "QualitySetting.Terrain",
  ShaderLOD = "QualitySetting.ShaderLOD"
}
EnumQualityLevel = {
  Off = 0,
  Low = 1,
  Middle = 2,
  High = 3
}
BuildTilesType = {
  One = 1,
  Two = 2,
  Three = 3
}
StatTTType = {
  Guide = "noviceboot",
  Quest = "quest",
  Special = "special",
  JumpGuideId = "jump",
  FinishTrigger = "finishTrigger",
  FinishLevel = "finishLevel",
  CreateLevelStart = "createLevelStart",
  CreateLevelComplete = "createLevelComplete",
  EngeryNotEnough = "engery_not_enough",
  PveBattleStart = "pveBattleStart",
  PveBattlePowerLack = "pveBattlePowerLack",
  PveBattleFail = "pveBattleFail"
}
GuideCameraShowUIMainType = {
  None = 0,
  Hide = 1,
  Show = 2
}
BaseExpansionType = {
  None = 0,
  Road = 1,
  Tree = 2
}
NewUserWorld = {
  Skip = 0,
  Ing = 1,
  Pass = 2
}
AllianceHelpState = {
  No = 0,
  UpgradeHelped = 1,
  RuinsHelped = 2,
  UpgradeAndRuinsHelped = 3
}
UIRocketLandingPlayType = {Enter = 1, Quick = 2}
GuideJumpType = {
  BuildPlace = 1,
  QueueBuild = 2,
  PlantAnimal = 3,
  WaitMessageFinish = 4,
  ClickTime = 5,
  Factory = 6,
  ClickBuild = 7,
  FactorySpeed = 8,
  TimelineJump = 9,
  WaitCloseUI = 10,
  BuildLevel = 11,
  QueueState = 12,
  AllianceMember = 13,
  DoneGuide = 14,
  CityPointType = 15,
  BuildRoad = 16,
  HasBuild = 17,
  HasGroceryStoreOrder = 18,
  ClickRadarBubble = 19,
  IsHaveCanShopItem = 20,
  UIStorageShopMainViewTab = 21,
  PlayerCareer = 22,
  AllianceLeader = 23,
  TreatSoldier = 24,
  BuildState = 25,
  LandLockState = 26,
  LandLockHasChest = 27,
  LandLockPowerEnough = 28,
  PveHasUseBattleHero = 29,
  PveBattleMinHeroRarity = 30,
  HasCanAdvanceHero = 31,
  HasOutRangeLevelHero = 32,
  FactoryFreeSpeed = 33,
  LockLandBubbleState = 34,
  HaveAlliance = 35,
  IsFormationUnset = 36,
  IsSuccessMarch = 37,
  HaveMonsterReward = 38,
  GetMonsterRewardBagFull = 39,
  Bubble = 40,
  AttackLevelMonster = 41,
  FinishChapter = 42,
  HaveLeaderInAlliance = 43,
  PveLevelExploreState = 44,
  FactoryState = 45,
  OwnResourceItemNum = 46,
  UIResourceLackHaveLackTips = 47,
  OwnResourceNum = 48,
  PveTaskNotUnCompleteState = 49,
  HaveUpgradeHero = 50,
  PveMonumentRestEnterTime = 51,
  HistoryUpgradeHero = 52,
  BuildBubble = 53,
  SceneType = 54,
  HasStarUpHero = 55,
  HasCanStarUpHero = 56,
  PveBattleResult = 57,
  OwnItemNum = 58,
  ShowQuestId = 59,
  WorldCollectPoint = 60,
  UIPVEPowerLack = 61
}
UINoInputType = {
  ShowNoScene = 1,
  ShowNoUI = 2,
  Close = 3
}
UIMovingType = {Open = 1, Close = 2}
PositionUnitType = {
  DefaultRoad = 1,
  InCityCanBuildPoint = 5,
  NoBuildPoint = 6
}
SpecialGuideLogType = {
  RocketLandingClickJump = 1103,
  RecommendPlantFarmFirstClickFarm = 1104,
  DragPlantFarm = 1105,
  PlantFarmPosLeftTop = 1106,
  PlantFarmPosRightTop = 1107,
  PlantFarmPosLeftDown = 1108,
  PlantFarmPosLeftRight = 1109,
  ShowFoodBoxFinger = 1110,
  ShowBusinessBoxFinger = 1111,
  PlaneRuinTimelineJump = 1112,
  PlaneRuinTimelineShow = 1200,
  PlaneRuinTimelineHello = 1201,
  PlaneRuinTimelineRuin = 1202
}
PlantPosLogIndex = {
  SpecialGuideLogType.PlantFarmPosLeftTop,
  SpecialGuideLogType.PlantFarmPosRightTop,
  SpecialGuideLogType.PlantFarmPosLeftDown,
  SpecialGuideLogType.PlantFarmPosLeftRight
}
ABTestType = {A = "0", B = "1"}
DestroyBuildType = {Self = 0, Other = 1}
DestroyRankType = {
  Blood = 0,
  Stamina = 1,
  DestroyRank = 2
}
StorageShopSlotState = {
  Empty = 0,
  OnSell = 1,
  Cleaning = 2,
  SoldOut = 3
}
StorageShopListType = {World = 0, Alliance = 1}
HeroStationState = {
  Current = 1,
  Idle = 2,
  Other = 3,
  Namesake = 4,
  Disabled = 5
}
OtherBuildBubbleType = {StorageShop = 1}
OtherBuildBubbleIcon = {
  CommonBg = "bubble_bg_unselect",
  StorageShop = "bubble_icon_trading_bank2"
}
WorldBuildTopBubbleType = {
  None = 0,
  HelperDetect = 2,
  ChatPlot = 3,
  HighFive = 4,
  Firework = 5
}
WorldBuildTopBubbleTypeData = {
  [WorldBuildTopBubbleType.HelperDetect] = {
    assert = "Assets/Main/Prefabs/March/WorldHelperDetectInfo.prefab",
    script = "Scene.BuildTopBubble.HelperDetectWorldBuildBubble"
  },
  [WorldBuildTopBubbleType.ChatPlot] = {
    assert = "Assets/Main/Prefabs/March/WorldPlotBubble.prefab",
    script = "Scene.BuildTopBubble.PlotBuildBubble"
  },
  [WorldBuildTopBubbleType.Firework] = {
    assert = "Assets/Main/Prefabs/March/WorldFireWorkInfo.prefab",
    script = "Scene.BuildTopBubble.FireworkWorldBuildBubble"
  },
  [WorldBuildTopBubbleType.HighFive] = {
    assert = "Assets/Main/Prefabs/March/WorldHighFiveBubble.prefab",
    script = "Scene.BuildTopBubble.HighFiveBubble"
  }
}
WorldEffectBubbleType = {
  None = 0,
  TreasureDetectRewardIcon = 1,
  HelpDetectEndEffectBubble = 2,
  HelpToTreatVirusBubble = 3,
  VirusPoisonedBubble = 4,
  MusicFestival2025Bubble = 5
}
WorldEffectBubbleTypeData = {
  [WorldEffectBubbleType.TreasureDetectRewardIcon] = {
    assert = "Assets/Main/Prefabs/March/WorldTreasureDetectRewardIcon.prefab",
    script = "Scene.WorldShortTimeEffectBubble.TreasureDetectRewardIconBubble"
  },
  [WorldEffectBubbleType.HelpDetectEndEffectBubble] = {
    assert = "Assets/Main/Prefabs/March/HelpDetectEndEffectBubble.prefab",
    script = "Scene.WorldShortTimeEffectBubble.HelpDetectEndEffectBubble"
  },
  [WorldEffectBubbleType.HelpToTreatVirusBubble] = {
    assert = "Assets/Main/Prefabs/March/HelpToTreatVirusBubble.prefab",
    script = "Scene.WorldShortTimeEffectBubble.HelpToTreatVirusBubble"
  },
  [WorldEffectBubbleType.VirusPoisonedBubble] = {
    assert = "Assets/Main/Prefabs/March/VirusPoisonedBubble.prefab",
    script = "Scene.WorldShortTimeEffectBubble.VirusPoisonedBubble"
  },
  [WorldEffectBubbleType.MusicFestival2025Bubble] = {
    assert = "Assets/Main/Prefabs/UI/ActMusicFestival2025/WorldShow/WorldPlayingMusicIcon.prefab",
    script = "Scene.WorldShortTimeEffectBubble.MusicFestival2025StartPartyBubble"
  }
}
ArrowPrefabName = {
  [GuideArrowStyle.Finger] = UIAssets.WorldYellowArrow,
  [GuideArrowStyle.Green] = UIAssets.WorldArrow,
  [GuideArrowStyle.Yellow] = UIAssets.WorldYellowArrow
}
HeroStationEffectType = {
  Normal = 0,
  GlobalMoney = 1,
  StorageLimit = 2,
  HeroExp = 3,
  TroopLimit = 4,
  TradeCenterMoney = 10001
}
HeroStationSkillEffectType = {
  [1000] = HeroStationEffectType.GlobalMoney,
  [1001] = HeroStationEffectType.StorageLimit,
  [1002] = HeroStationEffectType.TroopLimit,
  [1003] = HeroStationEffectType.HeroExp
}
FormationAddSoldierType = {
  TrainSoldier = 13,
  ThirdHeroBuild = 14,
  KillMonster = 15,
  RadarMonster = 16,
  FormationScience = 17,
  HeroUpgrade = 24,
  HeroExchange = 25
}
GuideTimeLineBubbleType = {
  OstrichEgg = 1,
  ZeroRocket = 2,
  Migrate = 3,
  Cow = 4
}
GuideOrderType = {
  CanSubmit = 1,
  OrderItemType = 2,
  NoSubmit = 3
}
GuideOrderState = {
  NoSubmit = 1,
  CanSubmit = 2,
  Finish = 3,
  Delete = 4
}
GuideUIMainShowType = {Hide = 1, Show = 2}
BuildZoneType = {
  No = -1,
  All = 0,
  Tower = 1,
  Hero = 2,
  Trade = 3,
  Military = 4,
  SeasonBuild = 5,
  MummyYard = 6,
  SeasonPhoto = 7
}
BuildZoneName = {
  [BuildZoneType.Tower] = 100810,
  [BuildZoneType.Hero] = 100811,
  [BuildZoneType.Trade] = 100812,
  [BuildZoneType.Military] = 100813,
  [BuildZoneType.SeasonBuild] = "season_building_clear_name005",
  [BuildZoneType.MummyYard] = "season_building_clear_name006",
  [BuildZoneType.SeasonPhoto] = "season_building_clear_name007"
}
BuildZoneMainType = {Sub = 0, Main = 1}
StationIdList = {
  BuildZoneType.Tower,
  BuildZoneType.Trade,
  BuildZoneType.Military,
  BuildZoneType.Hero
}
StationBuildId = {
  [BuildZoneType.Tower] = BuildingTypes.FUN_BUILD_MAIN,
  [BuildZoneType.Trade] = BuildingTypes.APS_BUILD_FARM,
  [BuildZoneType.Military] = BuildingTypes.FUN_BUILD_TRADING_CENTER,
  [BuildZoneType.Hero] = BuildingTypes.FUN_BUILD_RADAR_CENTER
}
ResourceItemShowType = {No = 0, Show = 1}
ComplexTipType = {
  Text = 1,
  Image = 2,
  Hero = 3
}
BubbleState = {Normal = 1, Road = 2}
NextBusinessComeType = {
  EARTH_ORDER = 0,
  GROCERY_STORE = 1,
  RESIDENT_ORDER = 2
}
ClickUISpecialBtnType = {
  UIFormationSelectHero = 1,
  UIFormationDeleteHero = 2,
  UIFormationTableAddHero = 3,
  UIPVESceneMinHeroRarity = 4,
  UIPVESceneHeroId = 5,
  UIPVESceneHeroRarity = 6,
  UIHeroListCanAdvanceHero = 7,
  UIScience = 8,
  UIBuildUpgradeLackResource = 9,
  UIHeroAdvanceMainHero = 10,
  UIHeroAdvanceSubHero = 11,
  UIHeroListAdvanceHero = 12,
  UIHeroListHeroId = 13
}
NationType = {
  UnitedNations = "1",
  China = "2",
  America = "3"
}
PlayerNations = {
  {
    Nation = NationType.UnitedNations,
    Flag = "",
    Name = ""
  },
  {
    Nation = NationType.China,
    Flag = "",
    Name = ""
  },
  {
    Nation = NationType.America,
    Flag = "",
    Name = ""
  }
}
ChatReportContent = {
  avatar = 2,
  name = 1,
  chat = 0,
  allianceName = 4,
  allianceAcronym = 5,
  allianceManifesto = 6,
  mailR4 = 7,
  mailPresident = 8,
  allianceNotice = 9,
  moment = 10,
  chatTranslate = 11,
  groupChatName = 12,
  groupChatContent = 13,
  allianceRankName = 14,
  giftMessage = 15,
  voiceChat = 16
}
ChatReportType = {
  Politics = 1,
  Ads = 2,
  Gambling = 3,
  Gm = 4,
  Sexy = 5,
  Attack = 6,
  NickName = 7,
  HeadIcon = 8,
  Other = 9,
  Privacy = 11
}
AllianceMineStatus = {
  Normal = 0,
  Constructing = 1,
  Ruin = 2,
  Build = 3,
  FoldUp = 4
}
AlMineConditionType = {
  MemberCount = 1,
  Power = 2,
  RuinLv = 3,
  PreBuild = 4,
  CityLevel = 5,
  Trends = 6,
  Science = 7,
  Resource = 8
}
LeagueMatchTab = {
  Activity = 1,
  GachaSunday = 2,
  Compete = 3,
  Notice = 4,
  AllianceRank = 5,
  CrossServer = 6,
  CrossServerDesert = 7
}
LeagueMatchStage = {
  None = 1,
  Preview = 2,
  GroupResult = 3,
  DrawLots = 4,
  DrawLotsFinished = 5,
  Compete = 6,
  WeeklySummary = 7,
  FinalSummary = 8
}
SegmentType = {
  None = 0,
  Bronze = 1,
  Silver = 1,
  Gold = 2,
  Platinum = 4,
  Diamond = 3
}
ActivityOverviewType = {
  EarthOrder = 1,
  RallyBossAct = 2,
  IndividualOrder = 3,
  ChampionBattle = 4,
  MineCave = 5,
  Puzzle = 6,
  AllianceOrder = 7,
  Arena = 8,
  Adventure = 9,
  EverydayTask = 10
}
OverviewToActType = {
  [ActivityOverviewType.RallyBossAct] = EnumActivity.RallyBossAct.Type,
  [ActivityOverviewType.IndividualOrder] = EnumActivity.IndividualOrder.Type,
  [ActivityOverviewType.MineCave] = EnumActivity.MineCave.Type,
  [ActivityOverviewType.Puzzle] = EnumActivity.Puzzle.Type,
  [ActivityOverviewType.AllianceOrder] = EnumActivity.AllianceOrder.Type,
  [ActivityOverviewType.Arena] = EnumActivity.Arena.Type
}
TreasureId = {EnergyTreasure = 10000}
MineCavePlunderType = {
  DefenseFail = 1,
  DefenseWin = 2,
  AttackWin = 3,
  AttackFail = 4
}
OverviewTypeToDailyActivity = {
  [2] = {
    Type = EnumActivity.RallyBossAct.Type,
    ActId = EnumActivity.RallyBossAct.ActId
  },
  [3] = {
    Type = EnumActivity.IndividualOrder.Type,
    ActId = nil
  },
  [5] = {
    Type = EnumActivity.MineCave.Type,
    ActId = EnumActivity.MineCave.ActId
  },
  [6] = {
    Type = EnumActivity.Puzzle.Type,
    ActId = nil
  },
  [8] = {
    Type = EnumActivity.Arena.Type,
    ActId = EnumActivity.Arena.ActId
  }
}
CityPrologueBuildType = {
  Ruins = "Ruins",
  Normal = "Normal",
  Plant = "Plant",
  Get = "Get"
}
TranslateType = {MailInfo = 1, ChatMessage = 2}
WelfareMessageKey = {GrowthPlanInfo = 1}
TodayNoSecondConfirmType = {
  RefreshDispatchTask = "RefreshDispatchTask",
  RefreshBestDispatchTask = "RefreshBestDispatchTask",
  SetKingdomBadges = "SetKingdomBadges",
  UpgradeUseDiamond = "UpgradeUseDiamond",
  BuyUseDialog = "BuyUseDialog",
  AutoDig = "AutoDig",
  BuyStaminaTip = "BuyStaminaTip",
  BuyLuckyRollTip = "BuyLuckyRollTip",
  BuyScratchTip = "BuyScratchTip",
  KillZombie = "KillZombie",
  CityWar = "CityWar",
  SeasonCityWar = "CityWar",
  KingActivity = "KingActivity",
  ChangeLightHouseBrightnessLevel = "ChangeLightHouseBrightnessLevel",
  CallbackPowerWorker = "CallbackPowerWorker",
  ShowSubscriptionBubble = "ShowSubscriptionBubble",
  FirstPayShowHero = "FirstPayShowHero",
  AllianceInvite = "AllianceInvite",
  MvCityInBattleWorld = "MvCityInBattleWorld",
  LuckyShopRefresh = "LuckyShopRefresh",
  CrossKingActivity = "CrossKingActivity",
  GiftBoxTip = "GiftBoxTip",
  GiftBoxOpenTip = "GiftBoxOpenTip",
  InfiniteGiftRefresh = "InfiniteGiftRefresh",
  BuyActivityArenaTimes = "BuyActivityArenaTimes",
  PayGoldBrick = "PayGoldBrick",
  TrainRefresh = "TrainRefresh",
  DecorationPickUp = "DecorationPickUp",
  AttackCityStronghold1 = "AttackCityStronghold1",
  AttackCityStronghold2 = "AttackCityStronghold2",
  UserGiveUpDesert = "UserGiveUpDesert",
  CollectInBlackRange = "CollectInBlackRange",
  ResistanceLack = "ResistanceLack",
  UserShareDesert = "UserShareDesert",
  UserDesertLinkTip = "UserDesertLinkTip",
  OverUseSeasonExpBook = "OverUseSeasonExpBook",
  AttackWorldBossBeforeSeasonStart = "AttackWorldBossBeforeSeasonStart",
  WhistleMonsterWhenInProtect = "WhistleMonsterWhenInProtect",
  AttackCityStronghold = "AttackCityStronghold",
  AttackCityStrongholdBoss = "AttackCityStrongholdBoss",
  DetectRescueSodlierFull = "DetectRescueSodlierFull",
  KingdomPositionApplyDeleteByCtrl = "KingdomPositionApplyDeleteByCtrl",
  KingdomPositionApplyDeleteBySelf = "KingdomPositionApplyDeleteBySelf",
  RefreshBlackMarket = "RefreshBlackMarket",
  AresMissileConfirm = "AresMissileConfirm",
  GoddessMummyConfirm = "GoddessMummyConfirm",
  MummyAttackConfirm = "MummyAttackConfirm",
  AttackMissileFactory = "AttackMissileFactory",
  UseDiamondRefreshBlackMarket = "UseDiamondRefreshBlackMarket",
  TrainGoConfirm = "TrainGoConfirm",
  HelpStopFireConfirm = "HelpStopFireConfirm",
  ActivityDecorationGachaNotSelectWish = "ActivityDecorationGachaNotSelectWish",
  SendCoalSecondConfirm = "SendCoalSecondConfirm",
  CityAttachmentBuildSecondConfirm = "CityAttachmentBuildConfirm",
  CollectTargetHaveMarch = "CollectTargetHaveMarch",
  CollectMeteoriteTargetHaveMarch = "CollectMeteoriteTargetHaveMarch",
  ActGiftBoxNewDel = "ActGiftBoxNewDel",
  NoClickGhostreconEnterTip = "NoClickGhostreconEnterTip",
  MoveCityInBlackTip = "MoveCityInBlackTip",
  MoveCityInBlackArea = "MoveCityInBlackArea",
  BuildingFinishRemindConfirm = "BuildingFinishRemindConfirm",
  CapacityBoxSelectNewOverQuickCount = "CapacityBoxSelectNewOverQuickCount",
  RefreshNewPeakBattleList = "RefreshNewPeakBattleList",
  ActivityAlarmClockBubble = "ActivityAlarmClockBubble",
  TacticalChipUpgradeFeedUse = "TacticalChipUpgradeFeedUse",
  MonsterInvasionSummonRemind = "MonsterInvasionSummonRemind",
  DiggingGameUseItem = "DiggingGameUseItem",
  SeasonGreenMarch = "SeasonGreenMarch",
  RecruitConfirmWhenAllianceCompete = "RecruitConfirmWhenAllianceCompete",
  CrossAttackMeteoriteNotice = "CrossAttackMeteoriteNotice",
  AllianceCenterAttackS3 = "AllianceCenterAttackS3",
  MeteoriteAllianceAssembly = "MeteoriteAllianceAssembly",
  UIDecorationChoiceBoxTip = "UIDecorationChoiceBoxTip",
  ActDetectTreasureItemUseTip = "ActDetectTreasureItemUseTip",
  ActMonopolyFreeNumEmptyTip = "ActMonopolyFreeNumEmptyTip",
  TrainPrepareChangeCoach = "TrainPrepareChangeCoach",
  ZoneMobilizationDonateLimitedConfirm = "ZoneMobilizationDonateConfirm",
  AllianceInviteVisitor = "AllianceInviteVisitor",
  KillZombieAlBossChallenge = "KillZombieAlBossChallenge",
  UseSkinColourTip = "UseSkinColourTip",
  KillZombiePersonalBossChallenge = "KillZombiePersonalBossChallenge",
  ZoneMobilizationDonateNoneAlliance = "ZoneMobilizationDonateNoneAlliance",
  ZoneMobilizationDonatePosRedPoint = "ZoneMobilizationDonatePosRedPoint",
  AllianceJoinRallyLimit = "AllianceJoinRallyLimit",
  BattleCardDecomposeConfirm = "BattleCardDecomposeConfirm",
  KillZombieAlBossChallengeMax = "KillZombieAlBossChallengeMax",
  ShowFireworkQueue = "ShowFireworkQueue",
  ShowFireworkQuitAlliance = "ShowFireworkQuitAlliance",
  ShowFireworkKickOutAlliance = "ShowFireworkKickOutAlliance",
  ShowFireworkBagUse = "ShowFireworkBagUse",
  BountyHunterAttackNormalMonster = "BountyHunterAttackNormalMonster",
  BountyHunterAttackWhenCanRefresh = "BountyHunterAttackWhenCanRefresh",
  BountyHunterRefreshWhenEliteExist = "BountyHunterRefreshWhenEliteExist",
  ResistanceWarningTip = "ResistanceWarningTip",
  SurfingBattleEnterBtn = "SurfingBattleEnterBtn",
  SurfingDeviceLevelLowRemind = "SurfingDeviceLevelLowRemind",
  DiggingTreasureConfirmTip = "DiggingTreasureConfirmTip",
  SeasonCampDestroyNoticeSilence = "SeasonCampDestroyNoticeSilence",
  SURFING_FIRST_ENTER_ACTIVITY = "SURFING_FIRST_ENTER_ACTIVITY",
  Ghost_Parkour_Challenge_Other = "Ghost_Parkour_Challenge_Other",
  Ghost_Parkour_Enter_Button = "Ghost_Parkour_Enter_Button",
  RADAR_QUICK_CLAIM_DAILY_ALERT = "RADAR_QUICK_CLAIM_DAILY_ALERT",
  TruckSuperDepartureRefreshSecondConfirm = "TruckSuperDepartureRefreshSecondConfirm",
  TruckSuperDepartureRefreshLackingGoodsSecondConfirm = "TruckSuperDepartureRefreshLackingGoodsSecondConfirm",
  AllianceInviteShareCostRemind = "AllianceInviteShareCostRemind",
  TrainRefreshSecondConfirm = "TrainRefreshSecondConfirm",
  CampScienceDayRed = "CampScienceDayRed",
  S0AllianceBossVisitorRemind = "S0AllianceBossVisitorRemind",
  S0AllianceBossWeaknessAttackRemind = "S0AllianceBossWeaknessAttackRemind",
  WorldBookmarkDelConfirm = "WorldBookmarkDelConfirm",
  SeasonTowerSweepTipSecondConfirm = "SeasonTowerSweepTipSecondConfirm"
}
QuestShowType = {No = 0, Show = 1}
RedPacketState = {
  ALREADY_GET = 0,
  VALID = 1,
  COST_ALL = 2,
  TIMEOUT = 3,
  PREPARE_SEND = 4
}
GarageBuildIds = {
  BuildingTypes.FUN_BUILD_TRAINFIELD_1,
  BuildingTypes.FUN_BUILD_TRAINFIELD_2,
  BuildingTypes.FUN_BUILD_TRAINFIELD_3,
  BuildingTypes.FUN_BUILD_TRAINFIELD_4
}
PackTimeType = {
  Regular = 1,
  Always = 2,
  Conditional = 3,
  ByTrigger = 5,
  AlwaysByWeek = 6,
  Controlled = 7,
  AlwaysHideTime = 8,
  Periodic = 9
}
ShareCheckType = {
  StorageShop = 0,
  MailScoutResult = 1,
  MailBattleReport = 2
}
UIMainIconPrefab = {
  PiggyBank = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_PiggyBank.prefab",
  EnergyBank = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_EnergyBank.prefab",
  SellCatgirl = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  SellCop = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  SellConsigliere = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  SellDetective = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  SellSumo = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  SellClown = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_SellHero.prefab",
  Robot1 = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Robot.prefab",
  Robot2 = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Robot.prefab",
  Robot3 = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Robot.prefab",
  SellDiamond = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Packstore.prefab",
  SellCoin = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Packstore.prefab",
  SellHeroCommon = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Packstore.prefab",
  SellSpeedCommon = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Packstore.prefab",
  UIMain_icon_hero1 = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_hero1.prefab",
  UIMain_icon_Onestepahead = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Onestepahead.prefab",
  UIMain_icon_HeroLegend = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_HeroLegend.prefab",
  UIMain_icon_Invincible = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_Invincible.prefab",
  UIMain_icon_firstPay = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_firstPay.prefab",
  UIMain_icon_PlayerLevelPackage = "Assets/Main/Prefabs/UI/UIMain/UIMain_icon_PlayerLevelPackage.prefab"
}
SysAlState = {
  WaitMerge = -2,
  Normal = -1,
  SignUp = 0,
  R4Elect = 1,
  R4Reuslt = 2,
  LeaderElect = 3,
  LeaderResult = 4,
  MergeTime_1 = 5,
  MergeTime_2 = 6
}
EffectReasonType = {
  Science = 0,
  Building = 1,
  Hero = 2,
  VIP = 3,
  MONTH_CARD = 4,
  PLAYER_LEVEL = 5,
  Hero_Station = 6,
  Science_Activity = 7,
  Alliance_Science = 8,
  World_Alliance_City = 9,
  Status = 10,
  Tank = 11,
  Career = 12,
  Alliance_Career = 13,
  Land = 14,
  SERVER_EFFECT = 15,
  BASE_TALENT = 16,
  Mastery = 17
}
BuffReasonIcon = {}
BuffReasonIcon[EffectReasonType.Science] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_technology"
BuffReasonIcon[EffectReasonType.Hero] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_hero"
BuffReasonIcon[EffectReasonType.VIP] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_vip"
BuffReasonIcon[EffectReasonType.BASE_TALENT] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_HQ-Talent"
BuffReasonIcon[EffectReasonType.Building] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_console"
BuffReasonIcon[-1] = "Assets/Main/Sprites/UI/UILWBuild/UIBuild_icon_robot_other"
UseABTestCountry = {
  "IN",
  "CN",
  "PH",
  "ID",
  "GB"
}
Wasteland_PlantState = {
  ToPlant = 1,
  ToWater = 2,
  ToReap = 3
}
AllianceCareerPosType = {No = 0, Yes = 1}
AllianceCareerEffectDescriptionType = {
  AddCount = 2,
  SubCount = 3,
  AddPercent = 4,
  SubPercent = 5
}
AllianceCityNewsType = {
  OCCUPY_NEUTRAL_CITY = 0,
  OCCUPY_OCCUPIED_CITY = 1,
  FIRST_NEUTRAL_CITY = 2
}
BattleNewsType = {Battle = 0, AllianceCity = 1}
UITipDirection = {
  ABOVE = 1,
  BELOW = 2,
  LEFT = 3,
  RIGHT = 4
}
AllianceAlertType = {
  BUILDING = 0,
  COLLECT = 1,
  ALLIANCE_CITY = 2,
  DESERT = 3,
  ALLIANCE_BUILD = 4,
  DRAGON_BUILDING = 5
}
AllianceTaskFuncType = {
  AllianceOrder = 1,
  AllianceMoveCity = 2,
  AllianceScience = 3,
  AllianceCareer = 4
}
IrrigationType = {Farmland = 1, Pasture = 2}
GuidePrologueFlag = {Start = 0, End = 1}
BuyFlag = {NOT_BUY = 0, BUY = 1}
LandLockState = {
  Any = -1,
  Unknown = 0,
  Hide = 1,
  Locked = 2,
  Unlocked = 4,
  Finished = 5
}
LandLockBubbleType = {
  Green = 0,
  Help = 1,
  Axe = 2,
  Red = 3,
  Yellow = 4,
  Wood = 5
}
LandLockTopIcon = {
  None = "None",
  Yellow = "Yellow",
  Red = "Red"
}
MonsterLockState = {
  NOT_BUY = 0,
  BUY = 1,
  Finished = 2
}
MonsterLockBubbleState = {
  Unlocked = "Unlocked",
  Pay = "Pay",
  Pve = "Pve"
}
HeroMonthCardRewardState = {
  REWARD_STATE_CAN_RECEIVE = 1,
  REWARD_STATE_LOCK = 2,
  REWARD_STATE_RECEIVED = 3,
  REWARD_STATE_UNRECEIVED = 4
}
SeasonForceRewardStatus = {
  NOT_RECEIVE = 0,
  RECEIVED = 1,
  BATTLE_PASS_RECEIVED = 2
}
SeasonForceRewardPackageType = {CRYSTAL_BOX = 0, MONEY = 1}
VirusChangeType = {
  None = 0,
  MarchBack = 1,
  DefendCity = 2,
  Treat = 3,
  CultivateVirus = 4,
  VirusExplosion = 5,
  PVELackResist = 6,
  PVESpecial = 7,
  PVPWin = 8,
  PVPLose = 9,
  Pumpkin = 10,
  Weather = 11,
  WorldBuildingAdd = 12
}
TemperatureChangeType = {
  NONE = -1,
  MARCH = 1,
  AttackedByRunningBoss = 2,
  AttackedByZombieRushBoss = 3,
  AttackedByPlayer = 4,
  LANDMINE = 5,
  WARMING = 6
}
CareerType = {
  None = 0,
  Admiral = 1,
  Raider = 2,
  Merchant = 3,
  Farmer = 4,
  Guard = 5
}
CareerSkillType = {Unknown = 0, AdmiralTroopSkill = 1}
DestroyType = {
  Normal = 0,
  LandMind = 1,
  MainBuildingExplosion = 2,
  MuseMummy = 3,
  MummyPatrol = 4,
  MissileForThrone = 5,
  DarknessMonster = 6,
  RunningBoss = 7,
  DarknessWhistleWander = 8,
  AllianceBuildShieldSkill = 9
}
CareerSkillTypeToIdList = {
  [CareerSkillType.AdmiralTroopSkill] = {10002, 10011}
}
CareerSkillState = {
  Unknown = 0,
  Ready = 1,
  Using = 2,
  Used = 3
}
QuestionAndAnswerType = {Q_A_TYPE_NPC = 2, Q_A_TYPE_NPC_ALL_RIGHT = 3}
GuideBuildState = {
  Normal = 1,
  NeedConnect = 2,
  Box = 3
}
FactoryIdToProductEffectId = {}
FactoryIdToProductEffectId[BuildingTypes.FUN_BUILD_FOODSHOP] = EffectDefine.EFFECT_PRODUCT_QUEUE_ADD_711000
FactoryIdToProductEffectId[BuildingTypes.FUN_BUILD_FOOD] = EffectDefine.EFFECT_PRODUCT_QUEUE_ADD_707000
FactoryIdToProductEffectId[BuildingTypes.FUN_BUILD_FOOD_1] = EffectDefine.EFFECT_PRODUCT_QUEUE_ADD_717000
FactoryIdToProductEffectId[BuildingTypes.FUN_BUILD_FOOD_2] = EffectDefine.EFFECT_PRODUCT_QUEUE_ADD_718000
FactoryIdToProductEffectId[BuildingTypes.FUN_BUILD_OIL_REFINERY] = EffectDefine.EFFECT_PRODUCT_QUEUE_ADD_708000
GuideNpcDoNextType = {
  Auto = 0,
  WaitWalk = 1,
  WaitWalkDelete = 2
}
SceneManagerSceneID = {
  None = 0,
  City = 1,
  World = 2,
  PVE = 3,
  Custom = 4
}
SceneType = {
  None = 0,
  City = 1,
  World = 2,
  PVE = 3,
  Custom = 4
}
CustomSceneSubType = {
  None = 0,
  PrepareTrain = 1,
  Hummer = 2,
  StageFeature = 3
}
PveStatus = {
  FirstStart = 0,
  MultiStart = 1,
  Finish = 2
}
CurScene = {PVEScene = -99}
PveLevelType = {
  NormalLevel = 1,
  HeroExpLevel = 2,
  FightLevel = 3,
  NormalExpLevel = 4,
  BattleExpLevel = 5,
  RadarExpLevel = 6,
  BattlePlayBackLevel = 7,
  AdventureLevel = 8,
  ZombieLevel = 9,
  SkillLevel = 10,
  ArmyLevel = 11,
  BarrageLevel = 12,
  ZombieBattle = 20
}
PveEntrance = {
  Test = 0,
  LandLock = 1,
  Monument = 2,
  DetectEventPve = 3,
  MonsterLock = 4,
  MineCave = 5,
  ArenaBattle = 6,
  ArenaSetting = 7,
  BattlePlayBack = 8,
  Adventure = 9,
  AdventureSetting = 10,
  LevelExplore = 11,
  PveAct = 12
}
PveExitType = {
  ExitBtn = 1,
  DetectEventExitBtn = 2,
  TowerupExitBtn = 3
}
PveSweepType = {No = 0, Yes = 1}
BULLET_LOG = false
DAMAGE_LOG = false
LOCAL_HERO_SKILL_OVERRIDE = false
INVINCIBLE = false
PVE_TEST_MODE = false
DEFAULT_BULLET_MOTION_STRING = "0,0,2,2|1,1,0,0"
TIME_STOP_DURATION = 3
SKILL_PUBLIC_CD = 0.01
TIME_STOP_CD = 0.1
TIME_STOP_CD_AI = 1
HALO_SKILL_CD = -1
HALO_BUFF_DURATION = -1
ULTIMATE_SKILL_SLOT_INDEX = 2
HERO_AWAKEN_SKILL_SLOT_INDEX = 4
DIE_PERCENT = 0.99
ZOMBIE_REMOVE_DISTANCE_Z = 25
BARRAGE_SCENE_CENTER = 36
EXIT_SPEED = 24
EXIT_CTRL_POINT_OFFSET = 5
WHITE_MAT = nil
RED_MAT = nil
PVEType = {
  None = -1,
  Barrage = 0,
  Parkour = 1,
  Skirmish = 2,
  Preview = 3,
  World = 4,
  Count = 5,
  FakePVP = 6,
  Arena3V3 = 7,
  MultipleParkour = 8,
  TorchRelay = 9,
  KOF = 10,
  DominatorTrain = 11,
  Surfing = 12,
  LastStand = 13,
  GhostParkour = 14,
  SkyBattle = 15
}
PVPType = {
  [PVEType.Skirmish] = 1,
  [PVEType.FakePVP] = 2
}
PVEEnterType = {
  Debug = -1,
  GM = 0,
  Default = 1,
  Radar = 2,
  TowerupJeepAdventure = 3,
  TruckRob = 4,
  PVPArena = 5,
  Monopoly = 6,
  Arena3V3 = 7,
  ActivityArena = 8,
  TrainRob = 9,
  ActivityArenaV2 = 10,
  TrailTower = 11,
  TruckRobRecord = 12,
  Mail = 13,
  CD_BattleLog = 14,
  TorchRelayMain = 15,
  NewPeakArena = 17,
  DetectCaveExploreEnter = 18,
  BeginnerEvent = 19,
  OpeningStage = 20,
  StageFeatureBuilding = 21,
  DetectZombieBusTrain = 22,
  DetectRetryTask = 23,
  Guide = 24,
  DetectAttackCityS0 = 25,
  T11IdleGameBattleEvent = 26,
  SurfingPlayback = 27,
  HSRRob = 28,
  LastStand = 29,
  NewGaleArena = 30,
  GhostPlayback = 31,
  CityBuilding = 35,
  HeroTryOut = 36,
  CityFakeZombie = 37,
  StageFeatureScene = 38,
  SeasonTower = 39
}
UnitType = {
  None = 0,
  Zombie = 1,
  Member = 2,
  Junk = 4,
  Plot = 8,
  TacticalWeapon = 16,
  Pet = 32,
  All = 63
}
ServerSwitch = {
  PveUseGpuSkin = 1,
  PveUseRvoOpt = 2,
  ShaderWarmUp = 3,
  PveGpuSkinFull = 4,
  PveCollider2D = 5,
  PveReturnOpt = 6,
  ParkourPerformance = 7,
  BuildArrayOpt = 8,
  BiuBiuNewPing = 9,
  GPUDamageNum = 10,
  MiniGameUseHybridNetwork = 11
}
UnitType2String = {
  [1] = "\228\184\167\229\176\184",
  [2] = "\232\139\177\233\155\132",
  [4] = "\230\157\130\231\137\169",
  [8] = "NPC",
  [16] = "\230\136\152\230\156\175\230\173\166\229\153\168",
  [UnitType.Pet] = "\229\143\172\229\148\164\231\137\169"
}
AnimName = {
  Idle = "idle",
  Run = "run",
  Walk = "walk",
  Attack = "attack",
  AttackMove = "attack_move",
  Dead = "dead",
  Dead_Fire = "dead_fire",
  Born = "born",
  Hurt = "hurt",
  Aim = "idle",
  Stun = "stun",
  SpecialMove = "specialMove"
}
MemberAnim = {
  Idle = "idle",
  Run = "run",
  Attack = "attack",
  Dead = "dead",
  Aim = "idle"
}
ZombieAnim = {
  Idle = "idle",
  Run = "run",
  Walk = "walk",
  Attack = "attack",
  Dead = "dead",
  Dead_Fire = "dead_fire",
  Born = "born",
  Hurt = "hurt"
}
BulletDurabilityType = {
  Time = 0,
  Collide = 1,
  CollideInfinity = -1,
  Once = 2
}
PVECamp = {
  Enemy = 0,
  Ally = 1,
  Neutral = 2,
  Self = 3,
  Count = 4
}
SkillType = {
  Bullet = 1,
  Buff = 2,
  Halo = 3,
  PassiveDeath = 4,
  CityIdle = 5,
  Expert = 6
}
SkillActionType = {
  Bullet = 1,
  Buff = 2,
  Halo = 3,
  Summon = 4,
  ResetCD = 5,
  DisperseEffect = 6,
  NoBulletDamage = 7,
  ReduceCD = 8
}
SkillAPType = {Active = 0, Passive = 1}
SkillTriggerType = {
  Active = 0,
  IdleOutside = 1,
  AlwaysOutside = 2,
  AlwaysInside = 3,
  Death = 4,
  BeHit = 5,
  Cast = 6,
  BeHitNew = 7
}
BulletMoveType = {
  Static = 0,
  Straight = 1,
  Parabola = 2,
  Follow = 4,
  Ray = 5,
  Revert = 6,
  StaticLineTracking = 7,
  StaticLineTrackingCenter = 8,
  CurveByAngle = 9,
  CurveByTargetAngle = 10,
  CircleRandom = 11,
  MoveSummon = 12,
  ParabolaPos = 13
}
LocationCondition = {
  None = 0,
  Self = 1,
  Same = 2,
  Default = 3,
  Random = 4,
  FrontOnly = 5,
  BackOnly = 6
}
LocationType = {
  None = 0,
  Front = 1,
  Back = 2
}
HeroType = {
  None = -1,
  All = 0,
  Tank = 1,
  Missile = 2,
  Aircraft = 3
}
HeroTemplateType = {
  Hero = 1,
  PVPEnemy = 2,
  SkirmishSoldier = 3,
  Dominator = 4
}
HeroJob = {
  Defense = 1,
  exportation = 2,
  subsidiary = 3
}
ColliderType = {Sphere = 1, Capsule = 2}
PriorityType = {
  All = 0,
  Nearest = 1,
  LowestHP = 2,
  Farthest = 3,
  Random = 4,
  HighestMaxHP = 5,
  HighestEffect = 6,
  HighestBuffCount = 7,
  BoxNearest = 8,
  BoxFarthest = 9,
  BoxRandom = 10
}
BulletBuffType = {
  None = 0,
  OnHit = 1,
  OnHitByChance = 2,
  OnKill = 3,
  OnCastToCaster = 4
}
LayerType = {
  Member = "Member",
  Zombie = "Zombie",
  Junk = "Junk"
}
BuffType = {
  Halo = 0,
  Property = 1,
  Dot = 2,
  Hot = 3,
  Stun = 4,
  Imprison = 5,
  BeTaunt = 7,
  Shield = 9,
  SpecialMove = 10,
  ModelScale = 14,
  SplashDamage = 16,
  ReplaceBullet = 18,
  Transformer = 21,
  Charge = 22,
  Dive = 23,
  AttackedTriggerBuff = 26,
  Tornado = 31,
  Frozen = 32,
  DotDamage = 37,
  SurfingMagnet = 40,
  SurfingJetPack = 41,
  SurfingDoubleCoin = 42,
  SurfingShield = 43,
  SurfingMorph = 44,
  SurfingQuatraCoin = 45,
  GhostSpeedUp = 46,
  GhostNitrogen = 47,
  SingleSkillDamageLimit = 100,
  AbsorbItem = 101,
  NewHot = 102,
  ChangeMaxBlood = 103
}
BuffSubType = {
  Default = 0,
  ReduceDamage = 1,
  ShieldFromCasterHp = 2,
  ShieldFromValue = 3,
  ReplaceBulletForNormalAttack = 6,
  ReplaceBulletForUltimate = 7,
  ReplaceBulletForAll = 8
}
BarrageState = {
  Push = 1,
  PreExit = 2,
  Exit = 3,
  Lose = 4
}
SkirmishStage = {
  Load = 1,
  Opening = 2,
  Fight = 3,
  End = 4
}
FakePVPStage = {
  Lineup = 0,
  Load = 1,
  Opening = 2,
  Fight = 3,
  End = 4
}
ActionPhase = {
  Prepare = 0,
  Cast = 1,
  Damage = 2,
  Buff = 3,
  Dot = 4,
  FIRE_BULLET = 5,
  SPLASH_DAMAGE = 6,
  REMOVE_BUFF = 7,
  SummonPet = 8,
  SkillCast = 11,
  ShieldDamage = 12,
  Bounce = 14,
  BeforeHeroAwakenSkillCast = 16
}
SkirmishMoveState = {Stay = 1, Path = 2}
SkirmishFireState = {
  TeamMove = 1,
  Aim = 2,
  Casting = 3,
  Idle = 4,
  Die = 5,
  Auto = 6,
  Born = 7
}
BattleMoveTimelineState = {End = 1, TryNext = 2}
SquadState = {
  Stay = 1,
  Move = 2,
  Exit = 3
}
MemberCommand = {
  Stay = 1,
  Move = 2,
  AutoAttack = 3,
  StationAttack = 4,
  Ultimate = 5
}
MemberState = {
  Stay = 1,
  Move = 2,
  Dead = 3,
  Born = 4
}
AttackState = {
  AutoAttack = 1,
  StationAttack = 2,
  HoldFire = 3,
  Ultimate = 4
}
ZombieState = {
  Born = 0,
  Idle = 1,
  Run = 2,
  Attack = 3,
  Die = 4,
  HardControl = 5,
  Dive = 6
}
HardControlType = {
  Stiff = 1,
  Imprison = 2,
  Hurt = 3,
  Stun = 4,
  Charge = 5,
  Tornado = 6,
  Frozen = 7,
  HitBack = 8,
  TornadoDown = 9
}
PVEHardControlPriority = {
  HardControlType.Tornado,
  HardControlType.TornadoDown,
  HardControlType.HitBack,
  HardControlType.Frozen,
  HardControlType.Stiff,
  HardControlType.Imprison
}
DamageTextType = {
  HeroNormalAttack = 1,
  HeroUltimate = 2,
  ZombieNormalAttack = 3,
  ZombieUltimate = 4,
  ReduceDamageBuff = 5,
  Miss = 6,
  GetBuff = 7,
  Drone = 8,
  Dot = 9,
  Splash = 10,
  DisperseEffect = 11,
  TriggerItem = 12,
  ShieldDamage = 100
}
ExDamageType = {attackPercent = 1, hpPercent = 2}
EffectObjType = {Normal = 0, Sprite = 1}
SkillCastState = {
  Cooldown = 0,
  Ready = 1,
  FrontSwing = 2,
  Chant = 3,
  BackSwing = 4
}
SoundLimitType = {
  UnitDeath = 1,
  BulletHit = 2,
  BulletCreate = 3,
  TroopAttackCity = 4,
  TroopMarching = 5,
  BossWarning = 6,
  SkillFire = 7,
  MAX = 7
}
SoundIdToLimitType = {
  [10030] = SoundLimitType.TroopAttackCity,
  [10031] = SoundLimitType.TroopMarching
}
SoundByNameLimitType = {SkillFire = 1}
LWSoundType = {
  Normal = 0,
  BGM = 1,
  Eff = 2,
  AMB = 3,
  Env = 4
}
DamageType = {
  None = -1,
  Physics = 0,
  Magic = 1,
  RealDamage = 10001,
  ShieldDamage = 10002
}
ResPointType = {Normal = 0, Alliance = 1}
PuzzleTaskState = {
  PuzzleTaskState_UnComplete = 0,
  PuzzleTaskState_Complete = 1,
  PuzzleTaskState_Reward_Get = 2
}
PuzzleStageRewardState = {PuzzleStageRewardState_UnGet = 0, PuzzleStageRewardState_Get = 1}
LandLockCondition = {
  Unknown = 0,
  Ok = 1,
  NeedResource = 2,
  NeedItem = 3,
  NeedResourceItem = 4,
  NeedBuilding = 5,
  NeedChapter = 6,
  NeedPrior = 7,
  ToPay = 8,
  ToPve = 9,
  ToFinish = 10
}
PveBuffType = {
  No = 0,
  Speed = 1,
  AttackAnim = 2,
  WeaponBigger = 3,
  Player = 4,
  AttackQuick = 5,
  AddAttack = 6,
  Stun = 7
}
AllianceFlagBgColor = {
  Color.New(0.4, 0.76, 0.99),
  Color.New(0.21, 0.86, 0.89),
  Color.New(0.65, 0.89, 0.23),
  Color.New(1, 0.78, 0),
  Color.New(0.99, 0.52, 0.15),
  Color.New(0.89, 0.35, 0.06),
  Color.New(0.99, 0.37, 0.78),
  Color.New(0.88, 0.42, 1),
  Color.New(0.56, 0.47, 0.9)
}
AllianceFlagFgColor = {
  Color.New(0.9, 0.95, 1),
  Color.New(0.9, 0.99, 0.9),
  Color.New(0.99, 0.98, 0.89),
  Color.New(1, 0.98, 0.87),
  Color.New(0.99, 0.93, 0.89),
  Color.New(0.99, 0.87, 0.87),
  Color.New(0.99, 0.9, 0.97),
  Color.New(0.9, 0.98, 0.9),
  Color.New(0.91, 0.94, 1)
}
PveBuffTimeType = {Time = 1, Always = 2}
CarriageState = {
  PullIn = 1,
  Hide = 2,
  PullOut = 3,
  Straight = 4,
  Turn = 5
}
TrainState = {
  BeforeDeparture = 1,
  Travelling = 2,
  ArrivedFinal = 3
}
RailwayStationState = {
  Disable = 1,
  WarmUp = 2,
  Fog = 3,
  FirstReward = 4,
  CanRob = 10,
  CannotRob = 11
}
TruckStationState = {
  Lock = 0,
  Ready = 1,
  Exhausted = 2,
  Travelling = 3,
  Reward = 4
}
TrainPlatformState = {
  NoTrain = 0,
  TrainNoDriver = 1,
  TrainWithDriver = 2,
  TrainWithPassenger = 3
}
TrainTab = {
  Enemy = 1,
  Mine = 2,
  Ally = 3,
  MAX = 3
}
TrainType = {Truck = 1, Train = 2}
TrainVipType = {isLucky = 0, isBigBro = 1}
TrainUIOpenType = {Prepare = 1, Departure = 2}
TrainPreparePage = {Driver = 1, Passenger = 2}
TrainStationType = {Main = 1, City = 2}
TrainKeyFrameType = {
  PullIn = 1,
  PullOut = 2,
  TurnIn = 3,
  TurnOut = 4
}
LandLockBubbleState = {
  None = "None",
  Hide = "Hide",
  Locked = "Locked",
  Unlocked = "Unlocked",
  Pay = "Pay",
  Pve = "Pve"
}
LandLockBubbleVisibleType = {Hide = 1, Show = 2}
LandLockLevelShowCarryType = {Show = 0, No = 1}
LandLockRewardType = {
  None = 0,
  Chest = 1,
  CallChest = 2,
  CallSoldier = 3,
  Call = 4
}
UIPveSelectBuffOrder = {
  PveBuffType.AddAttack,
  PveBuffType.Speed,
  PveBuffType.Player
}
PveResultShowType = {Normal = 0, Pass = 1}
LotteryTimeType = {LotteryTimeType_Expert = "3", LotteryTimeType_Ten = "10"}
LotteryType = {LotteryType_Normal = 1, LotteryType_Season = 2}
SaveBobSceneState = {
  NoSave = 1,
  PlayTimeLine = 2,
  Saved = 3
}
PveHasUseBattleHeroType = {
  Any = 1,
  HeroId = 2,
  HeroQuality = 3,
  HeroIdWithoutMax = 4,
  HeroQualityWithoutMax = 5
}
ExpSource = {
  GM = 0,
  Farming = 1,
  Factory = 2,
  Building = 3,
  Science = 4,
  Army = 5,
  Order = 6,
  Reward = 7,
  Pasture = 8,
  KillMonster = 9
}
UIGuideMoveArrowNeedWaitType = {No = 0, Yes = 1}
BuildQueueState = {
  DEFAULT = 0,
  TRAINING = 1,
  CURE_ARMY = 2,
  RESEARCH = 3,
  FARMING = 4,
  FEEDING = 5,
  FACTORY = 6,
  STORAGE_SHOP = 7,
  UPGRADE = 16,
  REBIRTH_ARMY = 17,
  Ruins = 128
}
ConsumeType = {
  ConsumeType_Nil = 0,
  ConsumeType_Resource_Item = 1,
  ConsumeType_Resource = 2,
  ConsumeType_Item = 3
}
HeroEntrustState = {No = 0, Yes = 1}
ResLackType = {
  Res = 1,
  Item = 2,
  ResItem = 3,
  HeroExp = 4,
  Percent = 5,
  DesertNum = 6,
  SkyBattleRes = 7
}
ResLackGoToType = {
  LoesCamp = 9,
  ResourceBagUse = 11,
  ResourceBagBuy = 12,
  BuyGiftShop = 27,
  LockedLandLockUncheck = 40,
  BuildBuyItem = 41,
  UsePaperItem = 42,
  BuyGiftNew = 44,
  Explore = 47,
  BuyPveStamina = 48,
  UseBuildGoods = 52,
  GoActWin = 78,
  SeasonPass = 81,
  SeasonWeek = 82,
  BuyGiftResNew = 1001
}
ResLackTypeNew = {
  Equip = 1,
  MasteryPoint = 2,
  TitleSkin = 3
}
NpcTalkType = {
  Left = 1,
  Right = 2,
  HeroEntrust = 3
}
HeroEntrustNeedType = {
  ResourceItem = 1,
  Resource = 2,
  Goods = 3
}
MarchAutoBackType = {NoBack = 0, Back = 1}
HaveAllianceType = {Yes = 1, No = 2}
NpcBubbleStayType = {
  Trigger = 1,
  All = 2,
  Time = 3
}
AdventureState = {
  Ready = 1,
  Playing = 2,
  Won = 3,
  Lost = 4
}
AdventureType = {
  Default = 0,
  Monster = 1,
  Buff = 2,
  Reward = 3,
  Box = 4
}
AdventureRaidState = {
  Ready = 1,
  NeedLevel = 2,
  Started = 3,
  LevelMaxed = 4
}
PveLoadingAnimType = {
  Black = 1,
  Yellow = 2,
  Circle = 3
}
BattleBuffGroup = {Default = 0, Adventure = 1}
BattleBuffType = {
  Effect = 0,
  Skill = 1,
  AdventureHp = 2,
  DisableHero = 3,
  HireHero = 4
}
BattleBuffTimeType = {
  Normal = 0,
  Battle = 1,
  Time = 2
}
HeroAdvanceConsumeType = {ConsumeType_Same_Hero = 1, ConsumeType_Same_Camp = 2}
ResourceTypePickUpEffectName = {}
ResourceTypePickUpEffectName[ResourceType.Electricity] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shandian.prefab"
ResourceTypePickUpEffectName[ResourceType.Metal] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shuijing.prefab"
ResourceTypePickUpEffectName[ResourceType.Oil] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_wasi.prefab"
ResourceTypePickUpEffectName[ResourceType.Water] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_water.prefab"
ResourceTypePickUpEffectName[ResourceType.Food] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_jinbi.prefab"
SuccessMarchFlagType = {No = 0, Yes = 1}
ShowFakePlayerFlagType = {Show = 1, Hide = 2}
PveBuildTriggerDirection = {
  Bottom = 1,
  Left = 2,
  Top = 3,
  Right = 4
}
ShowWorldCollectPointType = {Show = 1, Hide = 2}
SetAttackGuideFlag = {NoBackAndWaitResult = 1, WaitResult = 2}
BubbleShowType = {Show = 1, Hide = 2}
AccountViewType = {Bind = 1, Question = 2}
TankShowType = {Show = 1, Back = 2}
ShowLoadMaskType = {Show = 1, Hide = 2}
WeekType = {
  "372307",
  "372308",
  "372309",
  "372310",
  "372311",
  "372312",
  "372313"
}
NoticeEquipDelays = {
  [UIWindowNames.UIRecruitLotteryTip] = 3,
  [UIWindowNames.UISoliderGetTip] = 3,
  [UIWindowNames.UIGarageRefit] = 3
}
ShaderEffectType = {ShakeWhite = 1}
GuideTalkDialogType = {AllianceName = 1}
ShowLandLockType = {Show = 1, Hide = 2}
PveTriggerVisibleType = {Show = 1, Hide = 2}
GuideSetNormalVisible = {Show = 1, Hide = 2}
NewMarchType = {
  DEFAULT = -1,
  NORMAL = 0,
  ASSEMBLY_MARCH = 1,
  MONSTER = 2,
  BOSS = 3,
  SCOUT = 4,
  EXPLORE = 5,
  RESOURCE_HELP = 6,
  GOLLOES_EXPLORE = 7,
  GOLLOES_TRADE = 8,
  ACT_BOSS = 9,
  PUZZLE_BOSS = 10,
  DIRECT_MOVE_MARCH = 11,
  CHALLENGE_BOSS = 12,
  TRAIN = 14,
  RUNNING_BOSS = 15,
  ALL_OUT = 16,
  ZOMBIE_RETREAT = 17,
  TREAT_VIRUS = 18,
  ZOMBIE_RUSH = 19,
  DARK_KNIGHT_CITY = 20,
  ACT_BERSERK_BOSS = 21,
  BEHEMOTH_BOSS = 22,
  BEHEMOTN_SKILL = 23,
  LOTTO_RECEIVE = 24,
  MUMMY = 25,
  ZONE_MOBILIZATION_BOSS = 26,
  ZONE_MOBILIZATION_DONATE = 27,
  RUNNING_MUMMY = 28,
  SANDFISH = 29,
  FAKE_ATTACK = 30,
  CAMEL = 31,
  VALENTINE = 32,
  DARKNESS_MONSTER = 33,
  ALLIANCE_BOSS_SAND = 34,
  CAR_REBUILD = 35,
  DETECT_ZOMBIE_BUS_TRAIN = 36,
  POWER_WORKER = 37,
  MONSTER_CHALLENGE_DONATE = 38,
  BLOODY_QUEEN = 39,
  FLOWER_TRAIN = 43,
  CROSS_NORMAL = 40,
  CROSS_ASSEMBLY_MARCH = 41,
  ZONE_TRAIN = 42,
  CROSS_SCOUT = 44,
  CROCODILE = 45
}
CityPeopleAndCarVisibleType = {AllShow = 1, AllHide = 2}
TriggerNeedType = {
  Resource = 1,
  ResourceItem = 2,
  Goods = 3
}
AttackAnimDirection = {
  LeftToRight = 1,
  RightToLeft = 2,
  Circle = 3
}
PveAtomType = {Tree = 0, Stone = 1}
LevelExploreState = {
  Hide = 1,
  Doing = 2,
  Locked = 3,
  Finish = 4,
  Sweep = 5
}
LevelExploreSpecial = {HeroExp = "exp", Activity = "activity"}
PveShowBloodType = {No = 0, Show = 1}
BuildMaxNumType = {
  Cur = 1,
  Guide = 2,
  Quest = 3,
  Chapter = 4
}
IsShowDMAType = {NotShow = 1, Show = 2}
PrivacyKey = {
  V1 = "PrivacyConfirm_0305",
  V2 = "PrivacyConfirm_0306",
  IOSV2 = "PrivacyConfirm_0306_ios",
  V3 = "PrivacyConfirm_0307"
}
PveShowSkill = {Show = 0, No = 1}
FactoryDataType = {FactoryDataType_Normal = 0, FactoryDataType_PVE = 1}
FactoryProductType = {
  FactoryProductType_Resource_Item = 0,
  FactoryProductType_Item = 1,
  FactoryProductType_Resource = 2,
  FactoryProductType_Score = 3
}
HeroAdvanceGuideSignalType = {
  Enter = 1,
  ShowMainHeroBlack = 2,
  HideMainHeroBlack = 3,
  ShowSubHeroBlack = 4,
  HideSubHeroBlack = 5,
  ShowHeroStarUpBlack = 6,
  HideHeroStarUpBlack = 7
}
FogType = {Black = 0, White = 1}
QuestBubbleType = {
  None = 0,
  World = 1,
  Pve = 2
}
ActMonsterTowerDiff = {
  [1] = "UIMonsterTower_extent1",
  [2] = "UIMonsterTower_extent2",
  [3] = "UIMonsterTower_extent3",
  [4] = "UIMonsterTower_extent4",
  [5] = "UIMonsterTower_extent5"
}
RocketStatus = {RocketStatus_Normal = 0, RocketStatus_Preview = 1}
ForceChangeScene = {City = 0, World = 1}
HeatSourceType = {
  Const = 0,
  City = 1,
  Stronghold = 2,
  PersonalStove = 3,
  AllianceStove = 4,
  WarFlag = 5,
  VictoryTower = 6
}
HeatSourceState = {
  None = -1,
  Close = 0,
  Active = 1,
  Overload = 2
}
PveSelectionType = {Trigger = 1, DropReward = 2}
CommonCostNeedType = {
  Resource = 1,
  ResourceItem = 2,
  Goods = 3,
  Build = 4,
  Science = 5,
  RefreshAll = 100
}
ProductResourceItemBuildingTypes = {
  BuildingTypes.FUN_BUILD_OUT_WOOD,
  BuildingTypes.FUN_BUILD_OUT_STONE
}
UIBuildDetailTabType = {Build = 1, Detail = 2}
LodType = {
  None = 0,
  Custom = 1,
  MainSelf = 1001,
  MainAlly = 1002,
  MainOther = 1003,
  WormHoleSelf = 1004,
  WormHoleAlly = 1005,
  WormHoleOther = 1006,
  Monster = 2001,
  Resource = 2002,
  Explore = 2003,
  Sample = 2004,
  Garbage = 2005,
  MonsterReward = 2006,
  RadarPve = 2007,
  WorldBoss = 2008,
  TroopSelf = 3001,
  TroopAlly = 3002,
  TroopOther = 3003,
  Ground = 4001,
  Zone = 4002,
  CityLabel = 5001,
  WorldCity = 5002,
  Desert = 5003,
  WorldAllianceBuild = 5004,
  WorldAllianceFlag = 5005,
  NPCCity = 5006,
  MainEnemy = 5007,
  WormHoleEnemy = 5008
}
BuildBanMoveType = {Yes = 0, No = 1}
RoadState = {Normal = 0, Updating = 1}
RoadPathType = {
  NORMAL = 0,
  VIADUCT = 1,
  MAIN_ROAD = 2
}
RoadDirectType = {
  None = -1,
  HORIZONTAL = 0,
  PORTRAIT = 1,
  WEST_TO_EAST = 2,
  EAST_TO_WEST = 3,
  NORTH_TO_SOUTH = 4,
  SOUTH_TO_NORTH = 5
}
DomeRange = {
  Zero = 0,
  Min = 3,
  Middle = 1,
  Max = 2
}
DomeLevel = {
  [DomeRange.Zero] = 0,
  [DomeRange.Min] = 1,
  [DomeRange.Middle] = 2,
  [DomeRange.Max] = 3
}
DomeRadius = {
  [DomeRange.Zero] = 0,
  [DomeRange.Min] = 18,
  [DomeRange.Middle] = 18,
  [DomeRange.Max] = 30
}
LandLockDomeExRadius = {
  [DomeRange.Zero] = 0,
  [DomeRange.Min] = -1.2,
  [DomeRange.Middle] = -1.2,
  [DomeRange.Max] = -1.0
}
ResourceItem = {Wood = 10000, Stone = 10001}
UIHeroStarProgressType = {UIHeroStarProgressType_Slider = 1, UIHeroStarProgressType_Block = 2}
GuideSceneType = {
  City = 1,
  World = 2,
  Pve = 3
}
GuideUIBuildListSpecialType = {OpenUI = 1, Move = 2}
GuideMaskType = {
  UIPveMainResource = 1,
  UIPveMainStaminaSlider = 2,
  UIPveMainBag = 3
}
GuideMaskTypeSignalType = {
  UIPveMainResourceShow = 101,
  UIPveMainResourceHide = 102,
  UIPveMainStaminaSliderShow = 104,
  UIPveMainStaminaSliderHide = 105,
  UIPveMainBagShow = 106,
  UIPveMainBagHide = 107
}
UIMainTopBtnType = {
  Stamina = 1,
  Goods = 2,
  Gold = 3
}
GuideOpenPanelType = {Common = 1}
PvePowerLackType = {
  None = 0,
  Power = 1,
  Army = 2,
  Hero = 3,
  Fail = 4
}
PvePowerLackTipType = {
  HeroExpBook = 53,
  HeroExpMonster = 54,
  HeroUpgradeStar = 55,
  HeroUpgradeSkill = 56,
  TrainUnit = 57,
  HeroHigherLevel = 58,
  HeroHigherPower = 59,
  HeroBeyond = 60,
  FirstPay = 61,
  MainQuest = 62,
  HeroExpOrBeyond = -53
}
PvePowerLackShowTips = {
  [PvePowerLackType.Power] = {
    PvePowerLackTipType.HeroExpBook,
    PvePowerLackTipType.HeroExpMonster,
    PvePowerLackTipType.HeroUpgradeStar,
    PvePowerLackTipType.HeroUpgradeSkill,
    PvePowerLackTipType.TrainUnit,
    PvePowerLackTipType.HeroHigherPower,
    PvePowerLackTipType.HeroBeyond,
    PvePowerLackTipType.FirstPay
  },
  [PvePowerLackType.Army] = {
    PvePowerLackTipType.TrainUnit
  },
  [PvePowerLackType.Hero] = {
    PvePowerLackTipType.HeroExpBook,
    PvePowerLackTipType.HeroExpMonster,
    PvePowerLackTipType.HeroHigherLevel,
    PvePowerLackTipType.HeroBeyond
  },
  [PvePowerLackType.Fail] = {
    PvePowerLackTipType.HeroExpOrBeyond,
    PvePowerLackTipType.HeroUpgradeStar,
    PvePowerLackTipType.TrainUnit,
    PvePowerLackTipType.FirstPay
  }
}
GuideEndShowQuestType = {Show = 0, No = 1}
ShowWorldArrowType = {FarmGet = 1, FarmFree = 2}
BuildListBuffType = {
  BuildListBuffType_SpeedUp = 1,
  BuildListBuffType_Free = 2,
  BuildListBuffType_Max = 3
}
HeroLackTipsType = {
  HeroLackTipsType_Recruit = 1,
  HeroLackTipsType_Debris_Exchange = 2,
  HeroLackTipsType_First_Charge = 3,
  HeroLackTipsType_Promotion_Gift_Bag = 4,
  HeroLackTipsType_Recharge_Gift_Bag = 5,
  HeroLackTipsType_Activity = 6,
  HeroLackTipsType_Detect_Event = 7,
  HeroLackTipsType_Vip = 8
}
HeroEffectDefine = {
  EquipHealthPoint = 50005,
  HealthPoint = 50006,
  PhysicalAttack = 50007,
  EquipPhysicalAttack = 50008,
  PhysicalDefense = 50009,
  EquipPhysicalDefense = 50010,
  CriticalRate_Result = 50011,
  CriticalDamage_Result = 50012,
  ChanceToHit_Result = 50013,
  HealPoint_Result = 50014,
  PhysicalAttack_Result = 50015,
  Hero_ATK_Result = 50016,
  PhysicalDefense_Result = 50017,
  Hero_DEF_Result = 50018,
  Hero_HP_Result = 50019,
  Equip_HP_Result = 50020,
  Equip_ATK_Result = 50021,
  Equip_DEF_Result = 50022,
  PhysicalDamageReduce_Result = 50030,
  MagicDamageReduce_Result = 50031,
  PhysicalDamageAdd_Result = 50032,
  MagicDamageAdd_Result = 50033,
  TankBuildingLife = 50039,
  TankBuildingAttack = 50041,
  TankBuildingDefence = 50043,
  TankBuildingLastLife = 50040,
  TankBuildingLastAttack = 50042,
  TankBuildingLastDefence = 50044,
  MissileBuildingLife = 50046,
  MissileBuildingAttack = 50048,
  MissileBuildingDefence = 50050,
  MissileBuildingLastLife = 50047,
  MissileBuildingLastAttack = 50049,
  MissileBuildingLastDefence = 50051,
  AircraftBuildingLife = 50052,
  AircraftBuildingAttack = 50054,
  AircraftBuildingDefence = 50056,
  AircraftBuildingLastLife = 50053,
  AircraftBuildingLastAttack = 50055,
  AircraftBuildingLastDefence = 50057,
  Honor_HP = 50063,
  Honor_HP_Result = 50064,
  AllBuildingLastSoldierCapacity = 50071,
  TankBuildingLastSoldierCapacity = 50072,
  MissileBuildingLastSoldierCapacity = 50073,
  AircraftBuildingLastSoldierCapacity = 50074,
  HeroSoldierCapacity = 50079,
  HeroSoldierMorale = 50080,
  TacticalWeaponHp = 50081,
  TacticalWeaponAtk = 50082,
  TacticalWeaponDef = 50083,
  TacticalWeaponHp_Result = 50084,
  TacticalWeaponAtk_Result = 50085,
  TacticalWeaponDef_Result = 50086,
  TacticalWeaponAll_Ratio = 50090,
  TacticalWeaponHp_Ratio = 50091,
  TacticalWeaponAtk_Ratio = 50092,
  TacticalWeaponDef_Ratio = 50093,
  TacticalWeaponDisplayHp = 50098,
  TacticalWeaponDisplayAtk = 50099,
  TacticalWeaponDisplayDef = 50100,
  TacticalWeaponHp_Battle_Add = 50098,
  TacticalWeaponAtk_Battle_Add = 50099,
  TacticalWeaponDef_Battle_Add = 50100,
  UniqueWeaponHp = 51000,
  UniqueWeaponHp_result = 51001,
  UniqueWeaponHp_UW_Unit_Self = 51002,
  UniqueWeaponHp_UW_Unit_All = 51003,
  UniqueWeaponAtk = 51050,
  UniqueWeaponAtk_result = 51051,
  UniqueWeaponAtk_UW_Unit_Self = 51052,
  UniqueWeaponAtk_UW_Unit_All = 51053,
  UniqueWeaponDef = 51100,
  UniqueWeaponDef_result = 51101,
  UniqueWeaponDef_UW_Unit_Self = 51102,
  UniqueWeaponDef_UW_Unit_All = 51103,
  DominatorAffordHeroHp = 52005,
  DominatorAffordHeroAtk = 52015,
  DominatorAffordHeroDef = 52025,
  ProductivityRate = 71000,
  CommercialRate = 71001,
  AgilityRate = 71002,
  ConstitutionAddRate = 75000,
  HpAddRate = 75050,
  BuffHpAddRate = 75051,
  TankHeroHpAddRate = 75053,
  MissileHeroHpAddRate = 75054,
  AircraftHeroHpAddRate = 75055,
  LineupHpAddRate = 75060,
  StrengthAllAttackAddRate = 75100,
  AllAttackAddRate = 75150,
  BuffAttackAddRate = 75151,
  TankAttackAddRate = 75153,
  MissileAttackAddRate = 75154,
  AircraftAttackAddRate = 75155,
  LineupAttackAddRate = 75160,
  BuffAttackReduceRate = 75200,
  AllDefenseAddRate = 75250,
  BuffDefenseAddRate = 75251,
  TankDefenseAddRate = 75253,
  MissileDefenseAddRate = 75254,
  AircraftDefenseAddRate = 75255,
  LineupDefenseAddRate = 75260,
  BuffDefenseReduceRate = 75300,
  AllCriticalDamageAddRate = 75400,
  AllHitChanceAddRate = 75500,
  AllAttackSpeedAddRate = 75650,
  AttackAgainstZombieAddRate = 75953,
  UnlockEquipSlotLimit = 90002,
  UnlockStrengthenWeaponLimit = 90003,
  AllCriticalChanceAddRate = 75300,
  AllCdReduceRate = 75750,
  AllHealAddRate = 75800,
  AllBeHealedAddRate = 75850,
  SkillAllDamageAddRateSingle = 75949,
  SkillAllDamageAddRate = 75950,
  SkillPhysicalDamageAddRate = 75951,
  SkillMagicDamageAddRate = 75952,
  TankDamageAddRate = 75957,
  MissileDamageAddRate = 75958,
  AircraftDamageAddRate = 75959,
  SkillDamageReduceRate = 76000,
  SkillPhysicalDamageReduceRate = 76001,
  SkillMagicDamageReduceRate = 76002,
  SkillTakenDamageReduceRate = 76050,
  SkillPhysicalTakenDamageReduceRate = 76051,
  SkillMagicTakenDamageReduceRate = 76052,
  DefenceAgainstZombieReduceRate = 76053,
  EquipDamageReduceRateBase = 76057,
  EquipDamageReduceRatePhysics = 76058,
  EquipDamageReduceRateMagic = 76059,
  SkillTakenDamageAddRate = 76100,
  SkillPhysicalTakenDamageAddRate = 76101,
  SkillMagicTakenDamageAddRate = 76102,
  BattleHeroMoveSpeed = 80000,
  SuperArmor = 80001,
  HeroSkillMaxLevelAdd = 90027,
  HeroPower = 100000,
  HeroPowerLevel = 100001,
  HeroPowerSkill = 100002,
  HeroPowerEquip = 100003,
  HeroUniqueWeaponPower = 100006,
  TankLevelSoldierCapacity = 76201,
  MissileLevelSoldierCapacity = 76202,
  AircraftLevelSoldierCapacity = 76203,
  DominatorBaseHp = 52000,
  DominatorNormalTrainGroupHp = 52001,
  DominatorRankHp = 52002,
  DominatorMainTrainGroupHp = 52003,
  DominatorMainTrainGroupHpAddRate = 52006,
  DominatorRankHpAddRate = 52007,
  DominatorTacticalWeaponFinalHp = 50084,
  DominatorBuildHp = 50060,
  DominatorFinalHp = 52004,
  DominatorBaseAttack = 52010,
  DominatorNormalTrainGroupAttack = 52011,
  DominatorRankAttack = 52012,
  DominatorMainTrainGroupAttack = 52013,
  DominatorMainTrainGroupAttackAddRate = 52016,
  DominatorRankAttackAddRate = 52017,
  DominatorTacticalWeaponFinalAttack = 50085,
  DominatorBuildAttack = 50061,
  DominatorFinalAttack = 52014,
  DominatorBaseDefence = 52020,
  DominatorNormalTrainGroupDefence = 52021,
  DominatorRankDefence = 52022,
  DominatorMainTrainGroupDefence = 52023,
  DominatorMainTrainGroupDefenceAddRate = 52026,
  DominatorRankDefenceAddRate = 52027,
  DominatorTacticalWeaponFinalDefence = 50086,
  DominatorBuildDefence = 50062,
  DominatorFinalDefence = 52024,
  DominatorMainTrainGroupSoldierCapacity = 80009
}
ScienceEffectID = {
  TacticalSkillStarUp = 50242,
  TacticalWeaponLevelMaxLimit = 50243,
  ResourceFoodProductAddRate = 50102,
  ResourceMetalProductAddRate = 50103,
  ResourceWoodProductAddRate = 50104,
  ResourceExtraProductAddRate = 50148
}
WorkerEffectDefine = {
  TrainLimitRate = 50105,
  TrainCostRate = 50106,
  TrainTimeRate = 50133,
  SoldierCapacityRate = 50107,
  TrainLimitNum = 50125
}
HeroDetailTabType = {
  Weapon = 1,
  Profile = 2,
  Upgrade = 3,
  Skill = 4
}
HeroicForceType = {
  Life = 1,
  Attack = 2,
  Defence = 3,
  SoldierCapacity = 4
}
ProductLineState = {
  None = 0,
  Normal = 1,
  Full = 2,
  LackRes = 3,
  LackResItem = 4,
  NoHero = 5
}
ProductLineBuilds = {
  BuildingTypes.LW_BUILD_FARMLAND,
  BuildingTypes.LW_BUILD_QUARRY,
  BuildingTypes.LW_BUILD_GOLD_MILL,
  BuildingTypes.LW_BUILD_SMELTERY,
  BuildingTypes.LW_BUILD_TRAINING_CENTER,
  BuildingTypes.LW_BUILD_MATERIALS_WORKERSHOP,
  BuildingTypes.LW_BUILD_SQUAD_EQUIP_FACTORY,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_5,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_5,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_1,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_2,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_3,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_4,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY1,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY2,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY3,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY4,
  BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD,
  BuildingTypes.LW_BUILD_PETROLEUM,
  BuildingTypes.LW_BUILD_TACTICAL_COMPONENT,
  BuildingTypes.LW_BUILD_DOMINATOR_TRAIN
}
BuildDisPatchingHeroTrenchState = {
  HERO = 1,
  ADD = 2,
  LOCK = 3
}
HeroSkillEffectType = {
  DamageSkill = 1,
  BuffSkill = 2,
  PropertySkill = 3
}
HeroQualityType = {
  Normal = 1,
  Excellent = 2,
  Outstanding = 3,
  Genius = 4,
  Legendary = 5
}
WorkerQualityType = {
  Normal = 1,
  Excellent = 2,
  Outstanding = 3,
  Genius = 4,
  Legendary = 5
}
WorkerFilterQualityType = {
  All = 0,
  Legendary = 1,
  Genius = 2,
  Other = 3
}
WorkerFilterStateType = {
  All = 0,
  WORKER = 1,
  RESIDENTA = 2
}
WorkerFilterOwnedType = {
  All = 0,
  Owned = 1,
  UnOwned = 2
}
WorkerFilterCanUpType = {All = 0, CanUp = 1}
QualityBgName = {
  [1] = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_12",
  [2] = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_10",
  [3] = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_8",
  [4] = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_6",
  [5] = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_4"
}
WorkerDrawCardQualityBgName = {
  [1] = "Assets/Main/Sprites/UI/UIHeroRecruit/lyp_xingcunzhe_huise",
  [2] = "Assets/Main/Sprites/UI/UIHeroRecruit/lyp_xingcunzhe_lvse",
  [3] = "Assets/Main/Sprites/UI/UIHeroRecruit/lyp_xingcunzhe_lanse",
  [4] = "Assets/Main/Sprites/UI/UIHeroRecruit/lyp_xingcunzhe_zise",
  [5] = "Assets/Main/Sprites/UI/UIHeroRecruit/lyp_xingcunzhe_chengse"
}
VisitorType = {
  MERCHANT = 1,
  GIFT = 2,
  RECRUITMENT = 3,
  BATTLE = 4,
  WORKER_LOTTERY = 5,
  NOTIFY = 6,
  OPEN_PANEL = 7,
  ALLIANCE_INVITE_MOVE_CITY = 8,
  DOMINATOR = 9,
  SeasonDayGift = 10,
  VisitorActivity = 11,
  ALLIANCE_INVITE = 12,
  DOMINATOR_COCKATRICE = 13,
  AllianceCongratulation = 14,
  AD_REMINDER = 15,
  SKY_BATTLE = 16,
  PLANE_FEATURE = 17,
  S0_ALLIANCE_BOSS = 18,
  SURVIVOR_PACK_GiFT = 19,
  ProtectCoverVisitor = 20
}
OptionType = {
  Normal = 1,
  One = 2,
  Two = 3
}
EnterHeroSquadPanelWay = {
  ParkingLotBuilding = 1,
  ToMarch = 2,
  MainUI = 3,
  Gate = 4,
  Marching = 5,
  TruckDeparture = 6,
  ExpiredMonthlyCard = 7,
  PVE = 10,
  PveEnterBattle = 12,
  DetectEventPVE = 14,
  TowerupJeepAdventure = 15,
  TruckRob = 16,
  PVPArena = 17,
  PVPArenaDefence = 18,
  Arena3V3Attack = 19,
  Arena3V3Defence = 20,
  ActivityArena = 21,
  ActivityArenaDefence = 22,
  ActivityArenaV2 = 23,
  ActivityArenaV2Defence = 24,
  TrailTower = 25,
  ChampionDuel = 26,
  NewPeakArena = 27,
  NewPeakArenaDefence = 28,
  KOFAttack = 29,
  KOFDefence = 30,
  BeginnerEvent = 31,
  DetectZombieBusTrain = 32,
  StageFeatureBattle = 34,
  T11IdleGameBattleEvent = 35,
  HSRRob = 36,
  NewGaleArena = 37,
  NewGaleArenaDefence = 38,
  HSRDeparture = 39,
  HeroTryOut = 40,
  SeasonTower = 41
}
FormationDataType = {
  None = 0,
  ArmyFormation = 1,
  Formation3V3Atk = 2,
  Formation3V3Def = 3,
  TruckDeparture = 4,
  ChampionDuel = 5,
  PVE = 6,
  TrailTower = 7,
  TruckRob = 8,
  Gate = 9,
  KOFDefence = 10,
  KOFAttack = 11
}
FormationType = {
  NORMAL = 0,
  DEFEND = 1,
  SCOUT = 2,
  RESOURCE_HELP = 3,
  GOLLOES = 4,
  ELITE = 5,
  TEMPLATE = 6,
  BATTLEFIELD_NORMAL = 7,
  POWER_WORKER = 8
}
Type3v3 = {Arena = 1, Train = 2}
TypeKOF = {Train = 1, NewPeakArena = 2}
HeroIconType = {
  half_portrait = 1,
  small_icon = 2,
  pose_icon_path = 3,
  spine_path = 4,
  recruit_preview_icon = 5,
  pvp_hero_awaken_icon = 6,
  spine_background = 7
}
HeroSpineType = {Normal = 1, AwakenUpgrade = 2}
HeroModelType = {
  Battle = 1,
  City = 2,
  Queue = 3,
  PBR = 4,
  World = 5
}
HeroModelSourceType = {
  Hero = 1,
  UniqueWeapon = 2,
  HeroAwaken = 3,
  Rank = 4
}
HeroModelSourceTypeListInRemotePack = {
  [HeroModelSourceType.UniqueWeapon] = 1,
  [HeroModelSourceType.HeroAwaken] = 2
}
HeroModelTypeName = {
  [HeroModelType.Battle] = "model_path",
  [HeroModelType.City] = "city_model_path",
  [HeroModelType.Queue] = "queue_model_path",
  [HeroModelType.PBR] = "Heroimg_model",
  [HeroModelType.World] = "world_model_path"
}
WorkerState = {
  LEISURE = 1,
  RESIDENTA = 2,
  WORKER = 3
}
HeroSkillDetailPanelShowType = {
  ViewDetail = 1,
  Upgrade = 2,
  Unlock = 3
}
EquipmentSlotType = {
  Weapon = 1,
  Armor = 2,
  Core = 3,
  Radar = 4
}
GuideState = {
  Normal = 0,
  LevelOne = 1,
  OpeningDebut = 2,
  CityCopter = 3,
  Soldier = 4,
  UnLanlockTwo = 5,
  UnLanlockTwoShowTime = 6,
  Over = -1
}
HeroDetailGuideArrowType = {
  Upgrade = 1,
  Equip = 2,
  Skill = 3,
  Rank = 4,
  SkillPreview = 5,
  UniqueWeapon = 6,
  HeroAwaken = 7
}
LWResourceLackGetWay = {
  CityCollection = 1,
  UseItem = 2,
  Buy = 3,
  UpgradeBuilding = 4,
  EquipForge = 5,
  WorldMonster = 6,
  WorldCollection = 7,
  ZombieBattle = 8,
  Gather = 9,
  Recruit = 10,
  Pay = 11,
  HangUp = 12,
  DiamondStore = 13,
  QuestReward = 14,
  Promote = 15,
  EquipCompose = 16,
  SoldierTrain = 17,
  GiftPackage = 18,
  AllianceShop = 19,
  AllianceHelp = 20,
  AllianceDonate = 21,
  BuyGiftBag = 22,
  ClaimFreeStamina = 23,
  AllyDuel = 24,
  GoBuilding = 25,
  Arena = 26,
  VIPShop = 27,
  Activity = 28,
  DailyBuy = 29,
  WeeklyBuy = 30,
  HeroMonthCard = 31,
  WorldBoss = 32,
  Radar = 33,
  ActivityShop = 34,
  GiftPackageList = 35,
  DailyTask = 36,
  SaveGirl = 37,
  AllyDrill = 38,
  AllyStation = 39,
  TruckStation = 40,
  Arena3V3 = 41,
  HonorShop = 42,
  HeroTrail = 43,
  ZombieInvasion = 44,
  SurvivorRecruit = 45,
  DesertStormBattleField = 46,
  PersonalArms = 47,
  VIPDailyReward = 48,
  SecretTask = 49,
  SeasonBuild = 50,
  SeasonScience = 51,
  GoSeasonActivity = 52,
  GoSeasonWeekCard = 53,
  GoSeasonMain = 54,
  GoSeasonRewardPanel = 55,
  GoSeasonFLINT = 56,
  GoSeasonOBSIDIAN = 57,
  GoAllianceSeasonRank = 58,
  GoCommonShop = 59,
  GuideToUseChooseBox = 60,
  GoToWorkerRecruit = 61,
  VIPGiftPackage = 62,
  ActivityAndCheckOpen = 63,
  GotoActShop = 64,
  GogoBuilding = 65,
  GogoAllianceCity = 66,
  GoExchangeUI = 70,
  GoNearestCity = 71,
  GoWorld = 72,
  GoUnownedCityStronghold = 73,
  TorchRelayTaskDaily = 74,
  TorchRelayTaskTotal = 75,
  DailyPackage = 79,
  TacticalChipFactory = 81,
  GoToActivityAndDontCloseSelf = 82,
  GoToDragonHospital = 83,
  GoToDesertCollect = 84,
  GotoFarmerCurBuilding = 85,
  GotoUserMail = 200,
  GotoMummyCenter = 202,
  GotoMummyAllianceCenter = 203,
  OnlyDescType = 204,
  TrailTowerShop = 86,
  DecoChipExchange = 87,
  DecoSelfSelectItem = 88,
  HonorShopNew = 89,
  GoToDecorationShop = 93,
  GoToDispatchTreasureView = 94,
  GoToDigTreasureShare = 95,
  ResourceList = 96,
  GoToEasterEggTaskView = 213,
  GotoEmptyActivity = 97,
  GotoTacticalCardBox = 99,
  TacticalCardDailyLimit = 100,
  TacticalCardSalvage = 101,
  CityPos = 102,
  BountyHunterOpenHistoryView = 214,
  T11IdleGameMainView = 103,
  GiftShopSell = 104,
  GiftShopNotSell = 105,
  LackTypeMutal = 107,
  GoSeasonActivityEmpty = 108,
  GoBirthdaySetView = 109,
  GoGiftPrivilegeView = 110,
  OpenBuyDiamondViewWeekCard = 111,
  GotoSkyBattleGrowChapter = 300,
  GotoSkyBattleGrowBag = 301,
  GotoActRecycleSubView = 302,
  GoToAdList = 112,
  OpenAllyDuelTodayGacha = 113,
  OpenAllyDuelRewardView = 114,
  MultiUseItem = 115,
  GotoWorldBossTask = 116,
  OpenHeroTryOutTask = 117,
  FirstPayGetExp = 123,
  AllianceSkill = 124,
  GoToSeasonTower = 118,
  Tips_SingleText = -1
}
LWResourceLackShow_CountdownTypes = {
  [LWResourceLackGetWay.Promote] = true,
  [LWResourceLackGetWay.PersonalArms] = true
}
LWResourceLackShow_CompletedTypes = {
  [LWResourceLackGetWay.SecretTask] = true,
  [LWResourceLackGetWay.TruckStation] = true,
  [LWResourceLackGetWay.DailyTask] = true,
  [LWResourceLackGetWay.AllyDuel] = true
}
LWResourceLackShow_SoldOutTypes = {
  [LWResourceLackGetWay.AllianceShop] = true,
  [LWResourceLackGetWay.VIPShop] = true,
  [LWResourceLackGetWay.GoCommonShop] = true,
  [LWResourceLackGetWay.HonorShopNew] = true
}
LWResourceLackShow_NotOpenTypes = {
  [LWResourceLackGetWay.ActivityAndCheckOpen] = true,
  [LWResourceLackGetWay.GoToActivityAndDontCloseSelf] = true
}
UIQuestTab = {
  Chapter = 1,
  Main = 2,
  Daily = 3,
  Season = 4
}
UIQuestShowTab = {
  UIQuestTab.Chapter,
  UIQuestTab.Main,
  UIQuestTab.Daily,
  UIQuestTab.Season
}
UIQuestTabTitle = {
  [UIQuestTab.Chapter] = "170010",
  [UIQuestTab.Main] = "170014",
  [UIQuestTab.Daily] = "170015",
  [UIQuestTab.Season] = "100356"
}
UIHeroPropertyDetailType = {Hero = 1, Equip = 2}
AL_FLAG_SPRITE_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_qizi_%s.png"
LWAlFlags = {
  AlFlag1 = 1,
  AlFlag2 = 2,
  AlFlag3 = 3,
  AlFlag4 = 4,
  AlFlag5 = 5,
  AlFlag6 = 6
}
LWAlFlagIcons = {
  [LWAlFlags.AlFlag1] = "1",
  [LWAlFlags.AlFlag2] = "2",
  [LWAlFlags.AlFlag3] = "3",
  [LWAlFlags.AlFlag4] = "4",
  [LWAlFlags.AlFlag5] = "5",
  [LWAlFlags.AlFlag6] = "6"
}
LWAlMainMidBtnType = {
  Al_Territory = 1,
  Al_Science = 2,
  Al_Activity = 3,
  Al_Help = 4,
  Al_Shop = 5,
  Al_Gift = 6,
  Al_War = 7,
  Al_Member = 8,
  Al_Rank = 9,
  Al_Donate = 10,
  Al_Achieve = 11,
  Al_Gather = 12,
  Al_City = 13,
  Al_SeasonCity = 14,
  Al_SeasonDevote = 15,
  Al_SeasonMilestone = 16,
  Al_SeasonStoveCenter = 17,
  Al_GovernmentSkill = 18,
  Al_CityAttachment = 19,
  Al_SeasonMilitaryCenter = 20,
  Al_Season4Center = 21,
  Al_MilitaryPay = 22,
  Al_City_Effect = 23,
  Al_MakeFriends = 24,
  Al_Camp_Science = 25,
  Al_Alliance_Skill = 26
}
LWAlMainMidShowBtns = {
  LWAlMainMidBtnType.Al_War,
  LWAlMainMidBtnType.Al_Help,
  LWAlMainMidBtnType.Al_Gift,
  LWAlMainMidBtnType.Al_Member,
  LWAlMainMidBtnType.Al_Shop,
  LWAlMainMidBtnType.Al_Science,
  LWAlMainMidBtnType.Al_Achieve,
  LWAlMainMidBtnType.Al_MilitaryPay,
  LWAlMainMidBtnType.Al_Gather,
  LWAlMainMidBtnType.Al_Rank,
  LWAlMainMidBtnType.Al_Activity,
  LWAlMainMidBtnType.Al_MakeFriends,
  LWAlMainMidBtnType.Al_GovernmentSkill,
  LWAlMainMidBtnType.Al_Alliance_Skill,
  LWAlMainMidBtnType.Al_City,
  LWAlMainMidBtnType.Al_SeasonCity,
  LWAlMainMidBtnType.Al_SeasonDevote,
  LWAlMainMidBtnType.Al_SeasonMilestone,
  LWAlMainMidBtnType.Al_SeasonStoveCenter,
  LWAlMainMidBtnType.Al_SeasonMilitaryCenter,
  LWAlMainMidBtnType.Al_Season4Center,
  LWAlMainMidBtnType.Al_CityAttachment,
  LWAlMainMidBtnType.Al_City_Effect,
  LWAlMainMidBtnType.Al_Camp_Science
}
LWAlMainMidBtnParam = {
  [LWAlMainMidBtnType.Al_MakeFriends] = {
    Text = "s6_alliance_ally_btn02",
    Icon = "Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_lianmeng_tubiao_jiemeng.png"
  },
  [LWAlMainMidBtnType.Al_GovernmentSkill] = {
    Text = "season_alliance_government_skill_01",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/mjc_lianmeng_tubiao_guanzhijineng.png"
  },
  [LWAlMainMidBtnType.Al_SeasonStoveCenter] = {
    Text = "season_s2_alliance_building_name01",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/mjc_lianmeng_tubiao_ronglu.png"
  },
  [LWAlMainMidBtnType.Al_SeasonMilitaryCenter] = {
    Text = "season_s3_alliance_building_ui01",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/mjc_lianmeng_tubiao_ronglu.png"
  },
  [LWAlMainMidBtnType.Al_Season4Center] = {
    Text = "season_s3_alliance_building_ui01",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/mjc_lianmeng_tubiao_ronglu.png"
  },
  [LWAlMainMidBtnType.Al_SeasonCity] = {
    Text = "season_alliance_UI100",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_saijikaifa_lianmengzhongxin_icon.png"
  },
  [LWAlMainMidBtnType.Al_SeasonDevote] = {
    Text = "season_alliance_UI101",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_saijikaifa_saijigongxian_icon.png"
  },
  [LWAlMainMidBtnType.Al_SeasonMilestone] = {
    Text = "season_alliance_UI102",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_saijikaifa_saijilichengbei_icon.png"
  },
  [LWAlMainMidBtnType.Al_Territory] = {
    Text = 390075,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_1.png"
  },
  [LWAlMainMidBtnType.Al_Science] = {
    Text = 390148,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_7.png"
  },
  [LWAlMainMidBtnType.Al_Activity] = {
    Text = "alliance_main_btn_activity",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_2.png"
  },
  [LWAlMainMidBtnType.Al_Help] = {
    Text = 390110,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_8.png"
  },
  [LWAlMainMidBtnType.Al_Shop] = {
    Text = 390168,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_3.png"
  },
  [LWAlMainMidBtnType.Al_Gift] = {
    Text = 390445,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_9.png"
  },
  [LWAlMainMidBtnType.Al_War] = {
    Text = 393002,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_4.png"
  },
  [LWAlMainMidBtnType.Al_Member] = {
    Text = 390199,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_10.png"
  },
  [LWAlMainMidBtnType.Al_Rank] = {
    Text = 455113,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/ICON_POWERRANKING.png"
  },
  [LWAlMainMidBtnType.Al_Donate] = {
    Text = 390148,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_11.png"
  },
  [LWAlMainMidBtnType.Al_Achieve] = {
    Text = 390973,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_6.png"
  },
  [LWAlMainMidBtnType.Al_Gather] = {
    Text = 393103,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmeng_tubiao_linshi_12.png"
  },
  [LWAlMainMidBtnType.Al_City] = {
    Text = 455145,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_1.png"
  },
  [LWAlMainMidBtnType.Al_City_Effect] = {
    Text = "season5_city_bonus_tittle01",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_1.png"
  },
  [LWAlMainMidBtnType.Al_CityAttachment] = {
    Text = "season_builders_alliance_UI_3",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmengjianshezhe_tongmengrukou_icon.png"
  },
  [LWAlMainMidBtnType.Al_MilitaryPay] = {
    Text = "alliance_pay_title",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/lrb_TMJX_icon.png"
  },
  [LWAlMainMidBtnType.Al_Camp_Science] = {
    Text = "season_s6_activity_1200104_name",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zxl_lianmeng_zhenying_keji.png"
  },
  [LWAlMainMidBtnType.Al_Alliance_Skill] = {
    Text = "season_s6_government_skill_desc40",
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/mjc_lianmeng_tubiao_guanzhijineng.png"
  }
}
LWAlMainDownBtnType = {
  Al_Record = 1,
  Al_Apply = 2,
  Al_Setting = 3,
  Al_StarLog = 4
}
LWAlMainDownShowBtns = {
  LWAlMainDownBtnType.Al_Record,
  LWAlMainDownBtnType.Al_Apply,
  LWAlMainDownBtnType.Al_StarLog,
  LWAlMainDownBtnType.Al_Setting
}
LWAlMainDownBtnParam = {
  [LWAlMainDownBtnType.Al_Record] = {
    Text = 390061,
    Icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png"
  },
  [LWAlMainDownBtnType.Al_Apply] = {
    Text = 390834,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_shenqing.png"
  },
  [LWAlMainDownBtnType.Al_Setting] = {
    Text = 390189,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_shezhi.png"
  },
  [LWAlMainDownBtnType.Al_StarLog] = {
    Text = "alliance_weeklyStar_name",
    Icon = "Assets/Main/Sprites/UI/UIAllianceStar/zxl_tongmengzhixing_tubiao.png"
  }
}
LWAlSettingBtnType = {
  Al_Public_Info = 1,
  Al_Cancel_Leader = 2,
  Al_Authority = 3,
  Al_Exit = 4,
  Al_Apply = 6,
  Al_Share = 7,
  Al_List = 8,
  Al_Modify = 9,
  Al_Mail = 10,
  Al_Alliance_War_time = 11
}
LWAlSettingShowBtns = {
  LWAlSettingBtnType.Al_Authority,
  LWAlSettingBtnType.Al_List,
  LWAlSettingBtnType.Al_Share,
  LWAlSettingBtnType.Al_Apply,
  LWAlSettingBtnType.Al_Modify,
  LWAlSettingBtnType.Al_Mail,
  LWAlSettingBtnType.Al_Alliance_War_time,
  LWAlSettingBtnType.Al_Exit
}
LWAlSettingBtnParam = {
  [LWAlSettingBtnType.Al_Public_Info] = {
    Text = 393004,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_12.png"
  },
  [LWAlSettingBtnType.Al_Cancel_Leader] = {
    Text = 393005,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_13.png"
  },
  [LWAlSettingBtnType.Al_Authority] = {
    Text = 393006,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_14.png"
  },
  [LWAlSettingBtnType.Al_Exit] = {
    Text = 393007,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_15.png",
    Bg = "Assets/Main/Sprites/UI/UILWMail/lyp_lianmeng_anniu_3.png"
  },
  [LWAlSettingBtnType.Al_Apply] = {
    Text = 455006,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_zhuye_shenqingrumeng.png"
  },
  [LWAlSettingBtnType.Al_Share] = {
    Text = 393085,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_zhuye_fenxiangzhaomu.png"
  },
  [LWAlSettingBtnType.Al_List] = {
    Text = 455058,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_linshi_12.png"
  },
  [LWAlSettingBtnType.Al_Modify] = {
    Text = 455084,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/lyp_lianmeng_tubiao_yuyan.png"
  },
  [LWAlSettingBtnType.Al_Alliance_War_time] = {
    Text = "s5_alliance_battle_time_ui01",
    Icon = "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_lianmeng_tubiao_mianzhan.png",
    Bg = "Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_2.png"
  },
  [LWAlSettingBtnType.Al_Mail] = {
    Text = 455138,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/od_lianmeng_tubiao_linshi_13.png"
  }
}
AllianceOfficialPos = {
  Pos1 = 1,
  Pos2 = 2,
  Pos3 = 3,
  Pos4 = 4
}
LWAlMemberOffcialType = {
  None = 0,
  Deputy_Al_Leader = 1,
  Al_Goddess = 2,
  War_Commander = 3,
  Al_Ambassadoe = 4,
  Al_MASTER = 5
}
AllianceOfficialPosConf = {
  [LWAlMemberOffcialType.Deputy_Al_Leader] = {
    name = 391063,
    icon = "UIallianceposition_icon_Waekord",
    tip = 391067
  },
  [LWAlMemberOffcialType.Al_Goddess] = {
    name = 391064,
    icon = "UIallianceposition_icon_recruiter",
    tip = 391068
  },
  [LWAlMemberOffcialType.War_Commander] = {
    name = 391065,
    icon = "UIallianceposition_icon_Muse",
    tip = 391069
  },
  [LWAlMemberOffcialType.Al_Ambassadoe] = {
    name = 391066,
    icon = "UIallianceposition_icon_Butler",
    tip = 391070
  }
}
AlOfficialSkillType = {
  None = 0,
  AresMissile = 1,
  GoddessMummy = 2,
  MissileFactory = 3,
  Challenge = 4,
  GuardianTower = 5,
  AbundantHarvest = 6,
  Reinforcement = 7,
  RefreshBall = 8,
  TeslaCoil = 9
}
GovOfficialType = {
  Native = 0,
  Conquer = 1,
  Outpost = 2,
  Center = 3,
  Destroyer = 4
}
GovOfficialGroup = {
  Common = 1001,
  Outpost = 1002,
  Center = 1003,
  Destroyer = 1004
}
GovOfficialType2Group = {
  [GovOfficialType.Native] = GovOfficialGroup.Common,
  [GovOfficialType.Conquer] = GovOfficialGroup.Common,
  [GovOfficialType.Outpost] = GovOfficialGroup.Outpost,
  [GovOfficialType.Center] = GovOfficialGroup.Center,
  [GovOfficialType.Destroyer] = GovOfficialGroup.Destroyer
}
GovOfficialType2ThroneType = {
  [GovOfficialType.Native] = ThroneType.Native,
  [GovOfficialType.Conquer] = ThroneType.Cross,
  [GovOfficialType.Outpost] = ThroneType.Outpost,
  [GovOfficialType.Center] = ThroneType.Center,
  [GovOfficialType.Destroyer] = ThroneType.Destroyer
}
AlAlertType = {
  AresMissile = 1,
  GoddessMummy = 2,
  MissileFactory = 3,
  GuardianTower = 4,
  TeslaCoil = 5
}
LWAlMemberShowOffcial = {
  LWAlMemberOffcialType.Deputy_Al_Leader,
  LWAlMemberOffcialType.Al_Goddess,
  LWAlMemberOffcialType.War_Commander,
  LWAlMemberOffcialType.Al_Ambassadoe
}
LWAlMemberOffcialParam = {
  [LWAlMemberOffcialType.Deputy_Al_Leader] = {
    Text = 391063,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_guanzhi_fumengzhu.png",
    SmallIcon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_fumengzhu_xiao.png"
  },
  [LWAlMemberOffcialType.Al_Goddess] = {
    Text = 391064,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_guanzhi_shengnv.png",
    SmallIcon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_shengnv_xiao.png"
  },
  [LWAlMemberOffcialType.War_Commander] = {
    Text = 391065,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_guanzhi_zhanshen.png",
    SmallIcon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_zhanshen_xiao.png"
  },
  [LWAlMemberOffcialType.Al_Ambassadoe] = {
    Text = 391066,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_guanzhi_dashi.png",
    SmallIcon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_dashi_xiao.png"
  },
  [LWAlMemberOffcialType.Al_MASTER] = {
    Text = 302336,
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmeng_touxiangkuang.png"
  }
}
LWAlMemberRankType = {
  R1 = 1,
  R2 = 2,
  R3 = 3,
  R4 = 4,
  R5 = 5
}
LWAlMemberShowRank = {
  LWAlMemberRankType.R4,
  LWAlMemberRankType.R3,
  LWAlMemberRankType.R2,
  LWAlMemberRankType.R1
}
LWAlMemberRankParam = {
  [LWAlMemberRankType.R1] = {
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r1.png"
  },
  [LWAlMemberRankType.R2] = {
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r2.png"
  },
  [LWAlMemberRankType.R3] = {
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r3.png"
  },
  [LWAlMemberRankType.R4] = {
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r4.png"
  },
  [LWAlMemberRankType.R5] = {
    Icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r5.png"
  }
}
LWAlMemberAuthorityType = {
  Official_1 = 1,
  Official_2 = 2,
  Official_3 = 3,
  Official_4 = 4,
  Rank_1 = 5,
  Rank_2 = 6,
  Rank_3 = 7,
  Rank_4 = 8,
  Rank_5 = 9
}
LWAlShowAuthorityList = {
  [LWAlMemberRankType.R3] = {
    LWAlMemberAuthorityType.Rank_2,
    LWAlMemberAuthorityType.Rank_1
  },
  [LWAlMemberRankType.R4] = {
    LWAlMemberAuthorityType.Rank_3,
    LWAlMemberAuthorityType.Rank_2,
    LWAlMemberAuthorityType.Rank_1
  },
  [LWAlMemberRankType.R5] = {
    LWAlMemberAuthorityType.Rank_4,
    LWAlMemberAuthorityType.Rank_3,
    LWAlMemberAuthorityType.Rank_2,
    LWAlMemberAuthorityType.Rank_1,
    LWAlMemberAuthorityType.Official_1,
    LWAlMemberAuthorityType.Official_2,
    LWAlMemberAuthorityType.Official_3,
    LWAlMemberAuthorityType.Official_4
  }
}
LWAlMemberAuthorityParam = {
  [LWAlMemberAuthorityType.Official_1] = {
    Icon = LWAlMemberOffcialParam[LWAlMemberOffcialType.Deputy_Al_Leader].SmallIcon
  },
  [LWAlMemberAuthorityType.Official_2] = {
    Icon = LWAlMemberOffcialParam[LWAlMemberOffcialType.Al_Goddess].SmallIcon
  },
  [LWAlMemberAuthorityType.Official_3] = {
    Icon = LWAlMemberOffcialParam[LWAlMemberOffcialType.War_Commander].SmallIcon
  },
  [LWAlMemberAuthorityType.Official_4] = {
    Icon = LWAlMemberOffcialParam[LWAlMemberOffcialType.Al_Ambassadoe].SmallIcon
  },
  [LWAlMemberAuthorityType.Rank_1] = {
    Icon = LWAlMemberRankParam[LWAlMemberRankType.R1].Icon
  },
  [LWAlMemberAuthorityType.Rank_2] = {
    Icon = LWAlMemberRankParam[LWAlMemberRankType.R2].Icon
  },
  [LWAlMemberAuthorityType.Rank_3] = {
    Icon = LWAlMemberRankParam[LWAlMemberRankType.R3].Icon
  },
  [LWAlMemberAuthorityType.Rank_4] = {
    Icon = LWAlMemberRankParam[LWAlMemberRankType.R4].Icon
  },
  [LWAlMemberAuthorityType.Rank_5] = {
    Icon = LWAlMemberRankParam[LWAlMemberRankType.R5].Icon
  }
}
LWFunctionUnlockType = {
  MainUI_WorldBtn = 101,
  MainUI_HeroBtn = 102,
  MainUI_MailBtn = 103,
  MainUI_BagBtn = 104,
  MainUI_DetectBtn = 105,
  MainUI_FoodBar = 106,
  MainUI_MetalBar = 107,
  MainUI_CoinBar = 108,
  MainUI_BuildBtn = 109,
  MainUI_QuestIcon = 110,
  MainUI_PlayerInfo = 111,
  MainUI_PowerBar = 112,
  MainUI_GoldBar = 113,
  MainUI_DropBtn = 114,
  MainUI_VisitorBtn = 115,
  MainUI_BuildQueue = 116,
  MainUI_AllianceBtn = 117,
  MainUI_QuestEntry = 118,
  MainUI_FirstPay = 119,
  MainUI_GiftPack = 120,
  MainUI_Activity = 121,
  MainUI_Chat = 122,
  MainUI_VIP = 123,
  MainUI_Buff = 124,
  MainUI_PetroleumBar = 125,
  MainUI_Stamina = 126,
  MainUI_PlayerDownloadCenter = 127,
  HeroPanel_Require = 201,
  Worker_Lottery = 203,
  City_Shield = 204,
  Daily_Quest = 205,
  MainBuild_WorkerList = 206,
  MainBuild_Addition = 207,
  ClaimFreeStamina = 208,
  SquadEquip = 209,
  NewsCenter = 210,
  BuildListDecorate = 211,
  HeroHonor = 212,
  SoliderInstantFinish = 213,
  MainUI_FlintBar = 214,
  MainUI_ObsidianBar = 215,
  TileBtn_MainCityDetails = 216,
  Welfare_WeeklyCard = 301,
  Welfare_MonthCard = 302,
  Welfare_Diamond = 303
}
CityBuffType = {WarFever = 19, CityShield = 1}
LWWorldMonsterType = {
  ResMetal = 1,
  ResFood = 2,
  Boss = 3,
  City = 4,
  ResGold = 5,
  Radar = 6,
  MonsterInvade = 7,
  RunningMonster = 8,
  ResObsidian = 9,
  ResFlint = 10,
  FlowerCar = 13,
  S4Tank = 14,
  S4Airplane = 15,
  S4Missile = 16,
  S4Boss = 17,
  S4TankBN = 18,
  S4AirplaneBN = 19,
  S4MissileBN = 20,
  S4BossBN = 21,
  S4RunningBoss = 22,
  Lockhart = 1001
}
WorldMonsterSpecialType = {
  Normal = 0,
  LockHartOldS0 = 5,
  IndividualChallengeBoss = 6,
  AllyChallengeBoss = 7,
  AllyDrill = 8,
  MonsterInvasion = 9,
  MonsterInvasionBoss = 10,
  RunningMonster = 11,
  GoldenBeetleBoss = 13,
  CityStrongholdPVE = 20,
  CityStrongholdPVP = 21,
  CityStrongholdBOSS = 22,
  BerserkBoss = 23,
  InvasionBigBoss = 27,
  SmallSandWorm = 28,
  BigSandWorm = 29,
  ZoneMobilizationBoss = 30,
  SandFish = 31,
  SuperRunningBoss = 32,
  Boss33 = 33,
  CityGhostBoss = 34,
  FlowerBoss = 35,
  S4RunningBoss = 36,
  HugeSandWorm = 40,
  AllyDrillHugeSandWorm = 42,
  AL_CHALLENGE_BOSS_KIROV = 44,
  ZombieRushAltered = 45,
  S1RestCityDefendMonster = 46,
  S1RestBloodyQueenMonster = 47,
  S1RestBloodyQueenGunner = 48,
  S1RestBloodyQueenButcher = 49,
  AllyDrillCow = 50,
  AllyDrillRoadHog = 51,
  ALLIANCE_BOSS_S0 = 52,
  Crocodile = 53,
  LockHartS1 = 100,
  LockHartNewS0 = 101,
  LockHartS2 = 102,
  LockHartS3 = 103,
  LockHartS4 = 104,
  LockHartS5 = 105,
  LockHartS6 = 106
}
SandWormType = {
  Small = 0,
  Big = 1,
  SmallAndBig = 2
}
SandWormTaskType = {DailyTask = 1, Achievement = 2}
BloodyNightTaskType = {DailyTask = 1, Achievement = 2}
HideType = {
  None = 0,
  Anonymity = 1,
  Werewolf = 2
}
SoldierType = {
  Player = 1,
  Monster = 2,
  Dragon = 3,
  Mummy = 4
}
T11SoldierTypeWhiteList = {
  [SoldierType.Player] = true,
  [SoldierType.Dragon] = true
}
AlFindTheNearestMemberType = {
  Normal = 0,
  Freeze = 1,
  NotFreeze = 2,
  Warrior = 3
}
LWStageType = {
  SingleBattle = 1,
  DetectEvent = 2,
  TowerupAdvanture = 3
}
WeekCardFucntionType = {BuildQueue = 1, Collectable = 2}
WeekCardPackageStatus = {
  CanBuy = 1,
  CanClaim = 2,
  BuyAgain = 3,
  CannotBuy = 4
}
MarkGroup = {
  Alliance = 1,
  Personal = 2,
  WarZone = 3
}
MonopolyPlacealityType = {
  ArrivalBefore = 1,
  Arrive = 2,
  EventBefore = 3,
  EventEnd = 4,
  Occupy = 5,
  Leave = 6
}
MonopolyEventType = {
  blank = 1,
  Emigrated = 2,
  Parkour = 3,
  PickBox = 4,
  CountMasters = 8,
  DigTreasure = 9,
  SkyBattle = 10
}
MonplolyObstacleShowCondition = {
  Every = 1,
  UnLandLock = 2,
  ReMove = 3,
  MainLv = 4,
  ArriveGrid = 5,
  PlayerGo = 6
}
HeroExhibitBgPath = {
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_N_beijing_3",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_R_beijing_3",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_SR_beijing_3",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_SSR_beijing_3",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_UR_beijing_3"
}
HeroExhibitBgIcPath = {
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_N_tankebeijing",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_R_tankebeijing",
  "Assets/Main/TextureEx/UILWHeroExhibit/lyp_chouka_SR_tankebeijing"
}
HeroRecruitRateShowType = {
  Info = 1,
  DetailInfo = 2,
  GPPDetailInfo = 3
}
HeroRecruitRateDetailInfoType = {
  Hero = 1,
  Goods = 2,
  ResItem = 3,
  Worker = 4,
  SquadEquip = 5,
  Equip = 6,
  SkillChip = 7
}
HeroRecruitState = {
  PlayOpenAni = 1,
  Manual = 2,
  Auto = 3,
  All = 4,
  Fin = 5,
  OpenWithoutAni = 6,
  QuicklyAuto = 7
}
MOVE_CITY_EFFECT_DURATION = 5
CollectCheckObjType = {
  Default = -1,
  Alliance_Collect_Res = 0,
  IceSupplies = 1
}
CollectRewardType = {
  MONSTER = 0,
  PLUNDER = 1,
  COLLECT = 2,
  PLUNDER_LIMIT = 3,
  MONSTER_FIRST_KILL = 4,
  RALLY_LEADER = 5,
  RALLY_JOIN = 6,
  RALLY_JOIN_LIMIT = 7,
  FAKE_PLAYER = 8,
  DESERT = 9,
  DESERT_FIRST = 10,
  ALLIANCE_RESOURCE_COLLECT = 11,
  RALLY_LEADER_FIRST = 12,
  RALLY_JOIN_FIRST = 13,
  ICE_SUPPLIES = 14,
  INVASION_BIG_BOSS_CRIT = 15,
  INVASION_BIG_BOSS_KILL = 16,
  INVASION_BIG_BOSS_ATTACK = 17,
  RALLY_LEADER_BE_ATTACK = 18,
  MONSTER_FIRST_KILL_BE_ATTACK = 19,
  ALLIANCE_PUSH = 20,
  DISCOVER_SUPPLIES = 21,
  DISCOVER_MARCH_SUPPLIES = 22,
  BATTLE_CARD_SKILL_REWARD = 24,
  FLOWER_CHEER_BOX = 25,
  ROB_BANK_STRONGHOLD = 26,
  CARD_BOX_REWARD = 27,
  REPAIR_OUTPOST_REWARD = 28,
  FORTIFY_CHARGE_REWARD = 29,
  RALLY_JOIN_CROCODILE_LIMIT = 30
}
CollectRewardCost = {
  [CollectRewardType.MONSTER] = -10,
  [CollectRewardType.PLUNDER] = -5,
  [CollectRewardType.COLLECT] = 0,
  [CollectRewardType.PLUNDER_LIMIT] = -5,
  [CollectRewardType.MONSTER_FIRST_KILL] = -10,
  [CollectRewardType.RALLY_LEADER] = -20,
  [CollectRewardType.RALLY_JOIN] = 0,
  [CollectRewardType.RALLY_JOIN_LIMIT] = 0,
  [CollectRewardType.RALLY_JOIN_CROCODILE_LIMIT] = 0,
  [CollectRewardType.FAKE_PLAYER] = -5,
  [CollectRewardType.DESERT] = -10,
  [CollectRewardType.DESERT_FIRST] = -10,
  [CollectRewardType.ALLIANCE_RESOURCE_COLLECT] = 0,
  [CollectRewardType.RALLY_LEADER_FIRST] = -20,
  [CollectRewardType.ICE_SUPPLIES] = 0,
  [CollectRewardType.RALLY_LEADER_BE_ATTACK] = 0,
  [CollectRewardType.MONSTER_FIRST_KILL_BE_ATTACK] = 0
}
CollectRewardSort = {
  [CollectRewardType.ALLIANCE_PUSH] = true,
  [CollectRewardType.DISCOVER_SUPPLIES] = true,
  [CollectRewardType.DISCOVER_MARCH_SUPPLIES] = true
}
ComparisonType = {
  Equal = 1,
  NotEqual = 2,
  Greater = 3,
  GreaterEqual = 4,
  Less = 5,
  LessEqual = 6
}
EffectOverviewSourcePoint = {
  Tech = 1,
  Drone = 2,
  HonorWall = 3,
  Vip = 4,
  Building = 5,
  AllianceTech = 6,
  OccupiedCity = 7,
  ProfessionSpecialization = 8,
  SeasonBuilding = 9,
  SuperMonthCard = 10,
  Survivor = 11,
  Decoration = 12,
  Offices = 13,
  Equip = 14,
  HeroSkill = 15,
  HeroUniqueWeapon = 16,
  TacticalWeaponLevel = 17,
  TacticalWeaponPart = 18,
  TacticalWeaponChip = 19,
  DominatorTrainLevel = 20,
  DominatorRankLevel = 21,
  Title = 22,
  TacticalCard = 23,
  Server = 24,
  CampScience = 25
}
EffectOverviewType = {
  Battle = 2,
  Economy = 3,
  HeroAttack = 4,
  HeroDefend = 5,
  DominatorAttack = 6,
  DominatorDefend = 7
}
FirstPayState = {
  DontHaveBuilding = 0,
  Unrepaired = 1,
  Repairing = 2,
  HasReceivedNormalReward = 3,
  HasReceivedSpecialReward = 4
}
ActivityBoxState = {
  Close = 1,
  CanOpen = 2,
  Open = 3
}
PowerOverviewPowerType = {
  playerPower = 1,
  heroPower = 2,
  armyPower = 3,
  buildingPower = 4,
  sciencePower = 5,
  squadEquipPower = 6,
  dominatorPower = 7,
  tacticalCard = 8,
  superSoldierPower = 9
}
PowerOverviewPowerSourceType = {
  heroLevelPower = 1,
  heroRankPower = 2,
  heroSkillPower = 3,
  heroEquipPower = 4,
  heroHonorPower = 5,
  heroWeaponPower = 6,
  heroDecoPower = 7,
  heroAwakenPower = 25,
  weaponChipPower = 8,
  weaponEquipPower = 9,
  weaponLevelPower = 10,
  buildingDecoPower = 11,
  buildingWorkerPower = 12,
  armyPower = 13,
  sciencePower = 14,
  playerPower = 15,
  dominatorRankPower = 16,
  dominatorSkillPower = 17,
  dominatorTrainLvPower = 18,
  dominatorTrainStarPower = 19,
  tacticalCardBasePower = 20,
  tacticalCardLevelPower = 21,
  tacticalCardStarPower = 22,
  baseArmyPower = 23,
  soldierElevenPower = 24
}
PowerOverviewPowerSourcePath = {
  [PowerOverviewPowerType.heroPower] = {
    PowerOverviewPowerSourceType.heroLevelPower,
    PowerOverviewPowerSourceType.heroRankPower,
    PowerOverviewPowerSourceType.heroSkillPower,
    PowerOverviewPowerSourceType.heroEquipPower,
    PowerOverviewPowerSourceType.heroHonorPower,
    PowerOverviewPowerSourceType.heroWeaponPower,
    PowerOverviewPowerSourceType.heroDecoPower,
    PowerOverviewPowerSourceType.heroAwakenPower
  },
  [PowerOverviewPowerType.squadEquipPower] = {
    PowerOverviewPowerSourceType.weaponChipPower,
    PowerOverviewPowerSourceType.weaponEquipPower,
    PowerOverviewPowerSourceType.weaponLevelPower
  },
  [PowerOverviewPowerType.buildingPower] = {
    PowerOverviewPowerSourceType.buildingDecoPower,
    PowerOverviewPowerSourceType.buildingWorkerPower
  },
  [PowerOverviewPowerType.dominatorPower] = {
    PowerOverviewPowerSourceType.dominatorTrainLvPower,
    PowerOverviewPowerSourceType.dominatorTrainStarPower,
    PowerOverviewPowerSourceType.dominatorRankPower,
    PowerOverviewPowerSourceType.dominatorSkillPower
  },
  [PowerOverviewPowerType.tacticalCard] = {
    PowerOverviewPowerSourceType.tacticalCardBasePower,
    PowerOverviewPowerSourceType.tacticalCardLevelPower,
    PowerOverviewPowerSourceType.tacticalCardStarPower
  },
  [PowerOverviewPowerType.superSoldierPower] = {
    PowerOverviewPowerSourceType.baseArmyPower,
    PowerOverviewPowerSourceType.soldierElevenPower
  }
}
PowerOverviewShowPower = {
  PowerOverviewPowerType.heroPower,
  PowerOverviewPowerType.squadEquipPower,
  PowerOverviewPowerType.buildingPower,
  PowerOverviewPowerType.armyPower,
  PowerOverviewPowerType.superSoldierPower,
  PowerOverviewPowerType.sciencePower,
  PowerOverviewPowerType.dominatorPower,
  PowerOverviewPowerType.tacticalCard
}
FormationPowerSourceType = {
  Hero = 1,
  Army = 2,
  SquadEquip = 3,
  Other = 4
}
ChatPinMessageType = {
  AllianceNotice = 0,
  AllianceGatherMember = 1,
  AllianceGatherLeader = 2,
  AllianceNoticeDetails = 3,
  AllianceNoticeList = 4
}
NonActivityType = {
  GiftBoxRank = EnumActivity.GiftBoxActivity.Type
}
RankingTypeServer = {
  DEFAULT = 0,
  KILL_ALLIANCE = 1,
  POWER_ALLIANCE = 2,
  KILL = 3,
  POWER = 4,
  BUILDING = 5,
  ELITE_FIGHT = 6,
  ACT_BOSS = 7,
  ARENA_FIGHT = 8,
  PUZZLE_BOSS = 9,
  GOLLOES_CARD = 10,
  JIGSAW = 11,
  ACTIVITY_LEVEL = 12,
  HERO_TOTAL_POWER = 13,
  PVE_STAGE = 14,
  ONE_HERO_POWER = 15,
  TRIAL_TOWER_TANK = 18,
  TRIAL_TOWER_AIRPLANE = 19,
  TRIAL_TOWER_MISSILE = 20,
  DOMINATOR_UP_PVE = 21,
  T11_IDLE_GAME = 22
}
RankingTypeAlliance = {
  DEFAULT = 0,
  DONATE_TODAY = 1,
  DONATE_WEEK = 2,
  DONATE_ALL = 3,
  ORDER = 4,
  CITY_RECORD = 5
}
RankType = {
  None = 0,
  AllianceKill = RankingTypeServer.KILL_ALLIANCE,
  AlliancePower = RankingTypeServer.POWER_ALLIANCE,
  CommanderKill = RankingTypeServer.KILL,
  CommanderPower = RankingTypeServer.POWER,
  CommanderBase = RankingTypeServer.BUILDING,
  AllianceOrder = 6
}
AllianceDonateRankType = {
  None = 0,
  RankDay = 1,
  RankWeek = 2,
  RankHistory = 3
}
SeverBattleScoreRankType = {ALLIANCE = 1, PERSON = 2}
BuildNoQueue = {No = 0, Yes = 1}
PermissionType = {
  Accept = 1,
  Request = 2,
  Refuse = 3
}
RechargeEntryType = {
  Store = 1,
  DailySale = 2,
  MainUIPop = 3,
  PopRechargeInStore = 5,
  CreditShop = 9001
}
TowerupBattleType = {
  Zombie = 1,
  FakePVP = 2,
  Parkour = 3
}
SubscriptionItemType = {
  FreeGift_Weekly = 1,
  FreeGift_SeasonWeekly = 2,
  FreeGift_Daily = 3,
  Monthly = 4,
  SeasonWeekly = 5,
  Weekly = 6
}
DecorationType = {
  DecorationType_Main_City = 1,
  DecorationType_Head_Frame = 2,
  DecorationType_TittleName = 3,
  DecorationType_Main_Effect = 4,
  DecorationType_Chat_Bubble = 5,
  DecorationType_TacticalWeapon = 6,
  DecorationType_ChatNameColor = 7,
  DecorationType_MultiKill = 8,
  DecorationType_Emoji = 9,
  DecorationType_Dazzle = 10
}
DecorationGainType = {
  DecorationGainType_Item_Exchange = 0,
  DecorationGainType_Default = 1,
  DecorationGainType_Month_Card = 2,
  DecorationGainType_Female = 3,
  DecorationGainType_Champions = 4,
  DecorationGainType_Arena = 5,
  DecorationGainType_OfficialPosition = 6,
  DecorationGainType_LevelUp = 7,
  DecorationGainType_Title = 8
}
DecorationQuality = {
  DecorationQuality_Normal = 1,
  DecorationGainType_Rare = 2,
  DecorationGainType_Epic = 3,
  DecorationGainType_Legend = 4
}
QualityImagePath = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_n.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_r.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_sr.png",
  [4] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ssr.png",
  [5] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur.png",
  [10] = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur.png"
}
QualityTrainBgPath = {
  [1] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheN_bg.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheR_bg.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheSR_bg.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheSSR_bg.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheUR_bg.png",
  [10] = "Assets/Main/TextureEx/UILWRailway/lrb_chengjimaoyi_huocheUR_bg.png"
}
QualityTrainIconPath = {
  [1] = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/zxl_huoche_xitong_jin.png",
  [10] = "Assets/Main/TextureEx/UILWRailway/zxl_huoche_xitong_jin.png"
}
QualityTrainBigBgPath = {
  [1] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_hui.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_lv.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_lan.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_zi.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_cheng.png",
  [10] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_cheng.png"
}
QualityTrainBigImproveBgPath = {
  [1] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_hui_gradient_r.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_lv_gradient_n.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_lan_gradient_sr.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_zi_gradient_ssr.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_cheng_gradient_ur.png",
  [10] = "Assets/Main/TextureEx/UILWRailway/zyf_cjmy_cheng_gradient_ur.png"
}
TruckSuperDepartureQualityImagePath = {
  [1] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_hui.png",
  [2] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_lv.png",
  [3] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_lan.png",
  [4] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_zi.png",
  [5] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_cheng.png",
  [10] = "Assets/Main/TextureEx/UILWTruckSuperDeparture/lrb_cjmy_list_cheng.png"
}
DragonBuildState = {
  Protect = 0,
  Normal = 1,
  Occupying = 2,
  Occupied = 3
}
BattlefieldBuildState = {Normal = 1, Occupied = 2}
WinterEntityState = {
  Normal = 0,
  Occupied = 1,
  Fixing = 2,
  Occupying = 3,
  Death = 4,
  Waiting = 5
}
WinterStormCancelType = {
  Default = 100,
  Park = 101,
  Train = 102,
  OtherChangeScene = 103,
  MvBlackRange = 104,
  ShootGameEnterRoom = 105
}
SeasonDesertCity = {
  Alliance = "1",
  Other = "2",
  Block = "3"
}
SeasonHunterRankType = {
  Survival = 1,
  Kill = 2,
  Win = 3,
  Score = 4,
  Time = 5
}
SexType = {
  None = 0,
  Man = 1,
  Woman = 2,
  NoShow = 3
}
GloryPeriod = {
  None = 0,
  Unopened = 1,
  Prepare = 2,
  Start = 3,
  Settle = 4
}
GloryDeclareType = {Match = 1, List = 2}
GloryBattleState = {
  None = 0,
  Before = 1,
  Ongoing = 2,
  After = 3
}
GloryBattleResult = {
  None = 0,
  Win = 1,
  Lose = 2
}
GloryBattleDetailType = {
  Default = 0,
  PlaceFlag = 1,
  FoldUpFlag = 2,
  Occupy = 3,
  CrashBuilding = 4,
  CrashCenter = 5,
  Win = 6,
  MISSILE_ATTACK_MAIN = 7
}
GlorySeverType = {
  Self = 1,
  Opponent = 2,
  Other = 3
}
GloryScoreRankType = {Season = 0, Week = 1}
GloryContributionType = {
  OCCUPY_DESERT = 1,
  SEASON_BUILDING = 2,
  DONATE_ALLIANCE_STORE = 3,
  DECLARE_SCORE = 4,
  OCCUPY_ENEMY_DESERT = 5
}
DeclareRecordType = {Alliance = 1, ServerZone = 2}
GloryDeclareRecordWinType = {Win = 1, Lose = 0}
GloryDeclareRecordKoType = {No = 0, Ko = 1}
GloryDeclareRecordAtkType = {Attack = 1, Defence = 2}
GloryInfoTab = {
  None = 0,
  Summary = 1,
  SummaryHistory = 2,
  Rank = 3,
  RankHistory = 4,
  History = 5
}
MasteryCondType = {And = 0, Or = 1}
MasteryCdType = {Countdown = 1, Everyday = 2}
MasteryCdShow = {
  Sec = 1,
  Min = 2,
  Hour = 3
}
MasteryHome = {
  None = 0,
  Gather = 101,
  Build = 102,
  Battle = 103
}
MasteryHomeShowList = {
  MasteryHome.Gather,
  MasteryHome.Build,
  MasteryHome.Battle
}
MasteryHomeTitle = {
  [MasteryHome.Gather] = 110716,
  [MasteryHome.Build] = 110717,
  [MasteryHome.Battle] = 110718
}
MasteryTipState = {
  None = 0,
  CanLearn = 1,
  Maxed = 2,
  NeedLv = 3,
  NeedPoint = 4,
  NeedPrior = 5,
  Closed = 6
}
MasterySkillCannotUpResaon = {
  None = 0,
  MaxLv = 1,
  needHomeLv = 2,
  needSkillLv = 3,
  needCost = 4,
  homeDiff = 5,
  seasonDisable = 6,
  DesignerLock = 7,
  ExtraLock = 8
}
MasteryNodeState = {
  Hide = "hide",
  Off = "off",
  On = "on"
}
MasterySkillType = {Normal = 0, Title = 1}
MasterySkillState = {
  None = 0,
  Normal = 1,
  Locked = 2,
  CD = 3,
  Covered = 4,
  NoUse = 5,
  Effect = 6
}
MasterySkillUsePosType = {
  None = 0,
  Building = 1,
  Field = 2,
  SkillView = 3,
  Troop = 4,
  PersonalBuild = 5,
  MyDesert = 6,
  Monster = 7,
  AllianceCity = 8,
  FormationView = 9
}
MasterySkill = {
  Thrive = 1001,
  MasteryReward = 1002,
  RapidMine = 1004,
  IndustrialDevelop = 1005,
  Demolition = 1007,
  BuildingShield = 1009,
  BattleSupply = 1010,
  Landmine = 1011,
  RapidRepair = 1013,
  RandomAddAttack = 1016,
  RecoverMarch = 1017,
  Harvest = 1018,
  QuickCollect = 1019,
  ProductGarrison = 1020,
  UpgradeDesert = 1023,
  AddSpecialExp = 1025,
  RapidHeal = 1032,
  WarFlag = 1034,
  MopUp = 1037,
  BuildSpeedUpTogether = 1038,
  FireMine = 1043,
  BrokenMine = 1044,
  IceMine = 1045,
  FireBomb = 1047,
  IceBomb = 1048,
  CallSupply = 1049,
  CultivateVirus = 1051,
  BlackLandMoveCity = 1061,
  SandStorm = 1063,
  TouchOfNature = 1064,
  SandWormMine = 1065,
  WarriorSpeedUpTogether = 1066,
  FreeMoveCity = 1067,
  SeniorFreeMoveCity = 1093,
  BuyOneGetOneFree = 1073,
  CreateMummyRunningBoss = 1074,
  CreateFakeMarch = 1076,
  SandWormCaller = 1077,
  BloodyHunter = 1078,
  Whistle = 1079,
  WerewolfMoveCity = 1084,
  Flare = 1086,
  LightMine = 1087,
  ElectricianGather = 1088,
  AllyCityPoisoning = 1092,
  CreateWall = 1094,
  ReinforceWall = 1095,
  Multithread = 1096,
  SeasonResExchange = 1101,
  BuildFinishImd = 1102,
  ResearchFinishImd = 1104,
  FriendshipShield = 1105,
  MedicalAssistance = 1039,
  SummonWeather = 1110
}
MasterySkillLocation = {
  None = 0,
  ActiveSkill = 1,
  WorldBuild = 2,
  WorldDesert = 3,
  WorldFormation = 4
}
DecorationSkillUseType = {Active = 0, Passive = 1}
SeasonIntroType = {
  Pass = 1,
  Stronghold = 2,
  Morality = 3,
  EdenSubway = 4
}
ControlSeasonIntroType = {ScrollToNext = 1, ShowCloseBtn = 2}
BloodyNightState = {
  None = 0,
  Silent = 1,
  Bloody = 2
}
AlRankType = {
  Power = 1,
  Kill = 2,
  Donate = 3,
  DonateDaily = 4,
  DonateWeek = 5
}
RebateActivityTab = {Gift = 1, Shop = 2}
ActivityAttackCityTargetType = {
  Task = 1,
  Rank = 2,
  RankReward = 3
}
ActivityValidType = {
  None = 0,
  Now = 1,
  Later = 2,
  Over = 3
}
TreasureHuntActivityState = {
  SelectBigReward = 1,
  RefreshAni = 2,
  OpenCard = 3,
  OpenCardGetBigReward = 4,
  RefreshNextAni = 5,
  MaxLevelFin = 6,
  AutoOpen = 7
}
TreasureHuntNewActivityState = {
  SelectBigReward = 1,
  RefreshAni = 2,
  OpenCard = 3,
  OpenCardGetBigReward = 4,
  RefreshNextAni = 5,
  MaxLevelFin = 6,
  AutoOpen = 7
}
ActSlotState = {
  Idle = 1,
  MidQuicklyAni = 2,
  MidResultAni = 3,
  MidShowAni = 4
}
ActSlotRollResultType = {
  AAA = 1,
  BBB = 2,
  CCC = 3,
  DDD = 4,
  EEE = 5,
  FFF = 6,
  AAX = 7,
  BBX = 8,
  CCX = 9,
  DDX = 10,
  EEX = 11,
  FFX = 12,
  XXX = 13
}
ActSlotResultGroupoType = {
  AllSame = 1,
  DoubleSame = 2,
  Diff = 3
}
ActSlotResultGroupContain = {
  [ActSlotResultGroupoType.AllSame] = {
    ActSlotRollResultType.AAA,
    ActSlotRollResultType.BBB,
    ActSlotRollResultType.CCC,
    ActSlotRollResultType.DDD,
    ActSlotRollResultType.EEE,
    ActSlotRollResultType.FFF
  },
  [ActSlotResultGroupoType.DoubleSame] = {
    ActSlotRollResultType.AAX,
    ActSlotRollResultType.BBX,
    ActSlotRollResultType.CCX,
    ActSlotRollResultType.DDX,
    ActSlotRollResultType.EEX,
    ActSlotRollResultType.FFX
  },
  [ActSlotResultGroupoType.Diff] = {
    ActSlotRollResultType.XXX
  }
}
ActMonopolyState = {
  Idle = 1,
  DiceAni = 2,
  Move = 3,
  ArriveAni = 4,
  CycleAni = 5,
  WaitCycleRewardClose = 6
}
ActMonopolyGridDirType = {
  Left = 1,
  Right = 2,
  Up = 3,
  Down = 4
}
ActMonopolyGridType = {
  StartIndex = 1,
  Exp = 2,
  Event = 3
}
ActMonopolyDiceType = {Normal = 1, Special = 2}
ActMonopolyShopBuyType = {Money = 1, Item = 2}
ActMonopolyEventType = {
  BackEvent = 1,
  FreeH = 3,
  ExpEvent = 4,
  GetReward = 5,
  Shop = 6,
  Sport = 10
}
ActMonopolyBossState = {
  None = 0,
  Normal = 1,
  Weak = 2
}
ActMonopolyDropShowType = {
  Event = 1,
  Reward = 2,
  ActDetectTreasure = 3
}
ActMonopolyGridEffectType = {
  Eff_ui_dfw_dikuai_shuaguang = 1,
  Eff_ui_dfw_dikuai_jiangli = 2,
  Eff_ui_dfw_dikuai_shengji = 3
}
ActChristmasTreeDataType = {Rank = 1, Reward = 2}
ActChristmasTreeBelongType = {Personal = 1, Alliance = 2}
BanquetAttackMonsterBulletType = {
  None = -1,
  Normal = 0,
  Special = 1
}
BanquetAttackMonsterState = {Normal = 0, GetReward = 1}
SkillUseInWorldType = {
  MasterySkill = 1,
  CitySkinSkill = 2,
  TitleSkill = 3,
  TCCardSkill = 4
}
CitySkinSkillId = {PlayMusic = 10001}
BanquetAttackMonsterBossType = {Normal = 1, Special = 2}
BanquetAttackMonsterCostType = {Resource = 1, Goods = 2}
ActBingoTaskNum = {OneHorizontal = 3, OneVertical = 5}
ActBingoBoxType = {
  Horizontal = 1,
  Vertical = 2,
  BigReward = 3
}
ActBingoBoxState = {
  NoComplete = 0,
  CanReceive = 1,
  Received = 2
}
ActivityContentHandler = {}
ActivityContentHandler[EnumActivity.LeadingQuest.Type] = {
  assetPath = UIAssets.LeadingQuest,
  cls = "UI.UIActivityCenterTable.Component.LeadingTarget.LeadingQuestMain"
}
ActivityContentHandler[EnumActivity.ActSevenDay.Type] = {
  assetPath = UIAssets.UIActSevenDayNew,
  cls = "UI.UIActivityCenterTable.Component.UIActivitySevenDay.ActSevenDay"
}
ActivityContentHandler[EnumActivity.StrongestCommander.Type] = {
  assetPath = UIAssets.UIStrongestCommnaderPanel,
  cls = "UI.UIActivityCenterTable.Component.StrongestCommander.StrongestCommanderMain"
}
ActivityContentHandler[EnumActivity.LockhartActivity.Type] = {
  assetPath = UIAssets.LockhartActivityPanel,
  cls = "UI.UIActivityCenterTable.Component.Lockhart.LockhartActivityMain"
}
ActivityContentHandler[EnumActivity.WorldBoss.Type] = {
  assetPath = UIAssets.UIActivityWorldBoss,
  cls = "UI.UIActivityCenterTable.Component.ActBoss.ActWorldBoss"
}
ActivityContentHandler[EnumActivity.AllyDrill.Type] = {
  assetPath = UIAssets.AllyDrillMain,
  cls = "UI.UIActivityCenterTable.Component.AllyDrill.AllyDrillMain"
}
ActivityContentHandler[EnumActivity.KillZombieActivity.Type] = {
  assetPath = UIAssets.KillZombieActivityPanel,
  cls = "UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityMain"
}
ActivityContentHandler[EnumActivity.PersonalArmsNew.Type] = {
  assetPath = UIAssets.PersonalArmsNew,
  cls = "UI.UIActivityCenterTable.Component.PersonalArms.PersonalArms"
}
ActivityContentHandler[EnumActivity.DispatchTask.Type] = {
  assetPath = UIAssets.UIActivityDispatchTask,
  cls = "UI.UIActivityCenterTable.Component.DispatchTask.DispatchTask"
}
ActivityContentHandler[EnumActivity.AttackCityActivity.Type] = {
  assetPath = UIAssets.UIAttackCityMain,
  cls = "UI.UIActivityCenterTable.Component.AttackCity.AttackCityActivityMain"
}
ActivityContentHandler[EnumActivity.GrowFoundation.Type] = {
  assetPath = UIAssets.UIGrowFoundationPanel,
  cls = "UI.UIGiftPackage.Component.UILWGrowFoundation.UILWGrowFoundation"
}
ActivityContentHandler[EnumActivity.SunriseFoundation.Type] = {
  assetPath = UIAssets.UISunriseFoundationPanel,
  cls = "UI.UIGiftPackage.Component.UILWSunriseFoundation.UILWSunriseFoundation"
}
ActivityContentHandler[EnumActivity.ActDragon.Type] = {
  assetPath = UIAssets.UIActivityDesertBattle,
  cls = "UI.UIActivityCenterTable.Component.DesertBattle.DesertBattleActivityMain"
}
ActivityContentHandler[EnumActivity.ActWinterStorm.Type] = {
  assetPath = UIAssets.UIActivityWinterStorm,
  cls = "UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormActivityMain"
}
ActivityContentHandler[EnumActivity.RebateActivity.Type] = {
  assetPath = UIAssets.UIRebateMain,
  cls = "UI.UIActivityCenterTable.Component.Rebate.RebateActivityMain"
}
ActivityContentHandler[EnumActivity.TaskActivity.Type] = {
  assetPath = UIAssets.UITaskActivityMain,
  cls = "UI.UIActivityCenterTable.Component.Task.TaskActivity"
}
ActivityContentHandler[EnumActivity.TaskActivity2.Type] = {
  assetPath = UIAssets.UITaskActivityMain,
  cls = "UI.UIActivityCenterTable.Component.Task.TaskActivity"
}
ActivityContentHandler[EnumActivity.TreasureHuntActivity.Type] = {
  assetPath = UIAssets.UITreasureHuntMain,
  cls = "UI.UIActivityCenterTable.Component.TreasureHunt.TreasureHuntActivityMain"
}
ActivityContentHandler[EnumActivity.LuckyShop.Type] = {
  assetPath = UIAssets.UILuckyShop,
  cls = "UI.UIActivityCenterTable.Component.LuckyShop.LuckyShopMain"
}
ActivityContentHandler[EnumActivity.HeroTrialActivity.Type] = {
  assetPath = UIAssets.UIHeroTrial,
  cls = "UI.UIActivityCenterTable.Component.HeroTrial.UIHeroTrial"
}
ActivityContentHandler[EnumActivity.ScratchOffGame.Type] = {
  assetPath = UIAssets.UIScratchGame,
  cls = "UI.UIActivityCenterTable.Component.ScratchOffGame.ScratchOffGame"
}
ActivityContentHandler[EnumActivity.ContinuePay.Type] = {
  assetPath = UIAssets.UIContinuePay,
  cls = "UI.UIActivityCenterTable.Component.ContinuePay.UIContinuePayMain"
}
ActivityContentHandler[EnumActivity.ActMonopoly.Type] = {
  assetPath = UIAssets.UIActMonopolyMain,
  cls = "UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopoly"
}
ActivityContentHandler[EnumActivity.ActGiftGiving.Type] = {
  assetPath = UIAssets.UIActGiftGivingMain,
  cls = "UI.UIActivityCenterTable.Component.ActGiftGiving.ActGiftGivingMain"
}
ActivityContentHandler[EnumActivity.ActLottery.Type] = {
  assetPath = UIAssets.UIActLotteryMain,
  cls = "UI.UIActivityCenterTable.Component.ActLottery.ActLotteryMain"
}
ActivityContentHandler[EnumActivity.ActSlotMachine.Type] = {
  assetPath = UIAssets.UIActSlotMachineMain,
  cls = "UI.UIActivityCenterTable.Component.ActSlotMachine.ActSlotMachine"
}
ActivityContentHandler[EnumActivity.ActBingo.Type] = {
  assetPath = UIAssets.UIActBingo,
  cls = "UI.UIActivityCenterTable.Component.ActBingo.ActBingo"
}
ActivityContentHandler[EnumActivity.CitySkinGet.Type] = {
  assetPath = UIAssets.CitySkinGet,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinGet"
}
ActivityContentHandler[EnumActivity.MonsterInvasion.Type] = {
  assetPath = UIAssets.UIActivityMonsterInvasion,
  cls = "UI.UIActivityCenterTable.Component.ActMonsterInvasion.ActMonsterInvasion"
}
ActivityContentHandler[EnumActivity.JungleTrial.Type] = {
  assetPath = UIAssets.UIJungleTrial,
  cls = "UI.UIJungleTrial.JungleTrialMain"
}
ActivityContentHandler[EnumActivity.SandWormHunt.Type] = {
  assetPath = UIAssets.UISandWormHunt,
  cls = "UI.UISandWormHunt.SandWormHuntMain"
}
ActivityContentHandler[EnumActivity.SandWormFishing.Type] = {
  assetPath = UIAssets.UISandWormFishing,
  cls = "UI.UISandWormFishing.SandWormFishingMain"
}
ActivityContentHandler[EnumActivity.FishingMaster.Type] = {
  assetPath = UIAssets.UIFishingMaster,
  cls = "UI.UIFishing.FishingMaster"
}
ActivityContentHandler[EnumActivity.ArenaNewbie.Type] = {
  assetPath = UIAssets.UIArenaNewbie,
  cls = "UI.UIActivityCenterTable.Component.ArenaNewbie.UIArenaNewbie"
}
ActivityContentHandler[EnumActivity.Cooking.Type] = {
  assetPath = UIAssets.UIThanksGivingCooking,
  cls = "UI.UIActivityCenterTable.Component.ThanksGiving.Cooking.UIThanksGivingCooking"
}
ActivityContentHandler[EnumActivity.Banquet.Type] = {
  assetPath = UIAssets.UIActChristmasTree,
  cls = "UI.UIActivityCenterTable.Component.ActMonopoly.UIActChristmasTree.UIActChristmasTree"
}
ActivityContentHandler[EnumActivity.ActHeroLevelReplace.Type] = {
  assetPath = UIAssets.UIActHeroLevelReplacement,
  cls = "UI.UIActivityCenterTable.Component.UIHeroLevelReplace.UIActHeroLevelReplace"
}
ActivityContentHandler[EnumActivity.ActHeroPromotion.Type] = {
  assetPath = UIAssets.UIActHeroPromotion,
  cls = "UI.UIActivityCenterTable.Component.UIHeroPromotion.UIActHeroPromotion"
}
ActivityContentHandler[EnumActivity.SeasonSuppliesShare.Type] = {
  assetPath = UIAssets.LWSeasonSuppliesShare,
  cls = "UI.LWSeason.UILWSingleActivityContainer.Component.SeasonSuppliesShareAcitivity"
}
ActivityContentHandler[EnumActivity.SnowStormComing.Type] = {
  assetPath = UIAssets.UIActSnowStormComing,
  cls = "UI.LWSeason.UILWSingleActivityContainer.Component.SnowStorm.UIActSnowStormComing"
}
ActivityContentHandler[EnumActivity.CookFood.Type] = {
  assetPath = UIAssets.ACT_COOK_FOOD_PREFAB,
  cls = "UI.LWSeason.UILWSingleActivityContainer.Component.UIActCookFood"
}
ActivityContentHandler[EnumActivity.SeasonNuclearPowerPlantActivity.Type] = {
  assetPath = UIAssets.ACT_NUCLEAR_POWER_PLANT,
  cls = "UI.LWSeason.UILWSingleActivityContainer.Component.ActNuclearPowerPlant.UIActNuclearPowerPlant"
}
ActivityContentHandler[EnumActivity.TitaniumBlueStore.Type] = {
  assetPath = UIAssets.UITitaniumBlueStore,
  cls = "UI.UIActivityCenterTable.Component.UILWTitaniumBlueStore.UILWTitaniumBlueStoreMain"
}
ActivityContentHandler[EnumActivity.OptionalWeekCard.Type] = {
  assetPath = UIAssets.UILWOptionalWeekCard,
  cls = "UI.UIActivityCenterTable.Component.LWUIOptionalWeekCard.LWUIOptionalWeekCardView"
}
ActivityContentHandler[EnumActivity.Doomsday.Type] = {
  assetPath = UIAssets.UIDoomsday,
  cls = "UI.UIActivityCenterTable.Component.Doomsday.UIDoomsday"
}
ActivityContentHandler[EnumActivity.MultipleParkour.Type] = {
  assetPath = UIAssets.UIActivityMultipleParkour,
  cls = "UI.UIActivityCenterTable.Component.MultipleParkour.UIActivityMultipleParkour"
}
ActivityContentHandler[EnumActivity.CounterAttack.Type] = {
  assetPath = UIAssets.UIActivityCounterAttack,
  cls = "UI.UICounterAttack.CounterAttackMain"
}
ActivityContentHandler[EnumActivity.BloodyNight.Type] = {
  assetPath = UIAssets.UIActivityBloodyNight,
  cls = "UI.UIBloodyNight.UIBloodyNightMain"
}
ActivityContentHandler[EnumActivity.WestwardExpansion.Type] = {
  assetPath = UIAssets.UIWestwardExpansion,
  cls = "UI.WestwardExpansion.UIWestwardExpansion"
}
ActivityContentHandler[EnumActivity.ZombieRush.Type] = {
  assetPath = UIAssets.LWUIZombieRushMain,
  cls = "UI.UIActivityCenterTable.Component.LWUIZombieRush.LWUIZombieRushMain"
}
ActivityContentHandler[EnumActivity.DispatchTreasure.Type] = {
  assetPath = UIAssets.DispatchTreasure,
  cls = "UI/UIDispatchTask/Main/Component/DispatchTreasure"
}
ActivityContentHandler[EnumActivity.DoomCommander.Type] = {
  assetPath = UIAssets.UIActDoomCommander,
  cls = "UI/UIDoomVanguard/DoomCommaner/Component/UIActDoomCommander"
}
ActivityContentHandler[EnumActivity.LeadingQuestV2.Type] = {
  assetPath = UIAssets.LeadingQuestV2,
  cls = "UI.UIActivityCenterTable.Component.LeadingQuestV2.LeadingQuestMainV2"
}
ActivityContentHandler[EnumActivity.Questionnaire.Type] = {
  assetPath = UIAssets.LWUIQuestionnaire,
  cls = "UI.UIActivityCenterTable.Component.LWUIQuestionnaire.LWUIQuestionnaireMain"
}
ActivityContentHandler[EnumActivity.TreasureHuntNewActivity.Type] = {
  assetPath = UIAssets.UITreasureHuntNewMain,
  cls = "UI/UIActivityCenterTable/Component/TreasureHuntNew/ActivityTreasureHuntNewMainComponent"
}
ActivityContentHandler[EnumActivity.CommunityLink.Type] = {
  assetPath = UIAssets.UIActCommunityLink,
  cls = "UI/UIActivityCenterTable/Component/UIActCommunityLink/UIActCommunityLink"
}
ActivityContentHandler[EnumActivity.ActivityRebateNew.Type] = {
  assetPath = UIAssets.UIRebateNewActivityMain,
  cls = "UI/UIActivityCenterTable/Component/ActivityRebateNew/ActivityRebateNewMainComponent"
}
ActivityContentHandler[EnumActivity.BlackMarket.Type] = {
  assetPath = UIAssets.UIBlackMarketMain,
  cls = "UI.UIActivityCenterTable.Component.UILWBlackMarket.UILWBlackMarketMain"
}
ActivityContentHandler[EnumActivity.ChampionDuelMain.Type] = {
  assetPath = UIAssets.UIChampionDuelMain,
  cls = "UI.UIChampionDuel.View.UIChampionDuelMainView"
}
ActivityContentHandler[EnumActivity.BerserkBoss.Type] = {
  assetPath = UIAssets.LWUIBerserkBossMain,
  cls = "UI.UIActivityCenterTable.Component.LWUIBerserkBoss.LWUIBerserkBossMain"
}
ActivityContentHandler[EnumActivity.DecorationGacha.Type] = {
  assetPath = UIAssets.UIDecorationGachaMain,
  cls = "UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaMainComponent"
}
ActivityContentHandler[EnumActivity.TorchRelay.Type] = {
  assetPath = UIAssets.UITorchRelayMain,
  cls = "UI/LWTorchRelay/Activity/Main/UILWTorchRelayMainComponent"
}
ActivityContentHandler[EnumActivity.ActTrends.Type] = {
  assetPath = UIAssets.ActTrendsMain,
  cls = "UI.UIActivityCenterTable.Component.ActTrends.ActTrends"
}
ActivityContentHandler[EnumActivity.ActEpidemic.Type] = {
  assetPath = UIAssets.ActEpidemicMainPath,
  cls = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainView"
}
ActivityContentHandler[EnumActivity.Ghostrecon.Type] = {
  assetPath = UIAssets.Ghostrecon,
  cls = "UI.UIDispatchTask.Main.Component.Ghorstrecon.Ghostrecon"
}
ActivityContentHandler[EnumActivity.LotteLink.Type] = {
  assetPath = UIAssets.UIActLotteLink,
  cls = "UI/UIActivityCenterTable/Component/UIActLotteLink/UIActLotteLink"
}
ActivityContentHandler[EnumActivity.ActSevenDayV2.Type] = {
  assetPath = UIAssets.SevenDayV2Item,
  cls = "UI/LWUIActSevenDayV2/Component/ActSevenDayV2"
}
ActivityContentHandler[EnumActivity.HeroMonthCard.Type] = {
  assetPath = UIAssets.UILWHeroMonthCard,
  cls = "UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain"
}
ActivityContentHandler[EnumActivity.FrontBreakSunday.Type] = {
  assetPath = UIAssets.FrontBreakSunday,
  cls = "UI/UIActivityCenterTable/Component/UIActFrontBreakSunday/FrontBreakoutSunday"
}
ActivityContentHandler[EnumActivity.SeasonPeriodicCard.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonPeriodicCard/UIActSeasonPeriodicCard.prefab",
  cls = "UI.LWSeason.LWSeasonMain.Component.UILWActPeriodicCard"
}
ActivityContentHandler[EnumActivity.MultiReward.Type] = {
  assetPath = UIAssets.MultiReward,
  cls = "UI.UIActivityCenterTable.Component.MultiReward.UIMultiReward"
}
ActivityContentHandler[EnumActivity.ActHeroLevelAndStarReplace.Type] = {
  assetPath = UIAssets.UIActHeroLevelAndStarReplace,
  cls = "UI.UIActivityCenterTable.Component.UIHeroLevelAndStarReplace.UIActHeroLevelAndStarReplace"
}
ActivityContentHandler[EnumActivity.ActValentineSendGift.Type] = {
  assetPath = UIAssets.UIActValentineSendGift,
  cls = "UI.UIActivityCenterTable.Component.UIActValentine.UIActValentineSendGift"
}
ActivityContentHandler[EnumActivity.ActValentineReceiveGift.Type] = {
  assetPath = UIAssets.UIActValentineReceiveGift,
  cls = "UI.UIActivityCenterTable.Component.UIActValentine.UIActValentineReceiveGift"
}
ActivityContentHandler[EnumActivity.ActBountyHunter.Type] = {
  assetPath = UIAssets.UIActBountyHunter,
  cls = "UI/UIActivityCenterTable/Component/ActBountyHunter/Component/UIActBountyHunterRootComponent"
}
ActivityContentHandler[EnumActivity.RevivalPlan.Type] = {
  assetPath = UIAssets.UIRevivalPlanPanel,
  cls = "UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanActivityMain"
}
ActivityContentHandler[EnumActivity.ActEasterEgg.Type] = {
  assetPath = UIAssets.UIActEasterEggMainView,
  cls = "UI.LWUIActEasterEgg.LWUIActEasterEggMainView.View.LWUIActEasterEggMainView"
}
ActivityContentHandler[EnumActivity.SurfingBattleAct.Type] = {
  assetPath = UIAssets.UISurfingBattleActMain,
  cls = "UI.UISurfing.UIAct.UISurfingBattleActMain"
}
ActivityContentHandler[EnumActivity.OffSeason1Recapture.Type] = {
  assetPath = UIAssets.OffSeason1RecaptureMain,
  cls = "UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureMain"
}
ActivityContentHandler[EnumActivity.OffSeason1QueenOfBlood.Type] = {
  assetPath = UIAssets.OffSeason1QueenOfBloodMain,
  cls = "UI.LWOffSeason1.QueenOfBlood.UIOffSeason1QueenOfBloodMain"
}
ActivityContentHandler[EnumActivity.CrazyRock.Type] = {
  assetPath = UIAssets.CrazyRockView,
  cls = "UI.UIActCrazyRock.ActMain.View.LWUIActCrazyRockMainView"
}
ActivityContentHandler[EnumActivity.OFF_SEASON_DIG_REWARD.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/OffSeasonDigGame/OffSeasonDiggingGameMain.prefab",
  cls = "UI.OffSeasonDiggingGame.OffSeasonDiggingGameMain.OffSeasonDiggingGameMain"
}
ActivityContentHandler[EnumActivity.S0AttackCityNew.Type] = {
  assetPath = UIAssets.UIAttackCityS0Main,
  cls = "UI.LWCityAttackS0.Main.AttackCityS0Main"
}
ActivityContentHandler[EnumActivity.S0AttackCityBattlePass.Type] = {
  assetPath = UIAssets.UIAttackCityS0BattlePass,
  cls = "UI.LWCityAttackS0.BattlePass.UIAttackCityS0BattlePassView"
}
ActivityContentHandler[EnumActivity.S0AttackCityClue.Type] = {
  assetPath = UIAssets.UIAttackCityS0Clue,
  cls = "UI.LWCityAttackS0.ClueView.UIAttackCityS0ClueView"
}
ActivityContentHandler[EnumActivity.ActCalendar.Type] = {
  assetPath = UIAssets.ActCalendarMain,
  cls = "UI.ActCalendar.ActCalendarMain"
}
ActivityContentHandler[EnumActivity.GhostParkour.Type] = {
  assetPath = UIAssets.UIGhostParkourActMain,
  cls = "UI.UIGhostParkour.Outside.Main.UIGhostParkourActMainView"
}
ActivityContentHandler[EnumActivity.Recycle.Type] = {
  assetPath = UIAssets.ActRecycleMain,
  cls = "UI.LWUIActRecycle.LWUIActRecycleMainComponent"
}
ActivityContentHandler[EnumActivity.S0AllianceBoss.Type] = {
  assetPath = UIAssets.UIS0AllianceBossMain,
  cls = "UI.UIS0AllianceBoss.Main.UIS0AllianceBossMainView"
}
CalendarSourcePath = {Activity = "event_hub", Other = "event_page"}
BattlePassType = {
  Normal = 1,
  SevenDayLogin = 2,
  ActSevenDay = 3,
  Christmas = 4,
  NewYear = 5,
  NewYearSevenDayLogin = 6,
  SeasonBattlePass = 7,
  Valentine = 8,
  ValentineLogin = 9,
  SpringFestival = 10,
  NormalDouble = 11,
  Easter = 12,
  Ramadan = 13,
  DoomVanguard = 14,
  NormalNew1 = 1000015,
  NormalNew2 = 1000016,
  NormalNew3 = 1000017,
  NewYear_Common = 1000142,
  Normal_Common = 1000143
}
BattlePassContentHandler = {}
BattlePassContentHandler[BattlePassType.Normal] = {
  assetPath = UIAssets.UIBattlePass,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePass"
}
BattlePassContentHandler[BattlePassType.SevenDayLogin] = {
  assetPath = UIAssets.UISevenDayLogin,
  cls = "UI.UIActivityCenterTable.Component.UISevenDayLogin.UISevenDayLogin"
}
BattlePassContentHandler[BattlePassType.ActSevenDay] = {
  assetPath = UIAssets.UIBattlePassForActSevenDay,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassForActSevenDay"
}
BattlePassContentHandler[BattlePassType.Christmas] = {
  assetPath = UIAssets.UIBattlePassChristmas,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePass"
}
BattlePassContentHandler[BattlePassType.NewYear] = {
  assetPath = UIAssets.UIBattlePassNewYear,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYear"
}
BattlePassContentHandler[BattlePassType.NewYearSevenDayLogin] = {
  assetPath = UIAssets.UIActSevenDayLoginNewYear,
  cls = "UI.UIActivityCenterTable.Component.UISevenDayLogin.UISevenDayLogin"
}
BattlePassContentHandler[BattlePassType.SpringFestival] = {
  assetPath = UIAssets.UIBattlePassSpringFestival,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePass"
}
BattlePassContentHandler[BattlePassType.Valentine] = {
  assetPath = UIAssets.UIBattlePassValentine,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYear"
}
BattlePassContentHandler[BattlePassType.ValentineLogin] = {
  assetPath = UIAssets.UIActSevenDayLoginTorchRelay,
  cls = "UI.UIActivityCenterTable.Component.UISevenDayLogin.UISevenDayLoginNew"
}
BattlePassContentHandler[BattlePassType.SeasonBattlePass] = {
  assetPath = UIAssets.UIBattlePassNewYear,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYear"
}
BattlePassContentHandler[BattlePassType.NormalDouble] = {
  assetPath = UIAssets.UIBattlePassNewYear,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYear"
}
BattlePassContentHandler[BattlePassType.Easter] = {
  assetPath = UIAssets.UIBattlePassEaster,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYear"
}
BattlePassContentHandler[BattlePassType.Ramadan] = {
  assetPath = UIAssets.UIBattlePassRamadan,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePass"
}
BattlePassContentHandler[BattlePassType.DoomVanguard] = {
  assetPath = UIAssets.UIBattlePassForDoomVanguard,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassForActSevenDay"
}
BattlePassContentHandler[BattlePassType.NewYear_Common] = {
  assetPath = UIAssets.UIBattlePassNewYear_Common,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassNewYear_Common"
}
BattlePassContentHandler[BattlePassType.Normal_Common] = {
  assetPath = UIAssets.UIBattlePass_common,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePass_common"
}
BattlePassContentHandler[BattlePassType.NormalNew1] = {
  assetPath = UIAssets.UIBattlePassNormalNew,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassNormalNew"
}
BattlePassContentHandler[BattlePassType.NormalNew2] = {
  assetPath = UIAssets.UIBattlePassNormalNew,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassNormalNew"
}
BattlePassContentHandler[BattlePassType.NormalNew3] = {
  assetPath = UIAssets.UIBattlePassNormalNew,
  cls = "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassNormalNew"
}
BattlePassUtil = {}
BattlePassUtil[BattlePassType.SeasonBattlePass] = {
  icon1 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_zhiyezhuanjing_icon_saijizhanlingjiangli1.png",
  icon2 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_zhiyezhuanjing_icon_saijizhanlingjiangli2.png",
  icon3 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_zhiyezhuanjing_icon_saijizhanlingjiangli3.png"
}
CitySkinType = {
  None = 0,
  Christmas = 2,
  SpringFestival = 3,
  Valentine = 4,
  Easter = 5,
  Common = 1000138
}
CitySkinExchangeHandler = {}
CitySkinExchangeHandler[CitySkinType.None] = {
  assetPath = UIAssets.CitySkinExchange,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange"
}
CitySkinExchangeHandler[CitySkinType.Christmas] = {
  assetPath = UIAssets.UIChristmasCitySkinExchange,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange"
}
CitySkinExchangeHandler[CitySkinType.SpringFestival] = {
  assetPath = UIAssets.UISpringFestivalCitySkinExchange,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange"
}
CitySkinExchangeHandler[CitySkinType.Valentine] = {
  assetPath = UIAssets.UIValentineCitySkinExchange,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange"
}
CitySkinExchangeHandler[CitySkinType.Easter] = {
  assetPath = UIAssets.CitySkinExchange_Easter,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange"
}
CitySkinExchangeHandler[CitySkinType.Common] = {
  assetPath = UIAssets.CitySkinExchange_Common,
  cls = "UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchange_Common"
}
LuckyRollType = {
  None = 0,
  Christmas = 2,
  SpringFestival = 3,
  Easter = 4
}
LuckyRollContentHandler = {}
LuckyRollContentHandler[LuckyRollType.None] = {
  assetPath = UIAssets.LuckyRoll,
  cls = "UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRoll"
}
LuckyRollContentHandler[LuckyRollType.Christmas] = {
  assetPath = UIAssets.UIChristmasLuckyRoll,
  cls = "UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRoll"
}
LuckyRollContentHandler[LuckyRollType.SpringFestival] = {
  assetPath = UIAssets.UISpringFestivalLuckyRoll,
  cls = "UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRoll"
}
LuckyRollContentHandler[LuckyRollType.Easter] = {
  assetPath = UIAssets.UIEasterLuckyRoll,
  cls = "UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRoll"
}
AccuRechargeType = {
  None = 0,
  Christmas = 2,
  NewYear = 3,
  SpringFestival = 4,
  Valentine = 5,
  Easter = 6,
  FestivalOverlap = 100,
  Common = 1000126
}
AccuRechargeContentHandler = {
  [AccuRechargeType.None] = {
    assetPath = UIAssets.UIAccuRechargeMain,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain"
  },
  [AccuRechargeType.Christmas] = {
    assetPath = UIAssets.AccuRechargeChristmas,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain"
  },
  [AccuRechargeType.NewYear] = {
    assetPath = UIAssets.UIAccuRechargeNewYear,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRechargeNewYear.UIAccuRechargeMainNewYear"
  },
  [AccuRechargeType.SpringFestival] = {
    assetPath = UIAssets.UIAccuRechargeSpringFestival,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain"
  },
  [AccuRechargeType.Valentine] = {
    assetPath = UIAssets.UIAccuRechargeValentine,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRechargeNewYear.UIAccuRechargeMainNewYear"
  },
  [AccuRechargeType.Easter] = {
    assetPath = UIAssets.UIAccuRechargeEaster,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain"
  },
  [AccuRechargeType.Common] = {
    assetPath = UIAssets.UIAccuRecharge_Common,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain_Common"
  },
  [AccuRechargeType.FestivalOverlap] = {
    assetPath = UIAssets.AccuRechargeFestivalOverlap,
    cls = "UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeMain_FestivalOverlap"
  }
}
SevenDayType = {
  None = 0,
  NewYear = 2,
  DoomVanguard = 3
}
SevenDayContentHandler = {}
SevenDayContentHandler[SevenDayType.None] = {
  assetPath = UIAssets.UIActSevenDayNew,
  cls = "UI.UIActivityCenterTable.Component.UIActivitySevenDay.ActSevenDay"
}
SevenDayContentHandler[SevenDayType.NewYear] = {
  assetPath = UIAssets.UIActSevenDayNewYear,
  cls = "UI.UIActivityCenterTable.Component.UIActivitySevenDay.ActSevenDay"
}
SevenDayContentHandler[SevenDayType.DoomVanguard] = {
  assetPath = UIAssets.UIActSevenDayDoomVanguard,
  cls = "UI.UIDoomVanguard.SevenDay.Component.ActSevenDayDoomVanguard"
}
SevenDayV2Type = {
  None = 0,
  NewYear = 2,
  Dominator = 3
}
SevenDayV2ContentHandler = {}
SevenDayV2ContentHandler[SevenDayV2Type.None] = {
  assetPath = UIAssets.SevenDayV2Item,
  cls = "UI/LWUIActSevenDayV2/Component/ActSevenDayV2"
}
SevenDayV2ContentHandler[SevenDayV2Type.NewYear] = {
  assetPath = UIAssets.SevenDayV2NewItem,
  cls = "UI/LWUIActSevenDayV2/Component_New/ActSevenDayV2_New"
}
SevenDayV2ContentHandler[SevenDayV2Type.Dominator] = {
  assetPath = UIAssets.SevenDayV2Item,
  cls = "UI/LWUIActSevenDayV2/Component/ActSevenDayV2"
}
BargainShopType = {
  None = 0,
  Valentine = 2,
  Common = 1000155
}
BargainShopHandler = {}
BargainShopHandler[BargainShopType.None] = {
  assetPath = UIAssets.UIActivityBargainShop,
  cls = "UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopMain"
}
BargainShopHandler[BargainShopType.Valentine] = {
  assetPath = UIAssets.UIActivityBargainShopValentine,
  cls = "UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopMain"
}
BargainShopHandler[BargainShopType.Common] = {
  assetPath = UIAssets.UIActivityBargainShop_Common,
  cls = "UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopMain_Common"
}
GiftBoxActType = {
  None = 0,
  Old = 1,
  New = 2
}
GiftBoxActHandler = {}
GiftBoxActHandler[GiftBoxActType.Old] = {
  assetPath = UIAssets.UIGiftBox,
  cls = "UI.UIActivityCenterTable.Component.GiftBox.UIGiftBox"
}
GiftBoxActHandler[GiftBoxActType.New] = {
  assetPath = UIAssets.UIGiftBoxNew,
  cls = "UI.UIActivityCenterTable.Component.GiftBoxNew.UIGiftBoxNew"
}
BanquetAttackMonsterType = {
  None = 0,
  Valentine = 2,
  Common1 = 1000160
}
BanquetAttackMonsterHandler = {}
BanquetAttackMonsterHandler[BanquetAttackMonsterType.Valentine] = {
  assetPath = UIAssets.UIBanquetAttackMonster,
  cls = "UI.UIActivityCenterTable.Component.BanquetAttackMonster.BanquetAttackMonster"
}
BanquetAttackMonsterHandler[BanquetAttackMonsterType.Common1] = {
  assetPath = UIAssets.UIBanquetAttackMonster_Common1,
  cls = "UI.UIActivityCenterTable.Component.BanquetAttackMonster.BanquetAttackMonster_Common1"
}
BanquetDropType = {Normal = 1, UpgradeTreasureBox = 2}
LimitedTimeFeastType = {
  None = 0,
  Common1 = 2,
  Common2 = 1000141
}
LimitedTimeFeastHandler = {}
LimitedTimeFeastHandler[LimitedTimeFeastType.Common1] = {
  assetPath = UIAssets.LimitedTimeFeastChristmas,
  cls = "UI.UIActivityCenterTable.Component.LimitedTimeFeast.LimitedTimeFeast"
}
LimitedTimeFeastHandler[LimitedTimeFeastType.Common2] = {
  assetPath = UIAssets.LimitedTimeFeast_Common2,
  cls = "UI.UIActivityCenterTable.Component.LimitedTimeFeast.LimitedTimeFeast_Common2"
}
SignInType = {TacticalWeapon = 1, CommonFestival = 2}
SignInHandler = {}
SignInHandler[SignInType.TacticalWeapon] = {
  assetPath = UIAssets.UITWSignInMain,
  cls = "UI.UIActivityCenterTable.Component.ActSignIn.UITacticalWeaponSignIn"
}
SignInHandler[SignInType.CommonFestival] = {
  assetPath = UIAssets.UIFestivalCommonSignIn,
  cls = "UI.UIActivityCenterTable.Component.ActSignInFestivalCommon.UIFestivalCommonSignIn"
}
SubTypeActivities = {}
SubTypeActivities[EnumActivity.BattlePass.Type] = BattlePassContentHandler
SubTypeActivities[EnumActivity.BattlePass_new.Type] = BattlePassContentHandler
SubTypeActivities[EnumActivity.BattlePass_new222.Type] = BattlePassContentHandler
SubTypeActivities[EnumActivity.CitySkinExchange.Type] = CitySkinExchangeHandler
SubTypeActivities[EnumActivity.LuckyRoll.Type] = LuckyRollContentHandler
SubTypeActivities[EnumActivity.AccuRecharge.Type] = AccuRechargeContentHandler
SubTypeActivities[EnumActivity.ActSevenDay.Type] = SevenDayContentHandler
SubTypeActivities[EnumActivity.ActSevenDayV2.Type] = SevenDayV2ContentHandler
SubTypeActivities[EnumActivity.BargainShop.Type] = BargainShopHandler
SubTypeActivities[EnumActivity.GiftBoxActivity.Type] = GiftBoxActHandler
SubTypeActivities[EnumActivity.BanquetAttackMonster.Type] = BanquetAttackMonsterHandler
SubTypeActivities[EnumActivity.LimitedTimeFeast.Type] = LimitedTimeFeastHandler
SubTypeActivities[EnumActivity.SignIn.Type] = SignInHandler
NonActivityContentHandler = {}
NonActivityContentHandler[NonActivityType.GiftBoxRank] = {
  assetPath = UIAssets.UIGiftBoxRank,
  cls = "UI.UIGiftBoxRank.View.UIGiftBoxRankView"
}
CounterAttackStage = {
  WarmUp = 0,
  Assemble = 1,
  Attack = 2,
  Settle = 3,
  End = 4
}
CounterAttackState = {
  Fighting = 1,
  Win = 2,
  Lose = 3
}
CounterAttackType = {
  AllianceCity = 1000,
  AllianceStove = 2000,
  GreenCenter = 3000
}
ActLotteryDrawType = {
  One = 1,
  Ten = 2,
  Hundred = 3
}
ActLotteryOpenBigRewardState = {
  CanCheck = 1,
  WaitMsgReturn = 2,
  WaitViewClose = 3
}
AllyDrillStage = {
  NotStart = 0,
  SelectStage = 1,
  PrepareStage = 2,
  ReadyStage = 3,
  AttackStage = 4,
  SettleStage = 5,
  End = 6
}
AllyDrillPermission = {Invisible = 0, Visible = 1}
CanCrossServerReason = {
  Disable = -2,
  System = -1,
  Global = 0,
  AllianceDuel = 1,
  CrossThrone = 2,
  CrossInvasion = 3,
  METEORITE = 4,
  LocalCross = 5,
  CrossInvasionByAllianceRallyMark = 6,
  AllianceBackServer = 7,
  ZWL_BATTLE = 8
}
MoveCrossServerType = {
  BackToSrcServer = 0,
  AllianceDuel = 1,
  CrossServerKingBattle = 2,
  SeasonBattleDesert = 3,
  MeteoriteBattleServer = 4,
  BigMap3000 = 3,
  OtherAllianceRallyPoint = 6,
  BackToSrcServerBigMap = 7,
  LandlordToCenterServer = 8
}
JumpServerMode = {
  NormalMoveCity = "NormalMoveCity",
  CrossServerMoveCity = "CrossServerMoveCity",
  PutAllianceBuild = "PutAllianceBuild",
  CrossServerKing = "CrossServerKing",
  MeteoriteBattleMoveCity = "MeteoriteBattleMoveCity"
}
ActivityEntranceType = {
  Activity = 0,
  Package = 1,
  ThemeActivity = 2
}
NewsMainType = {
  PERSIONAL = 1,
  ALLIANCE = 2,
  COUNTRY = 3
}
NewsSubType = {
  PERSONAL_BATTLE = 1,
  ALLIANCE_BATTLE = 2,
  ALLIANCE_ATK_ALLIANCE_CITY = 3,
  APPOINT_OFFICAL = 4,
  CROSS_SERVER_BATTLE = 5,
  CROSS_PLUNDER_KINGDOM = 6,
  CROSS_AREA_BATTLE = 7,
  TRAIN_ROB = 8,
  ARENA_CHAMPION = 9,
  SIEGE_EVENT = 10,
  NEWS_DETAILS = 11
}
CommonEquipType = {None = 0, SquadEquip = 1}
BagItemType = {
  Item = 1,
  ResourceItem = 2,
  HeroEquip = 3,
  CommonEquip = 4
}
SpecialResLackType = {
  Energy = 1,
  Equip = 2,
  Soldier = 3,
  Worker = 4,
  CommonEquip = 5,
  TWSkillChip = 6
}
PVPArenaState = {
  Invalide = 0,
  NotActive = 1,
  NotOpen = 2,
  Open = 3
}
PVPArenaType = {
  PeakArena = 1,
  Arena3V3 = 2,
  NewbieArenaV2 = 3,
  NewPeakArena = 4,
  NewGaleArena = 5
}
PVPArenaRewardType = {
  Rank = 1,
  Personal = 2,
  Alliance = 3
}
ActivityArenaState = {
  None = 0,
  Wait = 1,
  Fight = 2,
  Over = 3
}
ArenaBattleStateType = {
  AttackVictory = 1,
  AttackDefeat = 2,
  DefendVictory = 3,
  DefendDefeat = 4
}
CommonActivityGroupEnum = {
  GiftBox = 132,
  Scratch = 3012,
  CitySkin = 7003,
  ThanksGiving = 144,
  Christmas = 145,
  NewYear = 146,
  SpringFestival = 147,
  Valentine = 148,
  Easter = 149,
  FoodFestival = 150,
  MusicFestival = 151,
  SportFestival = 152,
  FullMoon = 153,
  Halloween = 155,
  ThanksGiving2024 = 156,
  Christmas2024 = 159,
  DoomVanguard = 1000,
  TWSignIn = 5401,
  LotteLink = 154,
  Dominator = 157,
  Valentine2025 = 160,
  Alliance = 1001,
  S0AttackCityNew = 1002
}
CommonActivityGroupTitle = {
  [CommonActivityGroupEnum.Alliance] = "alliance_main_btn_activity",
  [CommonActivityGroupEnum.S0AttackCityNew] = "city_war_main_UI_01"
}
MainUICommonActivityGroupExceptShowList = {
  [CommonActivityGroupEnum.GiftBox] = true,
  [CommonActivityGroupEnum.Scratch] = true,
  [CommonActivityGroupEnum.CitySkin] = true,
  [CommonActivityGroupEnum.ThanksGiving] = true,
  [CommonActivityGroupEnum.LotteLink] = true,
  [CommonActivityGroupEnum.DoomVanguard] = true,
  [CommonActivityGroupEnum.Alliance] = true,
  [CommonActivityGroupEnum.S0AttackCityNew] = true
}
HeroTypeBuilding = {
  [HeroType.Tank] = BuildingTypes.LW_BUILD_TANKCENTER,
  [HeroType.Missile] = BuildingTypes.LW_BUILD_ARTILLERYCENTER,
  [HeroType.Aircraft] = BuildingTypes.LW_BUILD_AIRCRAFTCENTER
}
BuildingTypeHero = {
  [BuildingTypes.LW_BUILD_TANKCENTER] = HeroType.Tank,
  [BuildingTypes.LW_BUILD_ARTILLERYCENTER] = HeroType.Missile,
  [BuildingTypes.LW_BUILD_AIRCRAFTCENTER] = HeroType.Aircraft
}
LuckyShopItemType = {LuckyShopItemType_Resource = 1, LuckyShopItemType_Item = 2}
MonsterInvasionFindSelectType = {Alliance = 1, Self = 2}
WorldLifebaState = {
  FakePlayer = 1,
  Burn = 2,
  Normal = 3
}
CityState = {RuinedCity = 500300, VirusCity = 700102}
MiaCompleteState = {
  ItemAmpleResDeficiency = 1,
  ItemAmpleResAmple = 2,
  ItemDeficiencyResAmple = 3,
  ItemDeficiencyResDeficiency = 4
}
InfiniteGiftType = {GiftPackage = 1, Reawrd = 2}
VipTipType = {
  Expired = 1,
  ExpireSoon = 2,
  ShopRefreshed = 3
}
JumpWindowType = {
  Shop = 1,
  Activity = 2,
  Other = 3
}
MailRankType = {Player = 1, Alliance = 2}
OtherWindow = {
  UIHeroQualityRecruit = 1,
  UILWTrainScene = 2,
  UIAllyDuel = 3,
  UIGovernmentActivityMain = 4,
  TacticalWeaponSkillChip = 5,
  UIDispatchTaskMain = 6,
  S1 = 7,
  BlackMarketeers = 8
}
ScoutMailTargetType = {
  DEFAULT = "DEFAULT",
  MAIN_BUILDING = "MAIN_BUILDING",
  STORAGE = "STORAGE",
  COLLECT_BUILDING = "COLLECT_BUILDING",
  TOWER = "TOWER",
  BUILDING = "BUILDING",
  MARCH = "MARCH",
  TRAIN = "TRAIN",
  ALLIANCE_CITY = "ALLIANCE_CITY",
  ZWL_BUILDING = "ZWL_BUILDING",
  DESERT = "DESERT",
  ALLIANCE_BUILD = "ALLIANCE_BUILD",
  NPC_CITY = "NPC_CITY",
  CROSS_WORM_HOLE = "CROSS_WORM_HOLE",
  DRAGON_BUILDING = "DRAGON_BUILDING",
  CROSS_THRONE_BUILDING = "CROSS_THRONE_BUILDING",
  CITY_STRONGHOLD = "CITY_STRONGHOLD",
  CITY_OUTPOST = "CITY_OUTPOST",
  WINTER_STORM_BUILDING = "WINTER_STORM_BUILDING",
  CITY_TRADE = "CITY_TRADE",
  EPIDEMIC_BUILDING = "QUARANTINE_BUILDING"
}
NoticeItemType = {
  NoticePin = 1,
  NoticeDetail = 2,
  NoticeList = 3
}
TacticalWeaponPageType = {
  Basic = 1,
  Equip = 2,
  SkillChip = 3,
  Skin = 4,
  ChipPlan = 5
}
DecorationShowGroup = {City = 0, TacticalWeapon = 1}
CitySkinSkillState = {
  NoGetPath = 1,
  Lock = 2,
  UnLock = 3,
  UnLockLimitTime = 4
}
BattleUnitType = {
  Hero = 1,
  TacticalWeapon = 2,
  Pet = 3,
  Dominator = 4
}
TrailTowerStageType = {
  Common = 0,
  Elite = 1,
  Boss = 2
}
TrailTowerTabType = {
  None = 0,
  TrailTower = 1,
  Common = 2,
  StageFeatureChapter = 3,
  EasyStageFeatureChapter = 4,
  IntegratedStageFeatureChapter = 5
}
BattleExitTimeLogType = {
  ActFrontBreakSunday = "ActFrontBreakSunday",
  Surfing = "Surfing",
  GhostParkour = "GhostParkour",
  Tower_Common = "Tower_Common",
  Tower_StageFeature = "Tower_StageFeature",
  Tower_EasyStageFeature = "Tower_EasyStageFeature",
  SkyBattle = "SkyBattle",
  StageFeatureIntegrated = "StageFeatureIntegrated"
}
TrailTowerContentHandler = {
  [TrailTowerTabType.TrailTower] = {
    assetPath = UIAssets.LWUITrailTowerSubPanel,
    cls = "UI.LWTrailTower.View.LWUITrailTowerSubView"
  },
  [TrailTowerTabType.Common] = {
    assetPath = UIAssets.LWCountBattleMapVIew,
    cls = "UI.LWCountBattle.MapUI.View.LWCountBattleMapView",
    logType = BattleExitTimeLogType.Tower_Common
  },
  [TrailTowerTabType.StageFeatureChapter] = {
    assetPath = UIAssets.LWUIStageFeatureChapter,
    cls = "UI.LWUIStageFeatureChapter.View.LWUIStageFeatureChapterView",
    logType = BattleExitTimeLogType.Tower_StageFeature
  },
  [TrailTowerTabType.EasyStageFeatureChapter] = {
    assetPath = UIAssets.LWUIEasyStageFeatureChapter,
    cls = "UI.LWUIEasyStageFeatureChapter.View.LWUIEasyStageFeatureChapterView",
    logType = BattleExitTimeLogType.Tower_EasyStageFeature
  },
  [TrailTowerTabType.IntegratedStageFeatureChapter] = {
    assetPath = UIAssets.UIStageFeatureIntegrated,
    cls = "UI.UIStageFeatureIntegrated.View.UIStageFeatureIntegratedView",
    logType = BattleExitTimeLogType.StageFeatureIntegrated
  }
}
StageFeatureIntegratedDifficulty = {
  Normal = 1,
  Hard = 2,
  Nightmare = 3
}
StageFeatureIntegratedItemPassIcon = {
  [StageFeatureIntegratedDifficulty.Normal] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia1_1.png",
  [StageFeatureIntegratedDifficulty.Hard] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia2_1.png",
  [StageFeatureIntegratedDifficulty.Nightmare] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia3_1.png"
}
StageFeatureIntegratedItemNextIcon = {
  [StageFeatureIntegratedDifficulty.Normal] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia1_2.png",
  [StageFeatureIntegratedDifficulty.Hard] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia2_2.png",
  [StageFeatureIntegratedDifficulty.Nightmare] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia3_2.png"
}
StageFeatureIntegratedItemLockIcon = {
  [StageFeatureIntegratedDifficulty.Normal] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia1_3.png",
  [StageFeatureIntegratedDifficulty.Hard] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia2_3.png",
  [StageFeatureIntegratedDifficulty.Nightmare] = "Assets/Main/Sprites/UI/StageFeatureIntegrated/zxl_qxtw_guanqia3_3.png"
}
TrailTowerType = {
  Tank = 1,
  AirPlane = 2,
  Missile = 3
}
ShareType = {Pos = 1, BargainShop = 2}
BattleReportCamp = {
  Attacker = 1,
  Defender = 2,
  ThirdParty = 3
}
CommonRankPanelType = {
  DEFAULT = 0,
  TrendsRank = 1,
  WastedlandRank = 2,
  WastedlandRankWithAlliance = 3,
  NuclearPlatRank = 4,
  BloodyNightRank = 5,
  WestwardExpansionRank = 6
}
CommonActivityRankType = {PERSONAL = 1, ALLINCE = 2}
CommonRankType = {
  NONE = 0,
  PERSONAL = 1,
  ALLIANCE = 2
}
WORLD_MONSTER_FOCUS_OFFSET_Z = 5
MANY_YEARS_LATER = 4102415999000
ActiveShowType = {PopupPackage = 1}
TitaniumBlueBoxRewardState = {
  NoComplete = 0,
  CanReceive = 1,
  Received = 2
}
DecorationBookTab = {Overview = 1, Illustrated = 2}
CapacityBoxTagType = {
  default = 0,
  decoration = 1,
  hero = 2,
  TacticalCard = 3,
  HeroAwaken = 4
}
ArchiveSaveType = {Comic = 1}
TrainRewardState = {
  Extra = 1,
  Recapture = 2,
  EnglishExtra = 3
}
BuildPreConditionType = {build = 1, monopoly = 2}
ItemLinkType = {
  None = 0,
  RES_ITEM = 1,
  EQUIP = 2,
  SQUAD_EQUIP = 3,
  DECORATION = 4,
  DroneSkillChip = 5
}
DecorationBookFilterType = {
  All = 1,
  Have = 2,
  NotHave = 3
}
CityDecorationShowConditionType = {
  ServerOpenDay = 1,
  GameSeason = 2,
  AbsoluteTime = 3,
  GameSeasonDays = 4,
  OnlyInSeason = 5,
  OnlyInSeasonSettle = 6
}
HeroBackStoryShowConditionType = {GameSeason = 1}
ApplyEnterAllianceConditionType = {Power = 1, BaseLevel = 2}
ChatOperationBtnType = {
  Copy = 1,
  Translate = 2,
  Reply = 3,
  Report = 4,
  Up = 5,
  Down = 6,
  Emoji = 7,
  Share = 8,
  Recall = 9,
  TranslateAll = 10,
  Delete = 11,
  Reaction = 12
}
TranslateStateType = {
  TranslationError = -1,
  NotTranslated = 0,
  Translating = 1,
  TranslationCompleted = 2
}
TranslateSaveDataFuncType = {GiftHistory = 1, NoticeRecord = 2}
ChatCommonShareMethodType = {
  Download = 1,
  Chat = 2,
  FriendCircle = 3
}
ChatViewTipBubbleType = {
  AlHelp = 1,
  TrainTip = 2,
  RedPackage = 3,
  Treasure = 4,
  HighFive = 5,
  AllianceCongratulation = 6
}
ChatJumpSeqIdType = {TargetGoToFirst = 0, TargetGotoCenterAndEffect = 1}
ChatPhotoSource = {PlayerDetailFriendsCircle = 1}
ChatBigPhotoListViewType = {
  Normal = 1,
  Editor = 2,
  Revert = 4
}
FormationSaveType = {
  PVESquadAuto = 0,
  PVESquad = 1,
  TruckDefenceSquad = 4,
  TruckAttackSquad = 8,
  DominatorAndHero345 = 13,
  OnlyDominator = 14,
  DominatorNormal = 15,
  ParkourOneHero = 17,
  ParkourTwoHero = 18,
  ParkourThreeHero = 19,
  ParkourFourHero = 20,
  T11IdleGameBattleEvent = 22,
  SeasonTower = 23
}
TWSkillChipFormationType = {
  None = 0,
  ArmyFormation = 1,
  Formation3V3Atk = 2,
  Formation3V3Def = 3,
  TruckDeparture = 4,
  ChampionDuel = 5,
  TruckRob = 6,
  KOFDefence = 7,
  KOFAttack = 8
}
DeclareCondition = {
  AdjacentCity = 1,
  OccupyLimit = 2,
  DeclareLimit = 3,
  NewAlliance = 4,
  SmallAlliance = 5,
  LevelOne = 6,
  AdjacentStronghold = 7,
  AdjacentDesert = 8
}
AlarmUIOpenType = {MainUI = 1, DesertBattleUI = 2}
ResLackContextType = {
  Good = 1,
  ResItem = 2,
  Resource = 3,
  Energy = 10,
  Equip = 11,
  Soldier = 12,
  Worker = 13,
  CommonEquip = 14,
  TWSkillChipExp = 15,
  TWSkillChip = 16,
  BuildingDecoration = 17,
  Mummy = 18,
  MainCitySkin = 19,
  TacticalCard = 20
}
TruckRecordType = {
  TruckSend = 1,
  TruckRob = 2,
  TruckCollect = 3
}
TruckStateType = {
  Safe = 1,
  Robed = 2,
  DefendSuccess = 3
}
GuaranteedBoxGoodsShowType = {ShowWhenHave = 0, Always = 1}
PayErrorCode = {
  PAY_SUCCESS = 0,
  CHECK_FAIL = 1,
  ORDER_EXIST = 2,
  PLATFORM_CONNECT_ERROR = 3,
  ORDER_TRANSFER = 6
}
AllianceBuildType = {
  None = 0,
  Outpost = 1,
  Center = 2,
  ZombieRush = 3,
  StoveCenter = 4,
  Carrier = 5,
  Attachment = 6,
  MilitaryCenter = 7,
  MilitaryCenterS4 = 8,
  SiegeCamp = 1000,
  AresMissile = 2000,
  GoddessMummy = 2000
}
DetectEventTreasureClaimState = {
  NoClaim = 0,
  NormalClaim = 1,
  DoubleClaim = 2
}
ZombieRushRewardTabType = {Alliance = 1, Personal = 2}
UserGuideType = {ZombieRush = 1}
ZombieRushType = {ZombieRush = 1}
ZombieRushStatus = {
  None = 0,
  NoOpen = 1,
  Open = 2,
  Search = 3,
  CD = 4,
  End = 5,
  NoAlliance = 6
}
ZombieRushAllianceStatus = {
  Prepare = -1,
  Ready = 0,
  InBattle = 1,
  Failure = 2,
  Success = 3
}
ZombieRushUserStatus = {
  NoJoin = -1,
  Doing = 0,
  Failure = 1,
  Success = 2
}
SeasonTrendTaskType = {Dotnate = 11}
AllianceSettleType = {Normal = 1, Farmer = 2}
SeasonDigGameType = {Single = 1, Alliance = 2}
SeasonGreenRank = {Season = 1, Week = 2}
DispathTreasureExchangeItemType = {
  None = 1,
  Top = 2,
  Down = 3
}
HeroDetailPageType = {
  HeroGrowth = 1,
  HeroSkill = 2,
  HeroRank = 3,
  HeroUniqueWeapon = 4,
  HeroAwaken = 5
}
DispathTreasureExchangeTopItemType = {Receive = 1, Lose = 2}
SplinterExchangeType = {
  DispatchTreasure = {
    Id = 1,
    LogRedPoint = "TREASURE_FRAGMENT"
  },
  SeasonSynthesiss = {Id = 2},
  CookingIngredients = {Id = 3},
  DigTreasure = {Id = 4}
}
DispathTreasureRewardType = {
  Common = 0,
  Normal = 1,
  Rare = 2,
  Epic = 3
}
SplinterExchangeLogType = {Own = 1, Alliance = 2}
SeasonScoreRewardPanelType = {
  PersonalOccupyLand = 1,
  PersonalContributeAchievement = 2,
  AllianceStrongholdAchivement = 3
}
WorldAllianceCityType = {
  City = 1,
  Canon = 2,
  King = 3,
  Stronghold = 4,
  TradingStation = 5,
  MissileFactory = 6,
  GoldTree = 7,
  Mountain = 8,
  CrossZoneOutpost = 9,
  CrossZoneOutpostCanon = 10,
  Altar = 11,
  MiniGame = 12,
  LLNormalCity = 101,
  LLThroneCity = 105,
  LLCanon = 106,
  LLBuffCity = 107
}
SEASON_BUILD_GROUND_ID = 95
GatherResourceSpecialType = {
  Common = 0,
  Radar = 1,
  BlackLand = 3
}
LeadingQuestPowerUpType = {
  Building = 1,
  Hero = 2,
  Science = 3,
  Army = 4,
  SquadEquip = 5
}
BGMPlayingSourceType = {
  Defaul = 0,
  DecorationBGM = 1,
  EffectBGM = 2
}
DecorationSkillType = {
  Music = 1,
  Season = 2,
  Sound = 3,
  SeasonMummy = 4,
  SeasonRainforest = 5
}
EffectLackGotoType = {SeasonTrendMain = 1000}
DoomCommanderTaskType = {
  Monopoly = 1,
  Detect = 2,
  AllStage = 3,
  ArenaV2 = 4,
  LockHart = 5
}
FunctionOnType = {FestivalEntrance = 1, Activity = 2}
CommunityLinkState = {
  NotSkip = 1,
  CanGetSkipReward = 2,
  CannotBinding = 3,
  CanBinding = 4,
  CanGetBindingReward = 5,
  ClaimedBindingReward = 6
}
QuestionnaireRewardStatus = {
  NotAvailable = 0,
  CanReceive = 1,
  AlreadyReceive = 2
}
QuestionnaireType = {
  LimitedTime = 1,
  Permanent = 2,
  Return = 5
}
StatusId = {
  MusicSkillStatusId = 500500,
  BloodyNightGetMoreAward = 704070,
  BloodyNightDropMoreAward = 704004,
  BloodyNightHunterEnhance = 704716
}
StatusType2 = {
  MusicFestivalSkill = 25,
  SkinAnimationType = 26,
  SkinAnimationType2025Easter = 28,
  BuildingRewardBubble1 = 31,
  BuildingRewardEffect = 32,
  BuildingRewardBubble2 = 33,
  BuildingEffect = 34,
  BuildingRewardBubble3 = 35,
  Whistler = 37,
  MusicFestival2025_RewardBubble = 38
}
SkillMovingLogicType = {
  TeamZeroPos = 1,
  UnitNormalFormationPos = 2,
  PlayAnimation = 3,
  MoveToIndex = 4,
  RotateToIndex = 5,
  LockPos = 6,
  LockRotate = 7,
  RotateToFormationPos = 8,
  RotateToAngle = 9,
  CrossFade = 10,
  TeamCustomPos = 11
}
ChampionDuelState = {
  Default = 0,
  SignIn = 1,
  SignInAnnouncement = 2,
  PreStage = 3,
  PreStageAnnouncement = 4,
  Rematch = 5,
  RematchAnnouncement = 6,
  KnockOut = 7,
  FinalShow = 8
}
ChampionDuelDonateBoxState = {
  NoComplete = 0,
  CanReceive = 1,
  Received = 2
}
GameStoreType = {Google = 1, Apple = 2}
SeeDetectEventGetTreasureClaimInfoType = {Chat = 1, World = 2}
WorldTreasureType = {
  RadarTreasure = 1,
  SiegeTreasure = 2,
  ActivityRadarTreasure = 3,
  InvasionTreasure = 5,
  ZONE_MOBILIZATION = 6,
  SandWormTreasure = 7,
  AllianceBossSandBox = 8,
  PlayerKillMonsterTreasure = 9,
  FlowerCar = 10,
  OffSeasonDetect = 11,
  BloodyQueen = 12,
  GeneFragment = 13,
  FlowerTrainUpgradeTreasure = 15,
  FlowerTrainCheerTreasure = 16,
  WolfShadow = 17,
  S1PrefabSeasonBossTreasure = 18,
  S1PrefabWorldBossTreasure = 19,
  ZWL_GIFT = 20,
  Crocodile = 21
}
TreasureState = {
  NotStart = 0,
  Digging = 1,
  DiggingPause = 2,
  Complete = 3
}
CanvasOrder = {Cloud = 10, PvpAlarm = 20}
HeroPropertyDetailShowTitle = {
  Base = "151099",
  Attack = "building_center_desc4",
  Defend = "building_center_desc5"
}
GuideVFXPriority = {
  Low = 1,
  Middle = 50,
  High = 100
}
AllianceLogTab = {
  {
    title = "alliance_record_tab_1"
  },
  {
    title = "alliance_record_tab_2"
  },
  {
    title = "alliance_record_tab_3"
  },
  {
    title = "alliance_record_tab_4"
  }
}
SkillCastType = {
  None = 0,
  AutoAttack = 1,
  Active = 2,
  Passive = 3,
  Talent = 4,
  HeroAwaken = 5
}
SkillDisplayType = {
  PhysicalDamage = 1,
  EnergyDamage = 2,
  PhysicalDefense = 3,
  EnergyDefense = 4,
  Buff = 5,
  Debuff = 6,
  None = 0
}
MAIL_DAMAGEPAGE_DAMAGE_STAT = {
  physicalDamage = {
    key = "battle_stats_detail2",
    order = 1
  },
  magicDamage = {
    key = "battle_stats_detail3",
    order = 2
  },
  sputterDamage = {
    key = "battle_stats_detail4",
    order = 3
  },
  dotDamage = {
    key = "battle_stats_detail5",
    order = 4
  },
  critDamage = {
    key = "battle_stats_detail6",
    order = 5
  },
  critNum = {
    key = "battle_stats_detail7",
    order = 6
  },
  dizzyNum = {
    key = "battle_stats_detail9",
    order = 8
  },
  dispelNum = {
    key = "lw_sum_qusan",
    order = 9
  },
  dispelDebufNum = {
    key = "lw_sum_jinghua",
    order = 10
  },
  realDamage = {
    key = "real_damage",
    order = 11
  },
  shieldDamage = {
    key = "shield_damage_sum_name",
    order = 12
  },
  immuneBuffCount = {
    key = "disruption_num_name",
    order = 13
  }
}
MAIL_DAMAGEPAGE_TAKEN_DAMAGE_STAT = {
  physicalInjured = {
    key = "battle_stats_detail11",
    order = 1
  },
  magicInjured = {
    key = "battle_stats_detail10",
    order = 2
  },
  defenseNum = {
    key = "battle_stats_detail12",
    order = 3
  },
  defenseDamage = {
    key = "battle_stats_detail13",
    order = 4
  }
}
SeasonAchivementFlag = {
  Personal = 0,
  Alliance = 1,
  Camp = 2
}
SeasonAchivementFlagFilter = {
  All = {
    [SeasonAchivementFlag.Personal] = true,
    [SeasonAchivementFlag.Alliance] = true,
    [SeasonAchivementFlag.Camp] = true
  },
  Personal_Alliance = {
    [SeasonAchivementFlag.Personal] = true,
    [SeasonAchivementFlag.Alliance] = true
  },
  Camp = {
    [SeasonAchivementFlag.Camp] = true
  }
}
UIActSnowStormRewardPanelType = {SnowStormReward = 1, NuclearBuilding = 2}
UIActSnowStormRewardTabType = {Tab1 = 1, Tab2 = 2}
PERSONAL_FURNACE_STATE = {
  CLOSE = 0,
  RUN = 1,
  OVER_RUN = 2
}
LWUIBerserkBossRankTabType = {
  TotalPersonalDamage = 1,
  Boss = 2,
  TotalAllianceDamage = 3
}
LWUIBerserkBossRankType = {Personal = 0, Alliance = 1}
TorchRelayScenePropsMainType = {Obstacles = 1, Buff = 2}
TorchRelayScenePropsType = {
  StrengthAdd = 1,
  SpeedAdd = 2,
  Defend = 3,
  AutoCollect = 4,
  Invincible = 5,
  TreasureBox = 6,
  Obstacles = 7,
  ZombieObstacles = 8
}
TorchRelayScenePropsBornLine = {
  Left = 1,
  Middle = 2,
  Right = 3
}
TorchRelayBuffState = {
  SpeedAdd = 1,
  Defend = 2,
  AutoCollect = 3,
  Invincible = 4,
  InvincibleBeAttacked = 5,
  StrengthAdd = 6
}
RewardCriticalEffectImage = {
  "",
  "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_2bei.png",
  "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_3bei.png",
  "",
  "Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_5bei.png"
}
HeroEquipQuality = {
  Green = 2,
  Blue = 3,
  Purple = 4,
  Orange = 5,
  Red = 6
}
ItemGotoParaType = {Activity = 19}
ActivitySnowStormState = {
  NoStart = 0,
  Warning = 1,
  SnowStorm = 2,
  Reward = 3,
  End = 4
}
SeasonFactionDeclareWarStep = {
  declare_before = 0,
  declare = 1,
  invite = 2,
  battle_before = 3,
  battle = 4,
  battle_after = 5
}
OpMode = {
  EnterWorld = 1,
  ClickBtnThawing = 2,
  ClickBtnFrozen = 3,
  ClickBtnFireWillOn = 4,
  ClickBtnFireWillOff = 5,
  ClickBtnWorldSupplies = 6,
  ClickBtnResource = 7,
  ClickBtnWorldCity = 8,
  ClickBtnMummyYard = 9,
  ClickBtnMummyMainTab1 = 10,
  ClickBtnMummyMainTab2 = 11,
  ClickBtnResourceLack10 = 12,
  ClickBtnResourceLack13 = 13,
  ClickBtnResourceLack11014 = 14,
  ClickBtnGoldenBeetleBoss = 15,
  ClickBtnAllianceCenter = 16,
  ClickBtnTradeShop = 17,
  ClickBtnKingCity = 18,
  ClickBtnDesertCity = 19,
  ClickBtnDesertSupplies = 20,
  ClickBtnWorldSurprisePoint = 21,
  ClickBtnWorldGreen = 22,
  ClickBtnMainUISandWorm = 23,
  ClickBtnMummyYardOffSeason = 24,
  ClickBtnFixLightHouse = 25,
  ClickBtnGotPowerWorker = 26,
  ClickBtnActiveLightHouse = 27,
  ClickBtnLightHouseTab2 = 28,
  ClickBtnMakeMarchWithLight = 29,
  ClickBtnMilitaryCenter = 30,
  ClickBtnBloodyNight = 31,
  ClickBtnS4Tree = 32,
  ClickBtnS4LuckyCat = 33,
  ClickBtnS4WinePub = 34,
  ClickBtnGetEasterEgg = 35,
  ClickBtnS4WinePub2 = 36,
  ClickBtnS4TreePray = 37,
  ClickBtnBloodyNightMonster = 38,
  ClickBtnBloodyNightFlowerCar = 39,
  ClickBtnBloodyNightBoss = 40,
  ClickBtnTacticalCards = 41,
  ClickGoldTreeThird = 42,
  ClickBtnVirusEntry = 43,
  ClickBtnSearchMonster = 44,
  ClickBtnStrongholdMonster = 45,
  ClickBtnWeather = 46,
  ClickMonsterWithVirus = 47,
  ClickBtnOutpost = 48,
  ClickBtnGeneFragment = 49,
  BuildBoxOpenFinish821000 = 50,
  ClickBtnShowMakingCoffeeView = 51,
  BuildBoxOpenFinish827000 = 52,
  ClickBtnStrongholdCity = 53,
  ClickBtnOutpostCity = 54,
  ClickBtnBigKingCity = 55,
  ClickBtnMilitary = 56,
  ClickBtnAltarCity = 57
}
LWSeasonBattleFieldRewardPanelType = {
  BattleField = 1,
  Camp = 2,
  FamerReward = 3,
  GreenReward = 4
}
SeasonRankType = {
  AlliancePower = 1,
  PersonalPower = 2,
  ServerPower = 3,
  PersonalCrossServerPower = 4,
  AllianceCrossServerPower = 5,
  AllianceRareLand = 6,
  AllianceCamp1RareLand = 7,
  AllianceCamp2RareLand = 8,
  CampRareLand = 9,
  ServerRareLand = 10,
  ServerFamer = 11,
  CampPower = 12,
  AllianceCamp1Power = 13,
  AllianceCamp2Power = 14
}
SeasonRankGroup = {
  Personal = 1,
  Alliance = 2,
  Server = 3,
  Camp = 4
}
LayoutSizeChangeType = {
  MainUIResourceBar = "MainUI.ResourceBar",
  MainUILeftTopLayout = "MainUI.Left.Top.Layout"
}
ActivityTorchRelayTaskType = {Daily = 1, Milestones = 2}
GuideID = {EpidemicBattleGuide = 6100}
ScoutLevel = {
  Base = 1,
  SquadPower = 2,
  HeroEquip = 3,
  HeroSkill = 4,
  HonorWallPower = 5,
  HonorWallDetail = 6,
  DecoPower = 7,
  DecoDetail = 8,
  SciencePower = 9,
  ScienceDetail = 10,
  TacticalWeaponPower = 11,
  TacticalWeaponLv = 12,
  TWComponentLv = 13,
  TWSkillChip = 14,
  TWSkillChipLv = 15,
  TWSkillChipStar = 16,
  HeroUniqueWeaponLv = 17,
  InCitySoldierCount = 18,
  InCitySoldierDetail = 19,
  SoldierEffect = 20,
  HospitalSoldierCount = 21,
  HospitalSoldierDetail = 22
}
VisitorDialogType = {TemperatureLogic = 1, CommonRandomLogic = 2}
Vip18Constant = {
  HIDE_PANEL_ANI_TIME = 0.5,
  SHOW_PANEL_ANI_TIME = 0.5,
  DELAY_TIME = 0.2
}
FightActionParamType = {
  Default = 1,
  Addon = 2,
  Splash = 3,
  RealDamage = 17
}
FetchPicVerFuncType = {
  PlayerHeadIcon = 0,
  ChatSendPhoto = 1,
  MomentPhoto = 2,
  SeasonAlliancePhoto = 3,
  ChatAllianceNoticePhoto = 4,
  ChatAlNoticePhotoNew = 5
}
PhotoFuncType = {
  None = -1,
  PlayerHeadCamera = 0,
  PlayerHeadPickPhoto = 1,
  ChatSendPickPhoto = 2,
  MomentPickPhoto = 3,
  ChatAllianceNoticePhoto = 4,
  NewsCenter = 5,
  CommonMulSelect = 6
}
PhotoNativeFuncType = {
  Camera = 0,
  PickPhotoEditor = 1,
  PickSinglePhoto = 2,
  PickPhotoList = 3
}
PhotoUploadState = {
  None = -1,
  Uploading = 0,
  UploadSuccess = 1,
  UploadFail = 2,
  WaitPicVer = 3
}
MainCityPreviewZoneType = {
  None = 0,
  City = 1,
  World = 2
}
ScreenEffectSceneFilter = {
  None = 0,
  City = 1,
  World = 2
}
ScreenEffectParentType = {Camera = 1, WorldCameraPoint = 2}
GhostreconTaskType = {
  Own_NotExecuted = 1,
  Own_TeamingUp = 2,
  Own_Runing = 3,
  Own_WaitClaim = 4,
  Own_Claimed = 5,
  Alliance_TeamingUp = 6,
  Alliance_Runing = 7,
  Alliance_WaitClaim = 8,
  Alliance_Claimed = 9
}
GhostreconPointStealType = {
  Preview = 1,
  CanSteal = 2,
  UnSteal = 3,
  UnShow = 4
}
GhostreconQuality = {
  Bule = 3,
  Purple = 4,
  Yellow = 5,
  SuperYellow = 6
}
GhostreconBubbleIconImg = {
  [GhostreconTaskType.Own_NotExecuted] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_03",
    [GhostreconQuality.Purple] = "ljq_youling_icon_03",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_04",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_04"
  },
  [GhostreconTaskType.Own_TeamingUp] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_11",
    [GhostreconQuality.Purple] = "ljq_youling_icon_01",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_02",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_02"
  },
  [GhostreconTaskType.Own_Runing] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_12",
    [GhostreconQuality.Purple] = "ljq_youling_icon_05",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_06",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_06"
  },
  [GhostreconTaskType.Own_WaitClaim] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_09",
    [GhostreconQuality.Purple] = "ljq_youling_icon_13",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_07",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_07"
  },
  [GhostreconTaskType.Alliance_TeamingUp] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_11",
    [GhostreconQuality.Purple] = "ljq_youling_icon_01",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_02",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_02"
  },
  [GhostreconTaskType.Alliance_Runing] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_12",
    [GhostreconQuality.Purple] = "ljq_youling_icon_05",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_06",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_06"
  },
  [GhostreconTaskType.Alliance_WaitClaim] = {
    [GhostreconQuality.Bule] = "ljq_youling_icon_09",
    [GhostreconQuality.Purple] = "ljq_youling_icon_13",
    [GhostreconQuality.Yellow] = "ljq_youling_icon_07",
    [GhostreconQuality.SuperYellow] = "ljq_youling_icon_07"
  }
}
GhostreconQualitySetting = {
  [GhostreconQuality.Bule] = {
    BubbleTextColor = Color.New(0.1411764705882353, 0.3686274509803922, 0.5686274509803921, 1)
  },
  [GhostreconQuality.Purple] = {
    BuildBg = "ljq_youling_pinzhi_zi_02",
    ChatBuildBg = "ljq_youling_pinzhi_zi_01",
    BuildImg = "ljq_youling_jianzhu01",
    QualityImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ssr",
    BannerImg = "ljq_youling_bg_01",
    BoxImg = "ljq_youling_baoxiang_01.png",
    RewardTitleImg = "ljq_youling_tiaofu_01.png",
    BubbleTextColor = Color.New(0.4588235294117647, 0.14901960784313725, 0.7764705882352941, 1),
    RemindBg = "Assets/Main/Sprites/UI/UIChatNew3/lrb_tongmenghuoche_ssRbg.png",
    AccPointNum = 100
  },
  [GhostreconQuality.Yellow] = {
    BuildBg = "ljq_youling_pinzhi_cheng_02",
    ChatBuildBg = "ljq_youling_pinzhi_cheng_01",
    BuildImg = "ljq_youling_jianzhu02",
    QualityImg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur",
    BannerImg = "ljq_youling_bg_02",
    BoxImg = "ljq_youling_baoxiang_02.png",
    RewardTitleImg = "ljq_youling_tiaofu_02.png",
    BubbleTextColor = Color.New(0.6274509803921569, 0.25098039215686274, 0 / 255, 1),
    RemindBg = "Assets/Main/Sprites/UI/UIChatNew3/lrb_tongmenghuoche_URbg.png",
    AccPointNum = 200
  },
  [GhostreconQuality.SuperYellow] = {
    BuildBg = "ljq_youling_pinzhi_cheng_02",
    ChatBuildBg = "ljq_youling_pinzhi_cheng_01",
    BuildImg = "ljq_youling_jianzhu03",
    QualityImg = "Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_urxing",
    BannerImg = "ljq_youling_bg_03",
    BoxImg = "ljq_youling_baoxiang_02.png",
    RewardTitleImg = "ljq_youling_tiaofu_02.png",
    BubbleTextColor = Color.New(0.6274509803921569, 0.25098039215686274, 0 / 255, 1),
    RemindBg = "Assets/Main/Sprites/UI/UIChatNew3/lrb_tongmenghuoche_URbg.png",
    AccPointNum = 500
  }
}
GhostreconState = {
  NoOpen = 1,
  BeforOpen = 2,
  Open = 3,
  AfterOpen = 4
}
GhostreconEnterTipState = {
  None = 1,
  FirstIn = 2,
  MemberFull = 3
}
DailyPackageType = {
  Hero = 1,
  HeroUniqueWeapon = 2,
  HeroAwaken = 3
}
GetDuelScoreType = {Person = 1, Ally = 2}
ScoreType = {
  TrainSolider = 4,
  SciencePowerUp = 6,
  Shop = 20,
  BuildPowerUp = 23,
  Recruit = 42,
  Speed = 51,
  Stamina = 86,
  HeroUpgrade = 87,
  TWUpgrade = 108
}
SpeedScoreValue = {
  Soldier = 4,
  Science = 6,
  Build = 7,
  Heal = 9
}
WorldPreviewType = {
  Default = 0,
  AllianceCity = 1,
  PlayerCity = 2,
  AllyDrillBase = 3,
  Truck = 4,
  Train = 5,
  Dispatch = 6,
  Boss = 7,
  Monster = 8,
  GatherResource = 9,
  Rally = 10,
  Troop = 11,
  DragonBuilding = 12,
  SeasonDesert = 13,
  WinterEntity = 14,
  ZombieRushBuilding = 15,
  AllianceBuilding = 16,
  WorldTrigger = 17,
  DetectCaveExplore = 18,
  Radar = 19,
  MeteoriteRes = 20,
  EpidemicBuild = 21,
  HSR = 22,
  FlowerTrainReward = 23,
  PlayerCityRuin = 24,
  HighThanMultiObjects = 999
}
WorldPreviewTypeSort = {
  [WorldPreviewType.SeasonDesert] = 1,
  [WorldPreviewType.AllianceCity] = 10,
  [WorldPreviewType.PlayerCity] = 10,
  [WorldPreviewType.AllyDrillBase] = 10,
  [WorldPreviewType.GatherResource] = 10,
  [WorldPreviewType.DragonBuilding] = 10,
  [WorldPreviewType.WinterEntity] = 10,
  [WorldPreviewType.EpidemicBuild] = 10,
  [WorldPreviewType.MeteoriteRes] = 11,
  [WorldPreviewType.ZombieRushBuilding] = 10,
  [WorldPreviewType.AllianceBuilding] = 10,
  [WorldPreviewType.Radar] = 11,
  [WorldPreviewType.DetectCaveExplore] = 11,
  [WorldPreviewType.WorldTrigger] = 12,
  [WorldPreviewType.Dispatch] = 15,
  [WorldPreviewType.Boss] = 15,
  [WorldPreviewType.Monster] = 15,
  [WorldPreviewType.Truck] = 20,
  [WorldPreviewType.Train] = 30,
  [WorldPreviewType.HSR] = 30,
  [WorldPreviewType.PlayerCityRuin] = 10,
  [WorldPreviewType.Rally] = 40,
  [WorldPreviewType.Troop] = 50,
  [WorldPreviewType.Default] = 999
}
FishingState = {
  None = 0,
  NotStart = 1,
  Charge = 2,
  Wait = 3,
  Early = 4,
  Hook = 5,
  Unhook = 6,
  Reap = 7,
  Confiscate = 8,
  Reward = 9
}
ItemSpdMenu2SpeedScoreValue = {
  [ItemSpdMenu.ItemSpdMenu_Soldier] = SpeedScoreValue.Soldier,
  [ItemSpdMenu.ItemSpdMenu_Science] = SpeedScoreValue.Science,
  [ItemSpdMenu.ItemSpdMenu_City] = SpeedScoreValue.Build,
  [ItemSpdMenu.ItemSpdMenu_Heal] = SpeedScoreValue.Heal
}
GetDuelScoreType2SettingKey = {
  [GetDuelScoreType.Person] = SettingKeys.GETDUELSCORE_PERSON,
  [GetDuelScoreType.Ally] = SettingKeys.GETDUELSCORE_ALLY
}
BattleSummonType = {
  Monster = 0,
  Hero = 1,
  RangeMonster = 2,
  TriggerItem = 3,
  RangeTriggerItem = 4
}
BattlePetTargetedType = {
  Invisible = 0,
  OnlySelf = 1,
  ExcludeEnemy = 2,
  Any = 3,
  OnlyEnemy = 4
}
BattleSearchType = {
  None = 0,
  Zombie = 1,
  Member = 2,
  Junk = 4,
  Plot = 8,
  TacticalWeapon = 16,
  InvisiblePet = 32,
  OnlySelfPet = 64,
  ExcludeEnemyPet = 128,
  AllTargetedPet = 256,
  OnlyEnemyPet = 512,
  All = 1023
}
VipRequestSource = {
  VipView = 1,
  PayManager = 2,
  PassDay = 3,
  VipLevelUp = 4,
  UpdatePassDay = 5,
  UseVipItem = 6,
  PackPurchase = 7
}
ObjectPoolTag = {
  Normal = CS.ObjectPoolTag.Normal,
  Battle = CS.ObjectPoolTag.Battle,
  BattleScene = CS.ObjectPoolTag.BattleScene,
  BattleBullet = CS.ObjectPoolTag.BattleBullet,
  City = CS.ObjectPoolTag.City
}
ObjectPoolTagGroup = {
  Normal = CS.ObjectPoolTagGroup.Normal,
  Battle = CS.ObjectPoolTagGroup.Battle
}
BuyDiamondViewType = {Normal = 1, PopUp = 2}
LoadPriority = {
  Low = 0,
  Medium = 1,
  High = 2
}
PVPBattleOvertimeType = {
  None = 0,
  Normal = 1,
  Overtime = 2
}
BagResourceOverviewTabType = {
  Resource = 1,
  SpeedUp = 2,
  Other = 3
}
BagResourceOverviewShowTimeType = {
  Day = 1,
  Hour = 2,
  Minute = 3
}
EffectNumberDisplayTypeGallery = {NoneBattle = 4}
SeasonFactionType = {
  None = 0,
  Rebels = 1,
  Gendarmerie = 2,
  Central = 3
}
NuclearPowerRankType = {
  buildingZone = 1,
  buildingPerson = 2,
  bossHurtPersaon = 3
}
HeroRecruitTimeConditionType = {
  Season = "106",
  SeasonStartDay = "107",
  ServerOpenDay = "8",
  ServerId = "25"
}
ActMigrationMyState = {
  UnApply = 0,
  Applied = 1,
  Approved = 2,
  Refused = 3,
  GiveUp = 4,
  Success = 5
}
ActMigrationState = {
  Notice = 1,
  Prepare = 2,
  Apply = 3,
  Migrate = 4,
  Announce = 5
}
ActMigrationIdentity = {
  Low = 0,
  Normal = 1,
  High = 2,
  SuperLow = 3
}
ActMigrationAllianceTagType = {
  Normal = 0,
  Favor = 1,
  Language = 2
}
AlliancePrivilegeType = {R4Expansion = 1, DetectTreasureGetRewardNumExpansion = 2}
MapStickerOpenType = {Wrold = 1, Decoration = 2}
NewPeakArenaBoxImg = {
  [1] = {
    closeImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_1"),
    openImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_2")
  },
  [2] = {
    closeImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_3"),
    openImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_4")
  },
  [3] = {
    closeImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_5"),
    openImg = string.format(LoadPath.UIPersonalArms, "cfm_huodong_gerenjunbei_baoxiang_xiao_6")
  }
}
ActivityFestivalIconType = {Single = 0, Group = 1}
UIVfxLifeType = {
  Stay = 1,
  HideAfterOnce = 2,
  DestroyAfterOnce = 3
}
AllianceLeaveTipsUnlockConditionType = {
  None = 0,
  Activity = 1,
  SeasonDayRange = 2,
  ZoneMobilization = 3,
  ServerOpenWeak = 4
}
NewPeakArenaState = {
  Invalide = 0,
  FirstPreview = 1,
  Preview = 2,
  Open = 3,
  Finshed = 4
}
NewPeakArenaLevel = {
  None = 0,
  Advanced = 1,
  Intermediate = 2
}
NewGaleArenaLevel = {
  None = 0,
  Basic = 1,
  Intermediate = 2,
  Advanced = 3
}
ActivityAlarmClockState = {
  NoOpen = 1,
  Doing = 2,
  End = 3
}
ActivityAlarmClockType = {
  AllyDrill = 2,
  ZombieRush = 3,
  ReserveSiege = 4,
  AllianceMark = 5,
  DesertWall = 6,
  MonsterInvasion = 7,
  KingdomPosition = 8,
  AllianceTrain = 9,
  AllianceStar = 10,
  KillZombie = 11,
  Meteorite = 12,
  Epidemic = 13,
  QueenOfBlood = 14,
  AllyDrillBooking = 15,
  DsbDuel = 16,
  ChampionDuel = 17,
  S0AllianceBossAppoint = 18,
  S0AllianceBossBattle = 19,
  BFWinter = 20
}
ActivityAlarmClockSystemType = {DayFree = 1}
ActivityAlarmClockGroupType = {
  Doing = -1,
  Today = -2,
  Tomorrow = -3,
  DayAfterTomorrow = -4,
  Alliance = 1
}
FlyText3DType = {
  Normal = 1,
  Crit = 2,
  ShieldBreaking = 3
}
InvasionAisillaActStatus = {
  NONE = 0,
  CREATE = 1,
  KILL = 2,
  ESCAPE = 3
}
CollectLimitLevel = {
  None = 0,
  Yellow = 1,
  Red = 2
}
BagResOverViewOtherType = {
  HeroExp = ResourceItemId.HeroExp,
  Gold = 100,
  Stamina = 107
}
BagResOverViewOtherSetting = {
  [BagResOverViewOtherType.HeroExp] = {
    iconName = "hero_exp_statistics"
  },
  [BagResOverViewOtherType.Gold] = {
    iconName = "item_diamonds_statistics",
    iconPath = "Assets/Main/Sprites/ItemIcons/item406.png"
  },
  [BagResOverViewOtherType.Stamina] = {
    iconName = "item_stamina_statistics",
    iconPath = "Assets/Main/Sprites/ItemIcons/Common_icon_stamina.png"
  }
}
WorldStickerType = {Build = 1, March = 2}
CommonTipConfirmType = {SeasonFarmerRewardTip = 1}
ArenaBubbleType = {
  None = 1,
  New = 2,
  VS = 3,
  ShowFirst = 4,
  ChampionDuel = 5
}
EffectOverviewSourceType = {ProfessionSpecialization = 1}
CommonRecordPanelType = {SeasonRewardRecord = 2}
HeroParkingSquadNameId = {
  [1] = 800351,
  [2] = 800352,
  [3] = 800353,
  [4] = 800354
}
UIVfxLifeType = {
  Stay = 1,
  HideAfterOnce = 2,
  DestroyAfterOnce = 3
}
GoodsType113DecorationEternalType = {
  None = 0,
  HaveDeco = 1,
  HaveGoods = 2
}
TacticalChipType = {
  Opening = 1,
  Attack = 2,
  Disturb = 3,
  Defend = 4
}
TacticalChipFocusType = {
  LeiDa = 1,
  DianChi = 2,
  YinQing = 3,
  XinPian = 4
}
TacticalChipFactoryPage = {
  Create = 1,
  Decompose = 2,
  Bag = 3
}
TacticalChipBagSortType = {
  ChipType = 1,
  Star = 2,
  Quality = 3
}
TacticalChipFactoryStatus = {
  None = 0,
  Idle = 1,
  Working = 2,
  CanGetChip = 3
}
UIHero100RecruitCardState = {
  Hide = 0,
  Flip = 1,
  Flipping = 2,
  Front = 3
}
UIHeroMultiRecruitType = {Ten = 1, OneHundred = 2}
UIWorkerMultiRecruitType = {Ten = 1, OneHundred = 2}
ExtraPowerInfoType = {
  Science = 11,
  AllianceScience = 12,
  Mastery = 13,
  Camp = 14,
  BattleField = 15
}
NewOtherPowerInfoType = {
  AllianceScience = 1,
  Mastery = 2,
  BattleField = 3,
  CampScience = 4,
  Militray = 5
}
ExtraPowerType2OtherPowerTypeMap = {
  [ExtraPowerInfoType.AllianceScience] = NewOtherPowerInfoType.AllianceScience,
  [ExtraPowerInfoType.Mastery] = NewOtherPowerInfoType.Mastery,
  [ExtraPowerInfoType.BattleField] = NewOtherPowerInfoType.BattleField
}
UIDetectSlotBoxPanelType = {DetectCaveExplorePanelType = 1}
HummerSceneUnitType = {
  None = 0,
  Player = 1,
  Zombie = 2,
  Trigger = 3,
  Drop = 4,
  Air = 5,
  JumpZombie = 6,
  Dominator = 7
}
HummerSceneTriggerType = {
  SpeedAdd = 1,
  Battle = 2,
  Air = 3
}
HummerSceneBuffType = {
  TriggerSpeedAdd = 1,
  FingerSpeedAdd = 2,
  JumpZombieSpeedAdd = 3
}
DragonCommandOrderModify = {
  Default = 0,
  Replace = 1,
  Del = 2
}
GateDefenceHeroType = {LWHero = 1, ChapterActor = 2}
BeginnerDirectorEvent = {
  UAV_Repaire = 10001,
  ZombieSeaFirstStage = 10002,
  ZombieSeaSecondStage = 10003,
  BigWorldKillZombie = 10004,
  CityFight = 10005,
  CityFight2 = 10006,
  CityFight3 = 10007
}
BeginnerScriptPointType = {
  GuideFLow = "GuideFLow",
  OpenWindow = "OpenWindow",
  MoveCamera = "MoveCamera",
  SpawnCityZombie = "SpawnCityZombie",
  SpawnCityActorHero = "SpawnCityActorHero",
  SpawnArmyNPC = "SpawnArmyNPC",
  UnLockCurMonopoly = "UnLockCurMonopoly",
  SetMonopolyVisble = "SetMonopolyVisble",
  SetCityPointVisible = "SetCityPointVisible"
}
BeginnerScriptPointTriggerType = {
  Time = 1,
  WaitPreDone = 2,
  TaskAllReceived = 4,
  OverTime = 8
}
DragonOperateLogType = {
  PlayerRemove = 1,
  PlayerGroupAdd1 = 2,
  PlayerGroupAdd2 = 3,
  CommanderAdd = 4,
  CommanderRemove = 5,
  GroupCancel = 6,
  GroupOpen = 7,
  ChangeTime = 8
}
DominatorId = {Gorilla = 1000000, Cockatrice = 1100000}
DominatorTrainGroupType = {Main = 1, Normal = 2}
DominatorGuideConditionId = {
  STEP_0 = 0,
  STEP_1 = 1,
  STEP_2 = 2,
  STEP_3 = 3,
  STEP_4 = 4
}
DominatorGuideTriggerId = {STEP_0 = 0}
DominatorGuideBehaviourId = {
  STEP_0 = 0,
  STEP_1 = 1,
  STEP_2 = 2,
  STEP_3 = 3,
  STEP_4 = 4
}
UILWDominatorMainPageTag = {
  Basic = 1,
  Rank = 2,
  Skill = 3,
  Train = 4,
  RankPreview = 5
}
DominatorGorillaTreatmentStage = {
  One = 1,
  Two = 2,
  Three = 3,
  Finish = 4
}
DominatorGorillaTreatmentFinishPlotGroupId = {One = 2407, Two = 2408}
DominatorTrainGroupId = {
  Attack = 110000,
  Defence = 120000,
  Hp = 130000
}
DominatorTrainGroupBannerImagePath = {
  [DominatorTrainGroupId.Attack] = "Assets/Main/TextureEx/LWUIDominator/Main/zxl_zhuzai_gongji_linshi.png",
  [DominatorTrainGroupId.Defence] = "Assets/Main/TextureEx/LWUIDominator/Main/zxl_zhuzai_fangyu_linshi.png",
  [DominatorTrainGroupId.Hp] = "Assets/Main/TextureEx/LWUIDominator/Main/zxl_zhuzai_shengming_linshi.png"
}
DominatorTrainGroupBannerDefaultImagePath = "Assets/Main/TextureEx/LWUIDominator/Main/zxl_zhuzai_gongji_linshi.png"
TacticalChipFocusType = {
  LeiDa = 1,
  DianChi = 2,
  YinQing = 3,
  XinPian = 4
}
TacticalChipFactoryPage = {
  Create = 1,
  Decompose = 2,
  Bag = 3
}
TacticalChipBagSortType = {
  ChipType = 1,
  Star = 2,
  Quality = 3
}
TacticalChipFactoryStatus = {
  None = 0,
  Idle = 1,
  Working = 2,
  CanGetChip = 3
}
ArmyFormationSlot = {
  Hero1 = 1,
  Hero2 = 2,
  Hero3 = 3,
  Hero4 = 4,
  Hero5 = 5,
  Dominator = 6
}
ArmyFormationPositionType = {
  Normal = 1,
  DominatorAndHero345 = 2,
  OnlyDominator = 3,
  OneHero = 4,
  TwoHero = 5,
  ThreeHero = 6,
  FourHero = 7
}
ArmyFormationSlotPositionType = {
  [ArmyFormationPositionType.Normal] = {
    ArmyFormationSlot.Hero1,
    ArmyFormationSlot.Hero2,
    ArmyFormationSlot.Hero3,
    ArmyFormationSlot.Hero4,
    ArmyFormationSlot.Hero5,
    ArmyFormationSlot.Dominator
  },
  [ArmyFormationPositionType.DominatorAndHero345] = {
    ArmyFormationSlot.Hero3,
    ArmyFormationSlot.Hero4,
    ArmyFormationSlot.Hero5,
    ArmyFormationSlot.Dominator
  },
  [ArmyFormationPositionType.OnlyDominator] = {
    ArmyFormationSlot.Dominator
  },
  [ArmyFormationPositionType.OneHero] = {
    ArmyFormationSlot.Hero1
  },
  [ArmyFormationPositionType.TwoHero] = {
    ArmyFormationSlot.Hero1,
    ArmyFormationSlot.Hero2
  },
  [ArmyFormationPositionType.ThreeHero] = {
    ArmyFormationSlot.Hero1,
    ArmyFormationSlot.Hero2,
    ArmyFormationSlot.Hero3
  },
  [ArmyFormationPositionType.FourHero] = {
    ArmyFormationSlot.Hero1,
    ArmyFormationSlot.Hero2,
    ArmyFormationSlot.Hero3,
    ArmyFormationSlot.Hero4
  }
}
PVPBattleSlot = {
  SelfHero1 = 1,
  SelfHero2 = 2,
  SelfHero3 = 3,
  SelfHero4 = 4,
  SelfHero5 = 5,
  EnemyHero1 = 6,
  EnemyHero2 = 7,
  EnemyHero3 = 8,
  EnemyHero4 = 9,
  EnemyHero5 = 10,
  SelfUav = 11,
  EnemyUav = 12,
  SelfDominator = 13,
  EnemyDominator = 14,
  SelfDominatorJump = 15,
  EnemyDominatorJump = 16
}
JeepAdventurePageType = {Domintor = 1, TowerUp = 2}
BuyConditionType = {
  MainBuildingLevel = 1,
  HeroRankLevel = 139,
  HeroUniqueWeaponLevel = 147,
  DominatorMainTrainGroupLevel = 155,
  DominatorRankLevel = 156,
  HasDominator = 157,
  HasUnlockedDominator = 158,
  HeroAwakenLevel = 213
}
DecorationUpgradeType = {NormalUpgrade = 0, AdvanceUpgrade = 1}
AccountBanViewShowType = {DefaultReasonStr = 1, ShumeiCreateAccountRisk = 2}
MonoPolyPlayerState = {Normal = 1, CrossFast = 2}
TradeStationListShowType = {Alliance = 1}
MultiRewardType = {
  TrainReward = 1,
  PersonalArms = 2,
  DetectTreasure = 3
}
ZoneMobilizationTabType = {
  All = 0,
  Donated = 1,
  Attack = 2,
  Defend = 3
}
ZoneMobilizationDonatedBoxType = {Personal = 1, Alliance = 2}
ZoneMobilizationStageType = {
  None = 0,
  Donated = 1,
  Battle_Place = 2,
  Battle_Transfer = 3,
  Battle = 4,
  SettlementShow = 5,
  Sprint = 6
}
ZoneMobilizationRankType = {Donated = 1, Damage = 2}
FakeMovingModelFlag = {
  None = 0,
  Aisilla = 1,
  Airship = 2,
  ZMBoss = 3,
  KirovLaunchStation = 4,
  WarFlag = 5,
  LandMine = 6,
  S0AllianceBuilding = 7
}
ZoneMobilizationDonateFlyType = {ResourcePoint = 1, SuppliesPoint = 2}
ZoneMobilizationDonatePushType = {ResourcePoint = "gather", SuppliesPoint = "supplies"}
WorldSuppliesType = {
  IceSeasonType = 1,
  ZoneMobilizationType = 2,
  DesertSeasonType = 3,
  DarknessSeasonType = 4,
  DarknessSeasonSmallType = 5,
  ZoneMobilizationSmallType = 6,
  FlowerTrainCheerBoxType = 7
}
SeasonBankReportType = {
  UNKNOWN = 0,
  DEPOSIT_TO = 1,
  DEPOSIT_DUE = 2,
  RETURE = 3,
  BE_ROBBED = 4
}
AttackerBossType = {Aisilla = 1, ZoneMobilizationBoss = 2}
Draw2DUIModelType = {
  Airship = 1,
  KillZombieKirov = 2,
  KillZombieBox = 3,
  KillZombieBoxUpgrade = 4
}
MultiWaveFakePVPStage = {
  Lineup = 0,
  Init = 1,
  RoundInit = 2,
  RoundOpening = 3,
  RoundFight = 4,
  RoundEnd = 5,
  End = 6
}
MeteoriteState = {
  MATCH = 1,
  PREVIEW = 2,
  GRAB = 3,
  REST = 4,
  SHOW = 5,
  END = 6
}
PlayerDetailOpenType = {Other = 0, OneSelf = 1}
PlayerBattleInfoType = {
  Power = 1,
  Kill = 2,
  Career = 3,
  Gift = 4
}
PlayerServerInfoType = {Alliance = 1, Server = 2}
PlayerDetailBottomBtnType = {
  Record = 1,
  User = 2,
  Setting = 3,
  Rank = 4,
  Service = 5,
  Like = 6,
  Gift = 7,
  Chat = 8,
  Notify = 9,
  Sticky = 10,
  Block = 11,
  Report = 12,
  Attention = 13
}
FriendsCirleSettingType = {
  Comment = 1,
  AllianceVisible = 2,
  AllianceMoment = 3
}
LetterClientParamType = {PlayerNickName = 1, CreateAccountTime = 2}
CommonBoxShowRewardTipAnchor = {
  Top = 1,
  Down = 2,
  Left = 3,
  Right = 4
}
DecorationQualityNew = {
  SSR = 5,
  SR = 4,
  R = 3
}
ZoneMobilizationBossStatusFlag = {
  None = 0,
  Alive = 1,
  Death = 2,
  Escape = 3
}
DominatorArchiveState = {
  Locked = -1,
  CanUnlock = 0,
  Unlocked = 1
}
DominatorTowerupFormationInfoDict = {
  {
    saveType = FormationSaveType.DominatorNormal,
    positionType = ArmyFormationPositionType.Normal
  },
  {
    saveType = FormationSaveType.DominatorAndHero345,
    positionType = ArmyFormationPositionType.DominatorAndHero345
  },
  {
    saveType = FormationSaveType.OnlyDominator,
    positionType = ArmyFormationPositionType.OnlyDominator
  }
}
ItemResPara1Type = {Diamond = 100}
ItemPara1Text = {
  [ItemResPara1Type.Diamond] = "182050"
}
PassYearItemIdList = {
  [710023] = 2024,
  [654121] = 2025,
  [654245] = 2026
}
HeroReplaceSlotSide = {Left = 1, Right = 2}
HeroListCardType = {ShowHeroName = 1, ShowHeroRank = 2}
CaveExplorationNodeType = {
  Entrance = 0,
  Regular = 1,
  Parkour = 2,
  Box = 3,
  Trap = 4,
  RewardOver = 5,
  Roll = 6
}
AlStarCeremonyInteractionType = {applaud = 1}
AlStarCeremonyState = {
  Ready = 1,
  Opening = 2,
  ReadPersonReward = 3,
  Applaud = 4,
  PersonAwards = 5,
  ReadAllianceReward = 6,
  AllianceAwards = 7,
  Finish = 8
}
AlStarCeremonyInnerState = {
  [AlStarCeremonyState.Ready] = {
    State0 = 0,
    State1 = 1,
    State2 = 2
  },
  [AlStarCeremonyState.Opening] = {State0 = 0, State1 = 1},
  [AlStarCeremonyState.ReadPersonReward] = {
    State0 = 0,
    State1 = 1,
    State2 = 2,
    State3 = 3,
    State4 = 4,
    State5 = 5,
    State6 = 6
  },
  [AlStarCeremonyState.Applaud] = {State0 = 0, State1 = 1},
  [AlStarCeremonyState.PersonAwards] = {State0 = 0, State1 = 1},
  [AlStarCeremonyState.ReadAllianceReward] = {
    State0 = 0,
    State1 = 1,
    State2 = 2
  },
  [AlStarCeremonyState.AllianceAwards] = {
    State0 = 0,
    State1 = 1,
    State2 = 2
  },
  [AlStarCeremonyState.Finish] = {State1 = 1, State2 = 2}
}
AlStarCeremonyPanelType = {
  CountDown = 1,
  Tip = 2,
  PersonAward = 3,
  Applaud = 4,
  InterAction = 5,
  AllianceReward = 6,
  Leave = 7,
  PersonList = 8,
  Thumb = 9,
  EmojiList = 10,
  Jump = 11
}
AlStarRewardBoxImg = {
  "Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_baoxiang_lan.png",
  "Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_baoxiang_zi.png",
  "Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_baoxiang_cheng.png"
}
AlStarAnimName = {Cheer = "tiao", Applaud = "guzhang"}
AlStarCeremonyReadPersonRewardRandomPoint = {
  {
    1,
    2,
    3,
    4,
    5
  },
  {
    1,
    6,
    7,
    8,
    4
  },
  {
    9,
    10,
    15,
    13,
    12
  },
  {
    9,
    10,
    15,
    16,
    14
  },
  {
    11,
    9,
    6,
    16,
    10
  }
}
AlStarMainUIAnimName = {
  Reward = "V_ui_UIAllianceStarMain_reward",
  In = "V_ui_UIAllianceStarMain_in"
}
AlStarRewardBoxImg = {
  [1] = {
    closeImg = "lrb_gerenjunbei_xiangzi_bai01",
    openImg = "lrb_gerenjunbei_xiangzi_bai02",
    boxCloseImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_1",
    boxOpenImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_2"
  },
  [2] = {
    closeImg = "lrb_gerenjunbei_xiangzi_lan01",
    openImg = "lrb_gerenjunbei_xiangzi_lan02",
    boxCloseImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_3",
    boxOpenImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_4"
  },
  [3] = {
    closeImg = "lrb_gerenjunbei_xiangzi_jin01",
    openImg = "lrb_gerenjunbei_xiangzi_jin02",
    boxCloseImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_5",
    boxOpenImg = "cfm_huodong_gerenjunbei_baoxiang_xiao_6"
  }
}
DirectPurchaseType = {
  DecorationShopMainCity = "DecorationShopMainCity"
}
UIDecorationIconCellParentType = {UIDecorationIconCell = 1, UILWMailBattleSkinItemComponent = 2}
DecorationShoGoodsState = {
  None = 0,
  Sale = 1,
  isUnlock = 2,
  isHave = 3,
  SoldOut = 4
}
GiftShowType = {Basics = 1, Edit = 2}
GiftShowItemType = {
  Empty = 1,
  Noraml = 2,
  Lock = 3
}
GiftShowUnlockType = {GetGiftTypeNum = 1}
GiftShowContentAniState = {
  NoAni = 1,
  ShowAni = 2,
  ShowAniWait = 3,
  NextAni = 4,
  NextAniWait = 5,
  TargetSetAni = 6,
  TargetSetAniWait = 7,
  NoAniWait = 8
}
ShoGoodsState = {
  None = 0,
  Sale = 1,
  isUnlock = 2,
  isHave = 3,
  SoldOut = 4
}
ScienceUnlockConditionType = {
  Building = 1,
  Science = 2,
  Resource = 3,
  ResourceItem = 4,
  Item = 5,
  ScienceAndLv = 6,
  ScienceGroupPercent = 7,
  MonoPolyFinish = 8
}
ValentineSendGiftScope = {
  SelfServer = 1,
  ZoneServer = 2,
  Alliance = 3
}
ValentineRankType = {SelfServer = 1, ZoneServer = 2}
GenderFilterType = {
  All = 0,
  Male = 1,
  Female = 2
}
SendGiftDetailPhotoType = {
  HeadIcon = 1,
  FriendCircle = 2,
  NpcIcon = 3
}
SearchPlayerType = {ValentineActivitySearch = 1, BuildingOfficialAppointmentSearch = 2}
AllyDrillBoss = {
  TankBoss = 0,
  HugeSandWorm = 1,
  RoadHog = 2,
  S0_NEW = 3
}
BattleSceneState = {
  LoadFirstSceneState = 1,
  ReadyToEnter = 2,
  Enter = 3,
  EnterBattle = 4,
  InBattle = 5,
  ChangeScene = 6
}
BountyHunterStateType = {
  Birth = 1,
  Idle = 2,
  Reload = 3,
  Attack = 4,
  Alert = 5,
  ChangeScene = 6,
  FullAttack = 7,
  TurnFront = 8,
  TurnBack = 9,
  ChangeGun = 10,
  ConfuseMonster = 11
}
BountyHunterAttackCameraStates = {
  BountyHunterStateType.Attack,
  BountyHunterStateType.Alert,
  BountyHunterStateType.Reload
}
BountyHunterSecondConfirmKey = {
  AttackNormalMonster = "AttackNormalMonster",
  AttackWhenCanRefresh = "AttackWhenCanRefresh",
  FirstFullAttack = "FirstFullAttack",
  BountyHunterFinalDaySuperShootMonster = "BountyHunterFinalDaySuperShootMonster",
  BountyHunterSuperShootFoundShopMax = "BountyHunterSuperShootFoundShopMax",
  BountyHunterSuperShoot = "BountyHunterSuperShoot"
}
BountyMonsterStateType = {
  Birth = 1,
  Idle = 2,
  BeHit = 3,
  Seek = 4,
  Patrol = 5,
  FleeBoss = 6,
  Stun = 7,
  Alert = 8,
  Dead = 999
}
BountyMonsterDamageSource = {HunterBullet = 1, SpecialEvent = 2}
BountyHunterItemType = {
  GroundMonster = 1,
  FlyMonster = 2,
  Boss = 3,
  FreeChest = 4
}
BountyMonsterQualityType = {
  NormalMonster = 1,
  EliteMonster = 2,
  Boss = 3
}
BountyMonsterBulletType = {
  Gun1 = 1,
  Gun2Small = 2,
  Gun2Big = 3
}
BountyHunterEventType = {
  BossEvent = 1,
  RandomBomb = 2,
  DropChest = 3,
  FullScreeAttack = 4,
  Shop = 5
}
BountyHunterAniActionQueueType = {
  Hunter = 101,
  Monster = 201,
  Scene = 301
}
BountyHunterActionTriggerType = {
  Immediate = 101,
  ExecuteWhenQueueEmpty = 201,
  PushQueue = 301
}
BountyHunterAniActionType = {
  MonsterHurt = 1000,
  MonsterRemove = 1001,
  AllSmallMonsterRemove = 1002,
  BossBirth = 2001,
  RandomBomb = 2002,
  ReceiveFreeChest = 2003,
  FullScreenAttack = 2004,
  ShopEvent = 2005,
  RefreshScene = 3001,
  GetFreeChest = 3002,
  ConfuseMonster = 3003,
  HunterAttack = 4001,
  SuperShoot = 5001
}
BountyHunterRewardHistoryType = {NormalCard = 1, BossCard = 2}
BountyHunterSceneDoorType = {
  Enter = 1,
  Right = 2,
  Left = 3
}
BountyHunterLogType = {
  KILL = 1,
  FREE_CHEST = 2,
  ATK_BOSS = 3,
  FULL_SCREEN_ATK = 4,
  ATK_BOSS_BY_LASER = 5,
  SUPER_SHOOT_FREE_CHEST = 6,
  SUPER_SHOOT_NORMAL_MONSTER = 7,
  SUPER_SHOOT_FLY_MONSTER = 8
}
BountyHunterEventType4Server = {
  Boss = 1,
  RandomBomb = 2,
  FreeChest = 3,
  Shop = 4
}
JeepStageFirstRewardType = {
  CanClaim = 1,
  NotReached = 2,
  Claimed = 3
}
JeepStageSweepResultType = {
  Victory = 1,
  Lose = 2,
  Stop = 3
}
JeepStageItemType = {
  Center = 1,
  Finished = 2,
  UnFinished = 3
}
SeasonCampDestroyStage = {
  None = -1,
  Idle = 0,
  Wait = 1,
  Fight = 2
}
UISeasonCallBackInfoOpenType = {DecorationPreview = 1}
CommonConfirmPanelType = {Default = 0, Diamond = 1}
CommonConfirmBtnType = {Default = 0, Inverse = 1}
BeHitNewSkillTriggerParamType = {
  AlwaysTrigger = 1,
  HurtBiggerThan = 2,
  HurtSmallerThan = 3,
  HpPercentSmallerThan = 4,
  MaxTriggerTime = 5
}
BattleSpecialFeatureTriggerType = {KillMonsterTotal = 1}
BattleSpecialFeatureBehaviorType = {SummonMonster = 1}
HeroUWEnhanceUnitType = {
  Weapon = 1,
  Energy = 2,
  Armor = 3
}
TacticalEquipBtnStatus = {
  Merge = 0,
  Upgrade = 1,
  Use = 2,
  GetMore = 3,
  Fill = 4,
  Confirm = 5,
  Replace = 6,
  Research = 7,
  MergeBan = 8,
  Count = 9
}
EpidemicZoneRole = {
  Default = 0,
  Lord = 1,
  Farmer = 2
}
BattleFieldBuildType = {
  POWER = 2,
  DEFENCE = 3,
  BUFF = 4,
  RES = 5,
  SCORE = 6
}
EpidemicTeamRewardType = {AB = 1, A = 2}
EpidemicBattleSide = {
  Default = 0,
  Lord = 1,
  FarmerL = 2,
  FarmerR = 3
}
EpidemicBattleScoreType = {
  None = 0,
  Arbiter = 1,
  Lord = 2,
  Farmer = 3
}
EpidemicZoneStage = {
  None = 0,
  SignIn = 1,
  Matching = 2,
  MatchEnd = 3,
  Prepare = 4,
  Battle = 5,
  Show = 6,
  End = 7
}
EpidemicZoneSkillType = {
  LordReactiveDefault = 1,
  LordReactiveRandom = 2,
  FarmerActive = 3,
  LordActive = 4,
  GodOfWar = 5
}
EpidemicZoneSignState = {
  StateSignNone = 0,
  StateSignSuc = 1,
  StateBan = 2,
  StateMatchFailed = 3,
  StateMatchSuc = 4
}
EpidemicZonePlayerState = {
  None = 0,
  Main = 1,
  Sub = 2
}
EpidemicBuildState = {Normal = 1, Occupied = 2}
EpidemicRankRewardType = {
  TotalScore = 1,
  BattleScore = 2,
  Cooperation = 3,
  Tactics = 4
}
EpidemicOperateLogType = {
  PlayerRemove = 1,
  PlayerGroupAdd1 = 2,
  PlayerGroupAdd2 = 3,
  ArbiterAdd = 4,
  ArbiterRemove = 5,
  GroupCancel = 6,
  GroupOpen = 7,
  ChangeRole = 8,
  ChangeTime = 9,
  CommanderAdd = 10,
  CommanderRemove = 11
}
EpidemicSkillId = {
  Quake = 301,
  Hospital = 302,
  Turret = 303,
  Judgment = 304
}
WarningTipType = {ParkourGoldBonus = 1}
ExplorerTreasureRewardQuality = {
  GREEN = 1,
  BLUE = 2,
  PURPLE = 3,
  ORANGE = 4,
  RED = 5
}
TreasureRewardType = {
  Map = 1,
  ExplorerTreasure = 2,
  MapNew = 3,
  DigTreasure = 4,
  BoxRewardAct = 5
}
DigRewardState = {
  CanNotGet = 0,
  CanGet = 1,
  HaveGot = 2,
  Fail = 3,
  NotBegin = 4
}
ActEasterEggType = {
  Gathering = 1,
  Vote = 2,
  Amazing = 3
}
ActEasterEggEditType = {
  GatheringQuestion = 1,
  VoteQuestion = 2,
  VoteAnswerA = 3,
  VoteAnswerB = 4
}
ActEasterAmazingEggState = {ToUpgrade = 1, Upgraded = 2}
ActEasterAmazingEggOpenType = {UnpackEggList = 1, PickUpEgg = 2}
ActEasterAnonymousRequestType = {
  RequestRandomName = 1,
  RequestSetAnonymousAvatar = 2,
  RequestSetAnonymousState = 3
}
ActEasterMessageTab = {Send = 1, Comment = 2}
ActivityWorldTreasureType = {ActEasterEgg = 1}
ActEasterEggDeleteType = {DeleteMyEggs = 1, DeleteMyComments = 2}
ActEasterEggChatOpType = {
  LikePoster = 1,
  LikeCommenter = 2,
  ReplayPost = 3,
  ReplayComment = 4
}
ActEasterEggChatScrollItemType = {
  Comment = 1,
  Vote = 2,
  Post = 3,
  LikeDescendOrder = 4,
  NoCommentNode = 5
}
SheepGameState = {
  Init = 0,
  Build = 1,
  ReBuild = 2,
  Doing = 3,
  Fair = 4,
  Success = 5,
  Exception = 6,
  SyncException = 7
}
SheepGameOpType = {
  Error = -1,
  Move = 1,
  Back = 2,
  Refresh = 3,
  Click = 11
}
SheepGameRankType = {Owner = 1, Language = 2}
BiuBiuGameRankType = {Owner = 1, Language = 2}
LittleGameRankType = {Owner = 1, Language = 2}
GiftPackageBuyType = {
  Money = 0,
  Free = 1,
  PlayerGold = 2
}
ActSlotMachineSelectCardAnimState = {
  Unflipped = "Unflipped",
  BrokeApart = "BrokeApart",
  FadeOut = "Default",
  OrangeCardFlip = "OrangeCardFlip",
  PurpleCardFlip = "PurpleCardFlip",
  BlueCardFlip = "BlueCardFlip"
}
ActSlotMachineSelectCardBgPath = {
  OrangeTypeBgPath = "Assets/Main/Sprites/UI/ActSlotMachine/lyt_fuhuojie_laohujichouka_ka2.png",
  PurpleTypeBgPath = "Assets/Main/Sprites/UI/ActSlotMachine/lyt_fuhuojie_laohujichouka_ka3.png",
  BlueTypeBgPath = "Assets/Main/Sprites/UI/ActSlotMachine/lyt_fuhuojie_laohujichouka_ka4.png"
}
ActSlotMachineSelectCardQualityType = {
  OrangeType = 1,
  PurpleType = 2,
  BlueType = 3
}
ActEasterEggChatRefreshType = {
  HistoryMessage = 1,
  NewMessage = 2,
  OnlyOrderByTime = 3
}
WorldPointSelectViewEntryType = {AllianceNotice = 1}
ChatAlNoticeSpecialDataType = {
  NoticeStartSpace = "nss",
  NoticeEndSpace = "nes",
  NoticeTrimStartStr = "ntss",
  NoticeTrimEndStr = "ntes",
  SortTag = "st",
  PointShare = "ps",
  NewsCenterURL = "ncu"
}
ChatAlNoticeSpecialDataParamType = {
  Tag = "t",
  Index = "i",
  shareData = "sd"
}
ChatAlNoticeTagInsertType = {
  None = 0,
  SortTagIndex = 1,
  CharIndex = 2
}
ChatAlNoticePosChangeTag = {
  ChatAlNoticeSpecialDataType.PointShare,
  ChatAlNoticeSpecialDataType.NewsCenterURL
}
AlNoticePicDataType = {
  SendId = "sId",
  SendState = "sState",
  AssetKey = "ak",
  SenderUid = "sUid",
  PicVer = "pVer",
  SmallWidth = "sw",
  SmallHeight = "sh",
  BigWidth = "bw",
  BigHeight = "bh"
}
AlNoticePicViewState = {
  None = 0,
  PicBeSelected = 1,
  PicBeSelectedCancel = 2
}
AlNoticeItemPicShowType = {Normal = 1, Detail = 2}
AlNoticeRecordFilterType = {
  All = 0,
  Publish = 1,
  Delete = 2,
  Upgrade = 3,
  Edit = 4
}
AlNoticeInputDataType = {AllianceNoticeData = 1, MsgParamTbl = 2}
SimpleCityEventType = {
  CityMonster = 1,
  CityCollect = 2,
  CitySaveSolider = 3,
  AllianceCelebration = 6,
  AllianceWelcome = 9
}
VoteNoticeEndTime = {END_TIME_RELATIVE = 0, END_TIME_ASSIGN = 1}
TimeShowType = {Server = 1, Local = 2}
MasteryTabType = {MasterSkillTab = 1, TacticalCard = 2}
TacticalCardType = {
  Core = 1,
  Battle = 2,
  Economy = 3
}
TacticalCardSlotUnlockCond = {SeasonPassDay = 1, MasteryLv = 2}
TacticalCardSlotType = {
  Hide = 0,
  Core = 1,
  Battle = 2,
  Economy = 3
}
TacticalCardQualityType = {
  White = 1,
  Green = 2,
  Blue = 3,
  Purple = 4,
  Orange = 5
}
TacticalCardQualityFilter = {
  WhiteAndBelow = 1,
  GreenAndBelow = 2,
  BlueAndBelow = 3,
  PurpleAndBelow = 4,
  OrangeAndBelow = 5
}
TacticalCardShowType = {SimpleShow = 1, DeluxeShow = 2}
TacticalCardUpdateSource = {Unknown = 1, EquipCard = 2}
TacticalCardSlotPrefabConfig = {
  [TacticalCardSlotType.Core] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCCoreCardSlot.prefab",
  [TacticalCardSlotType.Battle] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCNormalCardSlot.prefab",
  [TacticalCardSlotType.Economy] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCNormalCardSlot.prefab"
}
TacticalCardSlotClsConfig = {
  [TacticalCardSlotType.Core] = "UI.LWUITCCardMain.Component.CardSlot.TCCardBaseSlot",
  [TacticalCardSlotType.Battle] = "UI.LWUITCCardMain.Component.CardSlot.TCCardBaseSlot",
  [TacticalCardSlotType.Economy] = "UI.LWUITCCardMain.Component.CardSlot.TCCardBaseSlot"
}
TacticalCardConfigSlotClsConfig = {
  [TacticalCardSlotType.Core] = "UI.LWUITCCardMain.Component.CardSlot.TCCardConfigSlot",
  [TacticalCardSlotType.Battle] = "UI.LWUITCCardMain.Component.CardSlot.TCCardConfigSlot",
  [TacticalCardSlotType.Economy] = "UI.LWUITCCardMain.Component.CardSlot.TCCardConfigSlot"
}
TacticalCardPrefabPathConfig = {
  [TacticalCardType.Core] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCCoreCardItem.prefab",
  [TacticalCardType.Battle] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCNormalCardItem.prefab",
  [TacticalCardType.Economy] = "Assets/Main/Prefabs/UI/UILWTC/Component/TCNormalCardItem.prefab"
}
TacticalCardPrefabNameConfig = {
  [TacticalCardType.Core] = "TCCoreCardItem",
  [TacticalCardType.Battle] = "TCNormalCardItem",
  [TacticalCardType.Economy] = "TCNormalCardItem"
}
TacticalCardClsPathConfig = {
  [TacticalCardType.Core] = "UI.LWUITCCardMain.Component.CardEntity.TCCoreCardItemComponent",
  [TacticalCardType.Battle] = "UI.LWUITCCardMain.Component.CardEntity.TCNormalCardItemComponent",
  [TacticalCardType.Economy] = "UI.LWUITCCardMain.Component.CardEntity.TCNormalCardItemComponent"
}
TacticalQualityNameConfig = {
  [TacticalCardQualityType.Orange] = "battle_card_orange",
  [TacticalCardQualityType.Purple] = "battle_card_purple",
  [TacticalCardQualityType.Blue] = "battle_card_blue",
  [TacticalCardQualityType.Green] = "battle_card_green",
  [TacticalCardQualityType.White] = "100230"
}
TacticalCardNameConfig = {
  [TacticalCardType.Core] = "battle_card_core",
  [TacticalCardType.Battle] = "battle_card_battle",
  [TacticalCardType.Economy] = "battle_card_economic"
}
TacticalCardSkillType = {Active = 1, Passive = 2}
HeroSkillCatType = {Unit = 0, TacticalChip = 1}
TacticalCardSkillClsPathConfig = {
  [TacticalCardSkillType.Active] = "DataCenter.TacticalCardManager.Skill.TCActiveSkillData",
  [TacticalCardSkillType.Passive] = "DataCenter.TacticalCardManager.Skill.TCPassiveSkillData"
}
TCCardSkillState = {
  None = 0,
  Normal = 1,
  Locked = 2,
  CD = 3,
  NoUse = 4,
  Effect = 5,
  NotUseInBattleField = 6,
  NotUseInCurPos = 7,
  UnKnownReason = 999,
  FormationArmySelected = 9999
}
TCCardSkillEffectType = {
  AddStatusToSelf = 1,
  AddReward = 2,
  AddEffectBySpeed = 3,
  AddEffectWithCardInAssist = 4,
  AddEffectWithCamp = 5,
  AddFormationStatus = 6,
  AddStatusToRound = 7,
  GetRemainResourceImmediate = 8,
  AddEffectByDistance = 9
}
CommonTabGroupItemStyle = {
  Default = 1,
  Style1 = 2,
  Style2 = 3,
  Style3 = 4,
  Style4 = 5,
  Style5 = 6,
  Style4Activity = 7
}
ChallengeZombieAlStageStatus = {
  None = 0,
  Unreached = 1,
  Reached = 2,
  Prepare = 3,
  Battle = 4,
  Settlement = 5,
  OpenOther = 6,
  Lock = 7
}
ChallengeZombieAlBossStage = {
  None = 0,
  Prepare = 1,
  Battle = 2,
  Settlement = 3
}
ChallengeZombieAlBossStatus = {
  None = 0,
  Prepare = 1,
  Normal = 2,
  Charge = 3,
  ChargeWaiting = 4,
  Weakness = 5,
  Frenzy = 6
}
CannotRefundReason = {
  NONE = 0,
  CANT_REFUND = 1,
  HAS_REFUNDED = 2,
  Reach_LIMIT = 4,
  REWARD_NOT_ENOUGH = 5,
  REFUNDING = 6,
  BUILDING = 7,
  CARD_USE = 8
}
RefundPunishType = {
  None = 0,
  PAY_BAN = 1,
  CHAT_BAN = 2,
  MARCH_BAN = 3,
  LOGIN_BAN = 4
}
RefundListPfType = {
  Google = "google",
  GoldBlock = "gold_brick_new"
}
AllyDuelGroup = {
  OpenTWEquipBox = 100921,
  TrainSoldier = 90502,
  KillEnemySoldier = 90602,
  KillSoldier = 90611,
  DeadSoldier = 90620
}
DigTreasureBlockType = {Reward = 5}
ActivityTimeType = {TimeType_120 = 120, TimeType_200 = 200}
CommonRedPointType = {
  Default = 0,
  Num = 1,
  Reward = 2
}
CommonRedPointExtraType = {
  normal = 0,
  Hide = 1,
  Add = 2
}
CommonRedPointPriority = {Level1 = 1, LevelNormal = 999}
CommonRedPointId = {
  MainUI_Stamina = 100,
  MainUI_Power = 101,
  MainUI_BuildQueue = 102,
  MainUI_ScienceQueue = 103,
  MainUI_Quest = 104,
  MainUI_DoomVanguard = 105,
  MainUI_AllyDuel = 106
}
DigTreasureBlockRewardState = {CanNotGet = 0, HaveGot = 2}
DetectEventRetryTaskCollectType = {
  Food = 1,
  Metal = 2,
  Wood = 3,
  Gold = 4,
  Soldier = 5
}
DetectEventRetryTaskCollectType2ResourceType = {
  [DetectEventRetryTaskCollectType.Food] = ResourceType.Food,
  [DetectEventRetryTaskCollectType.Metal] = ResourceType.Metal,
  [DetectEventRetryTaskCollectType.Wood] = ResourceType.Wood,
  [DetectEventRetryTaskCollectType.Gold] = ResourceType.Gold,
  [DetectEventRetryTaskCollectType.Soldier] = ResourceType.Soldier
}
TimeConditionType = {
  Type_1 = 1,
  Type_8 = 8,
  Type_9 = 9,
  Type_144 = 144,
  Type_148 = 148,
  Type_149 = 149,
  Type_150 = 150,
  Type_212 = 212
}
ZoneMobilizationSuppliesType = {Alliance = 0, Personal = 1}
AllianceWarTabType = {
  WarEvent = 1,
  Rally = 2,
  SoloAndAOSE = 3
}
MainAlBubbleType = {
  Alert = 1,
  Help = 2,
  Join = 3,
  Science = 4,
  Invite = 5,
  Declare = 6,
  War = 7,
  Gift = 8,
  FirstShow = 9,
  Star = 10,
  R4Recommend = 11,
  Friends = 12,
  S0AllianceBoss = 13
}
AlWarEventType = {
  DECLARE_ALLIANCE_CITY = 1,
  DEFENSE_ALLIANCE_CITY = 2,
  ATTACK_STRONGHOLD = 3,
  DEFENSE_STRONGHOLD = 4,
  JOIN_THRONE_WAR = 5,
  ATTACK_OUTPOST_WAR = 6,
  DEFENSE_OUTPOST_WAR = 7,
  ATTACK_OUTPOST_CITY = 8,
  DEFENSE_OUTPOST_CITY = 9,
  JOIN_CENTER_THRONE = 10,
  JOIN_NORMAL_THRONE = 11
}
CrazyRockGameMode = {Normal = 0, Offset = 1}
CrazyRockNoteType = {
  Empty = 0,
  SingleClick = 1,
  Continue = 2
}
CrazyRockEffect = {OffsetDisappearEff = 0}
CrazyRockGameState = {
  Load = 0,
  InGame = 1,
  Pause = 2,
  Resume = 3,
  NoNote = 4,
  Replay = 5,
  MusicEnd = 999
}
CrazyRockHitType = {
  EmptyHit = 0,
  SingleNoteHit = 1,
  ContinueFirstNoteHit = 3,
  ContinueHit = 4
}
CrazyRockScoreType = {
  Perfect = 1,
  Good = 2,
  Empty = 3
}
SeasonMainActivityRewardSignType = {
  None = 0,
  Task = 1,
  Duration = 2
}
SeasonMainActivityRewardStatusType = {
  During = 1,
  Normal = 2,
  Finish = 3
}
SuppliesSearchType = {Detect = 1, Monopoly = 2}
T11MainPageType = {Overview = 1}
T11UnlockState = {
  Unknown = 0,
  T11UnlockProgressUpgrade = 1011,
  SkillProgressUpgrade = 1012,
  T11Unlockable = 1021,
  SkillBreakable = 1022,
  T11Unlocking = 1031,
  SkillBreaking = 1032,
  T11UnlockConfirmComplete = 1041,
  SkillBreakConfirmComplete = 1042,
  T11MaxStage = 9999
}
T11EquipUpgradeState = {
  NotUnLock = 0,
  Upgrading = 1,
  Unlocked = 2
}
T11SoldierType = {
  T11NotUnLock = 0,
  T11SoldierTypeA = 1,
  T11SoldierTypeB = 2
}
T11EquipType = {
  Unknown = 0,
  Head = 1,
  Body = 2,
  Arm = 3,
  Weapon = 4
}
T11PowerInfoGetType = {
  All = 0,
  BaseVal = 1,
  ResultVal = 2
}
OfficerRecruitType = {HeroRecruit = 1, WorkerRecruit = 9}
DominatorCockatriceUnlockProgress = {
  Init = 0,
  GetWorker = 1,
  FinishFinalTimeline = 2,
  End = 3
}
RecaptureActCityBattleCityStatus = {
  NONE = 0,
  MONSTER_OCCUPIED = 1,
  SERVER_OCCUPIED = 2
}
RecaptureActUpdateType = {
  NORMAL = 0,
  MONSTER_DEAD = 1,
  TASK_INFO_UPDATE = 2,
  PRESIDENT_CHOOSE_UPDATE = 3
}
IGNORE_WINDOW_AT_MI_LIST = {
  [UIWindowNames.UIChatNew_v2] = true,
  [UIWindowNames.UICommonIntroTip] = true,
  [UIWindowNames.UICommonUseItemTip] = true,
  [UIWindowNames.UICommonMessageSpecialBar] = true,
  [UIWindowNames.UICommonMessageBar] = true,
  [UIWindowNames.UICommonSingleMsgBar] = true,
  [UIWindowNames.UIPermanentTips] = true,
  [UIWindowNames.UINoticeTips] = true,
  [UIWindowNames.UINoticeHeroTips] = true,
  [UIWindowNames.UICommonBuyItem] = true,
  [UIWindowNames.UICommonUseResItemTips] = true,
  [UIWindowNames.UICommonItemProbability] = true,
  [UIWindowNames.LWUIMasteryExpGet] = true,
  [UIWindowNames.UIGetDuelScoreTip] = true,
  [UIWindowNames.UIOfficialMessageBar] = true,
  [UIWindowNames.UICommonMessageBarOld] = true,
  [UIWindowNames.UIAttackUnitsTips] = true,
  [UIWindowNames.LWUITCExpGet] = true,
  [UIWindowNames.UIBattleMessageBar] = true
}
BirthdayShowArea = {
  None = 0,
  OnlySelf = 1,
  Alliance = 2,
  All = 3
}
GuidServerRecordType = {
  BirthdayDataRecord = "BDR",
  BirthdayFuncAfterOpenInfoViewOpen = "BFAOIV",
  GiftShowIndexTipState = "GSITS",
  GiftShowAutoAni = "GSAA"
}
GiftShowAutoAniVal = {Play = "1", Stop = "2"}
GiftShowIndexTipStateType = {
  None = 0,
  LockTip = 1,
  UnlockTip = 2
}
MonthMaxDay = {
  [1] = 31,
  [2] = 29,
  [3] = 31,
  [4] = 30,
  [5] = 31,
  [6] = 30,
  [7] = 31,
  [8] = 31,
  [9] = 30,
  [10] = 31,
  [11] = 30,
  [12] = 31
}
BirthdayAgeKeyMeaning = {
  key = 1,
  strKey = 2,
  ageMin = 3,
  ageMax = 4
}
BirthdaySzn = {
  Default = 0,
  Spring = 1,
  Summer = 2,
  Fall = 3,
  Winter = 4
}
BirthdayZodType = {Hide = 0, ShowAll = 1}
ConstellationType = {
  Agr = 1,
  Psc = 2,
  Ari = 3,
  Tau = 4,
  Gem = 5,
  Cnc = 6,
  Leo = 7,
  Vir = 8,
  Lib = 9,
  Sco = 10,
  Sgr = 11,
  Cap = 12
}
ConstellationDateNum = {
  [ConstellationType.Agr] = {
    s = {m = 1, d = 20},
    e = {m = 2, d = 18}
  },
  [ConstellationType.Psc] = {
    s = {m = 2, d = 19},
    e = {m = 3, d = 20}
  },
  [ConstellationType.Ari] = {
    s = {m = 3, d = 21},
    e = {m = 4, d = 19}
  },
  [ConstellationType.Tau] = {
    s = {m = 4, d = 20},
    e = {m = 5, d = 20}
  },
  [ConstellationType.Gem] = {
    s = {m = 5, d = 21},
    e = {m = 6, d = 21}
  },
  [ConstellationType.Cnc] = {
    s = {m = 6, d = 22},
    e = {m = 7, d = 22}
  },
  [ConstellationType.Leo] = {
    s = {m = 7, d = 23},
    e = {m = 8, d = 22}
  },
  [ConstellationType.Vir] = {
    s = {m = 8, d = 23},
    e = {m = 9, d = 22}
  },
  [ConstellationType.Lib] = {
    s = {m = 9, d = 23},
    e = {m = 10, d = 23}
  },
  [ConstellationType.Sco] = {
    s = {m = 10, d = 24},
    e = {m = 11, d = 22}
  },
  [ConstellationType.Sgr] = {
    s = {m = 11, d = 23},
    e = {m = 12, d = 21}
  },
  [ConstellationType.Cap] = {
    s = {m = 12, d = 22},
    e = {m = 1, d = 19}
  }
}
ConstellationIcon = {
  [ConstellationType.Agr] = {
    normal = "ljq_shengri_xingzuo_02_a",
    gray = "ljq_shengri_xingzuo_02_a"
  },
  [ConstellationType.Psc] = {
    normal = "ljq_shengri_xingzuo_03_a",
    gray = "ljq_shengri_xingzuo_03_a"
  },
  [ConstellationType.Ari] = {
    normal = "ljq_shengri_xingzuo_04_a",
    gray = "ljq_shengri_xingzuo_04_a"
  },
  [ConstellationType.Tau] = {
    normal = "ljq_shengri_xingzuo_05_a",
    gray = "ljq_shengri_xingzuo_05_a"
  },
  [ConstellationType.Gem] = {
    normal = "ljq_shengri_xingzuo_06_a",
    gray = "ljq_shengri_xingzuo_06_a"
  },
  [ConstellationType.Cnc] = {
    normal = "ljq_shengri_xingzuo_07_a",
    gray = "ljq_shengri_xingzuo_07_a"
  },
  [ConstellationType.Leo] = {
    normal = "ljq_shengri_xingzuo_08_a",
    gray = "ljq_shengri_xingzuo_08_a"
  },
  [ConstellationType.Vir] = {
    normal = "ljq_shengri_xingzuo_09_a",
    gray = "ljq_shengri_xingzuo_09_a"
  },
  [ConstellationType.Lib] = {
    normal = "ljq_shengri_xingzuo_10_a",
    gray = "ljq_shengri_xingzuo_10_a"
  },
  [ConstellationType.Sco] = {
    normal = "ljq_shengri_xingzuo_11_a",
    gray = "ljq_shengri_xingzuo_11_a"
  },
  [ConstellationType.Sgr] = {
    normal = "ljq_shengri_xingzuo_12_a",
    gray = "ljq_shengri_xingzuo_12_a"
  },
  [ConstellationType.Cap] = {
    normal = "ljq_shengri_xingzuo_01_a",
    gray = "ljq_shengri_xingzuo_01_a"
  }
}
LetterContentType = {
  Default = 0,
  Birthday = 1,
  SznDateBirthday = 2
}
LetterGroupType = {Birthday = 3}
LetterGroupTypeStr = {Birthday = "3"}
QueenOfBloodActivityState = {
  preview = 0,
  preBattleShow = 1,
  preBattleShowNoApplication = 2,
  battle = 3,
  postBattleShow = 4,
  activityEndShow = 5
}
QueenOfBloodBattleState = {
  none = 0,
  prepare = 1,
  battle = 2
}
QueenOfBloodBattleResult = {
  AllSuccess = 0,
  PartSuccess = 1,
  AllDefeat = 2
}
OffSeason1TaskGroup = {OffSeason1Recapture = 1, QueenOfBlood = 2}
OffSeason1GoalTaskType = {
  [OffSeason1TaskGroup.OffSeason1Recapture] = -1,
  [OffSeason1TaskGroup.QueenOfBlood] = -2
}
OffSeason1TaskGroupIconPath = {
  [OffSeason1TaskGroup.OffSeason1Recapture] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/wxy_S1xiusai_nvwang_jifen.png",
  [OffSeason1TaskGroup.QueenOfBlood] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/wxy_S1xiusai_fangong_jifen.png"
}
QueenOfBloodLvImgPath = {
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_jin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_yin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_tong.png"
}
QueenOfBloodUpdateType = {
  NORMAL = 0,
  PEASONAL_RANK = 1,
  SPACIAL_MONSTER_UPDATE = 2,
  SPACIAL_MONSTER_SINGLE_UPDATE = 3,
  TASK_INFO_UPDATE = 4,
  RANK_UPDATE = 5
}
FetchGlobalStateReason = {
  ACT_EVE_OF_DECISIVE_BATTLE = 1,
  CITY_BATTLE_S1_REST_DEFEND = 2,
  WEATHER = 3,
  ZWL_LANDLORD_BUFF = 5,
  ZWL_FARMER_BUFF = 6,
  Season6CampDestroy = 10001
}
RedPacketType = {
  Festival = 1,
  War = 2,
  Trade = 3,
  Season = 4,
  Birthday = 5,
  LuckyBuff = 6,
  LuckyWithoutBuff = 7
}
SurfingMonsterState = {
  None = 0,
  Born = 1,
  Idle = 2,
  Run = 3,
  Attack = 4,
  Die = 5
}
SurfingBuffSkillType = {
  Double = 1,
  Magnet = 2,
  Fly = 3,
  Shields = 4,
  Resurrection = 5,
  AllianceHelp = 6,
  Fourfold = 7,
  ShapeShifting = 8
}
SurfingBattlePassType = {Personal = 1, Alliance = 2}
SurfingUnitEffectType = {
  None = 0,
  GotScore = 1,
  GotProps = 2,
  ShieldBroken = 3,
  Resurgence = 4,
  Morph = 5,
  Sliding = 6,
  SpeedUp = 7,
  GotEnergy = 8
}
SurfingBattleRankType = {
  AllianceBpRank = 0,
  AllianceRank = 1,
  TopServersRank = 2
}
NewRankIconPath = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}
SurfingBattleRankRoundType = {Meters = 1, CoinNum = 2}
RewardMultipleIcon = {
  [2] = "mjc_leida_wajuejilu_jinli",
  [3] = "wxy_jinli_x3",
  [4] = "wxy_jinli_x4"
}
MultipleMarkIcon = {
  [2] = "zyf_kongtouzhaohuan_huode_x2",
  [3] = "wxy_jinli_huode_x3",
  [4] = "wxy_jinli_huode_x4"
}
UIPlayBgmType = {
  CrazyRockMain = 1,
  CrazyRockGame = 2,
  ActivityCommonGroup = 3
}
PlayerInfoHeartInfoType = {
  ThumbsUp = 1,
  Gift = 2,
  HighFive = 3,
  BirthdayThumbsUp = 4
}
AllianceBatState = {
  None = 0,
  PreOpenState = 1,
  Ready = 2,
  Start = 3,
  Finish = 4,
  StartOut = 5
}
SeasonTetrisRankType = {Owner = 1, Language = 2}
PlayerType = {
  PlayerNone = -1,
  PlayerSelf = 0,
  PlayerAlliance = 1,
  PlayerOther = 2,
  PlayerAllianceLeader = 3,
  PlayerAllianceEnemy = 4,
  PlayerZoneEnemy = 5,
  PlayerSeasonEnemy = 6,
  PlayerSeasonCamp = 7,
  PlayerSeasonAssist = 8
}
CrossMarchTargetSwitchDefine = {
  [MarchTargetType.COLLECT] = MarchTargetType.CROSS_COLLECT,
  [MarchTargetType.ATTACK_ARMY_COLLECT] = MarchTargetType.CROSS_ATTACK_ARMY_COLLECT,
  [MarchTargetType.ATTACK_MONSTER] = MarchTargetType.CROSS_ATTACK_MONSTER,
  [MarchTargetType.SCOUT_CITY] = MarchTargetType.CROSS_SCOUT_CITY,
  [MarchTargetType.ASSISTANCE_CITY] = MarchTargetType.CROSS_ASSISTANCE_CITY,
  [MarchTargetType.DIRECT_ATTACK_ACT_BOSS] = MarchTargetType.CROSS_DIRECT_ATTACK_ACT_BOSS,
  [MarchTargetType.ATTACK_CITY_STRONGHOLD] = MarchTargetType.CROSS_ATTACK_CITY_STRONGHOLD,
  [MarchTargetType.ASSISTANCE_CITY_STRONGHOLD] = MarchTargetType.CROSS_ASSISTANCE_CITY_STRONGHOLD,
  [MarchTargetType.ATTACK_ALLIANCE_CITY] = MarchTargetType.CROSS_ATTACK_ALLIANCE_CITY,
  [MarchTargetType.ASSISTANCE_ALLIANCE_CITY] = MarchTargetType.CROSS_ASSISTANCE_ALLIANCE_CITY,
  [MarchTargetType.DETECT_TREASURE] = MarchTargetType.CROSS_DETECT_TREASURE,
  [MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS] = MarchTargetType.CROSS_DIRECT_ATTACK_ACT_BERSERK_BOSS,
  [MarchTargetType.ATTACK_CITY] = MarchTargetType.CROSS_ATTACK_CITY,
  [MarchTargetType.BACK_HOME] = MarchTargetType.CROSS_BACK_HOME
}
CrossMarchSwitchDefine = {
  [NewMarchType.NORMAL] = NewMarchType.CROSS_NORMAL,
  [NewMarchType.ASSEMBLY_MARCH] = NewMarchType.CROSS_ASSEMBLY_MARCH,
  [NewMarchType.SCOUT] = NewMarchType.CROSS_SCOUT
}
BattleReportPreviewEnterType = {
  Default = 0,
  ActWorldBossBattleRecord = 1,
  NewBattleReportChatShare = 2
}
UIInteractionBubbleState = {
  Idle = 1,
  InOut = 2,
  Up = 3
}
UIInteractionBubbleFlyInTime = 0.25
UIInteractionBubbleFlyOutTime = 0.25
UIInteractionBubbleFlyUpTime = 0.25
UIInteractionBubbleShowTime = 2
SurfingGoodsType = {
  Score = 1,
  Box = 2,
  Energy = 3
}
BuildMoveState = {
  None = 1,
  Success = 2,
  Fail = 3
}
CityAttackS0NewBattlePassType = {
  ALL = -2,
  Score = -1,
  LevelOne = 1,
  LevelTwo = 2,
  LevelThree = 3,
  LevelFour = 4,
  LevelFive = 5,
  LevelSix = 6
}
CityAttackS0ActivityState = {
  Waiting = 10,
  CityAttack = 20,
  Ending = 30
}
CityAttackS0FixedTask = {
  OneLimitLevel = 15,
  FiveLimitLevel = 16,
  OneLimitStar = 17,
  FiveLimitStar = 18
}
CoffeeState = {
  FULL = 1,
  EMPTY = 2,
  AVAILABLE = 3,
  UNLOCKABLE = 4
}
INPUT_FLAGS = {
  LEFT = 1,
  RIGHT = 2,
  UP = 3,
  DOWN = 4
}
EVENT_FLAGS = {
  BUFF_SPEED_UP = 1,
  BUFF_SPEED_DOWN = 2,
  NITROGEN_SPEED_UP = 3,
  NITROGEN_SPEED_DOWN = 4,
  COLLISION = 5,
  COLLISION_LEFT = 6,
  COLLISION_RIGHT = 7,
  COLLISION_FINISH = 8
}
EXIT_FLAGS = {
  LOSE = 1,
  RESURGENCE = 2,
  EXIT = 3,
  WIN = 4
}
SurfingMotionState = {
  Normal = 0,
  Idle = 1,
  Running = 2,
  Jumping = 3,
  AirSliding = 4,
  GroundSliding = 5,
  Flying = 6,
  FreeFalling = 7
}
WeekDayNameByIndex = {
  [1] = "activity_1110000_12",
  [2] = "activity_1110000_13",
  [3] = "activity_1110000_14",
  [4] = "activity_1110000_15",
  [5] = "activity_1110000_16",
  [6] = "activity_1110000_17",
  [7] = "activity_1110000_18"
}
BattleStarCondition = {
  None = 0,
  Success = 1,
  HPPercent = 2,
  StageSuccessTime = 3,
  MemberNum = 4
}
SkyBattleRewardType = {
  Coin = 1,
  Plane = 2,
  Equip = 3
}
SkyBattleEquipType = {
  HP = 1,
  Attack = 2,
  MemberPropPercent = 3,
  MemberNum = 4
}
SkyBattlePlanePropertiesType = {
  HPNum = 1,
  Attack = 2,
  MemberNum = 3,
  MemberPropPercent = 4
}
SkyBattleChapterGrowthGuideType = {
  Slot1 = 1,
  Skin = 2,
  Recycle = 3
}
LittleGameRoomState = {
  RoomFair = -1,
  WaitPlayer = 0,
  WaitReady = 1,
  FightReady = 2,
  FightDescribe = 3,
  FightIng = 4,
  FightEnd = 5
}
ActUIBanquetHistoryLogType = {
  Attack = 1,
  KillZombie = 2,
  FlowerCar = 3
}
UpgradeTreasureBoxResult = {
  None = 0,
  Success = 1,
  Fail = 2
}
UpgradeTreasureBoxQuality = {
  Green = 2,
  Blue = 3,
  Purple = 4,
  Orange = 5,
  Red = 6
}
FlowerTrainInteractiveType = {
  Like = 1,
  Cheer = 2,
  ClaimLvLvBox = 3
}
FlowerTrainState = {
  Normal = 0,
  WaitingReward = 1,
  Arrived = 2
}
FlowerTrainOperateFailReason = {
  Unknown = 0,
  NotInSourceServer = 1,
  InBattleField = 2
}
GameCenterUploadDataName = {
  ActFrontBreakSunday = "com.fun.lastwar.leaderboard.event.frontline.weekly",
  StageFeatureChapter = "com.fun.lastwar.leaderboard.frontline.chapter.%s",
  LoginDaysAchievement = "com.fun.lastwar.achievement.login.days.%s",
  BaseLevelAchievement = "com.fun.lastwar.achievement.build.level.%s",
  HistoryMaxPowerAchievement = "com.fun.lastwar.achievement.power.%s",
  StageFeatureChapterAchievement = "com.fun.lastwar.achievement.frontline.clear.chapter.%s",
  OwnMonikaHero = "com.fun.lastwar.achievement.greet.monica"
}
SkyBattleMonsterStateType = {
  SearchTarget = 1,
  Attack = 2,
  Born = 3,
  Die = 4,
  HitL = 5,
  HitR = 6
}
SkyBattleMoveDirectionState = {
  Idle = 1,
  Left = 2,
  Right = 3,
  Forward = 4,
  BackWard = 5
}
SkyBattleAnimName = {
  Idle = "idle",
  Attack = "attack",
  Dead = "death",
  Born = "born",
  Hurt = "hurt",
  Aim = "idle",
  HitR = "hit_R",
  HitL = "hit_L"
}
LastStandBuildType = {
  Hospital = 1,
  Barracks = 2,
  ArmyYard = 3,
  Turret = 4,
  Home = 5,
  Gate = 6
}
LastStandDoorContactDirection = {
  FromInside = 1,
  FromOutside = 2,
  Leave = 3
}
LastStandDoorType = {
  Left = 1,
  Right = 2,
  Top = 3,
  Bottom = 4
}
LastStandGuideConditionType = {
  CoinEnough = 1,
  BuildingDone = 2,
  EnterLevelTime = 3,
  SoliderNum = 4,
  KillMonsterNum = 5
}
LastStandActionType = {
  GuideToTarget = 1,
  CreateSolider = 2,
  ShowTips = 3
}
AssetLoadPriority = {
  Low = 0,
  Medium = 1,
  High = 2,
  UltraHigh = 3
}
RewardShowType = {NORMAL = 0, TRAIN_SEASON_EXTRA = 1}
UploadImageType = {
  Avatar = 0,
  Chat = 1,
  SeasonPhoto = 2
}
AllianceScoreUISetting = {
  [1] = {
    LongScoreBgPath = "zyf_lianmeng_fenxiangbg_hui.png",
    ShortScoreBgPath = "zyf_lianmeng_jiaobiao_hui.png",
    StarPath = "lrb_lianmeng_xing02.png"
  },
  [2] = {
    LongScoreBgPath = "zyf_lianmeng_fenxiangbg_lan.png",
    ShortScoreBgPath = "lrb_lianmeng_benrenpingfenbg.png",
    StarPath = "lrb_lianmeng_xing02.png"
  },
  [3] = {
    LongScoreBgPath = "lrb_lianmeng_fenxiangbg.png",
    ShortScoreBgPath = "lrb_lianmeng_pingfenbg.png",
    StarPath = "lrb_lianmeng_xing01.png"
  }
}
AlApplyCheckType = {Normal = 0, Switch = 1}
PyramidSpeedUpEffectPath = {
  Up = "Assets/_Art_LastWar/Effect/Prefab/PyramidSpeedUpEffect/Eff_A_build_jinzita_jiasu_01_Variant.prefab",
  Down = "Assets/_Art_LastWar/Effect/Prefab/PyramidSpeedUpEffect/Eff_A_build_jinzita_jiasu_02_Variant.prefab"
}
NewsCenterWebEventName = {
  Like = "Like",
  ImageDownload = "ImageDownload",
  Share = "Share"
}
WebEventType = {NewsCenter = "NewsCenter"}
NewsChainDataState = {
  None = 0,
  Requesting = 1,
  HaveData = 2,
  NoData = 3
}
ShootShareChannelType = {
  None = 0,
  Season = 1,
  Country = 2,
  Alliance = 3,
  Private = 4
}
DispatchTaskRecordType = {
  All = -1,
  Assist = 0,
  Stolen = 1,
  Steal = 2
}
StageFeatureHelpInfoState = {
  None = 0,
  AcceptInvite = 1,
  Complete = 2,
  AcceptResult = 3,
  Expire = 4
}
PVELogFuncType = {Surfing = 1, GhostParkour = 2}
PVELogFilePathName = {
  [PVELogFuncType.Surfing] = "Surfing/",
  [PVELogFuncType.GhostParkour] = "GhostParkour/"
}
ParkourBuffType = {
  SPEED_BOARD = 1,
  NITROGEN = 2,
  OBSTACLE = 3
}
GhostParkourTierRewardState = {
  NoReward = 0,
  CanReward = 1,
  Rewarded = 2
}
GhostParkourTypeRank = {
  AllianceRank = 3,
  ServerRank = 4,
  AreaRank = 5
}
GhostParkourPassType = {Personal = 3, Alliance = 4}
GhostParkourRecordType = {
  All = 1,
  Attack = 2,
  Defense = 3
}
GhostSpeedEffectType = {
  None = 0,
  SpeedUpL1 = 1,
  SpeedUpL2 = 2,
  SpeedUpL3 = 3,
  SpeedUpSuper = 4,
  Dizziness = 5
}
LimitDropHistoryTabType = {NormalDrop = 1, PayDrop = 2}
LimitDropHistoryItemType = {
  DayTitleItem4First = 1,
  DayTitleItem = 2,
  DropInfo = 3,
  DropLimit = 4
}
AdCollectionId = {
  Resource = 1,
  HeroRecruit = 2,
  WorkerRecruit = 3,
  Train = 4
}
NoRollingAlignment = {
  Left = 0,
  Middle = 1,
  Right = 2
}
SalaryStatus = {
  NotAchieved = 0,
  CanGet = 1,
  HasGot = 2
}
AllianceSalaryType = {DailySalary = 0, WeeklySalary = 1}
AllianceSalaryRewardShowType = {All = 0, R4orR5 = 1}
AllianceSalaryConditionType = {
  DailyScore = 1,
  WeeklyAllianceScore = 2,
  WeeklyPersonalScore = 3,
  R4R5Days = 4
}
AllianceSalaryRewardImage = {
  [1] = "lrb_tmjx_jianglishengji_xiangzi_lv",
  [2] = "lrb_tmjx_jianglishengji_xiangzi_lan",
  [3] = "lrb_tmjx_jianglishengji_xiangzi_zi",
  [4] = "lrb_tmjx_jianglishengji_xiangzi_jin",
  [5] = "lrb_tmjx_jianglishengji_xiangzi_hong"
}
AllianceSalaryRewardTexture = {
  [1] = "lrb_TMJX_xiangzi_lv",
  [2] = "lrb_TMJX_xiangzi_lan",
  [3] = "lrb_TMJX_xiangzi_zi",
  [4] = "lrb_TMJX_xiangzi_jin",
  [5] = "lrb_TMJX_xiangzi_hong"
}
AllianceSalaryRewardBg = {
  [1] = "lrb_tmjx_jianglishengji_listlv",
  [2] = "lrb_tmjx_jianglishengji_listlan",
  [3] = "lrb_tmjx_jianglishengji_listzi",
  [4] = "lrb_tmjx_jianglishengji_listjin",
  [5] = "lrb_tmjx_jianglishengji_listhong"
}
SalaryActivityState = {NotOpen = 0, Open = 10}
PlotDubCondition = {GuideDone = "1"}
UseReturnOptPveType = {
  [PVEType.Parkour] = true,
  [PVEType.Surfing] = true,
  [PVEType.GhostParkour] = true,
  [PVEType.SkyBattle] = true
}
UseEnterGCPveType = {
  [PVEType.Surfing] = true,
  [PVEType.GhostParkour] = true
}
TruckSuperDepartureTabType = {
  None = 0,
  Refresh = 1,
  Departure = 2
}
SpeedUpDecorationType = {
  BuildingPercent = 1,
  BuildingTime = 2,
  SciencePercent = 3,
  ScienceTime = 4
}
ValentineRequestNewFollowType = {Follow = 1, SendGiftMain = 2}
FrontBreakSundayBoxState = {
  NotAchieved = 0,
  CanGet = 1,
  HasGot = 2
}
TrainAdditionPriceType = {Goods = 1, Resource = 2}
ValentineNpcRewardGetType = {
  Like = 1,
  Gift = 2,
  Follow = 3
}
HeadIconType = {Player = 1, Npc = 2}
BulletAddBuffMode = {
  None = 0,
  TriggerAfterCausedDamage = 1,
  TriggerOnceAfterCausedDamage = 2
}
BuffFromSourceType = {None = 0, Bullet = 1}
ParkourHpBarType = {
  Self = 0,
  Enemy = 1,
  PetShield = 2,
  EnemySmall = 3,
  SoldierSmall = 4
}
ParkourHeroUnitType = {Soldier = 1}
CommonRewardEffectQualityPath = {
  Quality4 = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_ui_commonnew_item_lightsweep_noraml.prefab",
  Quality5 = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_ui_commonnew_item_lightsweep_special.prefab"
}
AccountScoreLogInWebType = {
  AccountView_GoToBtn = 1,
  AfterBind = 2,
  AccountView_ScoreContent = 3
}
WebGenerateUrlType = {WebPay = "web-pay", AccountScore = "id-card"}
CiSparkTimelineType = {
  EnterGame = 1,
  RecueMonica = 2,
  DefaultBoss = 3
}
MonopolyPerformanceType = {
  Empty = 1,
  PerEnter = 2,
  PerLoop = 3,
  ObstacleEnter = 4,
  EasterEgg = 5,
  UnlockSparkComponent = 6
}
MonopolyPerformanceClass = {
  [MonopolyPerformanceType.Empty] = "MonopolyPerEmpty",
  [MonopolyPerformanceType.PerEnter] = "MonopolyPerEnter",
  [MonopolyPerformanceType.PerLoop] = "MonopolyPerLoop",
  [MonopolyPerformanceType.ObstacleEnter] = "MonopolyObstacleEnter",
  [MonopolyPerformanceType.EasterEgg] = "MonopolyPerEasterEgg",
  [MonopolyPerformanceType.UnlockSparkComponent] = "MonopolyUnlockSparkComponent"
}
MonopolyPerformanceTriggerType = {Begin = 1, End = 3}
MonopolyPerformanceTriggerEvent = {
  MonopolyArrived = "MonopolyArrived",
  MonopolyGoto = "MonopolyGoto",
  MonopolyInit = "MonopolyInit",
  UnLandLockBorn = "UnLandLockBorn",
  ClaimLandReward = "ClaimLandReward"
}
GoldBrickConst = {ItemId = 510046, RechargeId = 2010001}
FeatureExplorationType = {
  DailyPack = 1,
  Shop = 2,
  DoomVanguard = 3,
  VIP = 4,
  MonicaUI = 5,
  MonicaModel = 6,
  Mail = 7,
  World = 8
}
PayLockPlayerLockType = {
  None = 0,
  New = 1,
  Old = 2
}
HeroLevelType = {
  None = 0,
  CanUpgradeLevel = 1,
  CanStarLevel = 2,
  All = 3
}
AllianceBossS0ActStatus = {
  None = 0,
  NoPlan = 1,
  Prepare = 2,
  InCombat = 3,
  Finished = 4
}
AllianceBossS0ClearResult = {
  None = 0,
  Easy = 1,
  Normal = 2,
  Hard = 3,
  Failed = 4,
  NoRecord = 5,
  Lock = 6,
  LockMember = 7,
  InCombat = 8
}
AllianceBossS0RecordMemberFlag = {
  MVP = 1,
  HighestDmg = 2,
  MostAlly = 3
}
SeasonTowerConfig = {
  EntranceIcon = "Assets/Main/Sprites/UI/LWUISeasonTower/FX_S6yuanzheng_qipao.png",
  RewardType = {Group = 1, Stage = 2},
  RewardState = {
    CanReceive = 0,
    NoComplete = 1,
    Received = 2
  },
  BattleType = {Battle = 0, Sweep = 1},
  SelectItemUI = {Main = 1, Reward = 2},
  LevelToFloor = {
    1,
    10,
    100
  },
  BuffType = {
    All = 1,
    User = 2,
    Enemy = 3
  },
  EnterType = {Sweep = 1},
  GuideData = {
    TriggerId = {EnterMain = 1, BattleSuccess = 2},
    GuideId = {STEP_2 = 5842, STEP_5 = 5844},
    ConditionId = {Base = 1},
    BehaviourId = {
      OpenMain = 1,
      OpenIntroduction = 2,
      OpenRule = 3,
      ShowTile = 4,
      ShowTips1 = 5,
      ShowTips2 = 6
    }
  },
  Sound = {
    SweepStartSound = 95013,
    SweepSound = {
      95000,
      95001,
      95002
    },
    HitSound = {
      95003,
      95004,
      95005
    },
    HitFailedSound = {
      95006,
      95007,
      95008
    },
    HitBoom = 95009,
    ScoreStart = 95010,
    ScoreFinish = 95011
  }
}
AlertTowerBubbleType = {
  None = 0,
  T11IdleGame = 1,
  SeasonTower = 2,
  AlertTowerEntrance = 3
}
AllianceEffectType = {
  Start = 1,
  Loop = 2,
  End = 3,
  Custom = 4
}
AllianceEffectLoadType = {Find = 1, Load = 2}
ScienceDetailDescType = {None = 0, TacticalWeaponSkillStarUp = 1}
PopupNotificationType = {
  SandWorm = 1,
  ActMeteoriteBattle = 2,
  SeasonSettleTime = 3,
  NineNationKingBattle = 4,
  DawnPopup = 5
}
PopupActivityType = {
  KingActivity = 1,
  CrossKingActivity = 2,
  NewPeakArena = 3,
  NewGaleArena = 4,
  ThreeVThreeArena = 5,
  ChampionDuel = 6,
  ActDsbDuel = 7
}
PopupCleanType = {Click = 1, PassDay = 2}
return ConstClass("EnumType", EnumType)
