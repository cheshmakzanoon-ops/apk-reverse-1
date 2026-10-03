local UIChampionBattleRankView = {
  Name = UIWindowNames.UIChampionBattleRankView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleRankView.Controller.UIChampionBattleRankViewCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleRankView.View.UIChampionBattleRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/UIChampionBattleRankView.prefab"
}
return {UIChampionBattleRankView = UIChampionBattleRankView}
