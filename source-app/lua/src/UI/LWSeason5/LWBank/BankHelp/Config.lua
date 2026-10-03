local BankHelp = {
  Name = UIWindowNames.BankHelp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankHelp.BankHelpCtrl"),
  View = require("UI.LWSeason5.LWBank.BankHelp.BankHelpView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankHelp.prefab"
}
return {BankHelp = BankHelp}
