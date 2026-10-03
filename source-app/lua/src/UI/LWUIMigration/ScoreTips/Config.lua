local LWUIMigration_ScoreTips = {
  Name = UIWindowNames.LWUIMigrationScoreTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.ScoreTips.LWUIMigration_ScoreTipsCtrl"),
  View = require("UI.LWUIMigration.ScoreTips.LWUIMigration_ScoreTips"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_ScoreTips.prefab"
}
return {LWUIMigration_ScoreTips = LWUIMigration_ScoreTips}
