local LWUIMigration_SetAllyRecruit = {
  Name = UIWindowNames.LWUIMigrationSetAllyRecruit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.SetAllyRecruit.Controller.LWUIMigration_SetAllyRecruitCtrl"),
  View = require("UI.LWUIMigration.SetAllyRecruit.View.LWUIMigration_SetAllyRecruitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_SetAllyRecruit.prefab"
}
return {LWUIMigration_SetAllyRecruit = LWUIMigration_SetAllyRecruit}
