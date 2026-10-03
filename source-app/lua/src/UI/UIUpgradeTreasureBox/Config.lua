local UIUpgradeTreasureBoxView = {
  Name = UIWindowNames.UIUpgradeTreasureBoxView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIUpgradeTreasureBox.Ctrl.UIUpgradeTreasureBoxCtrl"),
  View = require("UI.UIUpgradeTreasureBox.View.UIUpgradeTreasureBoxView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActUpgradeTreasureBox/Prefab/UIUpgradeTreasureBox.prefab",
  CustomKeyCodeEscape = true
}
return {UIUpgradeTreasureBoxView = UIUpgradeTreasureBoxView}
