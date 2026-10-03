local UIDispatchTaskRecord = {
  Name = UIWindowNames.UIDispatchTaskRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Record.Controller.UIDispatchTaskRecordCtrl"),
  View = require("UI.UIDispatchTask.Record.View.UIDispatchTaskRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskRecord.prefab"
}
return {UIDispatchTaskRecord = UIDispatchTaskRecord}
