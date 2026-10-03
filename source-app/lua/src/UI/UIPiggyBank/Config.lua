local UIPiggyBank = {
  Name = UIWindowNames.UIPiggyBank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPiggyBank.Controller.UIPiggyBankCtrl"),
  View = require("UI.UIPiggyBank.View.UIPiggyBankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PiggyBank/UIPiggyBank.prefab"
}
return {UIPiggyBank = UIPiggyBank}
