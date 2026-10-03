local UIAllianceInvite = {
  Name = UIWindowNames.UIAllianceInvite,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceInvite.Controller.UIAllianceInviteCtrl"),
  View = require("UI.UIAllianceInvite.View.UIAllianceInviteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceInvite.prefab"
}
return {UIAllianceInvite = UIAllianceInvite}
