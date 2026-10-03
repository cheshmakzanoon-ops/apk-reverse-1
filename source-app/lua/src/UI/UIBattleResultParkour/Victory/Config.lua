local UIBattleResultParkourVictory = {
  Name = UIWindowNames.UIBattleResultParkourVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultParkour.Victory.UIBattleResultParkourVictoryCtrl"),
  View = require("UI.UIBattleResultParkour.Victory.UIBattleResultParkourVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultParkour_Victory.prefab"
}
return {UIBattleResultParkourVictory = UIBattleResultParkourVictory}
