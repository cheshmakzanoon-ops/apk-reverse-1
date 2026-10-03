local LWPVPArenaReward = {
  Name = UIWindowNames.LWPVPArenaReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPVPArena.RewardView.Controller.LWPVPArenaRewardCtrl"),
  View = require("UI.LWPVPArena.RewardView.View.LWPVPArenaRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWPVPArenaRewardView.prefab"
}
return {LWPVPArenaReward = LWPVPArenaReward}
