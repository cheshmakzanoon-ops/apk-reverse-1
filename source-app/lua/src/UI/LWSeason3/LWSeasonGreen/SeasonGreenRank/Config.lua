local SeasonGreenRankPanel = {
  Name = UIWindowNames.SeasonGreenRankPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenRank.SeasonGreenRankCtrl"),
  View = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenRank.SeasonGreenRankPanel"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/SeasonGreenRankPanel.prefab"
}
return {SeasonGreenRankPanel = SeasonGreenRankPanel}
