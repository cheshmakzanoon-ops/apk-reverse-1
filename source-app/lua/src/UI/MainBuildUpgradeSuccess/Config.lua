local MainBuildUpgradeSuccess = {
  Name = UIWindowNames.MainBuildUpgradeSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MainBuildUpgradeSuccess.Controller.MainBuildUpgradeSuccessCtrl"),
  View = require("UI.MainBuildUpgradeSuccess.View.MainBuildUpgradeSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/MainBuildUpgradeSuccessView.prefab"
}
return {UIBuildList = MainBuildUpgradeSuccess}
