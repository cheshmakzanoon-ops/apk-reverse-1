local UIChampionDuelReward = {
  Name = UIWindowNames.UIChampionDuelReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.Reward.Controller.UIChampionDuelRewardCtrl"),
  View = require("UI.UIChampionDuel.Reward.View.UIChampionDuelRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelReward.prefab"
}
return {UIChampionDuelReward = UIChampionDuelReward}
