local UIActivityRebateNewPackageReward = {
  Name = UIWindowNames.UIActivityRebateNewPackageReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRebateNew.Ctrl.UIRebateNewActivityPackageRewardCtrl"),
  View = require("UI.UIActivityRebateNew.View.UIRebateNewActivityPackageRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RebateNew/UIRebateNewActivityPackageReward.prefab"
}
return {UIActivityRebateNewPackageReward = UIActivityRebateNewPackageReward}
