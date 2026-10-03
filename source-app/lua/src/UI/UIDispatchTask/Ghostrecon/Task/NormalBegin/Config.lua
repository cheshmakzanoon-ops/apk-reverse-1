local UIGhostreconTaskNormalBegin = {
  Name = UIWindowNames.UIGhostreconTaskNormalBegin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Task.NormalBegin.Controller.UIGhostreconTaskNormalBeginCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Task.NormalBegin.View.UIGhostreconTaskNormalBeginView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Task/UIGhostreconTaskNormalBegin.prefab"
}
return {UIGhostreconTaskNormalBegin = UIGhostreconTaskNormalBegin}
