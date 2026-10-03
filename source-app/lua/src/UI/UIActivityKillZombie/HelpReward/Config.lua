local UIActivityKillZombieHelpReward = {
  Name = UIWindowNames.UIActivityKillZombieHelpReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityKillZombie.HelpReward.Controller.HelpRewardCtrl"),
  View = require("UI.UIActivityKillZombie.HelpReward.View.HelpRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/HelpReward.prefab"
}
return {UIActivityKillZombieHelpReward = UIActivityKillZombieHelpReward}
