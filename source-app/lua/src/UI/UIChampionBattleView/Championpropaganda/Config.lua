local UIChampionpropaganda = {
  Name = UIWindowNames.UIChampionpropaganda,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.Championpropaganda.Controller.UIChampionpropagandaViewController"),
  View = require("UI.UIChampionBattleView.Championpropaganda.View.UIChampionpropagandaView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/LFChampionpropaganda.prefab"
}
return {UIChampionpropaganda = UIChampionpropaganda}
