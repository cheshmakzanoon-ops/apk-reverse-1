local AllianceMilitaryRewardUpgrade = {
  Name = UIWindowNames.AllianceMilitaryRewardUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAllianceMilitaryPay.RewardUpgrade.Ctrl.AllianceMilitaryRewardUpgradeCtrl"),
  View = require("UI.LWAllianceMilitaryPay.RewardUpgrade.View.AllianceMilitaryRewardUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceMilitaryPay/AllianceMilitaryRewardUpgrade.prefab"
}
return {AllianceMilitaryRewardUpgrade = AllianceMilitaryRewardUpgrade}
