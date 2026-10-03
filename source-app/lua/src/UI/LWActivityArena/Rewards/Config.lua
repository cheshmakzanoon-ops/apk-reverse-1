local LWActivityArenaRewards = {
  Name = UIWindowNames.LWActivityArenaRewards,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArena.Rewards.LWActivityArenaRewardsCtrl"),
  View = require("UI.LWActivityArena.Rewards.LWActivityArenaRewardsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIActivityArenaRewards.prefab"
}
return {LWActivityArenaRewards = LWActivityArenaRewards}
