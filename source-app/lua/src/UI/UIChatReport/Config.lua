local UIChatReport = {
  Name = UIWindowNames.UIChatReport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatReport.Controller.UIChatReportCtrl"),
  View = require("UI.UIChatReport.View.UIChatReportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChatReport/UIChatReport.prefab"
}
return {UIChatReport = UIChatReport}
