local UIGhostreconFormation = {
  Name = UIWindowNames.UIGhostreconFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Formation.Controller.UIGhostreconFormationCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Formation.View.UIGhostreconFormationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Formation/UIGhostreconFormation.prefab"
}
return {UIGhostreconFormation = UIGhostreconFormation}
