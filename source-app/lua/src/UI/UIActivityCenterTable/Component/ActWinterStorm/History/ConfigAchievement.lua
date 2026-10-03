local UIWinterStormAchievement = {
  Name = UIWindowNames.UIWinterStormAchievement,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.Controller.UIWinterStormAchievementCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.View.UIWinterStormAchievementView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormAchievementPanel.prefab",
  HideBack = true
}
return {UIWinterStormAchievement = UIWinterStormAchievement}
