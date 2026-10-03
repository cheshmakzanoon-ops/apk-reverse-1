local UIBuildDecoUpgradeSuccess = {
  Name = UIWindowNames.UIBuildDecoUpgradeSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildDecoUpgradeSuccess.Ctrl.UIBuildDecoUpgradeSuccessCtrl"),
  View = require("UI.UIBuildDecoUpgradeSuccess.View.UIBuildDecoUpgradeSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgradeSuccess/UIDecoBuildUpgradeSuccess.prefab"
}
return {UIBuildDecoUpgradeSuccess = UIBuildDecoUpgradeSuccess}
