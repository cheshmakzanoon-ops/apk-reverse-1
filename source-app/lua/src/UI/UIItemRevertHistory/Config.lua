local UIItemRevertHistory = {
  Name = UIWindowNames.UIItemRevertHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIItemRevertHistory.Controller.UIItemRevertHistoryCtrl"),
  View = require("UI.UIItemRevertHistory.View.UIItemRevertHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIItemRevert/UIItemRevertHistory.prefab",
  HideBack = false,
  CustomKeyCodeEscape = false
}
return {UIItemRevertHistory = UIItemRevertHistory}
