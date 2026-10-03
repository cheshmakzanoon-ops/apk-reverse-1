local SeasonHunterRank = {
  Name = UIWindowNames.SeasonHunterRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterRank.SeasonHunterRankCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterRank.SeasonHunterRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterRank.prefab"
}
return {SeasonHunterRank = SeasonHunterRank}
