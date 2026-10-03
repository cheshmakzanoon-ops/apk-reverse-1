local FlowerTrainReward = {
  Name = UIWindowNames.FlowerTrainReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.FlowerTrain.UIFlowerTrainReward.Ctrl.UIFlowerTrainRewardCtrl"),
  View = require("UI.FlowerTrain.UIFlowerTrainReward.View.UIFlowerTrainRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainReward.prefab"
}
return {FlowerTrainReward = FlowerTrainReward}
