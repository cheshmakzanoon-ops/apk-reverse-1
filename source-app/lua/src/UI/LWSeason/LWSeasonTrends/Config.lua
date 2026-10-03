local UILWSeasonTrendsMain = {
  Name = UIWindowNames.UILWSeasonTrendsMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTrends.Controller.LWSeasonTrendsMainCtrl"),
  View = require("UI.LWSeason.LWSeasonTrends.View.LWSeasonTrendsMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/Trends/LWSeasonTrendsMain.prefab",
  HideBack = true
}
return {UILWSeasonTrendsMain = UILWSeasonTrendsMain}
