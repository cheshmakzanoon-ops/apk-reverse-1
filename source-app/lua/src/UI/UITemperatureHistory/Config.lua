local UITemperatureHistory = {
  Name = UIWindowNames.UITemperatureHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITemperatureHistory.Controller.UITemperatureHistoryCtrl"),
  View = require("UI.UITemperatureHistory.View.UITemperatureHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITemperatureHistory/UITemperatureHistory.prefab"
}
return {UITemperatureHistory = UITemperatureHistory}
