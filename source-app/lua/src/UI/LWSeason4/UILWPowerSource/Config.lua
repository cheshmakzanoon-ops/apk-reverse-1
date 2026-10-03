local UILWPowerSource = {
  Name = UIWindowNames.UILWPowerSource,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UILWPowerSource.Controller.UILWPowerSourceCtrl"),
  View = require("UI.LWSeason4.UILWPowerSource.View.UILWPowerSourceView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/UILWPowerSource.prefab"
}
return {UILWPowerSource = UILWPowerSource}
