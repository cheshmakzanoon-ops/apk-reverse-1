local LWUIBerserkBossDamageStatistics = {
  Name = UIWindowNames.LWUIBerserkBossDamageStatistics,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBerserkBossDamageStatistics.Controller.LWUIBerserkBossDamageStatisticsCtrl"),
  View = require("UI.LWUIBerserkBossDamageStatistics.View.LWUIBerserkBossDamageStatisticsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWBerserkBoss/LWUIBerserkBossDamageStatisticsPanel.prefab"
}
return {LWUIBerserkBossDamageStatistics = LWUIBerserkBossDamageStatistics}
