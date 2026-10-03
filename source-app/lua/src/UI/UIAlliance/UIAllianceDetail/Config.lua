local UIAllianceDetail = {
  Name = UIWindowNames.UIAllianceDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceDetail.Controller.UIAllianceDetailCtrl"),
  View = require("UI.UIAlliance.UIAllianceDetail.View.UIAllianceDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceDetail.prefab"
}
return {UIAllianceDetail = UIAllianceDetail}
