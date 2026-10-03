local UIMainPlayerReportTable = {
  Name = UIWindowNames.UIMainPlayerReportTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainPlayerReportTable.Controller.UIMainPlayerReportTableCtrl"),
  View = require("UI.UIMainPlayerReportTable.View.UIMainPlayerReportTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMainBottonBuild/UIMainPlayerReportTable.prefab"
}
return {UIMainPlayerReportTable = UIMainPlayerReportTable}
