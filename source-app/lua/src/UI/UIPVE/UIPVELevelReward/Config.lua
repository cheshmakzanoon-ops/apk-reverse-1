local UIPVELevelReward = {
  Name = UIWindowNames.UIPVELevelReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVELevelReward.Controller.UIPVELevelRewardCtrl"),
  View = require("UI.UIPVE.UIPVELevelReward.View.UIPVELevelRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVELevelReward.prefab"
}
return {UIPVELevelReward = UIPVELevelReward}
