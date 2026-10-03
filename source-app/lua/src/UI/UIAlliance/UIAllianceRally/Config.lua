local UIAllianceRally = {
  Name = UIWindowNames.UIAllianceRally,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceRally.Controller.UIAllianceRallyCtrl"),
  View = require("UI.UIAlliance.UIAllianceRally.View.UIAllianceRallyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISearch/AllianceRallyUI.prefab"
}
return {UIAllianceRally = UIAllianceRally}
