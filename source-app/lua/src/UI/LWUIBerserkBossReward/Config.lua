local LWUIBerserkBossReward = {
  Name = UIWindowNames.LWUIBerserkBossReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBerserkBossReward.Controller.LWUIBerserkBossRewardCtrl"),
  View = require("UI.LWUIBerserkBossReward.View.LWUIBerserkBossRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWBerserkBoss/LWUIBerserkBossRewardPanel.prefab"
}
return {LWUIBerserkBossReward = LWUIBerserkBossReward}
