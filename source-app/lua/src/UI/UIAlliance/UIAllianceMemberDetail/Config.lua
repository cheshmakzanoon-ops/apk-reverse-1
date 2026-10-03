local UIAllianceMemberDetail = {
  Name = UIWindowNames.UIAllianceMemberDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceMemberDetail.Controller.UIAllianceMemberDetailCtrl"),
  View = require("UI.UIAlliance.UIAllianceMemberDetail.View.UIAllianceMemberDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIOtherAllianceMemberDetail.prefab",
  HideBack = true
}
return {UIAllianceMemberDetail = UIAllianceMemberDetail}
