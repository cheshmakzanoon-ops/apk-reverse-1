local LWUICivilizationSparkUpgrade = {
  Name = UIWindowNames.LWUICivilizationSparkUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUICivilizationSparkUpgrade.Ctrl.LWUICivilizationSparkUpgradeCtrl"),
  View = require("UI.LWUICivilizationSparkUpgrade.View.LWUICivilizationSparkUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUICivilizationSpark/LWUICivilizationSparkUpgradeView.prefab"
}
return {LWUICivilizationSparkUpgrade = LWUICivilizationSparkUpgrade}
