local SeasonHunterReward = {
  Name = UIWindowNames.SeasonHunterReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterReward.SeasonHunterRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterReward.SeasonHunterRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterReward.prefab"
}
return {SeasonHunterReward = SeasonHunterReward}
