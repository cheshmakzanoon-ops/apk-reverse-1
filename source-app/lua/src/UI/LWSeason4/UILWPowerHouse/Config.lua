local UILWPowerHouse = {
  Name = UIWindowNames.UILWPowerHouse,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UILWPowerHouse.Controller.UILWPowerHouseCtrl"),
  View = require("UI.LWSeason4.UILWPowerHouse.View.UILWPowerHouseView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/UILWPowerHouse.prefab"
}
return {UILWPowerHouse = UILWPowerHouse}
