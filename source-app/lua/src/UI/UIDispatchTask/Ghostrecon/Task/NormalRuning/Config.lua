local UIGhostreconTaskNormalRuning = {
  Name = UIWindowNames.UIGhostreconTaskNormalRuning,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Task.NormalRuning.Controller.UIGhostreconTaskNormalRuningCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Task.NormalRuning.View.UIGhostreconTaskNormalRuningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Task/UIGhostreconTaskNormalRuning.prefab"
}
return {UIGhostreconTaskNormalRuning = UIGhostreconTaskNormalRuning}
