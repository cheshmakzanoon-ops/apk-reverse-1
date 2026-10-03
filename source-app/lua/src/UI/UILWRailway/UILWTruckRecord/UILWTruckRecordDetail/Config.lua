local UILWTruckRecordDetail = {
  Name = UIWindowNames.UILWTruckRecordDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecordDetail.Controller.UILWTruckRecordDetailCtrl"),
  View = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecordDetail.View.UILWTruckRecordDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTruckRecordDetail.prefab",
  HideBack = true
}
return {UILWTruckRecordDetail = UILWTruckRecordDetail}
