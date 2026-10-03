local LWUIActivityAlarmClockTop = {
  Name = UIWindowNames.LWUIActivityAlarmClockTop,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUIActivityAlarmClockTop.Ctrl.LWUIActivityAlarmClockTopCtrl"),
  View = require("UI.LWUIActivityAlarmClockTop.View.LWUIActivityAlarmClockTopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActivityAlarmClock/LWUIActivityAlarmClockTopPanel.prefab",
  DontPushWindowStack = true
}
return {LWUIActivityAlarmClockTop = LWUIActivityAlarmClockTop}
