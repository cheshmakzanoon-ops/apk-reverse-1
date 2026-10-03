local NewPeakArenaReward = {
  Name = UIWindowNames.NewPeakArenaReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaReward.Controller.NewPeakArenaRewardCtrl"),
  View = require("UI.NewPeakArenaReward.View.NewPeakArenaRewardView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaRewardView.prefab"
}
return {NewPeakArenaReward = NewPeakArenaReward}
