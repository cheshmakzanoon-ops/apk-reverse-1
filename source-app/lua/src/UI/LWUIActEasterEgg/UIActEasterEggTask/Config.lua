local UIActEasterEggTask = {
  Name = UIWindowNames.UIActEasterEggTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.UIActEasterEggTask.Ctrl.UIActEasterEggTaskCtrl"),
  View = require("UI.LWUIActEasterEgg.UIActEasterEggTask.View.UIActEasterEggTaskView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/UIActEasterEggTask.prefab"
}
return {UIActEasterEggTask = UIActEasterEggTask}
