local UILWSeasonTetrisGame = {
  Name = UIWindowNames.UILWSeasonTetrisGame,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonTetris.Game.Controller.UILWSeasonTetrisGameCtrl"),
  View = require("UI.LWSeason1.UILWSeasonTetris.Game.View.UILWSeasonTetrisGameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisGame.prefab",
  CustomKeyCodeEscape = true
}
return {UILWSeasonTetrisGame = UILWSeasonTetrisGame}
