local UIActMonopolyTask = {
  Name = UIWindowNames.UIActMonopolyTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyTask.Controller.UIActMonopolyTaskCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyTask.View.UIActMonopolyTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyTask.prefab"
}
return {UIActMonopolyTask = UIActMonopolyTask}
