local LWUIMigrationGuide = {
  Name = UIWindowNames.LWUIMigrationGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Guide.Controller.LWUIMigrationGuideCtrl"),
  View = require("UI.LWUIMigration.Guide.View.LWUIMigrationGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationGuide.prefab"
}
return {LWUIMigrationGuide = LWUIMigrationGuide}
