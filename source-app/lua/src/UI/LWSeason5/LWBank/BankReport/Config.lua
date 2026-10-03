local BankReport = {
  Name = UIWindowNames.BankReport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankReport.BankReportCtrl"),
  View = require("UI.LWSeason5.LWBank.BankReport.BankReportView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankReport.prefab"
}
return {BankReport = BankReport}
