local LFChampionBattleFight = {
  Name = UIWindowNames.LFChampionBattleFight,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleFight.Controller.LFChampionBattleFightCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleFight.View.LFChampionBattleFight"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/LFChampionBattleFight.prefab"
}
return {LFChampionBattleFight = LFChampionBattleFight}
