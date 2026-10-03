local UIGhostreconReward = {
  Name = UIWindowNames.UIGhostreconReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.Reward.Controller.UIGhostreconRewardCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.Reward.View.UIGhostreconRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Reward/UIGhostreconReward.prefab"
}
return {UIGhostreconReward = UIGhostreconReward}
