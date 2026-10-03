local LWUIMigrationPlayerMark = {
  Name = UIWindowNames.LWUIMigrationPlayerMark,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.PlayerMark.Ctrl.LWUIMigrationPlayerMarkCtrl"),
  View = require("UI.LWUIMigration.PlayerMark.View.LWUIMigrationPlayerMarkView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationPlayerMark.prefab"
}
return {LWUIMigrationPlayerMark = LWUIMigrationPlayerMark}
