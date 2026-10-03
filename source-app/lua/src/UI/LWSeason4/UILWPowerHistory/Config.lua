local UILWPowerHistory = {
  Name = UIWindowNames.UILWPowerHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UILWPowerHistory.Controller.UILWPowerHistoryCtrl"),
  View = require("UI.LWSeason4.UILWPowerHistory.View.UILWPowerHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/UILWPowerHistory.prefab"
}
return {UILWPowerHistory = UILWPowerHistory}
