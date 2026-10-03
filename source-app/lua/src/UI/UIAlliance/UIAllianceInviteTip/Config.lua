local UIAllianceInviteTip = {
  Name = UIWindowNames.UIAllianceInviteTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceInviteTip.Controller.UIAllianceInviteTipCtrl"),
  View = require("UI.UIAlliance.UIAllianceInviteTip.View.UIAllianceInviteTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceInviteTip.prefab"
}
return {UIAllianceInviteTip = UIAllianceInviteTip}
