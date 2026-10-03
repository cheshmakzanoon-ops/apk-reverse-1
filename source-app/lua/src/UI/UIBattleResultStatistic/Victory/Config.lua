local UIBattleResultStatisticVictory = {
  Name = UIWindowNames.UIBattleResultStatisticVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultStatistic.Victory.UIBattleResultStatisticVictoryCtrl"),
  View = require("UI.UIBattleResultStatistic.Victory.UIBattleResultStatisticVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultStatistic_Victory.prefab"
}
return {UIBattleResultStatisticVictory = UIBattleResultStatisticVictory}
