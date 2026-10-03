local UIBuildUpgradeExtraTip = {
  Name = UIWindowNames.UIBuildUpgradeExtraTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildUpgradeExtraTip.Controller.UIBuildUpgradeExtraTipCtrl"),
  View = require("UI.UIBuildUpgradeExtraTip.View.UIBuildUpgradeExtraTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildUpgradeExtraTip.prefab"
}
return {UIBuildUpgradeExtraTip = UIBuildUpgradeExtraTip}
