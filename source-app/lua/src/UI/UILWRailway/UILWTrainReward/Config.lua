local UILWTrainReward = {
  Name = UIWindowNames.UILWTrainReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainReward.Controller.UILWTrainRewardCtrl"),
  View = require("UI.UILWRailway.UILWTrainReward.View.UILWTrainRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainReward.prefab"
}
return {UILWTrainReward = UILWTrainReward}
