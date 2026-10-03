local UIBuildUpgrade = {
  Name = UIWindowNames.UIBuildUpgrade,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIBuildUpgrade.Controller.UIBuildUpgradeCtrl"),
  View = require("UI.UIBuildUpgrade.View.UIBuildUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildUpgrade.prefab"
}
return {UIBuildUpgrade = UIBuildUpgrade}
