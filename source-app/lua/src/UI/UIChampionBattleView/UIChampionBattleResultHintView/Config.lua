local UIChampionBattleResultHintView = {
  Name = UIWindowNames.UIChampionBattleResultHintView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleResultHintView.Controller.UIChampionBattleResultHintViewCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleResultHintView.View.UIChampionBattleResultHintView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionBattle/UIChampionBattleResultHintView.prefab"
}
return {UIChampionBattleResultHintView = UIChampionBattleResultHintView}
