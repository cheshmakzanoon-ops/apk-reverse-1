local LWSeasonDesertRank = {
  Name = UIWindowNames.LWSeasonDesertRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonDesertRank.Controller.LWSeasonDesertRankCtrl"),
  View = require("UI.LWSeason.LWSeasonDesertRank.View.LWSeasonDesertRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonDesertRank.prefab"
}
return {LWSeasonDesertRank = LWSeasonDesertRank}
