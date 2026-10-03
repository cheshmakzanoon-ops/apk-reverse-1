local UIBuildUpgradeAddDes = {
  Name = UIWindowNames.UIBuildUpgradeAddDes,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildUpgradeAddDes.Controller.UIBuildUpgradeAddDesCtrl"),
  View = require("UI.UIBuildUpgradeAddDes.View.UIBuildUpgradeAddDesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIBuildUpgradeAddDes.prefab"
}
return {UIBuildUpgradeAddDes = UIBuildUpgradeAddDes}
