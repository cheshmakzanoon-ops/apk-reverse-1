local CrossOccupyRankDetail = {
  Name = UIWindowNames.CrossOccupyRankDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.CrossOccupyRankDetail.Controller.CrossOccupyRankDetailCtrl"),
  View = require("UI.UIGovernment.CrossOccupyRankDetail.View.CrossOccupyRankDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/CrossOccupyRankDetail.prefab"
}
return {CrossOccupyRankDetail = CrossOccupyRankDetail}
