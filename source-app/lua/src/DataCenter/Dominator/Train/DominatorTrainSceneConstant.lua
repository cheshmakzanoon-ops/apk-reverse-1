local Constant = {}
Constant.DefaultScenePos = Vector3.New(10000, -0.02, -10000)
Constant.rtWidth = 810
Constant.rtHeight = 1440
Constant.SceneAssetPath = "Assets/Main/CoditionLoadRes/Dominator/Common/Prefabs/TrainScene/DominatorTrainScene.prefab"
Constant.TempIdleModelPath = "Assets/Main/Prefabs/PrefabsIncrement/Character/Dominator/Ape/Equip/A_Zhuzai_monkey_LV00/A_Zhuzai_monkey_LV00_xunlian.prefab"
Constant.DominatorPosOffset = {
  {
    Vector3(0, 0.273, -13.3)
  },
  {
    Vector3(-3.04, 0.273, -13.3),
    Vector3(4.08, 0.28, -15.7)
  },
  {
    Vector3(-7.52, 0.273, -13.3),
    Vector3(0, 0.273, -13.3),
    Vector3(7.52, 0.273, -13.3)
  },
  {
    Vector3(-8.91, 0.273, -25.96),
    Vector3(8.91, 0.273, -25.96),
    Vector3(-3.37, 0.273, -30.85),
    Vector3(3.37, 0.273, -30.85)
  }
}
Constant.DefaultMonsterRect = {
  5,
  5,
  3
}
Constant.DefaultMonsterCenterPos = {0, 7}
Constant.DefaultMonsterId = 100000
Constant.MonsterObjectIdMin = 300000
Constant.MonsterObjectIdMax = 400000
Constant.DefaultMissileDamage = 10000
Constant.BattleDuration = 15
Constant.DominatorBattleAngle = Vector3(0, 0, 0)
Constant.DominatorIdleAngle = Vector3(0, 180, 0)
Constant.DominatorIdleEffectAssetPath = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_shengji.prefab"
Constant.DominatorIdleEffectScale = Vector3(0.3, 0.3, 0.3)
Constant.UpgradeEffectAssetPathDict = {
  [DominatorTrainGroupId.Attack] = "Assets/_Art_LastWar/Effect/Prefab/2025/Eff_enhance_content/Eff_enhance_content_Up01.prefab",
  [DominatorTrainGroupId.Defence] = "Assets/_Art_LastWar/Effect/Prefab/2025/Eff_enhance_content/Eff_enhance_content_Up02.prefab",
  [DominatorTrainGroupId.Hp] = "Assets/_Art_LastWar/Effect/Prefab/2025/Eff_enhance_content/Eff_enhance_content_Up03.prefab"
}
Constant.UpgradeEffectScaleDict = {
  [DominatorTrainGroupId.Attack] = Vector3(1.15, 1.5, 1.5),
  [DominatorTrainGroupId.Defence] = Vector3(1.15, 1.5, 1.5),
  [DominatorTrainGroupId.Hp] = Vector3(1.15, 1.5, 1.5)
}
return Constant
