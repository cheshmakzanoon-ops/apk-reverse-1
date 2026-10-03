local UIEpidemicBattleSkill = {
  Name = UIWindowNames.UIEpidemicBattleSkill,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Controller.UIEpidemicBattleSkillCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.View.UIEpidemicBattleSkillView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleSkill.prefab"
}
return {UIEpidemicBattleSkill = UIEpidemicBattleSkill}
