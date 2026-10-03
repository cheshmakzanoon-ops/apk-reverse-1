local UIBattleResultCountBattleDefeat = {
  Name = UIWindowNames.UIBattleResultCountBattleDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultCountBattle.Defeat.UIBattleResultCountBattleDefeatCtrl"),
  View = require("UI.UIBattleResultCountBattle.Defeat.UIBattleResultCountBattleDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultCountBattle_Defeat.prefab"
}
return {UIBattleResultCountBattleDefeat = UIBattleResultCountBattleDefeat}
