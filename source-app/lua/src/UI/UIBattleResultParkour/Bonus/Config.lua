local UIBattleResultParkourBonusVictory = {
  Name = UIWindowNames.UIBattleResultParkourBonusVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultParkour.Bonus.UIBattleResultParkourBonusVictoryCtrl"),
  View = require("UI.UIBattleResultParkour.Bonus.UIBattleResultParkourBonusVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultParkourBonus_Victory.prefab"
}
return {UIBattleResultParkourBonusVictory = UIBattleResultParkourBonusVictory}
