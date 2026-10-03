local UILWDispatchTaskLog = {
  Name = UIWindowNames.UILWDispatchTaskLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDispatchTaskLog.Controller.UILWDispatchTaskLogCtrl"),
  View = require("UI.UILWDispatchTaskLog.View.UILWDispatchTaskLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTask/UILWDispatchTaskLog.prefab"
}
return {UILWDispatchTaskLog = UILWDispatchTaskLog}
