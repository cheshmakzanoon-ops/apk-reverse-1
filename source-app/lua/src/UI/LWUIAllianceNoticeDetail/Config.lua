local LWUIAllianceNoticeDetail = {
  Name = UIWindowNames.LWUIAllianceNoticeDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllianceNoticeDetail.Controller.LWUIAllianceNoticeDetailCtrl"),
  View = require("UI.LWUIAllianceNoticeDetail.View.LWUIAllianceNoticeDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/LWUIAllianceNoticeDetail.prefab",
  CustomKeyCodeEscape = true
}
return {LWUIAllianceNoticeDetail = LWUIAllianceNoticeDetail}
