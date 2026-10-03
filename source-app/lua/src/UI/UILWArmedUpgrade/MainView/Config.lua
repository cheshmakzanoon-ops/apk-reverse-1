local UILWArmedUpgradeMain = {
  Name = UIWindowNames.UILWArmedUpgradeMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWArmedUpgrade.MainView.Ctrl.UILWArmedUpgradeMainCtrl"),
  View = require("UI.UILWArmedUpgrade.MainView.View.UILWArmedUpgradeMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWArmedUpgrade/MainView/UILWArmedUpgradeMain.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UILWArmedUpgradeMain = UILWArmedUpgradeMain}
