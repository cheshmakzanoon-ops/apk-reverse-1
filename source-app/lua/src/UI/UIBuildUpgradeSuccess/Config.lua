local UIBuildUpgradeSuccess = {
  Name = UIWindowNames.UIBuildUpgradeSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildUpgradeSuccess.Controller.UIBuildUpgradeSuccessCtrl"),
  View = require("UI.UIBuildUpgradeSuccess.View.UIBuildUpgradeSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgradeSuccess/UIBuildUpgradeSuccess.prefab"
}
return {UIBuildUpgradeSuccess = UIBuildUpgradeSuccess}
