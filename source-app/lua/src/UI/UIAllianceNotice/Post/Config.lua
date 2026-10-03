local UIPostAllianceNotice = {
  Name = UIWindowNames.UIPostAllianceNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceNotice.Post.Controller.UIPostAllianceNoticeCtrl"),
  View = require("UI.UIAllianceNotice.Post.View.UIPostAllianceNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceNotice/UIPostAllianceNotice.prefab"
}
return {UIPostAllianceNotice = UIPostAllianceNotice}
