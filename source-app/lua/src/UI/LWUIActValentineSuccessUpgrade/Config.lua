local ValentineSuccessUpgrade = {
  Name = UIWindowNames.ValentineSuccessUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineSuccessUpgrade.Ctrl.ValentineSuccessUpgradeCtrl"),
  View = require("UI.LWUIActValentineSuccessUpgrade.View.ValentineSuccessUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineSuccessUpgrade.prefab",
  CustomKeyCodeEscape = true
}
return {ValentineSuccessUpgrade = ValentineSuccessUpgrade}
