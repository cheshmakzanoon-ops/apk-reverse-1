local UISetting = {
  Name = UIWindowNames.UISetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISetting.Controller.UISettingCtrl"),
  View = require("UI.UISetting.UISetting.View.UISettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingNew.prefab"
}
return {UISetting = UISetting}
