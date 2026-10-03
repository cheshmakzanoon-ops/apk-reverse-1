local UICityEventKillZombieReward = {
  Name = UIWindowNames.UICityEventKillZombieReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityEventKillZombieReward.Controller.UICityEventKillZombieRewardCtrl"),
  View = require("UI.UICityEventKillZombieReward.View.UICityEventKillZombieRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/UICityEventKillZombieRewards.prefab"
}
return {UICityEventKillZombieReward = UICityEventKillZombieReward}
