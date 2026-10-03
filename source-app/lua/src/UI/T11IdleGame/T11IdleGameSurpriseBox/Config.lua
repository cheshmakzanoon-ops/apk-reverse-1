local UILWT11IdleGameSurpriseBox = {
  Name = UIWindowNames.UILWT11IdleGameSurpriseBox,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameSurpriseBox.Ctrl.UILWT11IdleGameSurpriseBoxCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameSurpriseBox.View.UILWT11IdleGameSurpriseBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/SurpriseBox/UILWT11IdleGameSurpriseBox.prefab",
  CustomKeyCodeEscape = true
}
return {UILWT11IdleGameSurpriseBox = UILWT11IdleGameSurpriseBox}
