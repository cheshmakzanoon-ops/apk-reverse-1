local UILWAllianceInvite = {
  Name = UIWindowNames.UILWAllianceInvite,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAllianceInvite.Controller.UILWAllianceInviteCtrl"),
  View = require("UI.UILWAllianceInvite.View.UILWAllianceInviteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWAllianceInvite/UILWAllianceInvite.prefab"
}
return {UILWAllianceInvite = UILWAllianceInvite}
