local UIKingBattle = {
  Name = UIWindowNames.UIKingBattleRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.KingBattle.UIKingBattleRank.UIKingBattleRankCtrl"),
  View = require("UI.LWSeason5.KingBattle.UIKingBattleRank.UIKingBattleRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/KingBattle/UIKingBattleRank.prefab"
}
return {UIKingBattle = UIKingBattle}
