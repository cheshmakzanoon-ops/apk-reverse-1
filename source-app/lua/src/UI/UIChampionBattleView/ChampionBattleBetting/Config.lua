local ChampionBattleBetting = {
  Name = UIWindowNames.ChampionBattleBetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.ChampionBattleBetting.Controller.LFChampionBattleBettingCtrl"),
  View = require("UI.UIChampionBattleView.ChampionBattleBetting.View.LFChampionBattleBetting"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/LFChampionBattleBetting.prefab"
}
return {ChampionBattleBetting = ChampionBattleBetting}
