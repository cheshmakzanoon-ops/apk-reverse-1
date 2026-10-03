local UILWSeasonFactionWarScoreRankList = {
  Name = UIWindowNames.UILWSeasonFactionWarScoreRankList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarScoreRankList.Controller.UILWSeasonFactionWarScoreRankListCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarScoreRankList.View.UILWSeasonFactionWarScoreRankListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionWarScoreRankList.prefab"
}
return {UILWSeasonFactionWarScoreRankList = UILWSeasonFactionWarScoreRankList}
