local UIBattleResultNewbieVictory = {
  Name = UIWindowNames.UIBattleResultNewbieVictory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultNewbie.Victory.UIBattleResultNewbieVictoryCtrl"),
  View = require("UI.UIBattleResultNewbie.Victory.UIBattleResultNewbieVictoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultNewbie_Victory.prefab"
}
return {UIBattleResultNewbieVictory = UIBattleResultNewbieVictory}
