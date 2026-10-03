local BankSetting = {
  Name = UIWindowNames.BankSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankSetting.BankSettingCtrl"),
  View = require("UI.LWSeason5.LWBank.BankSetting.BankSettingView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankSetting.prefab"
}
return {BankSetting = BankSetting}
