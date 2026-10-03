local LWUIActivityAlarmClock = {
  Name = UIWindowNames.LWUIActivityAlarmClock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActivityAlarmClock.Controller.LWUIActivityAlarmClockCtrl"),
  View = require("UI.LWUIActivityAlarmClock.View.LWUIActivityAlarmClockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActivityAlarmClock/LWUIActivityAlarmClockPanel.prefab"
}
return {LWUIActivityAlarmClock = LWUIActivityAlarmClock}
