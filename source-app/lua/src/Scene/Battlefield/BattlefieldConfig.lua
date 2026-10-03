local BattlefieldConfig = {}
BattleField_SEASON = 9999
BattleFieldType = {
  Default = 0,
  MIN = 1,
  Desert = 1,
  WinterStorm = 2,
  EpidemicZone = 3,
  NewBattleTypeStart = 4,
  DsbDuel = 4,
  MAX = 4
}
BattleFieldTableKey = {
  MAP = "map_skin_id",
  ENTITY = "entity_table",
  P_SKILL = "personal_skills",
  T_SKILL = "team_skills",
  PARAM = "special_paras",
  P_POINT_ID = "personal_point_id",
  P_POINT_TYPE = "personal_point_type",
  STAR = "star",
  REWARD = "reward",
  GUIDE = "guide_group",
  RULES = "rules_group",
  TIME_CTRL = "time_controller",
  SIM = "battlefield_sim_group",
  UPDATE = "update_group",
  PING = "ping",
  PING_CD = "ping_cd",
  BATTLEFIELD_TYPE = "type",
  MULTIPLE_ASSISTANCE = "multiple_garrison",
  SOUND_VICTORY = "sound_battlefield_victory",
  SOUND_DEFEAT = "sound_battlefield_defeat",
  POINT_GROUP = "break_point_group_id",
  ACHIEVEMENT = "bf_achievement_group",
  REWARD_POINT = "bf_reward_point_group"
}
BattleFieldBuildType = {
  Normal = 1,
  POWER = 2,
  DEFENCE = 3,
  BUFF = 4,
  RES = 5,
  SCORE = 6
}
BattleFieldObjActType = {
  IDLE = "idle",
  FIX = "fix",
  AIM = "aim",
  ATK = "attack",
  DEAD = "dead",
  BORN = "born",
  CHARGE = "charge"
}
BattleFieldMiniState = {
  Normal = 1,
  Occupying_Red = 2,
  Occupying_Blue = 3,
  Occupied_Red = 4,
  Occupied_Blue = 5,
  Fixing = 6
}
BattlefieldEnterCheckType = {
  MIN = 1,
  AllianceIsValid = 1,
  BattlefieldMemberFull = 2,
  YouAreLowBeMember = 3,
  InBlackRect = 4,
  MAX = 4
}
BattlefieldTipsVertical = {
  Auto = 0,
  Up = 1,
  Down = 2
}
BF_RewardPointType = {
  None = 0,
  SCORE = 420,
  RANK = 421,
  MVP = 422,
  ACHIEVEMENT = 423
}
BF_GuideTag = {
  Rule = 1,
  Build = 2,
  Reward = 3,
  Other = 4,
  Skill = 5,
  Role = 6,
  Score = 7
}
BattlefieldBaseConfig = {}
BattlefieldBaseConfig[BattleFieldType.Desert] = {
  MapBaseName = "DragonWarDesert",
  UIName = UIWindowNames.LWMainDesertUI,
  BlockRangeLua = "Util.DragonBlockRange",
  WorldPrefabPath = "Assets/Main/Prefabs/World/BF_Desert",
  ScenePath = "Assets/Main/Scenes/BF_Desert",
  HeadUILuaPath = "Scene.WorldBuildHeadUI.WorldDragonBuildUI",
  BattlefieldSize = {200, 200},
  MiniMapPrefab = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleMiniMap.prefab",
  MiniMapLua = "UI.LWMainDesertUI.Component.LWMainDesertMiniMap",
  MiniMapOffY = -260,
  BattleInfoPrefab = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/battleInfo.prefab",
  BattleInfoLua = "UI.LWMainDesertUI.Component.LWMainDesertBattleInfo",
  BattleInfoOffY = -68,
  BattlefieldMgrGetter = function()
    return DataCenter.ActDragonManager
  end,
  BattlefieldTemplateMgrGetter = function()
    return DataCenter.DragonBuildTemplateManager
  end,
  ActMsgIdGetter = function()
    return MsgDefines.DragonActivityInfo
  end,
  ActType = EnumActivity.ActDragon.Type
}
BattlefieldBaseConfig[BattleFieldType.WinterStorm] = {
  MapBaseName = "DragonWarWinterStorm",
  UIName = UIWindowNames.LWMainWinterStormUI,
  BlockRangeLua = "Util.WinterStormBlockRange",
  WorldPrefabPath = "Assets/Main/Prefabs/World/BF_Winter",
  ScenePath = "Assets/Main/Scenes/BF_Winter",
  HeadUILuaPath = "Scene.WorldBuildHeadUI.WorldWinterStormBuildUI",
  BattlefieldSize = {70, 70},
  MiniMapPrefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/BattleMiniMap.prefab",
  MiniMapLua = "UI.LWMainWinterStormUI.Component.LWMainWinterStormMiniMap",
  MiniMapOffY = -260,
  BattleInfoPrefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/WinterStormBattleTopItemNew.prefab",
  BattleInfoLua = "UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormBattleTopItemNew",
  BattleInfoOffY = -100,
  SignPopPrefab = "Assets/Main/Prefabs/UI/BattleField/BattleFieldMainSign.prefab",
  SignPopLua = "UI.BattleFieldBase.MainSign.BattleFieldMainSign",
  SignPopOffY = -580,
  BattlefieldMgrGetter = function()
    return DataCenter.ActWinterStormManager
  end,
  BattlefieldTemplateMgrGetter = function()
    return DataCenter.WinterStormTemplateManager
  end,
  ActMsgIdGetter = function()
    return MsgDefines.WinterStormActInfo
  end,
  ActType = EnumActivity.ActWinterStorm.Type,
  BuildTemplate = "DataCenter.ActWinterStormManager.BattlefieldWinterStormBuildTemplate"
}
BattlefieldBaseConfig[BattleFieldType.EpidemicZone] = {
  MapBaseName = "BattleFiledEpidemic",
  UIName = UIWindowNames.LWMainEpidemicZoneUI,
  BlockRangeLua = "Util.EpidemicZoneBlockRange",
  WorldPrefabPath = "Assets/Main/Prefabs/World/BF_Epidemic",
  ScenePath = "Assets/Main/Scenes/BF_Epidemic",
  HeadUILuaPath = "Scene.WorldBuildHeadUI.WorldEpidemicBuildUI",
  BattlefieldSize = {148, 250},
  MiniMapPrefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleMiniMap.prefab",
  MiniMapLua = "UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneMiniMap",
  MiniMapOffY = -270,
  BattleInfoPrefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleInfo.prefab",
  BattleInfoLua = "UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneBattleInfo",
  BattleInfoOffY = -68,
  SignPopPrefab = "Assets/Main/Prefabs/UI/BattleField/BattleFieldMainSign.prefab",
  SignPopLua = "UI.BattleFieldBase.MainSign.BattleFieldMainSign",
  SignPopOffY = -660,
  BattlefieldMgrGetter = function()
    return DataCenter.ActEpidemicZoneManager
  end,
  BattlefieldTemplateMgrGetter = function()
    return DataCenter.EpidemicBuildTemplateMgr
  end,
  ActMsgIdGetter = function()
    return MsgDefines.EpidemicZoneActInfo
  end,
  ActType = EnumActivity.ActEpidemic.Type
}
BattlefieldBaseConfig[BattleFieldType.DsbDuel] = {
  MapBaseName = "BattleFiledDsbDuel",
  UIName = UIWindowNames.UIBattlefieldDsbDuelMainView,
  BlockRangeLua = "Util.DsbDuelBlockRange",
  WorldPrefabPath = "Assets/Main/Prefabs/World/BF_Dsb_Duel",
  ScenePath = "Assets/Main/Scenes/BF_Dsb_Duel",
  HeadUILuaPath = "Scene.WorldBuildHeadUI.WorldDsbBuildUI",
  BattlefieldSize = {200, 200},
  MiniMapPrefab = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/BattleMiniMapDsb.prefab",
  MiniMapLua = "UI.DsbDuelBattlefield.MiniMap.UIBattlefieldMiniMapDsb",
  MiniMapOffY = -254,
  BattlefieldMgrGetter = function()
    return DataCenter.BattlefieldDsbDuelManager
  end,
  BattlefieldTemplateMgrGetter = function()
    return DataCenter.BattlefieldDsbDuelTemplateManager
  end,
  ActMsgIdGetter = function()
    return MsgDefines.DsbActInfo
  end,
  ActType = EnumActivity.ActDsbDuel.Type,
  BuildTemplate = "DataCenter.BattlefieldDsbDuel.Template.BattlefieldDsbBuildTemplate"
}
local _battlefieldUINames

function BattlefieldConfig.IsBattlefieldMainUI(uiName)
  if not uiName then
    return false
  end
  if not _battlefieldUINames then
    _battlefieldUINames = {}
    for k, v in pairs(BattlefieldBaseConfig) do
      _battlefieldUINames[v.UIName] = true
    end
  end
  return _battlefieldUINames[uiName]
end

return BattlefieldConfig
