local LWGotoUpgradeBaseView = {
  Name = UIWindowNames.LWGotoUpgradeBaseView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGotoUpgradeBase.Controller.LWGotoUpgradeBaseCtrl"),
  View = require("UI.LWGotoUpgradeBase.View.LWGotoUpgradeBaseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGotoUpgradeBase/LWGotoUpgradeBase.prefab"
}
return {LWGotoUpgradeBaseView = LWGotoUpgradeBaseView}
