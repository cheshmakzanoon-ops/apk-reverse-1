local BountyHunterReward = {
  Name = UIWindowNames.BountyHunterReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.Ctrl.UIActBountyHunterRewardCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.View.UIActBountyHunterRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/RewardHistory/UIActBountyHunterReward.prefab"
}
return {BountyHunterReward = BountyHunterReward}
