local LWUIMigrationSetAllyRecruitLanguage = {
  Name = UIWindowNames.LWUIMigrationSetAllyRecruitLanguage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.SetAllyRecruitLanguage.Controller.LWUIMigrationSetAllyRecruitLanguageCtrl"),
  View = require("UI.LWUIMigration.SetAllyRecruitLanguage.View.LWUIMigrationSetAllyRecruitLanguageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_AllyRecruitSetLanguage.prefab"
}
return {LWUIMigrationSetAllyRecruitLanguage = LWUIMigrationSetAllyRecruitLanguage}
