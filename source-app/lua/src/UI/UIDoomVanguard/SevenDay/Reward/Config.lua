local UIActSevenDayDoomVanguardReward = {
  Name = UIWindowNames.UIActSevenDayDoomVanguardReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDoomVanguard.SevenDay.Reward.Controller.UIActSevenDayDoomVanguardRewardCtrl"),
  View = require("UI.UIDoomVanguard.SevenDay.Reward.View.UIActSevenDayDoomVanguardRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DoomVanguard/SevenDay/ActSevenDayDoomVanguardRewardView.prefab"
}
return {UIActSevenDayDoomVanguardReward = UIActSevenDayDoomVanguardReward}
