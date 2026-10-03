local UIAllianceFlag = {
  Name = UIWindowNames.UIAllianceFlag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceFlag.Controller.UIAllianceFlagCtrl"),
  View = require("UI.UIAlliance.UIAllianceFlag.View.UIAllianceFlagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceFlag.prefab"
}
return {UIAllianceFlag = UIAllianceFlag}
