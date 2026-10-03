local LWUISeasonPreviewRank = {
  Name = UIWindowNames.LWUISeasonPreviewRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.SeasonPreviewRank.Controller.SeasonPreviewRankPanelCtrl"),
  View = require("UI.LWSeasonShared.SeasonPreviewRank.View.SeasonPreviewRankPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeasonShared/SeasonPreviewRankPanel.prefab"
}
return {LWUISeasonPreviewRank = LWUISeasonPreviewRank}
