local UIAllianceAutoJoinRally = {
  Name = UIWindowNames.UIAllianceAutoJoinRally,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceAutoJoinRally.Controller.UIAllianceAutoJoinRallyCtrl"),
  View = require("UI.UIAlliance.UIAllianceAutoJoinRally.View.UIAllianceAutoJoinRallyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceAutoJoinRally.prefab"
}
return {UIAllianceAutoJoinRally = UIAllianceAutoJoinRally}
