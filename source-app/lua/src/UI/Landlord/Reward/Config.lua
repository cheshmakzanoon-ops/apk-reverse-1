local UILLReward = {
  Name = UIWindowNames.UILLReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Reward.Ctrl.UILLRewardCtrl"),
  View = require("UI.Landlord.Reward.View.UILLRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLRewardPanel.prefab"
}
return {UILLReward = UILLReward}
