local UITacticalWeaponSkillLevelUp = {
  Name = UIWindowNames.UITacticalWeaponSkillLevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponSkillLevelUp.Controller.UITacticalWeaponSkillLevelUpCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponSkillLevelUp.View.UITacticalWeaponSkillLevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponSkillLevelUp.prefab"
}
return {UITacticalWeaponSkillLevelUp = UITacticalWeaponSkillLevelUp}
