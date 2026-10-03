local UIDetectCaveExplorationRewardGet = {
  Name = UIWindowNames.UIDetectCaveExplorationRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDetectCaveExplorationRewardGet.Controller.UIDetectCaveExplorationRewardGetCtrl"),
  View = require("UI.UIDetectCaveExplorationRewardGet.View.UIDetectCaveExplorationRewardGetView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/CaveExploration/UIDetectCaveExplorationRewardGet.prefab",
  AcquireHighFPSLockerForSeconds = 5
}
return {UIDetectCaveExplorationRewardGet = UIDetectCaveExplorationRewardGet}
