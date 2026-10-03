local UILWBiuBiuGame = {
  Name = UIWindowNames.UILWBiuBiuGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuGame.Controller.UILWBiuBiuGameCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuGame.View.UILWBiuBiuGameView"),
  PrefabPath = "Assets/Main/MiniGameRes/BiuBiu/Prefab/UI/UILWBiuBiuGame.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWBiuBiuGame = UILWBiuBiuGame}
