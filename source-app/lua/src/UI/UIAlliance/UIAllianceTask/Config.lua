local UIAllianceTask = {
  Name = UIWindowNames.UIAllianceTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceTask.Controller.UIAllianceTaskCtrl"),
  View = require("UI.UIAlliance.UIAllianceTask.View.UIAllianceTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceTask.prefab"
}
return {UIAllianceTask = UIAllianceTask}
