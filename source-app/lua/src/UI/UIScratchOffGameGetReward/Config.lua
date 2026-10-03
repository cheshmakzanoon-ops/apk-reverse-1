local UIScratchOffGameGetReward = {
  Name = UIWindowNames.ScratchOffGameGetRewardPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchOffGameGetReward.Ctrl.UIScratchOffGameGetRewardCtrl"),
  View = require("UI.UIScratchOffGameGetReward.View.UIScratchOffGameGetRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchOffGameGetReward/ScratchOffGetReward.prefab"
}
return {UIScratchOffGameGetReward = UIScratchOffGameGetReward}
