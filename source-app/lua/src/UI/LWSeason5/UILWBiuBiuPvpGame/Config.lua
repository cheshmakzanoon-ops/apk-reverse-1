local UILWBiuBiuPvpGame = {
  Name = UIWindowNames.UILWBiuBiuPvpGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuPvpGame.Controller.UILWBiuBiuPvpGameCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuPvpGame.View.UILWBiuBiuPvpGameView"),
  PrefabPath = "Assets/Main/MiniGameRes/BiuBiu/Prefab/UI/UILWBiuBiuPvpGame.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWBiuBiuPvpGame = UILWBiuBiuPvpGame}
