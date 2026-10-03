local UIWorldOccupyHistory = {
  Name = UIWindowNames.UIWorldOccupyHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldOccupyHistory.Controller.UIWorldOccupyHistoryCtrl"),
  View = require("UI.LWWorld.UIWorldOccupyHistory.View.UIWorldOccupyHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/UIWorldOccupyHistory.prefab"
}
return {UIWorldOccupyHistory = UIWorldOccupyHistory}
