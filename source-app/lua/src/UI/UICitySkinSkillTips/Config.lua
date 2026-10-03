local UICitySkinSkillTips = {
  Name = UIWindowNames.UICitySkinSkillTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICitySkinSkillTips.Controller.UICitySkinSkillTipsCtrl"),
  View = require("UI.UICitySkinSkillTips.View.UICitySkinSkillTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/UICitySkinSkillTips.prefab"
}
return {UICitySkinSkillTips = UICitySkinSkillTips}
