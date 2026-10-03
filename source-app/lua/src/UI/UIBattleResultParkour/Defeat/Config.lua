local UIBattleResultParkourDefeat = {
  Name = UIWindowNames.UIBattleResultParkourDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultParkour.Defeat.UIBattleResultParkourDefeatCtrl"),
  View = require("UI.UIBattleResultParkour.Defeat.UIBattleResultParkourDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultParkour_Defeat.prefab"
}
return {UIBattleResultParkourDefeat = UIBattleResultParkourDefeat}
