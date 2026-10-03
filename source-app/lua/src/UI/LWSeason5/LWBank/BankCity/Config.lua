local BankCity = {
  Name = UIWindowNames.BankCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWBank.BankCity.BankCityCtrl"),
  View = require("UI.LWSeason5.LWBank.BankCity.BankCityView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/BankCity.prefab"
}
return {BankCity = BankCity}
