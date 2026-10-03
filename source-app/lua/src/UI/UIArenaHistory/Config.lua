local UIArenaHistory = {
  Name = UIWindowNames.UIArenaHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIArenaHistory.Controller.UIArenaHistoryCtrl"),
  View = require("UI.UIArenaHistory.View.UIArenaHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIArena/UIArenHistory.prefab"
}
return {UIArenaHistory = UIArenaHistory}
