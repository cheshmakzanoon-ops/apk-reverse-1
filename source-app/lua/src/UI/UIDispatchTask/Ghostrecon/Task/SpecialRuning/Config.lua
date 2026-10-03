local UIGhostreconTaskSpecialRuning = {
  Name = UIWindowNames.UIGhostreconTaskSpecialRuning,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Task.SpecialRuning.Controller.UIGhostreconTaskSpecialRuningCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Task.SpecialRuning.View.UIGhostreconTaskSpecialRuningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Task/UIGhostreconTaskSpecialRuning.prefab"
}
return {UIGhostreconTaskSpecialRuning = UIGhostreconTaskSpecialRuning}
