local UIBattleResultStatisticDefeat = {
  Name = UIWindowNames.UIBattleResultStatisticDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultStatistic.Defeat.UIBattleResultStatisticDefeatCtrl"),
  View = require("UI.UIBattleResultStatistic.Defeat.UIBattleResultStatisticDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultStatistic_Defeat.prefab"
}
return {UIBattleResultStatisticDefeat = UIBattleResultStatisticDefeat}
