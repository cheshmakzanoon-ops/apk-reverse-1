local UIMailCampRestraintDetail = {
  Name = UIWindowNames.UIMailCampRestraintDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIMailCampRestraintDetail.Controller.UIMailCampRestraintDetailCtrl"),
  View = require("UI.UIFormation.UIMailCampRestraintDetail.View.UIMailCampRestraintDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIMailCampRestraintDetail.prefab"
}
return {UIMailCampRestraintDetail = UIMailCampRestraintDetail}
