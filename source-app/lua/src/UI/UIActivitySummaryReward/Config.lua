local UIActivitySummaryReward = {
  Name = UIWindowNames.UIActivitySummaryReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivitySummaryReward.Controller.UIActivitySummaryRewardCtrl"),
  View = require("UI.UIActivitySummaryReward.View.UIActivitySummaryRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIActivitySummaryReward/UIActivitySummaryReward.prefab"
}
return {UIActivitySummaryReward = UIActivitySummaryReward}
