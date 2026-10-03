local UIWorldBossRank = {
  Name = UIWindowNames.UIWorldBossRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldBossRank.Controller.UIWorldBossRankCtrl"),
  View = require("UI.UIWorldBossRank.View.UIWorldBossRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldBossRankView.prefab"
}
return {UIWorldBossRank = UIWorldBossRank}
