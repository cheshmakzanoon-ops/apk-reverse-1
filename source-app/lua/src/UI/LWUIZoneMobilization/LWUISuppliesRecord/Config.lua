local LWUIZoneMobilizationSuppliesRecord = {
  Name = UIWindowNames.LWUIZoneMobilizationSuppliesRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUISuppliesRecord.Controller.LWUIZoneMobilizationSuppliesRecordCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUISuppliesRecord.View.LWUIZoneMobilizationSuppliesRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationSuppliesRecord.prefab"
}
return {LWUIZoneMobilizationSuppliesRecord = LWUIZoneMobilizationSuppliesRecord}
