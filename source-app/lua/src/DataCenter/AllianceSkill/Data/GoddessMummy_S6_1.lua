local GoddessMummy_S6_1 = {
  AresScriptPath = "DataCenter.AllianceGovernmentCommonSkill.Effect.AltarGoddessMummySkillTarget",
  NeedAresScriptPath = true,
  AresModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/WarningEff_s6_GoddessMummy.prefab",
  NeedAresModelPath = true,
  AresEffects = {
    {
      Tags = "flyEnd",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_flyoff.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 3.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "hit",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_hit.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 0.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "zidan",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_zidan.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 0.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  IconIndex = 3,
  BaseScriptPath = "DataCenter.AllianceGovernmentCommonSkill.Effect.AltarGoddessMummySkill",
  NeedBaseScriptPath = true,
  BaseModelPath = "Assets/Main/SeasonRes/S6/Prefabs/AllianceBuilding/A_build_S6_goddess_mummy_world.prefab",
  NeedBaseModelPath = true,
  NeedSkillIcon = true,
  BaseEffects = {
    {
      Tags = "end",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_shifang_end.prefab",
      LogicType = 3,
      LoadType = 2,
      StartTime = -4.0,
      Duration = 2.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    },
    {
      Tags = "loop",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_shifang_loop.prefab",
      LogicType = 2,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 9999.0,
      OverTime = 0.0,
      PlayOnDisplayMode = true
    },
    {
      Tags = "start",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu.prefab",
      LogicType = 1,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 2.8,
      OverTime = 1.2,
      PlayOnDisplayMode = false
    },
    {
      Tags = "charge",
      Path = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_S6_AllianceSkill_bianfu_bat.prefab",
      LogicType = 4,
      LoadType = 2,
      StartTime = 0.0,
      Duration = 10.0,
      OverTime = 0.0,
      PlayOnDisplayMode = false
    }
  },
  AlertIcon = "Assets/Main/SeasonRes/S6/Sprites/AllianceSkill/ljq_zhujiemian_s6_bianfu.png"
}
return GoddessMummy_S6_1
