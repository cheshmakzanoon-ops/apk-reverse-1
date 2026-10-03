local LWUIZoneMobilizationTask = {
  Name = UIWindowNames.LWUIZoneMobilizationTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUITask.Controller.LWUIZoneMobilizationTaskCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUITask.View.LWUIZoneMobilizationTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationTaskPanel.prefab"
}
return {LWUIZoneMobilizationTask = LWUIZoneMobilizationTask}
