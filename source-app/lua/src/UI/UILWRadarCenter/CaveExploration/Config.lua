local UIDetectCaveExploration = {
  Name = UIWindowNames.UIDetectCaveExploration,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWRadarCenter.CaveExploration.Controller.UIDetectCaveExplorationCtrl"),
  View = require("UI.UILWRadarCenter.CaveExploration.View.UIDetectCaveExplorationView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/CaveExploration/UIDetectCaveExploration.prefab",
  HideBack = true
}
return {UIDetectCaveExploration = UIDetectCaveExploration}
