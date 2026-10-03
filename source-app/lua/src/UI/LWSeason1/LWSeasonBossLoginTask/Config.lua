local LWSeasonBossLoginTask = {
  Name = UIWindowNames.LWSeasonBossLoginTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWSeasonBossLoginTask.Controller.LWSeasonBossLoginTaskCtrl"),
  View = require("UI.LWSeason1.LWSeasonBossLoginTask.View.LWSeasonBossLoginTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/BossLogin/LWSeasonBossLoginTask.prefab"
}
return {LWSeasonBossLoginTask = LWSeasonBossLoginTask}
