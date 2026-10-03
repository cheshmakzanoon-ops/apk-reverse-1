local UILWT11IdleGameGuide = {
  Name = UIWindowNames.UILWT11IdleGameGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11IdleGame.T11IdleGameGuide.Ctrl.UILWT11IdleGameGuideCtrl"),
  View = require("UI.T11IdleGame.T11IdleGameGuide.View.UILWT11IdleGameGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11IdleGame/Guide/UILWT11IdleGameGuide.prefab"
}
return {UILWT11IdleGameGuide = UILWT11IdleGameGuide}
