local LWUIMonsterInvasionRecord = {
  Name = UIWindowNames.LWUIMonsterInvasionRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.UIMonsterInvasionRecord.Controller.UIMonsterInvasionRecordCtrl"),
  View = require("UI.MonsterInvasion.UIMonsterInvasionRecord.View.UIMonsterInvasionRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionRecordView.prefab"
}
return {LWUIMonsterInvasionRecord = LWUIMonsterInvasionRecord}
