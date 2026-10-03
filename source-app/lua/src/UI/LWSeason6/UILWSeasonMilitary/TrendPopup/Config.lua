local S6MilitaryTrendPopupView = {
  Name = UIWindowNames.S6MilitaryTrendPopupView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonMilitary.TrendPopup.Ctrl.S6MilitaryTrendPopupCtrl"),
  View = require("UI.LWSeason6.UILWSeasonMilitary.TrendPopup.View.S6MilitaryTrendPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Military/S6MilitaryTrendPopup.prefab"
}
return {S6MilitaryTrendPopupView = S6MilitaryTrendPopupView}
