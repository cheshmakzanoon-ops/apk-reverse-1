local UICitySkinSkillTip = {
  Name = UIWindowNames.UICitySkinSkillTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICitySkinSkillTip.Controller.UICitySkinSkillTipCtrl"),
  View = require("UI.UICitySkinSkillTip.View.UICitySkinSkillTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CitySkinSkill/UICitySkinSkillTip.prefab"
}
return {UICitySkinSkillTip = UICitySkinSkillTip}
