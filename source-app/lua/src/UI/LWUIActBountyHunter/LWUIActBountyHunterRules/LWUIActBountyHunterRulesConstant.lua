local Constant = {}
Constant.Type = {
  Monster_Refresh = 1,
  Event_Refresh = 2,
  Minion_Reward = 3,
  Elite_Reward = 4,
  Fly_Reward = 5,
  Boss_Reward = 6,
  Box_Reward = 7
}
Constant.Item01AssetPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/LWUIActBountyHunterRulesDropItem01.prefab"
Constant.Item02AssetPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/LWUIActBountyHunterRulesDropItem02.prefab"
Constant.DetailItemAssetPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/LWUIActBountyHunterRulesDropDetailItem.prefab"
Constant.MonsterItemAssetPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/LWUIActBountyHunterRulesDropMonsterItem.prefab"
Constant.MonsterRewardTypes = {
  Constant.Type.Minion_Reward,
  Constant.Type.Elite_Reward,
  Constant.Type.Fly_Reward,
  Constant.Type.Boss_Reward
}
return Constant
