local UIDispatchTaskReward = {
  Name = UIWindowNames.UIDispatchTaskReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Reward.Controller.UIDispatchTaskRewardCtrl"),
  View = require("UI.UIDispatchTask.Reward.View.UIDispatchTaskRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskReward.prefab"
}
return {UIDispatchTaskReward = UIDispatchTaskReward}
