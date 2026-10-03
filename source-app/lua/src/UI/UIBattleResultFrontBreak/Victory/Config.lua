local UIBattleResultFrontBreakVictory = {
  Name = UIWindowNames.UIBattleResultFrontBreakVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultFrontBreak.Victory.UIBattleResultFrontBreakVictoryCtrl"),
  View = require("UI.UIBattleResultFrontBreak.Victory.UIBattleResultFrontBreakVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultFrontBreak_Victory.prefab"
}
return {UIBattleResultFrontBreakVictory = UIBattleResultFrontBreakVictory}
