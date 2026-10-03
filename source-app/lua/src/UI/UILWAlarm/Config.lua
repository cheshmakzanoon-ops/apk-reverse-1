local UILWAlarm = {
  Name = UIWindowNames.UILWAlarm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlarm.Controller.UILWAlarmCtrl"),
  View = require("UI.UILWAlarm.View.UILWAlarmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/Alarm/UILWAlarm.prefab"
}
return {UILWAlarm = UILWAlarm}
