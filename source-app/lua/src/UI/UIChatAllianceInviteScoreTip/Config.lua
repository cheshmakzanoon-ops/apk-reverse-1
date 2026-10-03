local UIChatAllianceInviteScoreTipView = {
  Name = UIWindowNames.UIChatAllianceInviteScoreTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatAllianceInviteScoreTip.Ctrl.UIChatAllianceInviteScoreTipCtrl"),
  View = require("UI.UIChatAllianceInviteScoreTip.View.UIChatAllianceInviteScoreTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAllianceInviteScoreTip/UIChatAllianceInviteScoreTip.prefab"
}
return {UIChatAllianceInviteScoreTipView = UIChatAllianceInviteScoreTipView}
