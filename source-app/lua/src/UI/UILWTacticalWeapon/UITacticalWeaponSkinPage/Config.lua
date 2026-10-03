local UITacticalWeaponSkinPage = {
  Name = UIWindowNames.UITacticalWeaponSkinPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponSkinPage.Controller.UITacticalWeaponSkinPageCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponSkinPage.View.UITacticalWeaponSkinPage"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponSkinPage.prefab",
  HideBack = true
}
return {UITacticalWeaponSkinPage = UITacticalWeaponSkinPage}
