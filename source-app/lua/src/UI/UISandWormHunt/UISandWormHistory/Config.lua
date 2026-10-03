local UISandWormHistory = {
  Name = UIWindowNames.UISandWormHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormHunt.UISandWormHistory.Controller.UISandWormHistoryCtrl"),
  View = require("UI.UISandWormHunt.UISandWormHistory.View.UISandWormHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/UISandWormHistory.prefab"
}
return {UISandWormHistory = UISandWormHistory}
