local UIAllianceEveryDayTask = {
  Name = UIWindowNames.UIAllianceEveryDayTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceEveryDayTask.Controller.UIAllianceEveryDayTaskCtrl"),
  View = require("UI.UIAlliance.UIAllianceEveryDayTask.View.UIAllianceEveryDayTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceEveryDayTask.prefab"
}
return {UIAllianceEveryDayTask = UIAllianceEveryDayTask}
