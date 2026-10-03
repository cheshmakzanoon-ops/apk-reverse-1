local UIBFDsbDuelBattleBuildState = {
  Name = UIWindowNames.UIBFDsbDuelBattleBuildState,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DsbDuelBattlefield.BuildState.UIBFDsbDuelBattleBuildStateCtrl"),
  View = require("UI.DsbDuelBattlefield.BuildState.UIBFDsbDuelBattleBuildStateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/UIBFDsbDuelBattleBuildState.prefab"
}
return {UIBFDsbDuelBattleBuildState = UIBFDsbDuelBattleBuildState}
