local UIActCalendarBubbleTips = {
  Name = UIWindowNames.UIActCalendarBubbleTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.ActCalendar.UIActCalendarBubbleTips.Ctrl.UIActCalendarBubbleTipsCtrl"),
  View = require("UI.ActCalendar.UIActCalendarBubbleTips.View.UIActCalendarBubbleTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/UIActCalendarBubbleTips.prefab"
}
return {UIActCalendarBubbleTips = UIActCalendarBubbleTips}
