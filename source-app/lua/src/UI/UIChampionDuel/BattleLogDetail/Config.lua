local UIChampionDuelBattleLogDetail = {
  Name = UIWindowNames.UIChampionDuelBattleLogDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.BattleLogDetail.Controller.UIChampionDuelBattleLogDetailCtrl"),
  View = require("UI.UIChampionDuel.BattleLogDetail.View.UIChampionDuelBattleLogDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelBattleLogDetail.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIChampionDuelBattleLogDetail = UIChampionDuelBattleLogDetail}
