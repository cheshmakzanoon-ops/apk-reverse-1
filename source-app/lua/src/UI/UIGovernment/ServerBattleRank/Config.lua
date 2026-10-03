local UIGovernmentServerBattleRank = {
  Name = UIWindowNames.UIGovernmentServerBattleRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleRank.Controller.ServerBattleRankCtrl"),
  View = require("UI.UIGovernment.ServerBattleRank.View.ServerBattleRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattle/RankPanel.prefab"
}
return {UIGovernmentServerBattleRank = UIGovernmentServerBattleRank}
