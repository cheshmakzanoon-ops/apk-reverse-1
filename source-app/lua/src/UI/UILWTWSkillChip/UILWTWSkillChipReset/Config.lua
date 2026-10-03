local UILWSkillChipReset = {
  Name = UIWindowNames.UILWSkillChipReset,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTWSkillChip.UILWTWSkillChipReset.Controller.UILWSkillChipResetCtrl"),
  View = require("UI.UILWTWSkillChip.UILWTWSkillChipReset.View.UILWSkillChipResetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipReset.prefab"
}
return {UILWSkillChipReset = UILWSkillChipReset}
