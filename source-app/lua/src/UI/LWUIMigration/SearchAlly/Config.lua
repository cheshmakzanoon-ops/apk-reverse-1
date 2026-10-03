local LWUIMigrationSearchAlly = {
  Name = UIWindowNames.LWUIMigrationSearchAlly,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.SearchAlly.LWUIMigration_SearchAllyCtrl"),
  View = require("UI.LWUIMigration.SearchAlly.LWUIMigration_SearchAlly"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_SearchAlly.prefab"
}
return {LWUIMigrationSearchAlly = LWUIMigrationSearchAlly}
