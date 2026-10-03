local UILWAlSetting = {
  Name = UIWindowNames.UILWAlSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlSetting.Controller.UILWAlSettingCtrl"),
  View = require("UI.UILWAlliance.UILWAlSetting.View.UILWAlSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlSetting.prefab"
}
return {UILWAlSetting = UILWAlSetting}
