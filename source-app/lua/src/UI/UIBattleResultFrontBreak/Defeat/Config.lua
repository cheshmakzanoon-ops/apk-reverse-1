local UIBattleResultFrontBreakDefeat = {
  Name = UIWindowNames.UIBattleResultFrontBreakDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultFrontBreak.Defeat.UIBattleResultFrontBreakDefeatCtrl"),
  View = require("UI.UIBattleResultFrontBreak.Defeat.UIBattleResultFrontBreakDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultFrontBreak_Defeat.prefab"
}
return {UIBattleResultFrontBreakDefeat = UIBattleResultFrontBreakDefeat}
