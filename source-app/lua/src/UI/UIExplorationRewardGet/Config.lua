local UIExplorationRewardGet = {
  Name = UIWindowNames.UIExplorationRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIExplorationRewardGet.Controller.UIExplorationRewardGetCtrl"),
  View = require("UI.UIExplorationRewardGet.View.UIExplorationRewardGetView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/ExplorationReward/UIExplorationRewardGet.prefab",
  AcquireHighFPSLockerForSeconds = 5
}
return {UIExplorationRewardGet = UIExplorationRewardGet}
