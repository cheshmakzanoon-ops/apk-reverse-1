local LWUISheepGame = {
  Name = UIWindowNames.LWUISheepGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWUISheepGame.Controller.LWUISheepGameCtrl"),
  View = require("UI.LWSeason4.LWUISheepGame.View.LWUISheepGameView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepGame.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {LWUISheepGame = LWUISheepGame}
