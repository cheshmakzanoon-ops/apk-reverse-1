local UIBuildUpgradeTip = {
  Name = UIWindowNames.UIBuildUpgradeTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIBuildUpgradeTip.Controller.UIBuildUpgradeTipCtrl"),
  View = require("UI.UIBuildUpgradeTip.View.UIBuildUpgradeTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIUpgradeSuccess.prefab"
}
return {UIBuildUpgradeTip = UIBuildUpgradeTip}
