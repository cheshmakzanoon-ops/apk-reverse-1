local UIAllianceWarDetail = {
  Name = UIWindowNames.UIAllianceWarDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceWarDetail.Controller.UIAllianceWarDetailCtrl"),
  View = require("UI.UIAlliance.UIAllianceWarDetail.View.UIAllianceWarDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceWarDetail.prefab"
}
return {UIAllianceWarDetail = UIAllianceWarDetail}
