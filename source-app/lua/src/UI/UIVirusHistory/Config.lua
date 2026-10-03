local UIVirusHistory = {
  Name = UIWindowNames.UIVirusHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVirusHistory.Controller.UIVirusHistoryCtrl"),
  View = require("UI.UIVirusHistory.View.UIVirusHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIVirusHistory/UIVirusHistory.prefab"
}
return {UIVirusHistory = UIVirusHistory}
