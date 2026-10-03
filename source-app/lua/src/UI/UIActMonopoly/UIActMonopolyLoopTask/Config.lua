local UIActMonopolyLoopTask = {
  Name = UIWindowNames.UIActMonopolyLoopTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyLoopTask.Controller.UIActMonopolyLoopTaskCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyLoopTask.View.UIActMonopolyLoopTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyLoopTask.prefab"
}
return {UIActMonopolyLoopTask = UIActMonopolyLoopTask}
