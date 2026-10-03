local UIBattleResultMysteryTreasureDefeat = {
  Name = UIWindowNames.UIBattleResultMysteryTreasureDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultMysteryTreasure.Defeat.UIBattleResultMysteryTreasureDefeatCtrl"),
  View = require("UI.UIBattleResultMysteryTreasure.Defeat.UIBattleResultMysteryTreasureDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultMysteryTreasure_Defeat.prefab"
}
return {UIBattleResultMysteryTreasureDefeat = UIBattleResultMysteryTreasureDefeat}
