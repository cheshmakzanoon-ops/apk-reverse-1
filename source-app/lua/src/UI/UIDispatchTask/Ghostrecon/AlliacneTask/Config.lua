local UIGhostreconAllianceTask = {
  Name = UIWindowNames.Config,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.AlliacneTask.Controller.UIGhostreconAllianceTaskCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.AlliacneTask.View.UIGhostreconAllianceTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/AllianceTask/UIGhostreconAllianceTask.prefab"
}
return {UIGhostreconAllianceTask = UIGhostreconAllianceTask}
