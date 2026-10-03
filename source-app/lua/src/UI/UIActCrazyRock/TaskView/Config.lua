local UIActCrazyRockTask = {
  Name = UIWindowNames.UIActCrazyRockTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActCrazyRock.TaskView.Ctrl.UIActCrazyRockTaskCtrl"),
  View = require("UI.UIActCrazyRock.TaskView.View.UIActCrazyRockTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActCrazyRock/UIActCrazyRockTask.prefab"
}
return {UIActCrazyRockTask = UIActCrazyRockTask}
