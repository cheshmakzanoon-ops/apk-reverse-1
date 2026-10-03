local UIKillZombieAlReward = {
  Name = UIWindowNames.UIKillZombieAlReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIKillZombieAlReward.Ctrl.UIKillZombieAlRewardCtrl"),
  View = require("UI.UIKillZombieAlReward.View.UIKillZombieAlRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIKillZombieAlReward.prefab"
}
return {UIKillZombieAlReward = UIKillZombieAlReward}
