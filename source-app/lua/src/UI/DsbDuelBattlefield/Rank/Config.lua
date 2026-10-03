local RankViewConfig = {
  Name = UIWindowNames.UIBattlefieldDsbDuelBattleRankView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DsbDuelBattlefield.Rank.UIBattlefieldDsbDuelBattleRankCtrl"),
  View = require("UI.DsbDuelBattlefield.Rank.UIBattlefieldDsbDuelBattleRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/UIBattlefieldDsbDuelBattleRankView.prefab"
}
return {RankViewConfig = RankViewConfig}
