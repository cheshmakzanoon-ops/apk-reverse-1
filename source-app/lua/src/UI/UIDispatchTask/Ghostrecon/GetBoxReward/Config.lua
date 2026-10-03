local UIGhostreconGetBoxReward = {
  Name = UIWindowNames.UIGhostreconGetBoxReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.GetBoxReward.Controller.UIGhostreconGetBoxRewardCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.GetBoxReward.View.UIGhostreconGetBoxRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/GetBoxReward/UIGhostreconGetBoxReward.prefab"
}
return {UIGhostreconGetBoxReward = UIGhostreconGetBoxReward}
