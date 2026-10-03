local UILWSeasonTetrisFail = {
  Name = UIWindowNames.UILWSeasonTetrisFail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonTetris.Fail.Controller.UILWSeasonTetrisFailCtrl"),
  View = require("UI.LWSeason1.UILWSeasonTetris.Fail.View.UILWSeasonTetrisFailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisFail.prefab",
  CustomKeyCodeEscape = true
}
return {UILWSeasonTetrisFail = UILWSeasonTetrisFail}
