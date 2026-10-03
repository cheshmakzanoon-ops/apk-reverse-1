local UIBattleResultNewbieDefeat = {
  Name = UIWindowNames.UIBattleResultNewbieDefeat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattleResultNewbie.Defeat.UIBattleResultNewbieDefeatCtrl"),
  View = require("UI.UIBattleResultNewbie.Defeat.UIBattleResultNewbieDefeatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonCombatResultNew/UIBattleResultNewbie_Defeat.prefab"
}
return {UIBattleResultNewbieDefeat = UIBattleResultNewbieDefeat}
