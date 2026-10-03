local UIDesertMapUIView = {
  Name = UIWindowNames.UIBFDsbDuelBattleMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DsbDuelBattlefield.BattleMap.UIBFDsbDuelBattleMapCtrl"),
  View = require("UI.DsbDuelBattlefield.BattleMap.UIBFDsbDuelBattleMap"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/UIBFDsbDuelBattleMap.prefab"
}
return {UIDesertMapUIView = UIDesertMapUIView}
