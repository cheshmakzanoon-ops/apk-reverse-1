local LWSeasonBossLoginRecord = {
  Name = UIWindowNames.LWSeasonBossLoginRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWSeasonBossLoginRecord.Controller.LWSeasonBossLoginRecordCtrl"),
  View = require("UI.LWSeason1.LWSeasonBossLoginRecord.View.LWSeasonBossLoginRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/BossLogin/LWSeasonBossLoginRecord.prefab"
}
return {LWSeasonBossLoginRecord = LWSeasonBossLoginRecord}
