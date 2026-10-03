local BankCityHistory = {
  Name = UIWindowNames.BankCityHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankCityHistory.BankCityHistoryCtrl"),
  View = require("UI.LWSeason5.LWBank.BankCityHistory.BankCityHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankCityHistory.prefab"
}
return {BankCityHistory = BankCityHistory}
