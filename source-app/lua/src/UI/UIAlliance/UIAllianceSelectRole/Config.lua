local UIAllianceSelectRole = {
  Name = UIWindowNames.UIAllianceSelectRole,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceSelectRole.Controller.UIAllianceSelectRoleCtrl"),
  View = require("UI.UIAlliance.UIAllianceSelectRole.View.UIAllianceSelectRoleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceSelectRole.prefab"
}
return {UIAllianceSelectRole = UIAllianceSelectRole}
