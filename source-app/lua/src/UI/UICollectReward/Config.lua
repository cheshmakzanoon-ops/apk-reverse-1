local UICollectReward = {
  Name = UIWindowNames.UICollectReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICollectReward.Controller.UICollectRewardCtrl"),
  View = require("UI.UICollectReward.View.UICollectRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICollectReward/UICollectReward.prefab"
}
return {UICollectReward = UICollectReward}
