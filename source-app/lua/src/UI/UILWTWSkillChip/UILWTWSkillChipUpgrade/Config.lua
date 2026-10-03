local UILWTWSkillChipUpgrade = {
  Name = UIWindowNames.UILWTWSkillChipUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Controller.UILWTWSkillChipUpgradeCtrl"),
  View = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.View.UILWTWSkillChipUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipUpgrade.prefab"
}
return {UILWTWSkillChipUpgrade = UILWTWSkillChipUpgrade}
