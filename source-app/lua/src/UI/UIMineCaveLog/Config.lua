local UIMineCaveLog = {
  Name = UIWindowNames.UIMineCaveLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMineCaveLog.Controller.UIMineCaveLogCtrl"),
  View = require("UI.UIMineCaveLog.View.UIMineCaveLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMineCaveLog/UIMineCaveLog.prefab"
}
return {UIMineCaveLog = UIMineCaveLog}
