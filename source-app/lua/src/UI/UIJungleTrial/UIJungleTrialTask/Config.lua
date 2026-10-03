local UIJungleTrialTask = {
  Name = UIWindowNames.UIJungleTrialTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJungleTrial.UIJungleTrialTask.UIJungleTrialTaskCtrl"),
  View = require("UI.UIJungleTrial.UIJungleTrialTask.UIJungleTrialTaskView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/JungleTrial/UIJungleTrialTask.prefab"
}
return {UIJungleTrialTask = UIJungleTrialTask}
