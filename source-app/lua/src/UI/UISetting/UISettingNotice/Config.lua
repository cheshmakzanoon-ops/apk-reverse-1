local UISettingNotice = {
  Name = UIWindowNames.UISettingNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingNotice.Controller.UISettingNoticeCtrl"),
  View = require("UI.UISetting.UISettingNotice.View.UISettingNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingNotice.prefab"
}
return {UISettingNotice = UISettingNotice}
