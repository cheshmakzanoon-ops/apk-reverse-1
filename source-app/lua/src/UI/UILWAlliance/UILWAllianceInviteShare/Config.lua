local UILWAllianceInviteShare = {
  Name = UIWindowNames.UILWAllianceInviteShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceInviteShare.Controller.UILWAllianceInviteShareCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceInviteShare.View.UILWAllianceInviteShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceInviteShare.prefab"
}
return {UILWAllianceInviteShare = UILWAllianceInviteShare}
