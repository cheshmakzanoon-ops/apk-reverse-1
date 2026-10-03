local UIActivityMultipleParkourRewards = {
  Name = UIWindowNames.UIActivityMultipleParkourRewards,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.MultipleParkour.Rewards.Controller.UIActivityMultipleParkourRewardsCtrl"),
  View = require("UI.UIActivityCenterTable.Component.MultipleParkour.Rewards.View.UIActivityMultipleParkourRewardsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MultipleParkour/UIActivityMultipleParkourRewards.prefab"
}
return {UIActivityMultipleParkourRewards = UIActivityMultipleParkourRewards}
