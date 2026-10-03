local LWUIMigrationSetting = {
  Name = UIWindowNames.LWUIMigrationSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Setting.Controller.LWUIMigrationSettingCtrl"),
  View = require("UI.LWUIMigration.Setting.View.LWUIMigrationSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationSetting.prefab"
}
return {LWUIMigrationSetting = LWUIMigrationSetting}
