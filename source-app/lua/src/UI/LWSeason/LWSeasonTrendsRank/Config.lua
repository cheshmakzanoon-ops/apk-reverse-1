local UILWSeasonTrendsRank = {
  Name = UIWindowNames.UILWSeasonTrendsRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTrendsRank.Controller.LWSeasonTrendsRankCtrl"),
  View = require("UI.LWSeason.LWSeasonTrendsRank.View.LWSeasonTrendsRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/Trends/LWSeasonTrendsRank.prefab",
  HideBack = false
}
return {UILWSeasonTrendsRank = UILWSeasonTrendsRank}
