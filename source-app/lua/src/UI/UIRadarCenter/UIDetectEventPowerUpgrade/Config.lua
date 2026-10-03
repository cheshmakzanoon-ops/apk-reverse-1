local UIDetectEventPowerUpgrade = {
  Name = UIWindowNames.UIDetectEventPowerUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRadarCenter.UIDetectEventPowerUpgrade.Controller.UIDetectEventPowerUpgradeCtrl"),
  View = require("UI.UIRadarCenter.UIDetectEventPowerUpgrade.View.UIDetectEventPowerUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRadarCenter/UIDetectEventPowerUpgrade.prefab"
}
return {UIDetectEventPowerUpgrade = UIDetectEventPowerUpgrade}
