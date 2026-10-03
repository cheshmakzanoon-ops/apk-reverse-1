local UIChatReportSpecificType = {
  Name = UIWindowNames.UIChatReportSpecificType,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatReportSpecificType.Controller.UIChatReportSpecificTypeCtrl"),
  View = require("UI.UIChatReportSpecificType.View.UIChatReportSpecificTypeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChatReport/UIChatReportSpecificType.prefab"
}
return {UIChatReportSpecificType = UIChatReportSpecificType}
