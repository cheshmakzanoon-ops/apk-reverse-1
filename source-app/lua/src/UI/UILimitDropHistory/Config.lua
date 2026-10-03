local UILimitDropHistory = {
  Name = UIWindowNames.UILimitDropHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILimitDropHistory.Ctrl.UILimitDropHistoryCtrl"),
  View = require("UI.UILimitDropHistory.View.UILimitDropHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILimitDropHistory_Prefab/UILimitDropHistory.prefab"
}
return {UILimitDropHistory = UILimitDropHistory}
