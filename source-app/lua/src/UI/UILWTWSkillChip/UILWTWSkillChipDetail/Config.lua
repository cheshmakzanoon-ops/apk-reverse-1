local UILWTWSkillChipDetail = {
  Name = UIWindowNames.UILWTWSkillChipDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTWSkillChip.UILWTWSkillChipDetail.Controller.UILWTWSkillChipDetailCtrl"),
  View = require("UI.UILWTWSkillChip.UILWTWSkillChipDetail.View.UILWTWSkillChipDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipDetail.prefab"
}
return {UILWTWSkillChipDetail = UILWTWSkillChipDetail}
