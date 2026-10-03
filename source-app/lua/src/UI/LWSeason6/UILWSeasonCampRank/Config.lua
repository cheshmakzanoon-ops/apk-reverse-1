local S6CampRankScoreTips = {
  Name = UIWindowNames.S6CampRankScoreTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonCampRank.Ctrl.S6CampRankScoreTipsCtrl"),
  View = require("UI.LWSeason6.UILWSeasonCampRank.View.S6CampRankScoreTipsView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampRank/S6CampRankScoreTips.prefab"
}
return {S6CampRankScoreTips = S6CampRankScoreTips}
