local UIPersonalArmsCalendar = {
  Name = UIWindowNames.UIPersonalArmsCalendar,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendar.Controller.UIPersonalArmsCalendarCtrl"),
  View = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendar.View.UIPersonalArmsCalendarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsCalendar.prefab"
}
return {UIPersonalArmsCalendar = UIPersonalArmsCalendar}
