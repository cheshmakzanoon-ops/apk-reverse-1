local LWUIWorldBossTask = {
  Name = UIWindowNames.LWUIWorldBossTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossTask.Controller.LWUIWorldBossTaskCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossTask.View.LWUIWorldBossTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WorldBoss/UIWorldBossTask.prefab"
}
return {LWUIWorldBossTask = LWUIWorldBossTask}
