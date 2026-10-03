local UISettingChooseURL = {
  Name = UIWindowNames.UISettingChooseURL,
  Layer = UILayer.Info,
  Ctrl = require("UI.UISetting.UISettingChooseURL.Controller.UISettingChooseURLCtrl"),
  View = require("UI.UISetting.UISettingChooseURL.View.UISettingChooseURLView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingChooseURL.prefab"
}
return {UISettingChooseURL = UISettingChooseURL}
