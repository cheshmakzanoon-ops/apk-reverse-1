local LWUIMigrationSetLanguage = {
  Name = UIWindowNames.LWUIMigrationSetLanguage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.SetLanguage.Controller.LWUIMigrationSetLanguageCtrl"),
  View = require("UI.LWUIMigration.SetLanguage.View.LWUIMigrationSetLanguageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationSetLanguage.prefab"
}
return {LWUIMigrationScore = LWUIMigrationSetLanguage}
