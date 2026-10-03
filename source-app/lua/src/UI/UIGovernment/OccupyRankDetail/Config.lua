local UIGovernmentOccupyRankDetail = {
  Name = UIWindowNames.UIGovernmentOccupyRankDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OccupyRankDetail.Controller.OccupyRankDetailCtrl"),
  View = require("UI.UIGovernment.OccupyRankDetail.View.OccupyRankDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OccupyRankDetail.prefab"
}
return {UIGovernmentOccupyRankDetail = UIGovernmentOccupyRankDetail}
