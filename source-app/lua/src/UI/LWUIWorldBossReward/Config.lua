local LWUIWorldBossReward = {
  Name = UIWindowNames.LWUIWorldBossReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIWorldBossReward.Controller.LWUIWorldBossRewardCtrl"),
  View = require("UI.LWUIWorldBossReward.View.LWUIWorldBossRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/LWUIWorldBossRewardView.prefab"
}
return {LWUIWorldBossReward = LWUIWorldBossReward}
