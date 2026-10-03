local ChampionBattleBettingrecord = {
  Name = UIWindowNames.ChampionBattleBettingrecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleBettingrecordView.Controller.LFChampionBattleBettingrecordController"),
  View = require("UI.UIChampionBattleView.UIChampionBattleBettingrecordView.View.LFChampionBattleBettingrecord"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/LFChampionBattleBettingrecord.prefab"
}
return {ChampionBattleBettingrecord = ChampionBattleBettingrecord}
