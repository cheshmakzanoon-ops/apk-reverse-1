local LWUIBerserkBossRank = {
  Name = UIWindowNames.LWUIBerserkBossRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBerserkBossRank.Controller.LWUIBerserkBossRankCtrl"),
  View = require("UI.LWUIBerserkBossRank.View.LWUIBerserkBossRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWBerserkBoss/LWUIBerserkBossRankPanel.prefab"
}
return {LWUIBerserkBossRank = LWUIBerserkBossRank}
