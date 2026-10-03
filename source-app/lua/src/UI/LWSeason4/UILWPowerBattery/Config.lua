local UILWPowerBattery = {
  Name = UIWindowNames.UILWPowerBattery,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UILWPowerBattery.Controller.UILWPowerBatteryCtrl"),
  View = require("UI.LWSeason4.UILWPowerBattery.View.UILWPowerBatteryView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/UILWPowerBattery.prefab"
}
return {UILWPowerBattery = UILWPowerBattery}
