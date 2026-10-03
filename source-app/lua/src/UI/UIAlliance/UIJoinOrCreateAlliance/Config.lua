local UIJoinOrCreateAlliance = {
  Name = UIWindowNames.UIJoinOrCreateAlliance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIJoinOrCreateAlliance.Controller.UIJoinOrCreateAllianceCtrl"),
  View = require("UI.UIAlliance.UIJoinOrCreateAlliance.View.UIJoinOrCreateAllianceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIJoinOrCreateAlliance.prefab"
}
return {UIJoinOrCreateAlliance = UIJoinOrCreateAlliance}
