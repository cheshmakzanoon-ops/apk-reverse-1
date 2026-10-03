local LWUIZombieRushReward = {
  Name = UIWindowNames.LWUIZombieRushReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZombieRushReward.Controller.LWUIZombieRushRewardCtrl"),
  View = require("UI.LWUIZombieRushReward.View.LWUIZombieRushRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRushRewardPanel.prefab"
}
return {LWUIZombieRushReward = LWUIZombieRushReward}
