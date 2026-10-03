local TeslaCoil_S6_1 = {
  AresScriptPath = "DataCenter.AllianceSkill.TeslaCoilSkillAlertEff",
  NeedAresScriptPath = true,
  AresModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/WarningEff_s6_Teslacoil.prefab",
  NeedAresModelPath = true,
  AresEffects = {
    {
      Tags = "xuli",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_yingwu_xuli.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 1.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "circle",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_yingwu_circle.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 3.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "hit",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_yingwu_attack.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 1.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  IconIndex = 3,
  BaseScriptPath = "DataCenter.AllianceSkill.TeslaCoilSkill",
  NeedBaseScriptPath = true,
  BaseModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/A_build_S6_teslacoil_world.prefab",
  NeedBaseModelPath = true,
  NeedSkillIcon = true,
  BaseEffects = {
    {
      Tags = "end",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_yingwu_tt_end.prefab",
      LogicType = 3,
      LoadType = 2,
      StartTime = -1.0,
      Duration = 2.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "loop",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_yingwu_tt_loop.prefab",
      LogicType = 2,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 9999.0,
      OverTime = 0.0,
      PlayOnDisplayMode = true
    }
  },
  AlertIcon = "Assets/Main/SeasonRes/S6/Sprites/AllianceSkill/ljq_zhujiemian_s6_fengshe.png",
  PrefabAlliancePreEffect = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampAllianceSkill/WorldCampAllianceSkillSkillTip.prefab",
  PrefabAlliancePreEffectCls = "UI.UIMoveCity.Component.MoveCityAllianceSkillEff"
}
return TeslaCoil_S6_1
