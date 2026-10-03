local DiggingLevelSingleView = {
  Name = UIWindowNames.DiggingLevelSingleView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.DiggingLevelSingleCtrl"),
  View = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.DiggingLevelSingleView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/DiggingGame/DiggingLevelSingle.prefab"
}
return {DiggingLevelSingleView = DiggingLevelSingleView}
