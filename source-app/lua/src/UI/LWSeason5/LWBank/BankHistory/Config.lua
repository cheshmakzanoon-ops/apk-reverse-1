local BankHistory = {
  Name = UIWindowNames.BankHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankHistory.BankHistoryCtrl"),
  View = require("UI.LWSeason5.LWBank.BankHistory.BankHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankHistory.prefab"
}
return {BankHistory = BankHistory}
