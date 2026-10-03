local UILWSeasonTetrisSuccess = {
  Name = UIWindowNames.UILWSeasonTetrisSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWSeason1/UILWSeasonTetris/Success/Controller/UILWSeasonTetrisSuccessCtrl"),
  View = require("UI/LWSeason1/UILWSeasonTetris/Success/View/UILWSeasonTetrisSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisSuccess.prefab",
  CustomKeyCodeEscape = true
}
return {UILWSeasonTetrisSuccess = UILWSeasonTetrisSuccess}
