local UIRevivalPlanRankReward = {
  Name = UIWindowNames.UIRevivalPlanRankReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlanRankReward.Controller.UIRevivalPlanRankRewardCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlanRankReward.View.UIRevivalPlanRankRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanRankRewardPanel.prefab"
}
return {UIRevivalPlanRankReward = UIRevivalPlanRankReward}
