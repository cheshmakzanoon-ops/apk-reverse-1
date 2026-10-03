local UIChampionBattleFormation = {
  Name = UIWindowNames.UIChampionBattleFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionBattleView.UIChampionBattleFormationView.Controller.UIChampionBattleFormationViewCtrl"),
  View = require("UI.UIChampionBattleView.UIChampionBattleFormationView.View.UIChampionBattleFormationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationTableNew.prefab"
}
return {UIChampionBattleFormation = UIChampionBattleFormation}
