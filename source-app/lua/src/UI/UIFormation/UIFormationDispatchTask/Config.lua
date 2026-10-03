local UIFormationDispatchTask = {
  Name = UIWindowNames.UIFormationDispatchTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationDispatchTask.Controller.UIFormationDispatchTaskCtrl"),
  View = require("UI.UIFormation.UIFormationDispatchTask.View.UIFormationDispatchTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationDispatchTask.prefab"
}
return {UIFormationDispatchTask = UIFormationDispatchTask}
