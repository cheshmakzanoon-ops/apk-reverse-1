local UIEpidemicBattleSkillPoint = {
  Name = UIWindowNames.UIEpidemicBattleSkillPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Controller.UIEpidemicBattleSkillPointCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.View.UIEpidemicBattleSkillPointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleSkillPoint.prefab"
}
return {UIEpidemicBattleSkillPoint = UIEpidemicBattleSkillPoint}
