local LWUIWorldBossRank = {
  Name = UIWindowNames.LWUIWorldBossRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIWorldBossRank.Controller.LWUIWorldBossRankCtrl"),
  View = require("UI.LWUIWorldBossRank.View.LWUIWorldBossRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/LWUIWorldBossRankView.prefab"
}
return {LWUIWorldBossRank = LWUIWorldBossRank}
