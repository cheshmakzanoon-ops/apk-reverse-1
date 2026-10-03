local UILWAllianceLog = {
  Name = UIWindowNames.UILWAllianceLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceLog.Controller.UILWAllianceLogCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceLog.View.UILWAllianceLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceLog.prefab"
}
return {UILWAllianceLog = UILWAllianceLog}
