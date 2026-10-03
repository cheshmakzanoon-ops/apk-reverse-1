local UIEnergyBankTip = {
  Name = UIWindowNames.UIEnergyBankTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIEnergyBankTip.Controller.UIEnergyBankTipCtrl"),
  View = require("UI.UIEnergyBankTip.View.UIEnergyBankTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEnergyBank/UIEnergyBankTip.prefab"
}
return {UIEnergyBankTip = UIEnergyBankTip}
