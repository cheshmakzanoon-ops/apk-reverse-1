local UIGhostreconTaskSpecialBegin = {
  Name = UIWindowNames.UIGhostreconTaskSpecialBegin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Task.SpecialBegin.Controller.UIGhostreconTaskSpecialBeginCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Task.SpecialBegin.View.UIGhostreconTaskSpecialBeginView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Task/UIGhostreconTaskSpecialBegin.prefab"
}
return {UIGhostreconTaskSpecialBegin = UIGhostreconTaskSpecialBegin}
