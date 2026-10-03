local UILWT11IdleGameBattleMain = {
  Name = UIWindowNames.UILWT11IdleGameBattleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameBattleMain.Ctrl.UILWT11IdleGameBattleMainCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameBattleMain.View.UILWT11IdleGameBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Battle/UILWT11IdleGameBattleMain.prefab",
  HideBack = true
}
return {UILWT11IdleGameBattleMain = UILWT11IdleGameBattleMain}
