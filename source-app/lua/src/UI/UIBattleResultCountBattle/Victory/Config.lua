local UIBattleResultCountBattleVictory = {
  Name = UIWindowNames.UIBattleResultCountBattleVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultCountBattle.Victory.UIBattleResultCountBattleVictoryCtrl"),
  View = require("UI.UIBattleResultCountBattle.Victory.UIBattleResultCountBattleVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultCountBattle_Victory.prefab"
}
return {UIBattleResultCountBattleVictory = UIBattleResultCountBattleVictory}
