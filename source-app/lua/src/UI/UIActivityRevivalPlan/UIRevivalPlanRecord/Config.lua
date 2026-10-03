local UIRevivalPlanRecord = {
  Name = UIWindowNames.UIRevivalPlanRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlanRecord.Controller.UIRevivalPlanRecordCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlanRecord.View.UIRevivalPlanRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanRecordPanel.prefab"
}
return {UIRevivalPlanRecord = UIRevivalPlanRecord}
