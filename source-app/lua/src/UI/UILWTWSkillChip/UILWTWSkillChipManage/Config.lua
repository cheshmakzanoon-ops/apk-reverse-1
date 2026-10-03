local UILWTWSkillChipManage = {
  Name = UIWindowNames.UILWTWSkillChipManage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Controller.UILWTWSkillChipManageCtrl"),
  View = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.View.UILWTWSkillChipManageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipManageWindow.prefab"
}
return {UILWTWSkillChipManage = UILWTWSkillChipManage}
