local UILWT11IdleGameBattleReward = {
  Name = UIWindowNames.UILWT11IdleGameBattleReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameBattleReward.Ctrl.UILWT11IdleGameBattleRewardCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameBattleReward.View.UILWT11IdleGameBattleRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleReward.prefab"
}
return {UILWT11IdleGameBattleReward = UILWT11IdleGameBattleReward}
