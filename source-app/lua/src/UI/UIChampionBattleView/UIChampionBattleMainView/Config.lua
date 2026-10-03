local UIChampionBattleMain = {
  Name = UIWindowNames.UIChampionBattleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleMainView.Controller.UIChampionBattleMainViewCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleMainView.View.UIChampionBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/LFChampionBattleView.prefab"
}
return {UIChampionBattleMain = UIChampionBattleMain}
