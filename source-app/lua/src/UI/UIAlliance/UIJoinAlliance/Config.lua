local UIJoinAlliance = {
  Name = UIWindowNames.UIJoinAlliance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIJoinAlliance.Controller.UIJoinAllianceCtrl"),
  View = require("UI.UIAlliance.UIJoinAlliance.View.UIJoinAllianceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIJoinAlliance.prefab"
}
return {UIJoinAlliance = UIJoinAlliance}
