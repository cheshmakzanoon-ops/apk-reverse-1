local LWUIMigrationResult = {
  Name = UIWindowNames.LWUIMigrationResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Result.Controller.LWUIMigrationResultCtrl"),
  View = require("UI.LWUIMigration.Result.View.LWUIMigrationResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationResult.prefab"
}
return {LWUIMigrationResult = LWUIMigrationResult}
