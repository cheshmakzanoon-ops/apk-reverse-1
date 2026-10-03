local GoldTreeRank = {
  Name = UIWindowNames.GoldTreeRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRank.GoldTreeRankCtrl"),
  View = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRank.GoldTreeRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreeRank.prefab"
}
return {GoldTreeRank = GoldTreeRank}
