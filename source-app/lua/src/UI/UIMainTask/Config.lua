local UIMainTask = {
  Name = UIWindowNames.UIMainTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainTask.Controller.UIMainTaskViewCtrl"),
  View = require("UI.UIMainTask.View.UIMainTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMainTask/UIMainTask.prefab"
}
return {UIMainTask = UIMainTask}
