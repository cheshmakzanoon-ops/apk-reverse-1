local UIBountyHunterSweepReward = {
  Name = UIWindowNames.UIBountyHunterSweepReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Ctrl.UIBountyHunterSweepRewardCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.View.UIBountyHunterSweepRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepReward.prefab",
  CustomKeyCodeEscape = true
}
return {UIBountyHunterSweepReward = UIBountyHunterSweepReward}
