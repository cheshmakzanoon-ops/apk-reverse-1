local UILWMummyHistory = {
  Name = UIWindowNames.UILWMummyHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWMummyHistory.Controller.UILWMummyHistoryCtrl"),
  View = require("UI.LWSeasonShared.UILWMummyHistory.View.UILWMummyHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UIMummyMain/UIMummyHistory.prefab"
}
return {UILWMummyHistory = UILWMummyHistory}
