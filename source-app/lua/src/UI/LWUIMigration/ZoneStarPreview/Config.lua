local LWUIMigrationZoneStarPreview = {
  Name = UIWindowNames.LWUIMigrationZoneStarPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.ZoneStarPreview.LWUIMigration_ZoneStarPreviewCtrl"),
  View = require("UI.LWUIMigration.ZoneStarPreview.LWUIMigration_ZoneStarPreview"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_ZoneStarPreview.prefab"
}
return {LWUIMigrationZoneStarPreview = LWUIMigrationZoneStarPreview}
