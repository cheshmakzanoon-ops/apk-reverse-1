local BankDepositInfo = {
  Name = UIWindowNames.BankDepositInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankDepositInfo.BankDepositInfoCtrl"),
  View = require("UI.LWSeason5.LWBank.BankDepositInfo.BankDepositInfoView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankDepositInfo.prefab"
}
return {BankDepositInfo = BankDepositInfo}
