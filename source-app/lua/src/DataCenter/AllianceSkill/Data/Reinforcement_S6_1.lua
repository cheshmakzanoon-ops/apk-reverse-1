local Reinforcement_S6_1 = {
  AresScriptPath = "",
  NeedAresScriptPath = false,
  AresModelPath = "",
  NeedAresModelPath = false,
  AresEffects = {
    {
      Tags = "end",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_she_shield_end.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 2.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "loop",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_she_shield_loop.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 0.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "sole",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_she_shield_shifang.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 1.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  IconIndex = 3,
  BaseScriptPath = "DataCenter.AllianceSkill.ReinforcementSkill",
  NeedBaseScriptPath = true,
  BaseModelPath = "",
  NeedBaseModelPath = false,
  NeedSkillIcon = false,
  BaseEffects = {
    {
      Tags = "start",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_she.prefab",
      LogicType = 1,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 4.0,
      OverTime = 1.2,
      PlayOnDisplayMode = false
    }
  }
}
return Reinforcement_S6_1
