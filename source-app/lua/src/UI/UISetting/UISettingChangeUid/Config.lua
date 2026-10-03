local UISettingChangeUid = {
  Name = UIWindowNames.UISettingChangeUid,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingChangeUid.Controller.UISettingChangeUidCtrl"),
  View = require("UI.UISetting.UISettingChangeUid.View.UISettingChangeUidView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingChangeUid.prefab"
}
return {UISettingChangeUid = UISettingChangeUid}
