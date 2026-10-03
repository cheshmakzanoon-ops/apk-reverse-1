local UIBountyHunterSweepConfirm = {
  Name = UIWindowNames.UIBountyHunterSweepConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Confirm.Ctrl.UIBountyHunterSweepConfirmCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Confirm.View.UIBountyHunterSweepConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepConfirm.prefab"
}
return {UIBountyHunterSweepConfirm = UIBountyHunterSweepConfirm}
