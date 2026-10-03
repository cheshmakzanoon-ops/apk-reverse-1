local UILWSeasonCrossOccupyDetail = {
  Name = UIWindowNames.UILWSeasonCrossOccupyDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonCrossOccupyDetail.Controller.UILWSeasonCrossOccupyDetailCtrl"),
  View = require("UI.LWSeason1.UILWSeasonCrossOccupyDetail.View.UILWSeasonCrossOccupyDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/CrossServerAttackCity/CrossOccupyDetail.prefab"
}
return {UILWSeasonCrossOccupyDetail = UILWSeasonCrossOccupyDetail}
