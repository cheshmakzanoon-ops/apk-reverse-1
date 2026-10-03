local SeasonGreenRankReward = {
  Name = UIWindowNames.SeasonGreenRankReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenRankReward.SeasonGreenRankRewardCtrl"),
  View = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenRankReward.SeasonGreenRankRewardPanel"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/SeasonGreenRankRewardPanel.prefab"
}
return {SeasonGreenRankReward = SeasonGreenRankReward}
