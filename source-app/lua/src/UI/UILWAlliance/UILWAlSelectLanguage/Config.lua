local UILWAlSelectLanguage = {
  Name = UIWindowNames.UILWAlSelectLanguage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlSelectLanguage.Controller.UILWAlSelectLanguageCtrl"),
  View = require("UI.UILWAlliance.UILWAlSelectLanguage.View.UILWAlSelectLanguageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlSelectLanguage.prefab"
}
return {UILWAlSelectLanguage = UILWAlSelectLanguage}
