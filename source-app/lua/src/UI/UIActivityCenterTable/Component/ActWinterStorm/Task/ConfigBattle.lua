local UIWinterStormBattleTask = {
  Name = UIWindowNames.UIWinterStormBattleTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Controller.UIWinterStormBattleTaskCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Task.View.UIWinterStormBattleTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormBattleTask.prefab"
}
return {UIWinterStormBattleTask = UIWinterStormBattleTask}
