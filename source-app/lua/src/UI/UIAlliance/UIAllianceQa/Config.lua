local UIAllianceQa = {
  Name = UIWindowNames.UIAllianceQa,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceQa.Controller.UIAllianceQaCtrl"),
  View = require("UI.UIAlliance.UIAllianceQa.View.UIAllianceQaView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceQa.prefab"
}
return {UIAllianceQa = UIAllianceQa}
