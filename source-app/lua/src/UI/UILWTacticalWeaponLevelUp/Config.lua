local UILWTacticalWeaponLevelUp = {
  Name = UIWindowNames.UILWTacticalWeaponLevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponLevelUp.Controller.UILWTacticalWeaponLevelUpCtrl"),
  View = require("UI.UILWTacticalWeaponLevelUp.View.UILWTacticalWeaponLevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTacticalWeaponLevelUp.prefab"
}
return {UILWTacticalWeaponLevelUp = UILWTacticalWeaponLevelUp}
