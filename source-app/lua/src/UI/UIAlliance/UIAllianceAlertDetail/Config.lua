local UIAllianceAlertDetail = {
  Name = UIWindowNames.UIAllianceWarDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceAlertDetail.Controller.UIAllianceAlertDetailCtrl"),
  View = require("UI.UIAlliance.UIAllianceAlertDetail.View.UIAllianceAlertDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceAlertDetail.prefab"
}
return {UIAllianceAlertDetail = UIAllianceAlertDetail}
