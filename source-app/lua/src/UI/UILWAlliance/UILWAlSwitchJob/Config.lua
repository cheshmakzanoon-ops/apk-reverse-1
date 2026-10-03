local UILWAlSwitchJob = {
  Name = UIWindowNames.UILWAlSwitchJob,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlSwitchJob.Ctrl.UILWAlSwitchJobCtrl"),
  View = require("UI.UILWAlliance.UILWAlSwitchJob.View.UILWAlSwitchJobView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlSwitchJob.prefab"
}
return {UILWAlSwitchJob = UILWAlSwitchJob}
