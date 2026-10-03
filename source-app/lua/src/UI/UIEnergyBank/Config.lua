local UIEnergyBank = {
  Name = UIWindowNames.UIEnergyBank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEnergyBank.Controller.UIEnergyBankCtrl"),
  View = require("UI.UIEnergyBank.View.UIEnergyBankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEnergyBank/UIEnergyBank.prefab"
}
return {UIEnergyBank = UIEnergyBank}
