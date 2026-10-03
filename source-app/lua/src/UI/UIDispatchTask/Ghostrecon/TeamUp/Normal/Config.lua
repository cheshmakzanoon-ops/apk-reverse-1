local UIGhostreconTeamUpNormal = {
  Name = UIWindowNames.UIGhostreconTeamUpNormal,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Normal.Controller.UIGhostreconTeamUpNormalCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Normal.View.UIGhostreconTeamUpNormalView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/TeamUp/UIGhostreconTeamUpNormal.prefab"
}
return {UIGhostreconTeamUpNormal = UIGhostreconTeamUpNormal}
