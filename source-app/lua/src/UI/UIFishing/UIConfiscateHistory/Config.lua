local UIConfiscateHistory = {
  Name = UIWindowNames.UIConfiscateHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIConfiscateHistory.UIConfiscateHistoryCtrl"),
  View = require("UI.UIFishing.UIConfiscateHistory.UIConfiscateHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIConfiscateHistory.prefab"
}
return {UIConfiscateHistory = UIConfiscateHistory}
