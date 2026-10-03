local UIDispatchTreasureReward = {
  Name = UIWindowNames.UIDispatchTreasureReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Treasure.Reward.Controller.UIDispatchTreasureRewardCtrl"),
  View = require("UI.UIDispatchTask.Treasure.Reward.View.UIDispatchTreasureRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTreasure/UIDispatchTreasureReward.prefab",
  CustomKeyCodeEscape = true
}
return {UIDispatchTreasureReward = UIDispatchTreasureReward}
