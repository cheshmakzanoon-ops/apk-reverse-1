local UISettingLanguage = {
  Name = UIWindowNames.UISettingLanguage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingLanguage.Controller.UISettingLanguageCtrl"),
  View = require("UI.UISetting.UISettingLanguage.View.UISettingLanguageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingLanguageNew.prefab"
}
return {UISettingLanguage = UISettingLanguage}
