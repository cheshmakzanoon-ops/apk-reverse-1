local UIActCalendarRewardFilter = {
  Name = UIWindowNames.UIActCalendarRewardFilter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.ActCalendar.UIActCalendarRewardFilter.Ctrl.UIActCalendarRewardFilterCtrl"),
  View = require("UI.ActCalendar.UIActCalendarRewardFilter.View.UIActCalendarRewardFilterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActCalendar/UIActCalendarRewardFilter.prefab"
}
return {UIActCalendarRewardFilter = UIActCalendarRewardFilter}
