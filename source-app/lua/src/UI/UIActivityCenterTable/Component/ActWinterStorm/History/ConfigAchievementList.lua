local UIWinterStormAchievementList = {
  Name = UIWindowNames.UIWinterStormAchievementList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.Controller.UIWinterStormAchievementListCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.View.UIWinterStormAchievementListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormAchievementList.prefab"
}
return {UIWinterStormAchievementList = UIWinterStormAchievementList}
