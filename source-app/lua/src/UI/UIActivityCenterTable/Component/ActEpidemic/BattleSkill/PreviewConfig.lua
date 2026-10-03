local UIEpidemicBattleSkillPreview = {
  Name = UIWindowNames.UIEpidemicBattleSkillPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Controller.UIEpidemicBattleSkillPreviewCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.View.UIEpidemicBattleSkillPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleSkillPreview.prefab"
}
return {UIEpidemicBattleSkillPreview = UIEpidemicBattleSkillPreview}
