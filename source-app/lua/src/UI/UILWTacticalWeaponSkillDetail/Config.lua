local UILWTacticalWeaponSkillDetail = {
  Name = UIWindowNames.UILWTacticalWeaponSkillDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponSkillDetail.Controller.UILWTacticalWeaponSkillDetailCtrl"),
  View = require("UI.UILWTacticalWeaponSkillDetail.View.UILWTacticalWeaponSkillDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWWeaponSkillDetailPanel.prefab"
}
return {UILWTacticalWeaponSkillDetail = UILWTacticalWeaponSkillDetail}
