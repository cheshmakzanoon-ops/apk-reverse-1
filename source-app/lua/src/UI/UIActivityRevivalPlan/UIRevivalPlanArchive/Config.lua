local UIRevivalPlanArchive = {
  Name = UIWindowNames.UIRevivalPlanArchive,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlanArchive.Controller.UIRevivalPlanArchivePanelCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlanArchive.View.UIRevivalPlanArchivePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanArchivePanel.prefab"
}
return {UIRevivalPlanArchive = UIRevivalPlanArchive}
