local UITCCardSkillTip = {
  Name = UIWindowNames.UITCCardSkillTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardSkillTip.Ctrl.UITCCardSkillTipCtrl"),
  View = require("UI.LWUITC.UITCCardSkillTip.View.UITCCardSkillTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardSkillTip/UITCCardSkillTip.prefab"
}
return {UITCCardSkillTip = UITCCardSkillTip}
