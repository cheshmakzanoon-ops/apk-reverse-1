local LLConst = {}
LLConst.IMG_DEFAULT_SERVER_ICON = "lrb_jinmai_zhanqv00.png"
LLConst.IMG_DEFAULT_SERVER_DI_HUI = "lrb_zhouliuhuodong_zhanqu_hui.png"
LLConst.IMG_DEFAULT_SERVER_DI_HONG = "lrb_zhouliuhuodong_zhanqu_hong.png"
LLConst.IMG_DEFAULT_SERVER_DI_LAN = "lrb_zhouliuhuodong_zhanqu_lan.png"
LLConst.PREFAB_DETAIL_SPEED = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetailSpeed.prefab"
LLConst.CLS_DETAIL_SPEED = "UI.LandlordBattle.BattleDetail.Component.LLDetailSpeed"
LLConst.REQ_DETAIL_LIST_PART = 10
LLConst.SIGN_GROUP_CHANGE = "LL_GROUP_CHANGE_SIGN"
LLConst.SIGN_ACT_GROUP_NEWS = "_ACT_LL_GROUP_NEWS"
LLConst.SIGN_INVITATION_GROUP = "LL_INVITATION_GROUP"
LLConst.NORMAL_CITY_FILL_IMG_RED = "Assets/Main/SeasonRes/Shared/Sprites/LWCommon/cfm_jindutiao_4.png"
LLConst.NORMAL_CITY_FILL_IMG_BLUE = "Assets/Main/SeasonRes/Shared/Sprites/LWCommon/cfm_jindutiao_5.png"
LLConst.THRONE_CITY_FILL_IMG_RED = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"
LLConst.THRONE_CITY_FILL_IMG_BLUE = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png"
LLConst.PREFAB_MINIMAP_INFO = "Assets/Main/Prefabs/UI/Landlord/World/LLMiniMapLodInfo.prefab"
LLConst.CLS_MINIMAP_INFO = "UI.LandlordBattle.BattleMainUI.Component.LLMiniMapLodInfo"
LLConst.PREFAB_MINIMAP_INFO_TIP = "Assets/Main/Prefabs/UI/Landlord/World/LLMiniMapLodInfoTip.prefab"
LLConst.CLS_MINIMAP_INFO_TIP = "UI.LandlordBattle.BattleMainUI.Component.LLMiniMapLodInfoTip"
LLConst.PREFAB_MINIMAP_PROGRESS = "Assets/Main/Prefabs/UI/Landlord/World/LLMiniMapProgress.prefab"
LLConst.CLS_MINIMAP_PROGRESS = "UI.LandlordBattle.BattleMainUI.Component.LLMiniMapProgress"
LLConst.Season5CenterServerCityState = {NormalCity = 0, LandlordCity = 1}
LLConst.LandlordStage = {
  UN_INIT = -1,
  NONE = 0,
  PREVIEW = 1,
  GROUP = 2,
  PREPARE = 3,
  BATTLE = 4,
  REST = 5,
  ENDED = 6
}
LLConst.ZWLBuildingState = {
  RUIN = 1,
  FIX = 2,
  NORMAL = 3,
  OVER = 4
}
LLConst.LLBuildingState = {
  NotOpen = 1,
  OpenButShield = 2,
  Fighting = 3,
  WillExplode = 4,
  Exploding = 5,
  Ruins = 6,
  Rebuilding = 7
}
LLConst.LandLordGroup = {
  NONE = 0,
  LORD = 1,
  FARMER = 2
}
LLConst.MAX_GROUP_SERVER = 8
LLConst.INIT_BIG_LORD_COUNT = 1
LLConst.INIT_BIG_FARMER_COUNT = 1
LLConst.OccupySpeedEffectId = {
  [LLConst.LandLordGroup.LORD] = 90204,
  [LLConst.LandLordGroup.FARMER] = 90201
}
LLConst.IronCurtainStatusId = 501005
LLConst.IronCurtainBuffMatPath = "Assets/Main/Material/IronCurtain/Eff_IronCurtain.mat"
LLConst.GiftBG_EMPTY = "lrb_jinmai_yaoqing_liwukong.png"
LLConst.GiftBG = {
  [4] = "lrb_jinmai_yaoqing_liwuzi.png",
  [5] = "lrb_jinmai_yaoqing_liwucheng.png",
  [6] = "lrb_jinmai_yaoqing_liwuhong.png"
}
LLConst.RewardType = {
  PTotal = 21,
  PKill = 22,
  PDestroy = 23,
  PBuild = 24,
  ATotal = 31,
  AKill = 32,
  ADestroy = 33,
  ABuild = 34,
  BD = 4,
  Win = 51,
  Lose = 52,
  Week = 61
}
LLConst.RewardTabType = {
  WL = 1,
  Week = 2,
  PRank = 3,
  ARank = 4,
  BD = 5
}
LLConst.RuleType = {
  Stage = 1,
  Rule = 2,
  Build = 3,
  Build1 = 31,
  Build2 = 32,
  Build3 = 33,
  Build4 = 34,
  Build5 = 35,
  Battle = 4,
  BattleDef = 41,
  BattleAtk = 42,
  BattleOther = 43
}
LLConst.CitySubType = {
  SmallStrongHold = 101,
  BigStrongHold = 102,
  BigCity = 103,
  Fortress = 104,
  Throne = 105
}
LLConst.BoomingTime = 10
LLConst.PREPARE_BATTLE_COUNTDOWN = 10
LLConst.BATTLE_END_COUNTDOWN = 30
return LLConst
