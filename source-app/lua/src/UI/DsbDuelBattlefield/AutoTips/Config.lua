local Config = {
  Name = UIWindowNames.UIBattlefieldSimpleWinningTipsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DsbDuelBattlefield.AutoTips.UIBattlefieldSimpleWinningTipsCtrl"),
  View = require("UI.DsbDuelBattlefield.AutoTips.UIBattlefieldSimpleWinningTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/UIBattlefieldSimpleWinningTipsView.prefab"
}
return {Config = Config}
