local UICityEventUAVRewards = {
  Name = UIWindowNames.UICityEventUAVRewardView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityEventUAVReward.Controller.UICityEventUAVRewardCtrl"),
  View = require("UI.UICityEventUAVReward.View.UICityEventUAVRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/UICityEventUAVRewards.prefab"
}
return {UICityEventUAVRewards = UICityEventUAVRewards}
