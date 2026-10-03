local LWUIMigrationScore = {
  Name = UIWindowNames.LWUIMigrationScore,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Score.Controller.LWUIMigrationScoreCtrl"),
  View = require("UI.LWUIMigration.Score.View.LWUIMigrationScoreView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationScore.prefab"
}
return {LWUIMigrationScore = LWUIMigrationScore}
