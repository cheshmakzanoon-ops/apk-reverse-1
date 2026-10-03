local UILWTruckRecord = {
  Name = UIWindowNames.UILWTruckRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Controller.UILWTruckRecordCtrl"),
  View = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.View.UILWTruckRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTruckRecord.prefab"
}
return {UILWTruckRecord = UILWTruckRecord}
