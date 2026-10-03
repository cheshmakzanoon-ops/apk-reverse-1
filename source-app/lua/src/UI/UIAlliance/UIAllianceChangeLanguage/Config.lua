local UIAllianceChangeLanguage = {
  Name = UIWindowNames.UIAllianceChangeLanguage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceChangeLanguage.Controller.UIAllianceChangeLanguageCtrl"),
  View = require("UI.UIAlliance.UIAllianceChangeLanguage.View.UIAllianceChangeLanguageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIChangeAllianceLanguage.prefab"
}
return {UIAllianceChangeLanguage = UIAllianceChangeLanguage}
