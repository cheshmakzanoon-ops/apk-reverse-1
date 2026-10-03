local UIGhostreconTeamUpSpecial = {
  Name = UIWindowNames.UIGhostreconTeamUpSpecial,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Special.Controller.UIGhostreconTeamUpSpecialCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Special.View.UIGhostreconTeamUpSpecialView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/TeamUp/UIGhostreconTeamUpSpecial.prefab"
}
return {UIGhostreconTeamUpSpecial = UIGhostreconTeamUpSpecial}
