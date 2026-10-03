local AbundantHarvest_S6_1 = {
  AresScriptPath = "",
  NeedAresScriptPath = false,
  AresModelPath = "",
  NeedAresModelPath = false,
  AresEffects = {},
  IconIndex = 3,
  BaseScriptPath = "DataCenter.AllianceSkill.AbundantHarvestSkill",
  NeedBaseScriptPath = true,
  BaseModelPath = "",
  NeedBaseModelPath = false,
  NeedSkillIcon = false,
  BaseEffects = {
    {
      Tags = "start",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_wa.prefab",
      LogicType = 1,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 4.5,
      OverTime = 1.2,
      PlayOnDisplayMode = false
    },
    {
      Tags = "sole",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_wa_zhiliao_solo.prefab",
      LogicType = 1,
      LoadType = 2,
      StartTime = 3.0,
      Duration = 2.0,
      OverTime = 1.2,
      PlayOnDisplayMode = false
    }
  }
}
return AbundantHarvest_S6_1
