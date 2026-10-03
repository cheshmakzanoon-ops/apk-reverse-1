local LWDecorationBookUpgrade = {
  Name = UIWindowNames.LWDecorationBookUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWDecorationBookUpgrade.Controller.LWDecorationBookUpgradeCtrl"),
  View = require("UI.LWDecorationBookUpgrade.View.LWDecorationBookUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildUpgrade.prefab"
}
return {LWDecorationBookUpgrade = LWDecorationBookUpgrade}
