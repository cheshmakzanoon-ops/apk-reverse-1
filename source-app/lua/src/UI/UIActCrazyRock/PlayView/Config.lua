local CrazyRockGame = {
  Name = UIWindowNames.CrazyRockGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActCrazyRock.PlayView.Ctrl.UIActCrazyRockGameCtrl"),
  View = require("UI.UIActCrazyRock.PlayView.View.UIActCrazyRockGameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActCrazyRock/UIActCrazyRockGame.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {CrazyRockGame = CrazyRockGame}
