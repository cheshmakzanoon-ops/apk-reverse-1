local UISettingFlag = {
  Name = UIWindowNames.UISettingFlag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingFlag.Controller.UISettingFlagCtrl"),
  View = require("UI.UISetting.UISettingFlag.View.UISettingFlagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingFlag.prefab"
}
return {UISettingFlag = UISettingFlag}
