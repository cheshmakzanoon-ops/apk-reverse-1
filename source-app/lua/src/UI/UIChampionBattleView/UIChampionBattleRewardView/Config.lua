local UIChampionBattleReward = {
  Name = UIWindowNames.UIChampionBattleReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleRewardView.Controller.ChampionBattleRewardViewCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleRewardView.View.ChampionBattleRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/UIChampionBattleReward.prefab"
}
return {UIChampionBattleReward = UIChampionBattleReward}
