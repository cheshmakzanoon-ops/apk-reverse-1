local UIDesertOperateLog = {
  Name = UIWindowNames.UIDesertOperateLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.OperateLog.Controller.UIDesertOperateLogCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.OperateLog.View.UIDesertOperateLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/OperateLog.prefab"
}
return {UIDesertOperateLog = UIDesertOperateLog}
