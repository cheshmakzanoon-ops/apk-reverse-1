local SeasonSelectLocationGameRank = {
  Name = UIWindowNames.SeasonSelectLocationGameRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.SeasonSelectLocationGame.Rank.Ctrl.SeasonSelectLocationGameRankCtrl"),
  View = require("UI.LWSeason5.SeasonSelectLocationGame.Rank.View.SeasonSelectLocationGameRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocationGame/SeasonSelectLocationGameRank.prefab"
}
return {SeasonSelectLocationGameRank = SeasonSelectLocationGameRank}
