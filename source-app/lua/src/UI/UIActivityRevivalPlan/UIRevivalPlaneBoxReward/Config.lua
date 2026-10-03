local UIRevivalPlaneBoxReward = {
  Name = UIWindowNames.UIRevivalPlaneBoxReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlaneBoxReward.Controller.UIRevivalPlaneBoxRewardCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlaneBoxReward.View.UIRevivalPlaneBoxRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlaneBoxRewardPanel.prefab"
}
return {UIRevivalPlaneBoxReward = UIRevivalPlaneBoxReward}
