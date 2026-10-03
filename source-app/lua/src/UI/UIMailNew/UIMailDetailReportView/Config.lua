local UIMailDetailReportView = {
  Name = UIWindowNames.UIMailDetailReportView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailDetailReportView.Controller.UIMailDetailReportCtrl"),
  View = require("UI.UIMailNew.UIMailDetailReportView.View.UIMailDetailReportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/MailDetailView/UIMailDetailView.prefab"
}
return {UIMailDetailReportView = UIMailDetailReportView}
