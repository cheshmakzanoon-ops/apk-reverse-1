local UIRevivalPlanTask = {
  Name = UIWindowNames.UIRevivalPlanTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlanTask.Controller.UIRevivalPlanTaskCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlanTask.View.UIRevivalPlanTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanTaskPanel.prefab"
}
return {UIRevivalPlanTask = UIRevivalPlanTask}
