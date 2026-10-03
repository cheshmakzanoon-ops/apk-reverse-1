local UIDetectRewardView = {
  Name = UIWindowNames.UIDetectReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDetectRewardView.Controller.UIDetectRewardCtrl"),
  View = require("UI.UIDetectRewardView.View.UIDetectRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICollectReward/UIDetectReward.prefab"
}
return {UIDetectRewardView = UIDetectRewardView}
