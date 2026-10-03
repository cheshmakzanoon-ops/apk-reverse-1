local UILWGGGoPvpGame = {
  Name = UIWindowNames.UILWGGGoPvpGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.GGGo.Common.UILWGGGoPvpGame.Controller.UILWGGGoPvpGameCtrl"),
  View = require("UI.LWSeason6.GGGo.Common.UILWGGGoPvpGame.View.UILWGGGoPvpGameView"),
  PrefabPath = "Assets/Main/MiniGameRes/GGGo/Prefab/UI/UILWGGGoPvpGame.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWGGGoPvpGame = UILWGGGoPvpGame}
