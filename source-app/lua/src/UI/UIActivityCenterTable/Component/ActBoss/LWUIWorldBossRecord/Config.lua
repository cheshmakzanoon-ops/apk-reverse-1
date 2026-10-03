local LWUIWorldBossRecord = {
  Name = UIWindowNames.LWUIWorldBossTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossRecord.Controller.LWUIWorldBossRecordCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossRecord.View.LWUIWorldBossRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WorldBoss/LWUIWorldBossRecordPanel.prefab"
}
return {LWUIWorldBossRecord = LWUIWorldBossRecord}
