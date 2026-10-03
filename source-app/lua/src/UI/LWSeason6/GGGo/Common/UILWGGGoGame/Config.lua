local UILWGGGoGame = {
  Name = UIWindowNames.UILWGGGoGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.GGGo.Common.UILWGGGoGame.Controller.UILWGGGoGameCtrl"),
  View = require("UI.LWSeason6.GGGo.Common.UILWGGGoGame.View.UILWGGGoGameView"),
  PrefabPath = "Assets/Main/MiniGameRes/GGGo/Prefab/UI/UILWGGGoGame.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWGGGoGame = UILWGGGoGame}
