local UIDispatchTaskRecordNewView = {
  Name = UIWindowNames.UIDispatchTaskRecordNewView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.RecordNew.Ctrl.UIDispatchTaskRecordNewCtrl"),
  View = require("UI.UIDispatchTask.RecordNew.View.UIDispatchTaskRecordNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskRecordNew.prefab"
}
return {UIDispatchTaskRecordNewView = UIDispatchTaskRecordNewView}
