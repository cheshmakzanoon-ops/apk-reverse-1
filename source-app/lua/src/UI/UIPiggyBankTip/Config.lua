local UIPiggyBankTip = {
  Name = UIWindowNames.UIPiggyBankTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIPiggyBankTip.Controller.UIPiggyBankTipCtrl"),
  View = require("UI.UIPiggyBankTip.View.UIPiggyBankTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PiggyBank/UIPiggyBankTip.prefab"
}
return {UIPiggyBankTip = UIPiggyBankTip}
