local UIExplorerTreasureReward = {
  Name = UIWindowNames.UIExplorerTreasureReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.ExplorerTreasure.Reward.Ctrl.UIExplorerTreasureRewardCtrl"),
  View = require("UI.UIDispatchTask.ExplorerTreasure.Reward.View.UIExplorerTreasureRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ExplorerTreasure/UIExplorerTreasureReward.prefab",
  CustomKeyCodeEscape = true
}
return {UIExplorerTreasureReward = UIExplorerTreasureReward}
