local UILWSeasonTrendsRank = {
  Name = UIWindowNames.UILWSeasonHeroLevelChangeReport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHeroLevelChange.Controller.UIHeroExchangeLevelReportCtrl"),
  View = require("UI.LWSeason.LWSeasonHeroLevelChange.View.UIHeroExchangeLevelReportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelReplacement/UIHeroExchangeLevelReport.prefab"
}
return {UILWSeasonTrendsRank = UILWSeasonTrendsRank}
