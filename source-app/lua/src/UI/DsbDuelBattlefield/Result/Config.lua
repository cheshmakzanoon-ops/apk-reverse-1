local BattleResultViewConfig = {
  Name = UIWindowNames.UIBattlefieldDsbDuelBattleResultView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DsbDuelBattlefield.Result.UIBattlefieldDsbDuelBattleResultCtrl"),
  View = require("UI.DsbDuelBattlefield.Result.UIBattlefieldDsbDuelBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/UIBattlefieldDsbDuelBattleResultView.prefab",
  CustomKeyCodeEscape = true
}
return {BattleResultViewConfig = BattleResultViewConfig}
