local UIAllianceChangeAnnounce = {
  Name = UIWindowNames.UIAllianceChangeAnnounce,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceChangeAnnounce.Controller.UIAllianceChangeAnnounceCtrl"),
  View = require("UI.UIAlliance.UIAllianceChangeAnnounce.View.UIAllianceChangeAnnounceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceChangeAnnounce.prefab"
}
return {UIAllianceChangeAnnounce = UIAllianceChangeAnnounce}
