local UIDailyActivity = {
  Name = UIWindowNames.UIDailyActivity,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIDailyActivity.Controller.UIDailyActivityCtrl"),
  View = require("UI.UIDailyActivity.View.UIDailyActivityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDailyActivity/UIDailyActivity.prefab"
}
return {UIDailyActivity = UIDailyActivity}
