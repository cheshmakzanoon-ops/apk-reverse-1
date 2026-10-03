local UIPVEFactoryUpgrade = {
  Name = UIWindowNames.UIPVEFactoryUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEFactoryUpgrade.Controller.UIPVEFactoryUpgradeCtrl"),
  View = require("UI.UIPVE.UIPVEFactoryUpgrade.View.UIPVEFactoryUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEFactoryUpgrade.prefab"
}
return {UIPVEFactoryUpgrade = UIPVEFactoryUpgrade}
