local UIAllianceInviteList = {
  Name = UIWindowNames.UIAllianceInviteList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceInviteList.Controller.UIAllianceInviteListCtrl"),
  View = require("UI.UIAlliance.UIAllianceInviteList.View.UIAllianceInviteListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceInviteList.prefab"
}
return {UIAllianceInviteList = UIAllianceInviteList}
