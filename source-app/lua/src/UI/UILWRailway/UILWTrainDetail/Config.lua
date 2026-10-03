local UILWTrainDetail = {
  Name = UIWindowNames.UILWTrainDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainDetail.Controller.UILWTrainDetailCtrl"),
  View = require("UI.UILWRailway.UILWTrainDetail.View.UILWTrainDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainDetail.prefab"
}
return {UILWTrainDetail = UILWTrainDetail}
