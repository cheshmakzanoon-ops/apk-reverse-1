local UIBattleResultJeepAdventureDefeat = {
  Name = UIWindowNames.UIBattleResultJeepAdventureDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultJeepAdventure.Defeat.UIBattleResultJeepAdventureDefeatCtrl"),
  View = require("UI.UIBattleResultJeepAdventure.Defeat.UIBattleResultJeepAdventureDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultJeepAdventure_Defeat.prefab"
}
return {UIBattleResultJeepAdventureDefeat = UIBattleResultJeepAdventureDefeat}
