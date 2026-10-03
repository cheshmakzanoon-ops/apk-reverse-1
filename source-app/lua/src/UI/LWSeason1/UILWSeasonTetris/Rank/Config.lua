local UILWSeasonTetrisRank = {
  Name = UIWindowNames.UILWSeasonTetrisRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonTetris.Rank.Controller.UILWSeasonTetrisRankCtrl"),
  View = require("UI.LWSeason1.UILWSeasonTetris.Rank.View.UILWSeasonTetrisRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisRank.prefab",
  HideBack = true
}
return {UILWSeasonTetrisRank = UILWSeasonTetrisRank}
