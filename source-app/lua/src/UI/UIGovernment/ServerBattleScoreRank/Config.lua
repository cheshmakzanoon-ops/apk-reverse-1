local ServerBattleScoreRank = {
  Name = UIWindowNames.UIServerBattleScoreRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleScoreRank.Controller.ServerBattleScoreRankCtrl"),
  View = require("UI.UIGovernment.ServerBattleScoreRank.View.ServerBattleScoreRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleScoreRank.prefab"
}
return {ServerBattleScoreRank = ServerBattleScoreRank}
