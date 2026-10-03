local UIActivityKillZombieActionReward = {
  Name = UIWindowNames.UIActivityKillZombieActionReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityKillZombie.ActionReward.Controller.ActionRewardCtrl"),
  View = require("UI.UIActivityKillZombie.ActionReward.View.ActionRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/ActionReward.prefab"
}
return {UIActivityKillZombieActionReward = UIActivityKillZombieActionReward}
