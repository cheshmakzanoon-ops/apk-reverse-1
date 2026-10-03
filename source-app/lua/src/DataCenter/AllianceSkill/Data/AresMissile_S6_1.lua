local AresMissile_S6_1 = {
  AresScriptPath = "DataCenter.AllianceGovernmentCommonSkill.Effect.AltarAresMissileSkillTarget",
  NeedAresScriptPath = true,
  AresModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/allianceBuilding_s6_zhanshenfeidan.prefab",
  NeedAresModelPath = true,
  AresEffects = {
    {
      Tags = "fire",
      Path = "ModelGo/Normal/action",
      LogicType = 4,
      LoadType = 1,
      StartTime = 0.0,
      Duration = 0.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  IconIndex = 3,
  BaseScriptPath = "DataCenter.AllianceGovernmentCommonSkill.Effect.AltarAresMissileSkill",
  NeedBaseScriptPath = true,
  BaseModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/A_build_S6_ares_missile_world.prefab",
  NeedBaseModelPath = true,
  NeedSkillIcon = true,
  BaseEffects = {
    {
      Tags = "loop",
      Path = "ModelGo/EffectGo/loop",
      LogicType = 4,
      LoadType = 1,
      StartTime = 0.0,
      Duration = 0.0,
      OverTime = -1.0,
      PlayOnDisplayMode = true
    },
    {
      Tags = "fire",
      Path = "ModelGo/EffectGo/action",
      LogicType = 3,
      LoadType = 1,
      StartTime = -10.0,
      Duration = 8.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  PreBlackModel = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_s2_ares_missile_black.prefab",
  AlertIcon = "Assets/Main/SeasonRes/S6/Sprites/AllianceSkill/ljq_zhujiemian_s6_fengshe.png"
}
return AresMissile_S6_1
