local UIGhostreconRecord = {
  Name = UIWindowNames.UIGhostreconRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Record.Controller.UIGhostreconRecordCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Record.View.UIGhostreconRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Record/UIGhostreconRecord.prefab"
}
return {UIGhostreconRecord = UIGhostreconRecord}
