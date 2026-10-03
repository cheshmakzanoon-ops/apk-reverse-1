local UIEpidemicBattleSkillRecord = {
  Name = UIWindowNames.UIEpidemicBattleSkillRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Controller.UIEpidemicBattleSkillRecordCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.View.UIEpidemicBattleSkillRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleSkillRecord.prefab"
}
return {UIEpidemicBattleSkillRecord = UIEpidemicBattleSkillRecord}
